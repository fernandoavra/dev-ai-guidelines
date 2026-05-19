# Task: Adicionar configurações ao settings.json gerado pelos scripts

**Started:** 2026-04-24
**Status:** done

## Goal
Adicionar 4 novas configurações (`language`, `preferredNotifChannel`, `remoteControlAtStartup`, `skipAutoPermissionPrompt`) ao settings.json global gerado pelos scripts setup-global.sh e setup-global.ps1.

## Plan
1. Editar `scripts/setup-global.sh` — adicionar as 4 novas propriedades ao heredoc do settings.json (linhas 84-171), logo após `_managed_by`
2. Editar `scripts/setup-global.ps1` — adicionar as mesmas 4 propriedades ao heredoc do settings.json (linhas 69-123), logo após `_managed_by`

## Files affected
- `scripts/setup-global.sh` — heredoc que gera ~/.claude/settings.json (adicionar 4 propriedades)
- `scripts/setup-global.ps1` — heredoc que gera ~/.claude/settings.json (adicionar 4 propriedades)

## Components involved
- scripts/ — scripts de setup global (únicos afetados)

## Acceptance criteria
- [x] `setup-global.sh` gera settings.json com `language`, `preferredNotifChannel`, `remoteControlAtStartup` e `skipAutoPermissionPrompt`
- [x] `setup-global.ps1` gera settings.json com as mesmas 4 propriedades
- [x] As propriedades `_scope` e `_managed_by` (já existentes) permanecem intactas
- [x] JSON gerado é válido (sem erros de sintaxe)

## Risks and edge cases
- Erro de sintaxe JSON no heredoc (trailing comma, aspas incorretas) — validar manualmente
- `_scope` e `_managed_by` já existem nos dois scripts — não duplicar

## Open questions
- Nenhuma — escopo claro e localizado

## Decision log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| 2026-04-24 | Não alterar hooks/settings.json | É referência apenas de hooks, não de settings globais | Nenhum |
| 2026-04-24 | Não duplicar _scope e _managed_by | Já existem nos heredocs | Nenhum |

---
*last-updated: 2026-04-24 12:15*
