---
description: Inicia uma tarefa com exploração e plano antes de qualquer código
argument-hint: <descrição da tarefa>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Before writing any code, use subagents to:
- Read PROJECT.md and the relevant section of CLAUDE.md
- Read .claude/agents/ and identify which agents are involved in this task
- Map every file that will need to change and why
- Identify cross-component dependencies (which components are affected)
- Flag any ambiguity that requires a decision before proceeding

Task: $ARGUMENTS

Acceptance criteria:
(inferir do contexto da tarefa ou perguntar se não for claro)

After the exploration, present:
1. Implementation plan (steps, order, rationale)
2. Files to be created or modified (with reason for each)
3. Risks and edge cases
4. Questions that need answers before starting

Wait for my approval before writing any code.
