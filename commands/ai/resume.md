---
description: Retoma uma tarefa salva com ai:handoff — lê o plano e continua de onde parou
argument-hint: <nome-da-tarefa>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

If $ARGUMENTS is empty:
1. List all .md files in .claude/plans/
2. For EACH file found, read the first 10 lines to extract the task name
   and date from the ## Task and ## Date headers
3. Present a numbered table with columns: #, Task Name, Date, Filename
   Example:
     | # | Tarefa                    | Data       | Arquivo                        |
     |---|---------------------------|------------|--------------------------------|
     | 1 | Migrar auth para OAuth2   | 2026-04-15 | migrar-auth-para-oauth2.md     |
     | 2 | Refatorar módulo de pagamentos | 2026-04-16 | refatorar-modulo-pagamentos.md |
4. If no files are found, inform the user there are no saved handoffs
   and suggest using /ai:handoff <nome> to create one.
5. Ask the user to pick a number or type the task name.
6. Do NOT proceed until the user chooses.

If $ARGUMENTS is provided:

Task to resume: $ARGUMENTS

Sanitize the task name the same way as ai:handoff: lowercase, replace spaces
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
