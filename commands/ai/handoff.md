---
description: Registra handoff da sessão atual em active-plan.md antes de encerrar ou /clear
allowed-tools: Read, Write, Edit, Bash
---

Before closing this session, create or update
.claude/plans/active-plan.md with:

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

Finally, output the git status so it's visible before the session closes.
