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

[SEVERITY: critical | major | minor] [FILE:LINE]
Problem: what is wrong (specific)
Why: why it matters in this codebase
Fix: concrete suggestion (with code if applicable)

Also report:
- What was done well (genuine, not generic praise)
- Whether the implementation matches PROJECT.md conventions
- Whether CLAUDE.md rules were followed
- Whether any decision was made that should go to the Decision Log

Severity guide:
- critical: must fix before merging (data loss, security hole, broken functionality)
- major: should fix before merging (violates core conventions, missing critical tests)
- minor: suggestion (style, minor improvement)

Do not approve. Only report findings.
