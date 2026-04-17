# dev-ai-guidelines

Playbook de desenvolvimento apoiado por agentes de IA — focado em Claude Code e Cursor.

Contém prompts, templates, hooks, comandos e scripts de setup para estruturar
projetos, automatizar fluxos e integrar agentes de IA ao ciclo diário de desenvolvimento.

---

## Setup em 2 comandos

```bash
# 1. Uma vez por máquina — instala tudo globalmente
cd dev-ai-guidelines
chmod +x scripts/setup-global.sh
./scripts/setup-global.sh

# 2. Uma vez por projeto — adiciona hooks do time
cd seu-projeto
/caminho/para/dev-ai-guidelines/scripts/setup-project.sh
git add .claude/ .cursor/ && git commit -m "chore: add ai hooks for team workflow"
```

**Windows (PowerShell):**
```powershell
.\scripts\setup-global.ps1   # uma vez por máquina
.\scripts\setup-project.ps1  # uma vez por projeto (rodar de dentro do projeto)
```

---

## O que o setup instala

### `setup-global` — pessoal, nunca commitado

| O que | Onde | Descrição |
|---|---|---|
| `CLAUDE.md` global | `~/.claude/CLAUDE.md` | Regras de orquestração multi-agente para todos os projetos |
| Comandos `/ai:*` | `~/.claude/commands/ai/` | 13 comandos prontos em qualquer projeto |
| Hooks Claude Code | `~/.claude/settings.json` | startup-check, intercept-clear, post-compact, post-clear-orient, block-dangerous, session-log |
| Hooks Cursor | `~/.cursor/hooks.json` | startup-check, block-dangerous, session-log |
| Scripts | `~/.claude/hooks/` e `~/.cursor/hooks/scripts/` | Scripts shell e Node.js |
| Prompts | `~/.claude/prompts/` | Referenciados pelos hooks automaticamente |

### `setup-project` — commitado, vale para o time

| O que | Onde | Descrição |
|---|---|---|
| `settings.json` | `.claude/settings.json` | format-on-edit + require-tests |
| `hooks.json` | `.cursor/hooks.json` | format-on-edit + require-tests |
| Template de plano | `.claude/plans/active-plan.md` | Handoff de sessão |

---

## Comandos `/ai:*` disponíveis após setup

| Comando | Quando usar |
|---|---|
| `/ai:setup` | Projeto novo — cria CLAUDE.md, agents, skills |
| `/ai:update` | Projeto existente — gap analysis antes de mudar |
| `/ai:docs` | Gera ou atualiza `PROJECT.md` |
| `/ai:task <descrição>` | Início de qualquer tarefa — plano antes do código |
| `/ai:handoff <nome-da-tarefa>` | Salva estado de uma tarefa antes de `/clear` ou encerrar |
| `/ai:resume [nome-da-tarefa]` | Retoma tarefa salva — lista disponíveis se nome omitido |
| `/ai:daily-close` | Final do dia — gera resumo do progresso e pendências |
| `/ai:daily-start` | Início do dia — briefing com contexto do dia anterior |
| `/ai:review` | Antes de abrir qualquer PR |
| `/ai:debt` | Auditoria periódica de dívida técnica |
| `/ai:bug <sintoma>` | Diagnóstico de bug — root cause antes de qualquer fix |
| `/ai:feature <descrição>` | Feature cross-componente — contrato antes dos agentes |
| `/ai:add <caminho>` | Novo componente adicionado — integração cirúrgica na estrutura existente |

### Fluxo handoff/resume (múltiplas tarefas em paralelo)

```
/ai:handoff migrar-auth-oauth2    # salva em .claude/plans/migrar-auth-oauth2.md
/ai:handoff refatorar-pagamentos  # salva em .claude/plans/refatorar-pagamentos.md
/clear

# nova sessão
/ai:resume                        # lista todas as tarefas salvas
/ai:resume migrar-auth-oauth2     # retoma direto uma tarefa específica
```

### Fluxo diário (controle semanal de progresso)

```
# final do dia
/ai:daily-close                   # gera .claude/dailies/2026-04-17.md

# manhã seguinte
/ai:daily-start                   # lê o daily mais recente e apresenta briefing
```

Os dailies são resumos leves — referenciam os planos em `.claude/plans/` sem duplicar conteúdo. Útil para manter visibilidade do progresso ao longo da semana.

---

## Hooks — descrição detalhada

Hooks são scripts que disparam automaticamente em eventos do Claude Code ou Cursor. Executam validações, injeções de contexto e automações sem intervenção manual.

### Hooks globais (instalados por `setup-global`)

| Hook | Evento | Descrição |
|---|---|---|
| **startup-check** | `SessionStart` (startup) | Detecta se o projeto tem `CLAUDE.md` e `.claude/agents/`. Se ausentes, injeta prompt orientando o setup. Evita que sessões comecem sem contexto. |
| **intercept-clear** | `UserPromptSubmit` | Intercepta `/clear` antes de executar. Verifica se existe trabalho não salvo e injeta prompt de handoff para evitar perda de contexto entre sessões. |
| **post-compact** | `SessionStart` (compact) | Após `/compact`, reinjecta o plano ativo (`.claude/plans/`) e orienta o Claude a se recontextualizar. Evita que compactação cause perda de direção. |
| **post-clear-orient** | `SessionStart` (clear) | Após `/clear`, reinjecta os próximos passos do handoff anterior para que o Claude saiba de onde continuar sem precisar perguntar. |
| **block-dangerous** | `PreToolUse` (Bash) | Bloqueia comandos destrutivos (`rm -rf /`, `drop database`, `git push --force`, etc.) antes da execução. Atua como rede de segurança em qualquer projeto. |
| **session-log** | `Stop` | Registra fim de sessão com timestamp em `.claude/logs/sessions.log` e envia notificação desktop (macOS/Linux). Útil para rastreabilidade. |

### Hooks por projeto (instalados por `setup-project`)

| Hook | Evento | Descrição |
|---|---|---|
| **format-on-edit** | `PostToolUse` (Edit/Write/MultiEdit) | Roda o formatador do projeto automaticamente após qualquer edição. Detecta a stack (prettier, black, gofmt, etc.) e aplica o formatador correto. |
| **require-tests** | `PreToolUse` (create_pull_request) | Bloqueia abertura de PR se os testes não estiverem passando. Detecta o runner (npm test, pytest, go test, etc.) e executa automaticamente. |

### Equivalência Claude Code / Cursor

| Função | Claude Code (bash) | Cursor (Node.js) |
|---|---|---|
| Startup check | `hooks/startup-check.sh` | `hooks-cursor/scripts/startup-check.mjs` |
| Block dangerous | `hooks/block-dangerous.sh` | `hooks-cursor/scripts/block-dangerous.mjs` |
| Session log | `hooks/session-log.sh` | `hooks-cursor/scripts/session-log.mjs` |
| Format on edit | `hooks/format-on-edit.sh` | `hooks-cursor/scripts/format-on-edit.mjs` |
| Require tests | `hooks/require-tests.sh` | `hooks-cursor/scripts/require-tests.mjs` |
| Intercept clear | `hooks/intercept-clear.sh` | _(sem equivalente Cursor)_ |
| Post compact | `hooks/post-compact.sh` | _(sem equivalente Cursor)_ |
| Post clear orient | `hooks/post-clear-orient.sh` | _(sem equivalente Cursor)_ |

---

## Cursor Rules — equivalentes dos comandos `/ai:*`

O Cursor não tem slash commands com argumentos. Em vez disso, usa **rules** (`.mdc`) ativadas por contexto ou manualmente. As Cursor rules equivalentes ficam em `cursor/rules/`:

| Claude Code | Cursor Rule | Ativação |
|---|---|---|
| `/ai:setup` | `setup-project.mdc` | Manual |
| `/ai:update` | `gap-analysis.mdc` | Manual |
| `/ai:docs` | `project-documentation.mdc` | Manual |
| `/ai:task` | `task-start.mdc` | Manual |
| `/ai:handoff` | `session-handoff.mdc` | Manual — pede nome da tarefa |
| `/ai:resume` | `session-resume.mdc` | Manual — lista tarefas se nome omitido |
| `/ai:daily-close` | `daily-close.mdc` | Manual |
| `/ai:daily-start` | `daily-start.mdc` | Manual |
| `/ai:review` | `code-review.mdc` | Manual |
| `/ai:debt` | `tech-debt-audit.mdc` | Manual |
| `/ai:bug` | `bug-diagnosis.mdc` | Manual |
| `/ai:feature` | `cross-component-feature.mdc` | Manual |

---

## Estrutura do repositório

```
dev-ai-guidelines/
├── scripts/                    # Setup automatizado (global + projeto)
│   ├── setup-global.sh / .ps1  # Instala hooks, comandos e CLAUDE.md global
│   ├── setup-project.sh / .ps1 # Instala hooks do projeto (commitável)
│   └── README.md
│
├── commands/ai/                # Comandos /ai:* para Claude Code
│   ├── setup.md   update.md   docs.md   add.md
│   ├── task.md    handoff.md  resume.md
│   ├── daily-close.md  daily-start.md
│   ├── review.md  debt.md    bug.md    feature.md
│
├── hooks/                      # Hooks Claude Code — bash (macOS/Linux)
│   ├── startup-check.sh        # Detecta projeto sem CLAUDE.md
│   ├── intercept-clear.sh      # Força handoff antes de /clear
│   ├── post-compact.sh         # Reorienta após /compact
│   ├── post-clear-orient.sh    # Reorienta após /clear
│   ├── block-dangerous.sh      # Bloqueia comandos destrutivos
│   ├── format-on-edit.sh       # Auto-formata após edições
│   ├── require-tests.sh        # Bloqueia PR se testes falhando
│   ├── session-log.sh          # Log + notificação desktop
│   ├── settings.json           # Configuração de referência
│   └── INSTALL.md
│
├── hooks-cursor/               # Hooks Cursor — Node.js (cross-platform)
│   ├── scripts/*.mjs           # Equivalentes dos hooks bash em Node.js
│   ├── hooks.json              # Configuração de referência
│   └── INSTALL.md              # Notas de compatibilidade Windows
│
├── cursor/rules/               # Cursor Rules — equivalentes dos /ai:*
│   ├── session-handoff.mdc     # Handoff com nome de tarefa
│   ├── session-resume.mdc      # Retomada de tarefa salva
│   ├── daily-close.mdc         # Resumo de final do dia
│   ├── daily-start.mdc         # Briefing de início do dia
│   ├── task-start.mdc          # Início de tarefa com plano
│   ├── setup-project.mdc       # Setup de projeto novo
│   ├── gap-analysis.mdc        # Gap analysis de projeto existente
│   ├── project-documentation.mdc # Geração de PROJECT.md
│   ├── code-review.mdc         # Review antes de PR
│   ├── bug-diagnosis.mdc       # Diagnóstico de bug
│   ├── tech-debt-audit.mdc     # Auditoria de dívida técnica
│   ├── cross-component-feature.mdc # Feature cross-componente
│   └── project-conventions.mdc # Convenções do projeto (alwaysApply)
│
├── templates/
│   ├── CLAUDE.md               # Template do contexto do projeto
│   ├── global-CLAUDE.md        # Template do ~/.claude/CLAUDE.md global
│   ├── PROJECT.md              # Template da documentação do projeto
│   └── active-plan.md          # Template de handoff de sessão
│
├── agents/                     # Subagentes prontos para uso
│   ├── code-reviewer.md
│   ├── architect.md
│   ├── qa-engineer.md
│   └── security-reviewer.md    # inclui tech-debt-auditor
│
├── prompts/                    # Prompts detalhados (referência e uso manual)
│   ├── 01-setup-hybrid-structure.md
│   ├── 02-gap-analysis.md
│   ├── 03-project-documentation.md
│   ├── 04-task-start.md
│   ├── 05-session-handoff.md
│   ├── 06-cross-component-feature.md
│   ├── 07-code-review.md
│   ├── 08-tech-debt-audit.md
│   └── 09-bug-diagnosis.md
│
├── DAILY-ROUTINE.md            # Rotina diária com checklist completo
└── README.md
```

---

## Fluxo para projeto novo

```bash
./scripts/setup-global.sh       # uma vez por máquina
claude                          # abre Claude Code no projeto
/ai:setup                       # cria CLAUDE.md + agents + skills
/ai:docs                        # gera PROJECT.md
../dev-ai-guidelines/scripts/setup-project.sh
git add .claude/ .cursor/ && git commit -m "chore: add ai hooks"
```

## Fluxo para projeto existente

```bash
./scripts/setup-global.sh       # uma vez por máquina (se ainda não fez)
claude                          # abre Claude Code no projeto
/ai:update                      # gap analysis — respeita o que já existe
/ai:docs                        # atualiza PROJECT.md
../dev-ai-guidelines/scripts/setup-project.sh
git add .claude/ .cursor/ && git commit -m "chore: add ai hooks"
```

---

## Rotina diária (resumo)

```
Manhã    → /ai:daily-start → briefing do dia anterior → escolha tarefa
Tarefa   → /ai:resume <nome> ou /ai:task <nova>
PR       → /ai:review antes de abrir
Pausa    → /ai:handoff <nome-da-tarefa> → /clear
Fim dia  → /ai:daily-close → resumo do dia salvo
Quinzenal → /ai:debt
Bug      → /ai:bug <sintoma>
```

Checklist completo em `DAILY-ROUTINE.md`.

---

## O que cada script configura

### `setup-global.sh` / `setup-global.ps1`

Executa uma vez por máquina. Instala recursos **pessoais** (nunca commitados):

| Recurso | Destino | Detalhes |
|---|---|---|
| CLAUDE.md global | `~/.claude/CLAUDE.md` | Regras de orquestração multi-agente, gerenciamento de contexto, fluxo de trabalho padrão e regras de segurança |
| Comandos `/ai:*` (13) | `~/.claude/commands/ai/*.md` | setup, update, docs, task, handoff, resume, daily-close, daily-start, review, debt, bug, feature, add |
| Hook: startup-check | `~/.claude/hooks/startup-check.sh` | Dispara em `SessionStart`(startup) — detecta projeto sem CLAUDE.md |
| Hook: intercept-clear | `~/.claude/hooks/intercept-clear.sh` | Dispara em `UserPromptSubmit` — intercepta `/clear` e força handoff |
| Hook: post-compact | `~/.claude/hooks/post-compact.sh` | Dispara em `SessionStart`(compact) — reinjecta plano ativo |
| Hook: post-clear-orient | `~/.claude/hooks/post-clear-orient.sh` | Dispara em `SessionStart`(clear) — reinjecta próximos passos |
| Hook: block-dangerous | `~/.claude/hooks/block-dangerous.sh` | Dispara em `PreToolUse`(Bash) — bloqueia comandos destrutivos |
| Hook: session-log | `~/.claude/hooks/session-log.sh` | Dispara em `Stop` — log + notificação desktop |
| settings.json global | `~/.claude/settings.json` | Registra todos os hooks globais acima no Claude Code |
| Scripts Cursor (Node.js) | `~/.cursor/hooks/scripts/*.mjs` | startup-check, block-dangerous, session-log (cross-platform) |
| hooks.json Cursor | `~/.cursor/hooks.json` | Registra hooks globais no Cursor |
| Prompts | `~/.claude/prompts/` e `~/.cursor/prompts/` | Prompts referenciados pelos hooks |

### `setup-project.sh` / `setup-project.ps1`

Executa uma vez por projeto. Instala recursos **commitáveis** (valem para o time):

| Recurso | Destino | Detalhes |
|---|---|---|
| Hook: format-on-edit | `.claude/hooks/format-on-edit.sh` | Dispara em `PostToolUse`(Edit/Write/MultiEdit) — auto-formata com a ferramenta do projeto |
| Hook: require-tests | `.claude/hooks/require-tests.sh` | Dispara em `PreToolUse`(create_pull_request) — bloqueia PR se testes falhando |
| settings.json projeto | `.claude/settings.json` | Registra format-on-edit e require-tests; define modelo padrão `claude-sonnet-4-6` |
| Template de plano | `.claude/plans/active-plan.md` | Template de handoff de sessão |
| Scripts Cursor (Node.js) | `.cursor/hooks/scripts/*.mjs` | format-on-edit, require-tests (cross-platform) |
| hooks.json Cursor | `.cursor/hooks.json` | Registra hooks de projeto no Cursor (afterFileEdit + beforeShellExecution) |
| .gitignore | `.gitignore` | Adiciona `.claude/settings.local.json`, `.claude/logs/`, `.claude/plans/archive/`, `.claude/dailies/` |

---

## Configuração de modelos (pessoal, por dev)

```bash
# ~/.zshrc ou ~/.bashrc
export ANTHROPIC_MODEL="claude-sonnet-4-6"
# export ANTHROPIC_MODEL="claude-opus-4-6"          # plano Max/Team Premium
export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-6"
```

Se não configurar nada, o Claude Code usa o padrão do plano automaticamente.

---

## Compatibilidade

| Recurso | macOS | Linux | Windows WSL2 | Windows nativo |
|---|---|---|---|---|
| Hooks Claude Code (`.sh`) | ✅ | ✅ | ✅ | ⚠️ |
| Hooks Cursor (`.mjs`) | ✅ | ✅ | ✅ | ✅ |
| Comandos `/ai:*` | ✅ | ✅ | ✅ | ✅ |
| Cursor Rules (`.mdc`) | ✅ | ✅ | ✅ | ✅ |
| Scripts de setup | `.sh` | `.sh` | `.sh` | `.ps1` |

---

## Princípios

- **Explorar antes de agir** — nenhum agente escreve código sem mapear o contexto
- **Planejar antes de implementar** — aprovação explícita antes de qualquer mudança
- **Documentar antes de fechar** — sessão não encerra sem handoff registrado
- **Contexto enxuto** — `/clear` entre tarefas, `/compact` só no meio de tarefa longa
- **Paralelizar com critério** — paralelo quando independente, sequencial quando há dependência

---

## Referências

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code Hooks](https://code.claude.com/docs/en/hooks)
- [Cursor Hooks](https://cursor.com/docs/hooks)
- [Skills Explained](https://claude.com/blog/skills-explained)
