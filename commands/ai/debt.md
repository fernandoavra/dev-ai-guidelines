---
description: Auditoria de dívida técnica — documenta sem corrigir
allowed-tools: Read, Write, Bash, Glob, Grep
---

Delegate the full audit to @tech-debt-auditor. It scans for dead code,
TODO/FIXME, duplication, convention violations, missing tests, outdated
dependencies, and anti-patterns.

Also add to the scan (not covered by the agent):
- Security smells: hardcoded values, broad permissions, missing validation
- Inconsistencies with patterns defined in PROJECT.md

Save output to .claude/plans/tech-debt-audit-$(date +%Y-%m-%d).md.

After the agent returns, add these sections at the top of the output:

## Summary
- Total items found by category
- Top 3 highest-risk items

## Recommended order of resolution
- Quick wins (< 1 day each)
- Planned items (next sprint)
- Long-term (architectural decisions needed)
