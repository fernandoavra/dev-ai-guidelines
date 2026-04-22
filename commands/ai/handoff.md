---
description: Registra handoff da sessão atual antes de encerrar ou /clear — requer nome da tarefa
argument-hint: <nome-da-tarefa>
allowed-tools: Read, Write, Edit, Bash, Glob
---

If $ARGUMENTS is empty, try to detect the active task for this session:

```bash
FILE=".claude/plans/.active-sessions.json"
[ -f "$FILE" ] && jq -r --arg pid "$PPID" '.[$pid].task // empty' "$FILE"
```

- If a task name is returned, use it and inform the user:
  "Detected active task: <name>. Proceeding."
- If no task is detected, list existing plan files in .claude/plans/
  and ask the user to provide a task name.
  Do NOT proceed without a task name.

Task name: $ARGUMENTS (or detected from session)

Sanitize the task name for use as filename: lowercase, replace spaces with
hyphens, remove special characters. Example: "migrar auth para OAuth2" becomes
"migrar-auth-para-oauth2".

## Step 1 — Commit check

Before anything else, check if there are uncommitted changes related to this task.
If there are staged or unstaged changes:
- Inform the user and suggest committing before proceeding.
- Wait for the user to commit or explicitly say to proceed without committing.

## Step 2 — Check for existing plan

Look for .claude/plans/$TASK_NAME.md (created by /ai:task or /ai:feature).

**If the plan file exists:**
- Read it — it already contains the goal, plan, decisions, and progress.
- Update the existing file by adding/refreshing the handoff sections below.
- Do NOT duplicate information already present in the plan.

**If the plan file does NOT exist:**
- Create .claude/plans/$TASK_NAME.md from scratch with full context.

## Step 3 — Add handoff sections

Append or update these sections in the plan file:

```
## Handoff — (current date)

### Status at close
- **Completed:** (specific: files changed, decisions made, criteria met)
- **In progress:** (exact state — not "working on X", but "function Y in file Z implemented up to step 3")
- **Blocked:** (what and why, or "nothing blocked")

### Next session start
- **First command to run:** (to verify state)
- **First task to pick up:** (specific enough to start without extra context)
- **Context that must NOT be lost:**
  - (decision or constraint 1)
  - (decision or constraint 2)

### Open risks
- (anything fragile or incomplete)
- (tests not yet written for code already merged)
- (decisions deferred that will affect next steps)

### Resume summary
(3 sentences: what someone — human or AI — needs to know to continue cold)
```

Update **Status** to the appropriate value (in-progress, blocked, paused).
Update **last-updated** timestamp.

## Step 4 — Deregister active session

Remove this task from the active sessions registry (task is being paused):

```bash
FILE=".claude/plans/.active-sessions.json"
[ -f "$FILE" ] && jq --arg pid "$PPID" 'del(.[$pid])' \
  "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
```

## Step 5 — Redirect if done

If the task status is "done" (all acceptance criteria met):
- Do NOT archive here. Instead, inform the user:
  "This task appears to be complete. Use /ai:task-finish $ARGUMENTS to
  formally close it with a completion summary and archive it."
- Still save the handoff sections above so no context is lost.
- If the user insists on finishing via handoff, proceed with archival:
  move the plan file to .claude/plans/archive/$TASK_NAME.md (create
  the archive/ directory if it does not exist).

## Step 6 — Confirm

Output the git status and confirm the file was saved at
.claude/plans/$TASK_NAME.md (or .claude/plans/archive/$TASK_NAME.md if archived)
so the user knows how to resume later with:
  /ai:resume $ARGUMENTS
