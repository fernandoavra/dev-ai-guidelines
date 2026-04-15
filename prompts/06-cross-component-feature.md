# Prompt 06 — Feature Cross-Componente

**Quando usar:** Tarefa que afeta mais de um componente (ex: api + app + backoffice).  
**Regra:** Contrato primeiro. Implementação paralela só após aprovação.

---

## Prompt

```
This feature spans multiple components. Use agent teams.

Feature: [DESCREVA A FEATURE AQUI]
Components affected: [ex: api, app, backoffice]

Orchestration plan:
1. @architect-agent: design the contract between components first
   - API schema, event format, or shared type definitions
   - Output to .claude/plans/[feature-name]-contract.md
   - Wait for my approval before any agent proceeds

2. After approval, run in parallel:
   - @[component-1]-agent: implement backend contract
   - @[component-2]-agent: implement frontend against mock of the contract
   - @[component-3]-agent: implement additional views/flows

3. @code-reviewer: validate that all implementations match the contract

4. @qa-engineer: write integration tests covering the full cross-component flow

No agent should begin implementation before the contract is approved.
Each agent must read [feature-name]-contract.md before starting.
```

---

## Notas de uso

- Substitua os agentes pelos nomes reais definidos em `.claude/agents/`
- O arquivo de contrato em `.claude/plans/` é o artefato mais importante desta sessão
- Se o contrato revelar que a feature é maior do que o esperado, divida em partes menores
