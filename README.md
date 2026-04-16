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
| Comandos `/ai:*` | `~/.claude/commands/ai/` | 9 comandos prontos em qualquer projeto |
| Hooks Claude Code | `~/.claude/settings.json` | startup-check, intercept-clear, block-dangerous, session-log |
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
| `/ai:handoff` | Antes de `/clear` ou encerrar o dia |
| `/ai:review` | Antes de abrir qualquer PR |
| `/ai:debt` | Auditoria periódica de dívida técnica |
| `/ai:bug <sintoma>` | Diagnóstico de bug — root cause antes de qualquer fix |
| `/ai:feature <descrição>` | Feature cross-componente — contrato antes dos agentes |
| `/ai:add <caminho>` | Novo componente adicionado — integração cirúrgica na estrutura existente |

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
│   ├── task.md    handoff.md  review.md
│   ├── debt.md    bug.md      feature.md
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
Início   → leia active-plan.md → /ai:task <tarefa>
Durante  → /clear entre tarefas, /compact no meio de tarefa longa
PR       → /ai:review antes de abrir
Fim      → /ai:handoff → /clear
Quinzenal → /ai:debt
Bug      → /ai:bug <sintoma>
```

Checklist completo em `DAILY-ROUTINE.md`.

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
