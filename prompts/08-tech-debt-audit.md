# Prompt 08 — Auditoria de Dívida Técnica

**Quando usar:** Quinzenalmente ou antes de uma sprint de qualidade.  
**Regra:** Apenas documentar. Nenhum fix durante a auditoria.

---

## Prompt

```
Use subagents to audit the entire codebase for technical debt.
Do not fix anything — only document.

Scan for:
- Dead code (functions, files, routes never called)
- Inconsistencies with patterns defined in PROJECT.md
- Missing tests on critical paths
- TODO/FIXME/HACK comments (list them all with file and line)
- Dependencies outdated or with known vulnerabilities
- Anti-patterns found in the codebase (document each with one example)
- Duplication across components that should be extracted to shared utilities
- Security smells: hardcoded values, broad permissions, missing validation

Output to .claude/plans/tech-debt-audit-[YYYY-MM-DD].md with:

## Summary
- Total items found by category
- Top 3 highest-risk items

## Items
Each item formatted as:
[CATEGORY] [FILE:LINE or SCOPE]
Issue: what was found
Risk: impact if left unaddressed
Effort: quick-win | planned | long-term
Priority: high | medium | low

## Recommended order of resolution
- Quick wins (< 1 day each)
- Planned items (next sprint)
- Long-term (architectural decisions needed)
```

---

## Notas de uso

- Substitua `[YYYY-MM-DD]` pela data real ao usar o prompt
- Arquivos de auditoria anteriores ficam em `.claude/plans/` como histórico
- Compare auditorias consecutivas para medir se a dívida está crescendo ou diminuindo
- Quick wins são candidatos perfeitos para sessões de aquecimento ou onboarding de devs novos
