# Prompt 09 — Diagnóstico de Bug / Incidente

**Quando usar:** Algo quebrou. Produção, staging ou desenvolvimento.  
**Regra:** Root cause antes de qualquer código. Nunca pedir fix imediato.

---

## Prompt

```
Something is broken. Do not guess. Investigate first.

Symptom: [DESCREVA O COMPORTAMENTO ERRADO]
Environment: [dev | staging | prod]
First observed: [quando foi percebido pela primeira vez]
Frequency: [sempre | intermitente | sob condição X]
Recent changes: [últimos commits ou deploys relevantes, se souber]

Use subagents to:
1. Trace the full execution path from trigger to failure point
2. Identify every file involved in that path
3. Find exactly where actual behavior diverges from expected
4. Check git log for recent changes to involved files
5. Check if there are tests covering this path and whether they pass

Do not suggest a fix until you have:
- The root cause (not a symptom)
- The specific line or decision where it breaks
- Why it breaks (not just what)
- Whether this is a regression (worked before) or never worked

Present findings in this format:

Root cause: [one sentence]
Evidence: [file:line + explanation]
Why it worked before (if regression): [what changed]
Proposed fix: [specific changes, not vague suggestions]
Risk of fix: [what else might be affected]
Tests to add: [to prevent regression]

Wait for approval before implementing the fix.

After the fix is applied:
- If an active plan file exists, append the bug to its Decision log
- If missing test coverage was revealed, note it for tech debt backlog
- If this is a regression, verify and add the missing test
```

---

## Notas de uso

- Quanto mais contexto no preenchimento, melhor o diagnóstico
- Se o bug for em produção e urgente, ainda assim faça o diagnóstico — um fix errado piora
- Após resolver, documente a causa e a correção no Decision Log do plano ativo
- Se o bug revelou ausência de testes, adicione ao backlog de tech debt
