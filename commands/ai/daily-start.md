---
description: Inicia o dia lendo o resumo do dia anterior — retoma o ritmo rapidamente
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Help the user start their day by loading context from the most recent daily
summary.

Steps:

1. List all files in .claude/dailies/ sorted by name (descending).
   - If the directory is empty or doesn't exist, inform the user there are
     no daily summaries yet and suggest: "Use /ai:daily-close at the end
     of the day to start building your daily log."
     Then stop.

2. Read the most recent daily file (highest date).

3. Present a briefing to the user:

   **Last session: YYYY-MM-DD**

   **Carry-over tasks** (in progress from last time):
   - task name → current state (1 line)

   **Blocked items** (need attention):
   - item → reason

   **Suggested priorities for today:**
   - (from the "Tomorrow" section of the daily file)

4. Check if the referenced plan files in .claude/plans/ still exist.
   Flag any that were deleted or moved since the daily was written.

5. Run `git status` and `git log --oneline -5` to show current repo state.

6. Ask the user:
   "Which task do you want to pick up? You can choose from the list above
   or start something new with /ai:task <description>."

Wait for user input before proceeding.
