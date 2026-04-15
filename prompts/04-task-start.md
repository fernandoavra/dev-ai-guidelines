# Prompt 04 — Início de Tarefa

**Quando usar:** Antes de qualquer implementação, sem exceção.  
**Regra:** Nunca pular para código sem aprovação explícita do plano.

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

After the exploration, present:
1. Implementation plan (steps, order, rationale)
2. Files to be created or modified (with reason for each)
3. Risks and edge cases
4. Questions that need answers before starting

Wait for my approval before writing any code.
```

---

## Notas de uso

- Preencha a tarefa e os critérios de aceite antes de rodar
- Se Claude começar a codar sem aprovação, interrompa e reforce o plano primeiro
- Se houver mais de 3 arquivos afetados em componentes diferentes, use o **Prompt 06**
