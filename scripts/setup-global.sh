#!/usr/bin/env bash
# =============================================================================
# setup-global.sh
# Configura hooks GLOBAIS — disparam em TODOS os projetos, na máquina do dev.
# Executar UMA vez por máquina. Nunca commitar este script com caminhos locais.
#
# Uso:
#   cd dev-ai-guidelines
#   chmod +x scripts/setup-global.sh
#   ./scripts/setup-global.sh
#
# Compatível: macOS, Linux
# =============================================================================

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; exit 1; }

# Verifica que está rodando da raiz do dev-ai-guidelines
[ -f "hooks/startup-check.sh" ] || \
  error "Execute este script a partir da raiz do repositório dev-ai-guidelines"

echo ""
echo "================================================================="
echo "  dev-ai-guidelines — Setup Global de Hooks"
echo "================================================================="
echo ""

# =============================================================================
# CLAUDE CODE — HOOKS GLOBAIS
# =============================================================================

info "Configurando hooks globais do Claude Code..."

CLAUDE_DIR="$HOME/.claude"
CLAUDE_HOOKS_DIR="$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_HOOKS_DIR"

# Copia os scripts de hook
cp hooks/startup-check.sh      "$CLAUDE_HOOKS_DIR/"
cp hooks/intercept-clear.sh    "$CLAUDE_HOOKS_DIR/"
cp hooks/post-compact.sh       "$CLAUDE_HOOKS_DIR/"
cp hooks/post-clear-orient.sh  "$CLAUDE_HOOKS_DIR/"
cp hooks/block-dangerous.sh    "$CLAUDE_HOOKS_DIR/"
cp hooks/block-env-files.sh    "$CLAUDE_HOOKS_DIR/"
cp hooks/session-log.sh        "$CLAUDE_HOOKS_DIR/"

# Permissão de execução
chmod +x "$CLAUDE_HOOKS_DIR"/*.sh
success "Scripts de hook do Claude Code copiados para $CLAUDE_HOOKS_DIR"

# Hooks não dependem mais de prompts externos — /ai:setup e /ai:handoff
# são invocados diretamente. Prompts legados não são mais copiados.
success "Hooks configurados (sem dependência de prompts externos)"

# Gera o settings.json GLOBAL do Claude Code
# Contém apenas os hooks que fazem sentido globalmente:
# - startup-check:      detecta projeto sem CLAUDE.md
# - intercept-clear:    força handoff antes de /clear
# - post-compact:       reorienta após /compact
# - post-clear-orient:  reorienta após /clear
# - block-dangerous:    segurança básica em qualquer projeto
# - block-env-files:    bloqueia leitura/escrita em .env e environment.*
# - session-log:        notificação de fim de sessão

CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"

# Faz backup se já existir
if [ -f "$CLAUDE_SETTINGS" ]; then
  cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.bak"
  warn "settings.json existente salvo em $CLAUDE_SETTINGS.bak"
fi

cat > "$CLAUDE_SETTINGS" << 'EOF'
{
  "_scope": "global — aplica em todos os projetos",
  "_managed_by": "dev-ai-guidelines/scripts/setup-global.sh",
  "language": "Portuguese (Brazil)",
  "preferredNotifChannel": "auto",
  "remoteControlAtStartup": true,
  "skipAutoPermissionPrompt": true,

  "hooks": {

    "SessionStart": [
      {
        "_comment": "Sessão nova: verifica se o projeto tem CLAUDE.md e agentes",
        "matcher": "startup",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/startup-check.sh",
          "timeout": 10
        }]
      },
      {
        "_comment": "Após /compact: reinjecta plano ativo para reorientação",
        "matcher": "compact",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/post-compact.sh",
          "timeout": 5
        }]
      },
      {
        "_comment": "Após /clear: reinjecta próximos passos do handoff",
        "matcher": "clear",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/post-clear-orient.sh",
          "timeout": 5
        }]
      }
    ],

    "UserPromptSubmit": [
      {
        "_comment": "Intercepta /clear e injeta prompt de handoff antes de limpar",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/intercept-clear.sh",
          "timeout": 5
        }]
      }
    ],

    "PreToolUse": [
      {
        "_comment": "Bloqueia comandos Bash destrutivos — vale em qualquer projeto",
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/block-dangerous.sh",
          "timeout": 5
        }]
      },
      {
        "_comment": "Bloqueia leitura/escrita em .env e environment.* — vale em qualquer projeto",
        "matcher": "Read|Write|Edit",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/block-env-files.sh",
          "timeout": 5
        }]
      }
    ],

    "Stop": [
      {
        "_comment": "Log de sessão + notificação desktop",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/session-log.sh",
          "timeout": 10
        }]
      }
    ]

  },

  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  }
}
EOF

success "settings.json global do Claude Code criado em $CLAUDE_SETTINGS"

# =============================================================================
# CURSOR — HOOKS GLOBAIS
# =============================================================================

info "Configurando hooks globais do Cursor..."

CURSOR_GLOBAL_DIR="$HOME/.cursor"
CURSOR_HOOKS_DIR="$CURSOR_GLOBAL_DIR/hooks/scripts"
mkdir -p "$CURSOR_HOOKS_DIR"

# Copia os scripts Node.js (cross-platform)
cp hooks-cursor/scripts/startup-check.mjs  "$CURSOR_HOOKS_DIR/"
cp hooks-cursor/scripts/block-dangerous.mjs "$CURSOR_HOOKS_DIR/"
cp hooks-cursor/scripts/session-log.mjs    "$CURSOR_HOOKS_DIR/"
success "Scripts de hook do Cursor copiados para $CURSOR_HOOKS_DIR"

success "Hooks do Cursor configurados"

# Gera o hooks.json GLOBAL do Cursor
CURSOR_HOOKS_JSON="$CURSOR_GLOBAL_DIR/hooks.json"

if [ -f "$CURSOR_HOOKS_JSON" ]; then
  cp "$CURSOR_HOOKS_JSON" "$CURSOR_HOOKS_JSON.bak"
  warn "hooks.json existente salvo em $CURSOR_HOOKS_JSON.bak"
fi

cat > "$CURSOR_HOOKS_JSON" << 'EOF'
{
  "version": 1,
  "_scope": "global — aplica em todos os projetos",
  "_managed_by": "dev-ai-guidelines/scripts/setup-global.sh",

  "hooks": {

    "sessionStart": [{
      "_comment": "Verifica se o projeto tem configuração de IA",
      "command": "node ~/.cursor/hooks/scripts/startup-check.mjs",
      "timeout": 10
    }],

    "beforeShellExecution": [{
      "_comment": "Bloqueia comandos destrutivos — vale em qualquer projeto",
      "command": "node ~/.cursor/hooks/scripts/block-dangerous.mjs",
      "timeout": 5
    }],

    "stop": [{
      "_comment": "Log de sessão + notificação desktop",
      "command": "node ~/.cursor/hooks/scripts/session-log.mjs",
      "timeout": 10
    }]

  }
}
EOF

success "hooks.json global do Cursor criado em $CURSOR_HOOKS_JSON"

# =============================================================================
# CLAUDE.md GLOBAL — regras de orquestração para todos os projetos
# =============================================================================
info "Instalando CLAUDE.md global..."

GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"

if [ -f "$GLOBAL_CLAUDE" ]; then
  cp "$GLOBAL_CLAUDE" "$GLOBAL_CLAUDE.bak"
  warn "CLAUDE.md global existente salvo em $GLOBAL_CLAUDE.bak"
fi

cp "templates/global-CLAUDE.md" "$GLOBAL_CLAUDE"
success "CLAUDE.md global instalado em $GLOBAL_CLAUDE"

# =============================================================================
# COMANDOS GLOBAIS — disponíveis em todos os projetos como /ai:*
# =============================================================================

info "Instalando comandos globais /ai:*..."

CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands/ai"
mkdir -p "$CLAUDE_COMMANDS_DIR"

cp commands/ai/*.md "$CLAUDE_COMMANDS_DIR/"
success "Comandos instalados em $CLAUDE_COMMANDS_DIR"

# =============================================================================
# VARIÁVEIS DE AMBIENTE — instrução (não modifica automaticamente)
# =============================================================================

echo ""
echo "================================================================="
echo "  Configuração de Modelos (adicione ao seu ~/.zshrc ou ~/.bashrc)"
echo "================================================================="
echo ""
echo "  # Modelo da sessão principal"
echo "  export ANTHROPIC_MODEL=\"claude-sonnet-4-6\""
echo "  # export ANTHROPIC_MODEL=\"claude-opus-4-6\"   # se tiver plano Max"
echo ""
echo "  # Subagentes usam Sonnet independente do modelo principal"
echo "  export CLAUDE_CODE_SUBAGENT_MODEL=\"claude-sonnet-4-6\""
echo ""
echo ""

# =============================================================================
# RESUMO FINAL
# =============================================================================

echo "================================================================="
echo "  Setup global concluído"
echo "================================================================="
echo ""
echo "  CLAUDE.md global   → ~/.claude/CLAUDE.md"
echo "  Comandos /ai:*     → ~/.claude/commands/ai/"
echo ""
echo "  /ai:setup       — setup inicial de IA para projeto novo"
echo "  /ai:update      — gap analysis e atualização incremental"
echo "  /ai:docs        — gera ou atualiza PROJECT.md"
echo "  /ai:task        — inicia tarefa com plano antes do código"
echo "  /ai:task-finish — marca tarefa como concluída e arquiva"
echo "  /ai:task-delete — descarta tarefa não executada"
echo "  /ai:handoff     — registra handoff de uma tarefa específica"
echo "  /ai:resume      — retoma tarefa salva com handoff"
echo "  /ai:daily-close — resumo do dia (progresso + pendências)"
echo "  /ai:daily-start — briefing matinal com contexto do dia anterior"
echo "  /ai:review      — code review com agentes"
echo "  /ai:debt        — auditoria de dívida técnica"
echo "  /ai:db-audit    — auditoria de banco de dados (schema, indexes, modelagem)"
echo "  /ai:bug         — diagnóstico de bug (root cause first)"
echo "  /ai:feature     — feature cross-componente com contrato"
echo "  /ai:ask         — responde perguntas sobre o projeto via documentação"
echo "  /ai:add         — integra novo componente/repositório à estrutura existente"
echo "  /ai:status      — visão rápida do estado da sessão atual"
echo ""
echo "  Claude Code hooks  → $CLAUDE_SETTINGS"
echo "  ├── CLAUDE.md global (orquestração multi-agente)"
echo "  ├── startup-check   (SessionStart: startup)"
echo "  ├── post-compact    (SessionStart: compact)"
echo "  ├── post-clear-orient (SessionStart: clear)"
echo "  ├── intercept-clear (UserPromptSubmit)"
echo "  ├── block-dangerous (PreToolUse: Bash)"
echo "  ├── block-env-files (PreToolUse: Read|Write|Edit)"
echo "  └── session-log     (Stop)"
echo ""
echo "  Cursor hooks       → $CURSOR_HOOKS_JSON"
echo "  ├── startup-check   (sessionStart)"
echo "  ├── block-dangerous (beforeShellExecution)"
echo "  └── session-log     (stop)"
echo ""
echo "  Próximo passo: rode setup-project.sh na raiz de cada projeto."
echo ""
