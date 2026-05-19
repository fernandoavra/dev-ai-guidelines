---
description: Revisão de código com agentes especializados antes de abrir PR
allowed-tools: Read, Grep, Glob, Bash
---

Review the changes in this PR as a senior engineer who did NOT write this code.

Use subagents:
- @code-reviewer: quality, readability, patterns, PROJECT.md conventions
- @security-reviewer: secrets, injection, auth gaps, exposed data
- @qa-engineer: test coverage, missing edge cases, untested critical paths

For each issue found, format as:

[P0 | P1 | P2 | P3] [FILE:LINE]
Problem: what is wrong (specific)
Why: why it matters in this codebase
Fix: concrete suggestion (with code if applicable)

Severity follows the shared scale in `agents/severity-scale.md`. Do
not invent levels — each subagent reports on the same scale so findings
can be synthesized into a single prioritized list.

Also report:
- What was done well (genuine, not generic praise)
- Whether the implementation matches PROJECT.md conventions
- Whether CLAUDE.md rules were followed
- Whether any decision was made that should go to the Decision Log

Do not approve. Only report findings.
