# Prompt 06 — Feature Cross-Componente

**Quando usar:** Tarefa que afeta mais de um componente (ex: api + app + backoffice).  
**Regra:** Contrato primeiro. Implementação paralela só após aprovação.  
**Resultado:** `.claude/plans/<nome-da-feature>.md` criado com contrato e plano.

---

## Prompt

```
This feature spans multiple components. Use agent teams.

Feature: [DESCREVA A FEATURE AQUI]
Components affected: [ex: api, app, backoffice]

Orchestration plan:
1. @architect-agent: design the contract between components first
   - API schema, event format, or shared type definitions
   - Save to .claude/plans/<feature-name>.md (sanitize name: lowercase,
     hyphens, no special chars) with: goal, contract (components, interfaces,
     constraints, implementation order), plan, files affected, acceptance
     criteria, risks, open questions, and an empty decision log table.
   - Wait for my approval before any agent proceeds

2. After approval, run in parallel:
   - @[component-1]-agent: implement backend contract
   - @[component-2]-agent: implement frontend against mock of the contract
   - @[component-3]-agent: implement additional views/flows
   Each agent must read the plan file before starting.

3. @code-reviewer: validate that all implementations match the contract

4. @qa-engineer: write integration tests covering the full cross-component flow

No agent should begin implementation before the contract is approved.

During implementation, update the plan file whenever a decision changes
the contract, a component deviates from the contract, a file is added/removed,
or a risk materializes. Append scope-affecting decisions to the Decision log.

If the feature turns out larger than expected, communicate clearly and
propose splitting — do NOT silently reduce scope.
```

---

## Notas de uso

- Substitua os agentes pelos nomes reais definidos em `.claude/agents/`
- O arquivo de plano em `.claude/plans/` é o artefato mais importante desta sessão
- Se o contrato revelar que a feature é maior do que o esperado, divida em partes menores
- O plano facilita o handoff (Prompt 05) — ele já contém o histórico de decisões
