---
description: Retoma uma tarefa salva com ai-handoff — le o plano e continua de onde parou
agent: build
---

If $ARGUMENTS is empty:
1. List all .md files in `.claude/plans/` (exclude dotfiles and archive/).
2. For EACH file, extract the task name from the first `# Task:` or
   `# Feature:` heading on line 1 of the plan file — that is the source
   of truth. Extract the date from the `**Started:**` field. Use the
   filename only as a fallback identifier.
3. Present a numbered table with columns: #, Task, Started, Filename
   Example:
     | # | Task                          | Started    | Filename                    |
     |---|-------------------------------|------------|-----------------------------|
     | 1 | Migrate auth to OAuth2        | 2026-04-15 | migrate-auth-to-oauth2.md   |
     | 2 | Refactor payments module      | 2026-04-16 | refactor-payments-module.md |
4. If no files are found, tell the user there are no saved handoffs
   and suggest using `/ai-handoff <name>` to create one.
5. Ask the user to pick a number or type the task name.
6. Do NOT proceed until the user chooses.

If $ARGUMENTS is provided:

Task to resume: $ARGUMENTS

Sanitize the task name the same way as ai-handoff: lowercase, replace spaces
with hyphens, remove special characters.

Steps:
1. Read .claude/plans/$TASK_NAME.md
   - If the file does not exist, run the same listing flow described above
     and ask the user to choose or correct the name.

2. Present a summary of the saved state:
   - What was completed
   - What was in progress
   - What was blocked
   - What the next steps were

3. Verify current state matches the handoff:
   - Run git status to check working tree
   - Check if files mentioned in the handoff still exist and are unchanged
   - Flag any discrepancies between saved state and current reality

4. Register active session — register this task for the current terminal:

   ```bash
   FILE=".claude/plans/.active-sessions.json"
   [ -f "$FILE" ] || echo '{}' > "$FILE"
   jq --arg pid "$PPID" --arg task "$TASK_NAME" \
     '.[$pid] = {"task": $task, "started": (now | todate)}' \
     "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
   ```

5. Present the resumption plan:
   - "Based on the handoff, the next action is: ..."
   - Any risks or blockers that were flagged
   - Ask for confirmation before proceeding

Wait for user approval before executing any changes.
