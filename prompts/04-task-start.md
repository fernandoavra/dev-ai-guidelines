# Prompt 04 — Início de Tarefa

**Quando usar:** Antes de qualquer implementação, sem exceção.  
**Regra:** Nunca pular para código sem aprovação explícita do plano.  
**Resultado:** `.claude/plans/<nome-da-tarefa>.md` criado com o plano inicial.

---

## Prompt

```
Before writing any code, use subagents to:
- Read PROJECT.md and the relevant section of CLAUDE.md
- Read .claude/agents/ and identify which agents are involved in this task
- Map every file that will need to change and why
- Identify cross-component dependencies (which components are affected)
- Flag any ambiguity that requires a decision before proceeding

Task: [DESCREVA A TAREFA AQUI]

Acceptance criteria:
- [critério 1]
- [critério 2]
- [critério 3]

Cross-component check: If more than 3 files across different components
are affected, flag this and suggest using the cross-component feature
workflow (Prompt 06) instead. Wait for my decision before proceeding.

After the exploration:
1. Save the plan to .claude/plans/<task-name>.md (sanitize name: lowercase,
   hyphens, no special chars) with: goal, steps, files affected, components,
   acceptance criteria, risks, open questions, and an empty decision log table.
2. Present the plan for approval.
3. Wait for my approval before writing any code.

During implementation, update the plan file whenever a decision changes
the scope, a file is added/removed, a risk materializes, or a question
is answered. Append scope-affecting decisions to the Decision log table.
```

---

## Notas de uso

- Preencha a tarefa e os critérios de aceite antes de rodar
- Se Claude começar a codar sem aprovação, interrompa e reforce o plano primeiro
- Se houver mais de 3 arquivos afetados em componentes diferentes, use o **Prompt 06**
- O arquivo de plano facilita o handoff (Prompt 05) — ele já contém o histórico de decisões
