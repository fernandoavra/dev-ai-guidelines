---
description: Revisao hostil — valida se o trabalho realmente resolve o problema antes de avancar
agent: build
subtask: true
---

This is a validation gate, not a code review. Use @hostile-reviewer to
challenge whether the current work actually achieves its stated goal.

## Step 1 — Detect context

If $ARGUMENTS is provided, use it as the task name (skip auto-detection).

Otherwise, try to detect the active task for this session:

```bash
FILE=".claude/plans/.active-sessions.json"
[ -f "$FILE" ] && jq -r --arg pid "$PPID" '.[$pid].task // empty' "$FILE"
```

**If a task name is available (from argument or detection):**
- Read .claude/plans/$TASK_NAME.md fully — store its content for Step 3.
- Inform the user: "Reviewing task: <name>"

**If no task is detected and no argument provided:**
- Check for changes using both commands:
  ```bash
  git status --porcelain
  git log --oneline main..HEAD 2>/dev/null
  ```
- If either produces output, proceed with a plan-less review (the reviewer
  will derive criteria from the changes themselves).
- If BOTH are empty, inform the user:
  "No active task and no changes to review. Nothing to validate."
  Do NOT proceed.

## Step 2 — Collect changes

First, detect the current branch:

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "$BRANCH"
```

**If on a feature branch (not main/master):**

Run these in parallel:
1. `git diff HEAD` — unstaged changes
2. `git diff --staged` — staged but uncommitted changes
3. `git diff main...HEAD` — all commits on this branch vs. main
4. `git log --oneline main..HEAD` — commit history
5. `git diff --name-status main...HEAD` — list of affected files

**If on main/master:**

Run these in parallel:
1. `git diff HEAD` — unstaged changes
2. `git diff --staged` — staged but uncommitted changes
3. `git log --oneline -10` — last 10 commits for context
4. `git diff --name-only HEAD` — list of modified files

If there is no diff output at all (everything is committed and on main
with no working tree changes), use the last 3 commits as scope:
1. `git diff HEAD~3...HEAD` — changes in last 3 commits
2. `git log --oneline -3` — commit messages
3. `git diff --name-status HEAD~3...HEAD` — files changed

## Step 3 — Dispatch hostile review

Read the plan file content collected in Step 1 (if a task was detected).
If the plan file was not yet read, read .claude/plans/$TASK_NAME.md now.

Send to @hostile-reviewer as a subagent with ALL of the following
explicitly included in the dispatch message:
- The full text of the plan file (if a task was detected) — do NOT
  tell the subagent to "read the plan"; include the content directly
- The full diff of changes (from Step 2)
- The list of files affected (from Step 2)
- The commit history (from Step 2)
- The current branch name

The reviewer must also read each changed file in full — not just the
diff — to understand the broader context of each change.

## Step 4 — Present verdict

Present the hostile-reviewer's findings to the user with the full
structured output (verdict, criteria audit, challenges, gaps, scope).

**If GO:**
- Confirm the work passed hostile review.
- Suggest next step based on context:
  - If task is active: "You can proceed to the next phase or run
    /ai-task-finish to close."
  - If no task: "You can run /ai-review for a code quality check before
    opening a PR."

**If NO-GO:**
- List all BLOCKERs clearly.
- Ask the user how they want to proceed:
  (a) address the blockers now
  (b) override and proceed anyway
  (c) abort and rethink the approach

## Step 5 — Update plan (if task is active)

If a task was detected and a plan file exists, append the review result
to the plan. Use today's date (from system context) for all date fields:

```
## Hostile Review — YYYY-MM-DD

**Verdict:** GO | NO-GO
**Blockers:** (count) | None
**Concerns:** (count)

Key findings:
- (1-line summary of each blocker or concern)
```

Add a row to the Decision log:
| YYYY-MM-DD | Hostile review: GO/NO-GO | (summary) | (impact) |

Update the **last-updated** timestamp.
