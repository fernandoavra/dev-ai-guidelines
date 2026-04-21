---
description: Encerra o dia com resumo do que foi feito e o que ficou em aberto — diário de progresso
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Generate a daily summary for today. The summary is a lightweight overview —
detailed state lives in the individual handoff files inside .claude/plans/.

Steps:

1. Determine today's date (YYYY-MM-DD format).

2. Gather information from multiple sources (in parallel when possible):
   a. Read ALL .md files in .claude/plans/ (excluding archive/) to understand
      active tasks and their current state (completed, in progress, blocked).
   b. Run `git log --oneline --since="today 00:00" --author="$(git config user.name)"`
      to see today's commits.
   c. Run `git diff --stat HEAD~10..HEAD` (or appropriate range) to understand
      scope of changes.

3. Extract decisions from plan files:
   For each active plan file that has a **Decision log** table, check for
   entries dated today. Include significant decisions in the daily summary
   under a dedicated section — this provides a quick view of what changed
   strategically, not just what code was written.

4. Create .claude/dailies/YYYY-MM-DD.md with this structure:

```markdown
# Daily — YYYY-MM-DD

## Done today
- (list of tasks completed or significant progress made, with 1-line summary each)

## In progress
- (list of tasks still open, with current status — reference the plan file)

## Decisions made today
- [task-name]: (decision and rationale, 1 line — from plan decision logs)

## Blocked
- (anything blocked and why — only if applicable)

## Commits
- (list of today's commits, one-line each)

## Tomorrow
- (suggested priorities for next day, based on what's in progress and blocked)
```

5. Keep it concise — max 3-5 items per section. This is a summary, not a log.
   Do NOT duplicate full handoff content. Reference plan files instead:
   "Migrar auth → see plans/migrar-auth-oauth2.md"

6. If there are tasks in .claude/plans/ that were NOT touched today,
   do NOT include them unless they are blocked.

7. Output the summary to the user and confirm the file was saved.
   Suggest: "Tomorrow, run /ai:daily-start to pick up where you left off."
