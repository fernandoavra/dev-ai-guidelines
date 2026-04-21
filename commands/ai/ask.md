---
description: Responde perguntas sobre o projeto com base na documentação existente — sem escanear o codebase
argument-hint: <pergunta sobre arquitetura, convenções, decisões etc.>
allowed-tools: Read, Glob, Grep
---

If $ARGUMENTS is empty, ask the user what they want to know about the project.
Do NOT proceed without a question.

Question: $ARGUMENTS

## Step 1 — Load project context (fast, targeted reads)

Read ONLY the documentation files that exist — skip any that are missing:

1. **CLAUDE.md** (project root) — conventions, commands, structure
2. **PROJECT.md** (project root) — architecture, standards, decision log
3. **AGENTS.md** (project root) — agent roles and delegation map
4. **.claude/plans/*.md** (excluding archive/) — active tasks, decisions, state
5. **.claude/dailies/** — only the most recent file, for current context

Do NOT explore the codebase, run commands, or read source code files
unless the answer genuinely cannot be found in the documentation above.

## Step 2 — Answer the question

Based on the documentation loaded:
- Answer directly and concisely
- Cite the source file for each claim (e.g., "per PROJECT.md, section X...")
- If the answer involves a past decision, reference the Decision log entry
- If the answer involves an active task, reference the plan file

## Step 3 — Handle gaps

If the documentation does not contain enough information to answer:
- Say explicitly what is missing and where it should be documented
- Offer to investigate the codebase (with user approval) as a fallback
- Suggest which command would fill the gap:
  - Missing architecture info → /ai:docs
  - Missing conventions → /ai:update
  - Missing decision context → check git log or ask the user

Do NOT guess or fabricate answers from general knowledge.
Only state what is grounded in the project's own documentation.
