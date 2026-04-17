---
description: Registra handoff da sessão atual antes de encerrar ou /clear — requer nome da tarefa
argument-hint: <nome-da-tarefa>
allowed-tools: Read, Write, Edit, Bash, Glob
---

If $ARGUMENTS is empty, list existing handoff files in .claude/plans/ and ask
the user to provide a task name. Do NOT proceed without a task name.

Task name: $ARGUMENTS

Sanitize the task name for use as filename: lowercase, replace spaces with
hyphens, remove special characters. Example: "migrar auth para OAuth2" becomes
"migrar-auth-para-oauth2".

Before closing this session, create or update
.claude/plans/$TASK_NAME.md (where $TASK_NAME is the sanitized name) with:

## Task: $ARGUMENTS
## Date: (current date)

## State at close
- What was completed (be specific: files changed, decisions made)
- What is in progress (exact state, not "working on X")
- What is blocked and why

## Next session start
- First command to run to verify state
- First task to pick up (specific enough to start without extra context)
- Context that must NOT be lost (decisions, constraints discovered)

## Risks open
- Anything fragile or incomplete that needs attention
- Tests not yet written for code already merged
- Decisions deferred that will affect next steps

Then summarize in 3 sentences what someone — human or AI agent —
needs to know to continue this work cold.

Finally, output the git status and confirm the file was saved at
.claude/plans/$TASK_NAME.md so the user knows how to resume later with:
  /ai:resume <nome-da-tarefa>
