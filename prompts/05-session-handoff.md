# Prompt 05 — Handoff de Sessão

**Quando usar:** Sempre antes de `/clear`, fechar o terminal ou encerrar o dia.  
**Resultado:** `.claude/plans/active-plan.md` atualizado com estado real da sessão.

---

## Prompt

```
Before we close this session, create or update
.claude/plans/active-plan.md with:

## State at close
- What was completed (be specific: files changed, decisions made)
- What is in progress (exact state, not "working on X")
- What is blocked and why

## Next session start
- First command to run to verify state
- First task to pick up (be specific enough that no context is needed)
- Context that must NOT be lost (decisions, constraints discovered)

## Risks open
- Anything fragile or incomplete that needs attention
- Tests not yet written for code already merged
- Decisions deferred that will affect next steps

Then summarize in 3 sentences what someone (human or AI agent)
needs to know to continue this work cold.
```

---

## Notas de uso

- Rode este prompt antes de qualquer `/clear` em sessão de trabalho real
- O `active-plan.md` é o único estado que sobrevive entre sessões — trate-o como crítico
- Se uma tarefa foi concluída totalmente, arquive o plano em `.claude/plans/archive/`
  e deixe o `active-plan.md` limpo para a próxima
