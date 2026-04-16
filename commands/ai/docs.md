---
description: Gera ou atualiza o PROJECT.md — documentação viva para humanos e agentes de IA
allowed-tools: Read, Write, Bash, Glob, Grep
---

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

After exploration, create or update PROJECT.md at the project root.

This file serves two audiences simultaneously:
- Human developers: onboarding, orientation, day-to-day reference
- AI agents: structured context for accurate, consistent code generation

Include these sections:
- Purpose & Scope (business context, boundaries, end users)
- Architecture Overview (diagram ASCII/Mermaid, components, communication patterns)
- Repository Structure (annotated tree, naming conventions, anti-patterns)
- Development Setup (prerequisites, step-by-step, env vars, common failures)
- Coding Standards (patterns to follow and avoid, error handling, security rules)
- Testing Strategy (types, locations, commands, coverage expectations)
- Git Workflow (branch naming, commit format, PR process, deploy triggers)
- Cross-Cutting Concerns (auth, config, shared utils, observability)
- Decision Log (up to 10 key architectural decisions: Decision | Why | Trade-offs | Date)
- Onboarding Checklist (Day 1, Week 1, what to read per component)
- AI Agent Guidelines (strict vs preferred conventions, handling ambiguity)

Quality rules:
- Ground every claim in something found in the codebase
- If something is missing, say explicitly "Not established — to be defined"
- Use concrete examples from actual code, not generic boilerplate
- End with metadata block: generated date, last-reviewed, review-cadence

After creating the file, output:
- 3 most important gaps found in the project
- 3 conventions that were inferred and should be confirmed
- Suggested next review trigger
