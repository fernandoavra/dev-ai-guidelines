# Prompt 05 — Handoff de Sessão

**Quando usar:** Sempre antes de `/clear`, fechar o terminal ou encerrar o dia.  
**Resultado:** `.claude/plans/<nome-da-tarefa>.md` atualizado com estado de fechamento.

---

## Prompt

```
Before we close this session, I need a handoff for task: [NOME DA TAREFA]

Check if .claude/plans/<task-name>.md already exists (created by task-start).

If it exists, update it by adding these handoff sections.
If it does not exist, create it from scratch.

## Handoff — (current date)

### Status at close
- What was completed (be specific: files changed, decisions made)
- What is in progress (exact state, not "working on X")
- What is blocked and why

### Next session start
- First command to run to verify state
- First task to pick up (be specific enough that no context is needed)
- Context that must NOT be lost (decisions, constraints discovered)

### Open risks
- Anything fragile or incomplete that needs attention
- Tests not yet written for code already merged
- Decisions deferred that will affect next steps

### Resume summary
Summarize in 3 sentences what someone (human or AI agent)
needs to know to continue this work cold.

Update the status and last-updated timestamp.
Confirm the file path so I can resume later.
```

---

## Notas de uso

- Rode este prompt antes de qualquer `/clear` em sessão de trabalho real
- Se a tarefa foi iniciada com o Prompt 04, o plano já existe e o handoff complementa
- Se a tarefa foi concluída totalmente, arquive o plano em `.claude/plans/archive/`
- Para retomar, use: `/ai:resume <nome-da-tarefa>`
