# Task: Implementar comando ai:hostile-review com agente hostile-reviewer

**Started:** 2026-05-09
**Status:** in-progress

## Goal
Criar um novo comando `/ai:hostile-review` que dispara um agente adversarial para validar criticamente o trabalho feito — desafiando decisões, abordagem e completude antes de finalizar ou avançar para próximas fases.

## Plan
1. Criar `agents/hostile-reviewer.md` — o agente adversarial com persona de reviewer hostil, modelo sonnet, read-only
2. Criar `commands/ai/hostile-review.md` — o comando que detecta a tarefa ativa, coleta contexto (diff, plano, arquivos alterados) e delega ao hostile-reviewer
3. Instalar comando localmente via `scripts/update-commands.sh` para validação

## Diferença do ai:review existente

| Aspecto | ai:review | ai:hostile-review |
|---------|-----------|-------------------|
| Quando | Pré-PR, antes de merge | Mid-task, antes de avançar fase |
| Foco | Código (qualidade, segurança, testes) | Abordagem (decisões, completude, lógica) |
| Perspectiva | "O código está bom?" | "Isso realmente resolve o problema?" |
| Agentes | code-reviewer, security-reviewer, qa-engineer | hostile-reviewer (único, adversarial) |
| Saída | Lista de issues por severidade | Veredicto GO/NO-GO com blockers |

## Files affected
- `agents/hostile-reviewer.md` — novo agente adversarial (read-only, sonnet)
- `commands/ai/hostile-review.md` — novo comando que orquestra a revisão hostil

## Components involved
- agents/ — novo agente hostile-reviewer
- commands/ai/ — novo comando hostile-review

## Acceptance criteria
- [x] Agente hostile-reviewer.md criado seguindo padrão dos agentes existentes
- [x] Comando hostile-review.md criado seguindo padrão dos comandos existentes
- [x] Comando detecta tarefa ativa automaticamente (via .active-sessions.json)
- [x] Comando funciona sem tarefa ativa (analisa git diff do branch)
- [x] Agente produz veredicto GO/NO-GO estruturado
- [x] Agente cruza mudanças feitas vs. plano/objetivo da tarefa
- [x] Agente desafia decisões, abordagem e completude — não apenas qualidade de código

## Risks and edge cases
- Sem tarefa ativa e sem diff: o comando não tem o que revisar — deve informar e abortar
- Plano sem acceptance criteria claros: o reviewer terá menos base para validar
- Confusão com ai:review: documentar claramente quando usar cada um

## Open questions
- (nenhuma — o escopo é claro)

## Decision log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| 2026-05-09 | Agente único (não 3 como ai:review) | Revisão hostil é uma perspectiva coesa, não 3 análises separadas | Simplifica comando |
| 2026-05-09 | Read-only (sem Write/Edit) | Reviewer hostil só reporta, nunca corrige | Segurança |
| 2026-05-09 | Veredicto GO/NO-GO | Decisão binária clara para o fluxo de trabalho | Facilita integração |
| 2026-05-09 | Hostile review: NO-GO → fixes applied | 2 blockers: branch detection e plan handoff ao subagente | Comando reescrito com bash explícito |
| 2026-05-09 | Adicionado argument-hint | Permite override manual quando auto-detection falha (ex: PID mudou) | Alinha com padrão do task-finish |
| 2026-05-09 | git diff --staged adicionado | Staged changes não eram capturados | Step 2 agora cobre unstaged + staged |

---
*last-updated: 2026-05-09 10:15*
