# Task: atualizar statusline para registrar tarefa no ai:task e ai:feature

**Started:** 2026-05-09
**Status:** done

## Goal
Garantir que o statusline exiba o nome da tarefa ativa assim que `/ai:task` ou `/ai:feature` são chamados, não apenas em `/ai:resume`.

## Problem analysis
- `ai:feature` (`commands/ai/feature.md`) não possui nenhum passo de registro de sessão em `.active-sessions.json`
- `ai:task` (`commands/ai/task.md`) tem o registro no Step 3, separado da criação do plano — o modelo às vezes pula direto para Step 4 sem executar o bash
- `ai:resume` funciona corretamente porque o registro está integrado ao fluxo principal

## Plan
1. `ai:task` — mover o registro de sessão para dentro do Step 2, logo após criar o arquivo do plano, e remover o Step 3 como passo separado. Renumerar steps subsequentes (4→3, 5→4)
2. `ai:feature` — adicionar registro de sessão ao Step 1, logo após criar o arquivo do plano (antes de apresentar para aprovação)

## Files affected
- `commands/ai/task.md` — mover registro de Step 3 para final do Step 2, remover Step 3, renumerar
- `commands/ai/feature.md` — adicionar bloco de registro no Step 1

## Components involved
- commands/ai — skill definitions que controlam o fluxo de tarefas
- .claude/statusline-command.sh — já funciona corretamente (lê .active-sessions.json)

## Acceptance criteria
- [x] `ai:task` registra sessão imediatamente após criar o plano (sem passo separado)
- [x] `ai:feature` registra sessão após criar o plano
- [x] Steps renumerados corretamente em `ai:task`
- [x] Nenhuma regressão no fluxo de `ai:resume`, `ai:task-finish`, `ai:task-delete`, `ai:handoff`

## Risks and edge cases
- A renumeração de steps no `ai:task` pode confundir se houver referências externas aos números dos steps (verificar prompts/ e documentação)

## Open questions
- (nenhuma)

## Decision log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| 2026-05-09 | Mover registro para dentro do step de criação do plano | Registro separado é frequentemente pulado pelo modelo | Melhora confiabilidade |

---
*last-updated: 2026-05-09 14:35*
