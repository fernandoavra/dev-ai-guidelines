---
description: Inicia uma tarefa com exploração e plano antes de qualquer código
argument-hint: <descrição da tarefa>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

If $ARGUMENTS is empty, ask the user to describe the task.
Do NOT proceed without a task description.

Task: $ARGUMENTS

## Step 1 — Explore

Before writing any code, use subagents to:
- Read PROJECT.md and the relevant section of CLAUDE.md
- Read .claude/agents/ and identify which agents are involved in this task
- Map every file that will need to change and why
- Identify cross-component dependencies (which components are affected)
- Flag any ambiguity that requires a decision before proceeding

Acceptance criteria:
(infer from task context or ask if unclear)

## Step 2 — Plan and persist

Sanitize $ARGUMENTS for use as filename: lowercase, replace spaces with
hyphens, remove special characters, truncate to 50 chars max.
Example: "migrar auth para OAuth2" becomes "migrar-auth-para-oauth2".

Create .claude/plans/$TASK_NAME.md with the following structure:

```
# Task: $ARGUMENTS

**Started:** (current date)
**Status:** planning

## Goal
(one clear sentence describing what this task achieves)

## Plan
1. [step] — rationale
2. [step] — rationale
...

## Files affected
- `path/to/file` — reason for change
- `path/to/file` — reason for change

## Components involved
- [component] — role in this task

## Acceptance criteria
- [ ] criterion 1
- [ ] criterion 2

## Risks and edge cases
- [risk or edge case]

## Open questions
- [question that needs an answer before or during implementation]

## Decision log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| (date) | Initial plan approved | — | — |

---
*last-updated: YYYY-MM-DD HH:MM*
```

## Step 3 — Present and wait

Present the plan to the user with:
1. Implementation plan (steps, order, rationale)
2. Files to be created or modified (with reason for each)
3. Risks and edge cases
4. Questions that need answers before starting

Confirm that the plan was saved at .claude/plans/$TASK_NAME.md.

Wait for my approval before writing any code.

## Step 4 — Keep the plan alive (CRITICAL)

Once implementation begins, update .claude/plans/$TASK_NAME.md whenever:
- A decision changes the original scope or approach
- A new file is added or a planned file is no longer needed
- A risk materializes or a new risk is discovered
- An open question is answered
- A step is completed (check off acceptance criteria)
- Status changes (planning → in-progress → blocked → done)

For each scope-affecting decision, append a row to the **Decision log** table.

Update the **last-updated** timestamp on every write.

This ensures /ai:handoff can read the plan file and produce a handoff
with minimal effort — the plan IS the source of truth for this task.
