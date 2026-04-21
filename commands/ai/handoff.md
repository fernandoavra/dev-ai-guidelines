---
description: Registra handoff da sessão atual antes de encerrar ou /clear — requer nome da tarefa
argument-hint: <nome-da-tarefa>
allowed-tools: Read, Write, Edit, Bash, Glob
---

If $ARGUMENTS is empty, list existing plan files in .claude/plans/ and ask
the user to provide a task name. Do NOT proceed without a task name.

Task name: $ARGUMENTS

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

## Step 4 — Archive if done

If the task status is "done" (all acceptance criteria met):
- Move the plan file to .claude/plans/archive/$TASK_NAME.md
- Create the archive/ directory if it does not exist.
- Inform the user the task was archived.

## Step 5 — Confirm

Output the git status and confirm the file was saved at
.claude/plans/$TASK_NAME.md (or .claude/plans/archive/$TASK_NAME.md if archived)
so the user knows how to resume later with:
  /ai:resume $ARGUMENTS
