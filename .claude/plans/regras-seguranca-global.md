# Task: Definir regras de seguranca globais para Claude Code

**Started:** 2026-04-23
**Status:** done

## Goal
Expandir a secao de seguranca do CLAUDE.md global com regras abrangentes de melhores praticas que o Claude deve seguir em todos os projetos.

## Plan
1. [x] Aprovar conjunto de regras — apresentar recomendacoes categorizadas e esperar aprovacao
2. [x] Atualizar template — editar `templates/global-CLAUDE.md` com a nova secao de seguranca
3. [x] Atualizar instancia ativa — editar `~/.claude/CLAUDE.md` com o mesmo conteudo
4. [x] Criar hook block-env-files.sh — enforcement para bloquear Read/Write/Edit em .env
5. [x] Atualizar hook block-dangerous.sh — bloquear `cat .env` e similares via Bash
6. [x] Atualizar setup-global.sh — incluir novo hook na instalacao e settings.json
7. [x] Bump version — template atualizado para 1.2

## Files affected
- `templates/global-CLAUDE.md` — secao de seguranca expandida (4 → 9 categorias)
- `~/.claude/CLAUDE.md` — instancia ativa sincronizada
- `hooks/block-env-files.sh` — novo hook de enforcement para arquivos de ambiente
- `hooks/block-dangerous.sh` — regra adicional para bloquear `cat .env` via Bash
- `~/.claude/settings.json` — novo hook PreToolUse registrado
- `scripts/setup-global.sh` — instalacao e settings.json atualizados

## Acceptance criteria
- [x] Regras cobrem todas as categorias (codigo, secrets, dependencias, git, dados, infra, auth, filesystem, env files)
- [x] Regras sao acionaveis (o Claude consegue segui-las)
- [x] Template e instancia ativa sincronizados
- [x] Hook de enforcement criado e instalado para .env files
- [x] block-dangerous.sh atualizado para cobrir `cat .env` via Bash
- [x] setup-global.sh atualizado com novo hook

## Decision log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| 2026-04-23 | Initial plan created | — | — |
| 2026-04-23 | Versao completa aprovada | Usuario pediu todas as categorias | 9 categorias de seguranca |
| 2026-04-23 | Secao .env como proibicao absoluta | Usuario pediu explicitamente | Hook de enforcement + regra CLAUDE.md |
| 2026-04-23 | Dupla protecao .env (hook + bash) | .env pode ser lido via Read tool ou via cat no Bash | Dois hooks cobrem ambos vetores |

---
*last-updated: 2026-04-23 22:25*
