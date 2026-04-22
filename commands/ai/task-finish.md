---
description: Marca uma tarefa como concluída, registra o resumo final e arquiva o plano
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
- Ask if they want to proceed anyway (creates a minimal completion record)
  or if they mistyped the name. Do NOT proceed without confirmation.

**If the plan file exists:**
- Read it fully — it contains goal, plan, decisions, acceptance criteria,
  and possibly handoff sections from previous sessions.

## Step 2 — Verify acceptance criteria

Check the **Acceptance criteria** section in the plan file.

**If ALL criteria are checked ([x]):**
- Confirm to the user that all criteria are met. Proceed to Step 3.

**If some criteria are NOT checked ([ ]):**
- List the unchecked criteria explicitly.
- Ask the user: "These criteria are still open. Do you want to:
  (a) mark them as done now, (b) skip them and finish anyway, or
  (c) abort and continue working?"
- Do NOT proceed to archival without explicit user confirmation.

## Step 3 — Check for uncommitted work

Run git status to check for uncommitted changes.

If there are staged or unstaged changes:
- Inform the user and suggest committing before finishing.
- Wait for the user to commit or explicitly say to proceed without committing.

Also suggest: "If you haven't run /ai:review yet, consider doing so before
finishing this task." This is a suggestion, not a blocker — proceed if the
user says to continue.

## Step 4 — Write completion summary

Add or update this section in the plan file, AFTER any existing handoff
sections (do not remove them — they are part of the task history):

```
## Completion — (current date)

### What was delivered
- (concrete deliverables: files created/changed, features implemented,
  bugs fixed — be specific)

### Key decisions made
- (significant decisions from the Decision log, summarized in 1 line each)

### What was NOT done (if applicable)
- (scope items explicitly deferred or dropped, with reason)

### Lessons learned (if any)
- (non-obvious insights that would help in similar future tasks)
```

## Step 5 — Update status and archive

1. Update **Status** to `done`.
2. Update **last-updated** timestamp.
3. Create .claude/plans/archive/ directory if it does not exist.
4. Move the plan file to .claude/plans/archive/$TASK_NAME.md.
5. Deregister from active sessions:

   ```bash
   FILE=".claude/plans/.active-sessions.json"
   [ -f "$FILE" ] && jq --arg pid "$PPID" 'del(.[$pid])' \
     "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
   ```

## Step 6 — Confirm

Output a summary:
- Confirm the task was marked as done and archived.
- Show the archive path: .claude/plans/archive/$TASK_NAME.md
- Remind: "Run /ai:daily-close at end of day to capture this in the daily summary."
