---
description: Descarta uma tarefa que não será executada — remove ou arquiva o plano com motivo
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
  (excluding archive/) and ask the user to provide a task name.
  Do NOT proceed without a task name.

Task name: $ARGUMENTS (or detected from session)

Sanitize the task name for use as filename: lowercase, replace spaces with
hyphens, remove special characters. Example: "migrar auth para OAuth2" becomes
"migrar-auth-para-oauth2".

## Step 1 — Locate the plan file

Look for .claude/plans/$TASK_NAME.md (created by /ai:task or /ai:feature).

**If the plan file does NOT exist:**
- Inform the user that no plan was found for this task name.
- List available plans in .claude/plans/ for reference.
- Do NOT proceed — ask for the correct name.

**If the plan file exists:**
- Read it and show the user a brief summary: goal, current status, and
  how many acceptance criteria were completed vs total.

## Step 2 — Confirm deletion

Ask the user:
- "Why is this task being discarded?" (capture the reason — it goes into the record)
- "Do you want to (a) archive it with a 'discarded' status (keeps history), or
  (b) delete the file permanently?"

Do NOT proceed without explicit confirmation.

## Step 3 — Record and dispose

**If the user chose (a) archive:**
1. Add this section to the plan file:

```
## Discarded — (current date)

**Reason:** (user's reason)
**Status at discard:** (what was done so far, if anything)
```

2. Update **Status** to `discarded`.
3. Update **last-updated** timestamp.
4. Create .claude/plans/archive/ directory if it does not exist.
5. Move the plan file to .claude/plans/archive/$TASK_NAME.md.

**If the user chose (b) delete:**
1. Delete .claude/plans/$TASK_NAME.md permanently.

## Step 4 — Deregister active session

Remove this task from the active sessions registry:

```bash
FILE=".claude/plans/.active-sessions.json"
[ -f "$FILE" ] && jq --arg pid "$PPID" 'del(.[$pid])' \
  "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
```

## Step 5 — Check for related branches or uncommitted work

Run git status and check if there is a branch named after the task
(e.g., feat/$TASK_NAME, fix/$TASK_NAME, or similar).

If found:
- Inform the user about the branch and any uncommitted changes.
- Do NOT delete branches or discard changes automatically — just inform.

## Step 6 — Confirm

Output a summary:
- What was done (archived with reason or deleted).
- If archived, show the path: .claude/plans/archive/$TASK_NAME.md
- If there are related branches or uncommitted work, remind the user.
