# Prompt 07 — Code Review

**Quando usar:** Antes de mergear qualquer PR relevante.  
**Regra:** O agente que escreveu o código não deve revisar o próprio código.

---

## Prompt

```
Review the changes in this PR as a senior engineer who did NOT write this code.

Use subagents:
- @code-reviewer: quality, readability, patterns, PROJECT.md conventions
- @security-reviewer: secrets, injection, auth gaps, exposed data
- @qa-engineer: test coverage, missing edge cases, untested paths

For each issue found, format as:

[SEVERITY: critical | major | minor] [FILE:LINE]
Problem: what is wrong
Why: why it matters in this codebase
Fix: concrete suggestion (with code if applicable)

Also report:
- What was done well (genuine, not generic praise)
- Whether the implementation matches PROJECT.md conventions
- Whether CLAUDE.md rules were followed
- Whether any decision was made that should go to the Decision Log

Do not approve. Only report findings.
```

---

## Notas de uso

- Cole o diff ou mencione os arquivos alterados se o Claude não tiver acesso ao PR diretamente
- `critical` = não pode mergear | `major` = deve corrigir antes | `minor` = sugestão
- Se nenhum `@security-reviewer` existir no projeto, peça ao `@code-reviewer` que
  inclua uma seção de segurança na revisão
