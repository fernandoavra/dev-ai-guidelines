---
description: Auditoria de dívida técnica — documenta sem corrigir
allowed-tools: Read, Write, Bash, Glob, Grep
---

Use subagents to audit the entire codebase for technical debt.
Do not fix anything — only document.

Scan for:
- Dead code (functions, files, routes never called)
- Inconsistencies with patterns defined in PROJECT.md
- Missing tests on critical paths
- TODO/FIXME/HACK comments (list every one with file and line)
- Dependencies outdated or with known vulnerabilities
- Anti-patterns found (document each with one concrete example)
- Duplication across components that should be extracted
- Security smells: hardcoded values, broad permissions, missing validation

Output to .claude/plans/tech-debt-audit-$(date +%Y-%m-%d).md with:

## Summary
- Total items found by category
- Top 3 highest-risk items

## Items
Each item formatted as:
[CATEGORY] [FILE:LINE or SCOPE]
Issue: what was found (specific)
Risk: impact if left unaddressed
Effort: quick-win | planned | long-term
Priority: high | medium | low

Categories: dead-code | duplication | missing-tests | convention | dependency | anti-pattern | todo

## Recommended order of resolution
- Quick wins (< 1 day each)
- Planned items (next sprint)
- Long-term (architectural decisions needed)
