# Scripts de Setup

Scripts para configurar hooks globais e por projeto em todas as plataformas.

---

## Visão geral

```
scripts/
├── setup-global.sh      # macOS / Linux — hooks globais (todos os projetos)
├── setup-global.ps1     # Windows       — hooks globais (todos os projetos)
├── setup-project.sh     # macOS / Linux — hooks por projeto (este projeto)
└── setup-project.ps1    # Windows       — hooks por projeto (este projeto)
```

---

## Qual script roda quando

| Script | Quem roda | Quando | Onde rodar |
|---|---|---|---|
| `setup-global.sh/ps1` | Cada dev, uma vez | Ao entrar no time ou trocar de máquina | Raiz do `dev-ai-guidelines` |
| `setup-project.sh/ps1` | Dev ou CI, uma vez por projeto | Ao criar ou reorganizar um projeto | Raiz do projeto alvo |

---

## O que cada script instala

### `setup-global` — hooks pessoais, nunca commitados

| Hook | Ferramenta | Evento | Comportamento |
|---|---|---|---|
| `startup-check` | Claude Code + Cursor | Início de sessão | Detecta projeto sem CLAUDE.md |
| `block-dangerous` | Claude Code + Cursor | Antes de qualquer comando | Bloqueia padrões destrutivos |
| `session-log` | Claude Code + Cursor | Fim de sessão | Log + notificação desktop |
| `intercept-clear` | Claude Code | Prompt com `/clear` | Força handoff antes de limpar |
| `post-compact` | Claude Code | Após `/compact` | Reinjecta plano ativo |
| `post-clear-orient` | Claude Code | Após `/clear` | Reinjecta próximos passos |

### `setup-project` — hooks do time, commitados no repositório

| Hook | Ferramenta | Evento | Comportamento |
|---|---|---|---|
| `format-on-edit` | Claude Code + Cursor | Após edição de arquivo | Auto-formata (prettier/black/gofmt) |
| `require-tests` | Claude Code + Cursor | Antes de PR/push para main | Bloqueia se testes falhando |

---

## Uso

### macOS / Linux

```bash
# 1. Uma vez por máquina — hooks globais
cd dev-ai-guidelines
chmod +x scripts/setup-global.sh
./scripts/setup-global.sh

# 2. Uma vez por projeto — hooks do time
cd seu-projeto
/caminho/para/dev-ai-guidelines/scripts/setup-project.sh

# 3. Commitar os hooks de projeto
git add .claude/settings.json .claude/hooks/ .claude/plans/
git add .cursor/hooks.json .cursor/hooks/scripts/
git commit -m "chore: add ai hooks for team workflow"
```

### Windows (PowerShell)

```powershell
# Habilitar execução de scripts (uma vez)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# 1. Uma vez por máquina — hooks globais
cd dev-ai-guidelines
.\scripts\setup-global.ps1

# 2. Uma vez por projeto — hooks do time
cd seu-projeto
/caminho/para/dev-ai-guidelines/scripts/setup-project.ps1

# 3. Commitar os hooks de projeto
git add .claude\settings.json .claude\hooks\ .claude\plans\
git add .cursor\hooks.json .cursor\hooks\scripts\
git commit -m "chore: add ai hooks for team workflow"
```

---

## Estrutura gerada após setup completo

```
~/ (pasta do usuário — nunca commitado)
├── .claude/
│   ├── settings.json          ← hooks globais do Claude Code
│   ├── hooks/*.sh             ← scripts globais (macOS/Linux)
│   ├── hooks/*.mjs            ← scripts globais (Windows)
│   └── prompts/*.md           ← prompts referenciados pelos hooks
└── .cursor/
    ├── hooks.json             ← hooks globais do Cursor
    ├── hooks/scripts/*.mjs    ← scripts globais Node.js
    └── prompts/*.md           ← prompts referenciados pelos hooks

seu-projeto/ (commitado no repositório)
├── .claude/
│   ├── settings.json          ← hooks do projeto (format + require-tests)
│   ├── hooks/*.sh ou *.mjs    ← scripts do projeto
│   └── plans/active-plan.md  ← template de handoff
└── .cursor/
    ├── hooks.json             ← hooks do projeto
    └── hooks/scripts/*.mjs    ← scripts Node.js do projeto
```

---

## Notas de plataforma

**Windows sem WSL2:** os scripts globais usam `.mjs` (Node.js) em vez de `.sh`.
O Claude Code no Windows não executa `.sh` nativamente — veja `hooks-cursor/INSTALL.md`.

**macOS/Linux:** ambos `.sh` (Claude Code global) e `.mjs` (Cursor e projeto) são usados.
Os `.mjs` são cross-platform; os `.sh` são mais simples e idiomáticos no Unix.
