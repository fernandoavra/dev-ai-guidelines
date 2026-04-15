# Prompt 03 — Geração do PROJECT.md

**Quando usar:** Uma vez por projeto, logo após o setup inicial.  
**Pré-requisito:** Prompt 01 já executado (CLAUDE.md e agentes no lugar).  
**Resultado:** PROJECT.md na raiz — documentação viva para humanos e agentes de IA.

---

## Prompt

```
Use subagents to explore this project thoroughly before writing anything.

EXPLORE the following in parallel:
- Full directory structure and file tree
- Tech stack, frameworks, versions and their relationships across all components
- Architecture patterns (REST, events, shared DB, monorepo conventions, etc.)
- Existing documentation (README, inline comments, wikis, .md files)
- Environment files, config patterns and secrets strategy
- Test strategy: unit, integration, e2e — what exists, what's missing
- CI/CD pipelines and deployment scripts
- Dependency management and shared packages
- Git history patterns: branch naming, commit conventions, PR size
- Existing CLAUDE.md, agents and skills

Do NOT write any file until the full exploration is complete.

---

After exploration, create a single file: PROJECT.md at the project root.

This file serves two audiences simultaneously:
- Human developers: onboarding, orientation, day-to-day reference
- AI agents: structured context for accurate, consistent code generation

Design every section to be useful for both. Prefer concrete examples over
abstract descriptions. Prefer facts found in the codebase over assumptions.

---

FILE STRUCTURE: PROJECT.md

# [Project Name]

## Purpose & Scope
- What this system does in 3–5 sentences (business context, not technical)
- What it explicitly does NOT do (boundaries)
- Who the end users are

## Architecture Overview
- System diagram in ASCII or Mermaid showing components and data flow
- Each component with: role, tech stack, port/URL, main entry point
- Communication patterns between components (sync/async, protocol, format)
- External services and third-party dependencies (why each exists)
- Data flow for the 2–3 most critical user journeys

## Repository Structure
- Annotated directory tree (root + one level deep per component)
- What belongs where and why (enforce with examples)
- Naming conventions for files, folders, functions, variables, components
- What must NEVER go where (anti-patterns found or anticipated)

## Development Setup
- Prerequisites with exact versions required
- Step-by-step setup from zero: clone → running locally
- Environment variables: which ones, what they do, where to get them
- How to run each component individually and all together
- Common setup failures and how to fix them

## Coding Standards
- Language/framework-specific conventions actually used in this codebase
- Patterns to follow (with short inline code examples from the real code)
- Patterns to avoid (with explanation of why, based on what was found)
- Error handling strategy
- Logging conventions
- Security rules: what must never be committed, hardcoded or exposed

## Testing Strategy
- Test types used and their purpose in this project
- Where tests live and how to run them (per component and globally)
- Coverage expectations and what must always be tested
- How to write a new test (short example following existing patterns)
- What the CI pipeline validates and when it blocks a merge

## Git Workflow
- Branch naming convention (with examples)
- Commit message format (with examples from actual history or conventions)
- PR size expectations and review process
- What triggers a deploy to each environment
- Hotfix and rollback procedures

## Cross-Cutting Concerns
- Authentication and authorization: how it works across components
- Configuration and secrets management
- Shared utilities and where they live
- Internationalization/localization if applicable
- Observability: logging, tracing, metrics

## Decision Log
- Up to 10 key architectural decisions found in the codebase
- Format per decision: Decision | Why | Trade-offs | Date (if discoverable)
- This section is the most valuable for AI agents — be specific

## Onboarding Checklist
- Day 1: environment running, first test passing, first PR open
- Week 1: first feature touched end-to-end
- What to read before touching each component
- Who to ask about what (roles, not names)
- Definition of "done" for a task in this project

## AI Agent Guidelines
- How to interpret this document when generating code
- Which conventions are strict (must follow) vs. preferred (default unless
  there's a reason)
- How to handle ambiguity: what to ask vs. what to infer
- What to always verify before modifying cross-component code
- Referencing other files: CLAUDE.md, agents in .claude/agents/,
  skills in .claude/skills/

---

QUALITY RULES for the output:

- Ground every claim in something found in the codebase — no hallucinated
  conventions
- If something is missing (no tests, no CI, no error handling pattern),
  say so explicitly as a gap, not a placeholder
- Use concrete examples from the actual code, not generic boilerplate
- Keep each section scannable: short paragraphs, lists, inline code blocks
- If a section has nothing real to say, write "Not established — to be defined"
- End the file with a metadata block:

---
generated: [date]
generated-by: Claude Code
last-reviewed: [date]
review-cadence: update when architecture changes or onboarding reveals gaps
---

After creating the file, output:
- 3 most important gaps found in the project
- 3 conventions that were inferred (not explicit) and should be confirmed
- Suggested next review trigger (what kind of change should prompt an update)
```

---

## Quando atualizar o PROJECT.md

- Nova arquitetura ou componente adicionado
- Mudança de stack relevante
- Onboarding de um dev novo revelou seção desatualizada
- Decision Log precisar de nova entrada significativa
- A cada mês: releitura rápida para verificar validade
