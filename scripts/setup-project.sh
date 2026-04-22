#!/usr/bin/env bash
# =============================================================================
# setup-project.sh
# Configura hooks POR PROJETO — disparam apenas neste projeto.
# Commitado no repositório: vale para todo o time automaticamente.
#
# Uso:
#   cd seu-projeto
#   /caminho/para/dev-ai-guidelines/scripts/setup-project.sh
#
# Ou, se dev-ai-guidelines for submódulo ou pasta próxima:
#   ../dev-ai-guidelines/scripts/setup-project.sh
#
# Compatível: macOS, Linux
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; exit 1; }

# Localiza o repositório dev-ai-guidelines
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUIDELINES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

[ -f "$GUIDELINES_DIR/hooks/format-on-edit.sh" ] || \
  error "Não foi possível localizar o repositório dev-ai-guidelines em $GUIDELINES_DIR"

# Confirma que está num projeto (não dentro do dev-ai-guidelines)
PROJECT_DIR="$(pwd)"
[ "$PROJECT_DIR" != "$GUIDELINES_DIR" ] || \
  error "Execute este script a partir da raiz do SEU PROJETO, não do dev-ai-guidelines"

echo ""
echo "================================================================="
echo "  dev-ai-guidelines — Setup de Hooks por Projeto"
echo "  Projeto: $PROJECT_DIR"
echo "================================================================="
echo ""

# =============================================================================
# CLAUDE CODE — HOOKS POR PROJETO
# =============================================================================

info "Configurando hooks do Claude Code para este projeto..."

CLAUDE_PROJECT_DIR="$PROJECT_DIR/.claude"
CLAUDE_PROJECT_HOOKS="$CLAUDE_PROJECT_DIR/hooks"

mkdir -p "$CLAUDE_PROJECT_HOOKS"

# Hooks de qualidade: específicos do projeto, commitados no repositório
cp "$GUIDELINES_DIR/hooks/format-on-edit.sh" "$CLAUDE_PROJECT_HOOKS/"
cp "$GUIDELINES_DIR/hooks/require-tests.sh"  "$CLAUDE_PROJECT_HOOKS/"
chmod +x "$CLAUDE_PROJECT_HOOKS"/*.sh
success "Scripts de hook do projeto copiados para $CLAUDE_PROJECT_HOOKS"

# Gera .claude/settings.json do projeto
# Não sobrescreve se já existir — faz merge manual via aviso
CLAUDE_PROJECT_SETTINGS="$CLAUDE_PROJECT_DIR/settings.json"

if [ -f "$CLAUDE_PROJECT_SETTINGS" ]; then
  warn "settings.json já existe em $CLAUDE_PROJECT_SETTINGS"
  warn "Adicione manualmente a seção de hooks abaixo ao arquivo existente:"
  echo ""
  cat << 'EOF'
  {
    "hooks": {
      "PostToolUse": [
        {
          "_comment": "Auto-formata após qualquer edição — stack detectada automaticamente",
          "matcher": "Edit|Write|MultiEdit",
          "hooks": [{
            "type": "command",
            "command": ".claude/hooks/format-on-edit.sh",
            "timeout": 30
          }]
        }
      ],
      "PreToolUse": [
        {
          "_comment": "Bloqueia PR/push se testes estiverem falhando",
          "matcher": "mcp__github__create_pull_request",
          "hooks": [{
            "type": "command",
            "command": ".claude/hooks/require-tests.sh",
            "timeout": 120
          }]
        }
      ]
    }
  }
EOF
  echo ""
else
  cat > "$CLAUDE_PROJECT_SETTINGS" << 'EOF'
{
  "_scope": "project — commitado, vale para todo o time",
  "_managed_by": "dev-ai-guidelines/scripts/setup-project.sh",

  "model": "claude-sonnet-4-6",

  "hooks": {

    "PostToolUse": [
      {
        "_comment": "Auto-formata após qualquer edição — stack detectada automaticamente",
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [{
          "type": "command",
          "command": ".claude/hooks/format-on-edit.sh",
          "timeout": 30
        }]
      }
    ],

    "PreToolUse": [
      {
        "_comment": "Bloqueia PR se testes estiverem falhando",
        "matcher": "mcp__github__create_pull_request",
        "hooks": [{
          "type": "command",
          "command": ".claude/hooks/require-tests.sh",
          "timeout": 120
        }]
      }
    ]

  }
}
EOF
  success "settings.json de projeto criado em $CLAUDE_PROJECT_SETTINGS"
fi

# Cria .claude/plans/ se não existir
mkdir -p "$CLAUDE_PROJECT_DIR/plans"
if [ ! -f "$CLAUDE_PROJECT_DIR/plans/active-plan.md" ]; then
  cp "$GUIDELINES_DIR/templates/active-plan.md" "$CLAUDE_PROJECT_DIR/plans/"
  success "Template active-plan.md criado em .claude/plans/"
fi

# =============================================================================
# CURSOR — HOOKS POR PROJETO
# =============================================================================

info "Configurando hooks do Cursor para este projeto..."

CURSOR_PROJECT_DIR="$PROJECT_DIR/.cursor"
CURSOR_PROJECT_HOOKS="$CURSOR_PROJECT_DIR/hooks/scripts"

mkdir -p "$CURSOR_PROJECT_HOOKS"

# Hooks de qualidade para Cursor (Node.js cross-platform)
cp "$GUIDELINES_DIR/hooks-cursor/scripts/format-on-edit.mjs" "$CURSOR_PROJECT_HOOKS/"
cp "$GUIDELINES_DIR/hooks-cursor/scripts/require-tests.mjs"  "$CURSOR_PROJECT_HOOKS/"
success "Scripts Node.js do Cursor copiados para $CURSOR_PROJECT_HOOKS"

# Gera .cursor/hooks.json do projeto
CURSOR_PROJECT_HOOKS_JSON="$CURSOR_PROJECT_DIR/hooks.json"

if [ -f "$CURSOR_PROJECT_HOOKS_JSON" ]; then
  warn "hooks.json já existe em $CURSOR_PROJECT_HOOKS_JSON"
  warn "Adicione manualmente as entradas abaixo ao arquivo existente."
  echo ""
  cat << 'EOF'
  {
    "version": 1,
    "hooks": {
      "afterFileEdit": [{
        "command": "node .cursor/hooks/scripts/format-on-edit.mjs",
        "timeout": 30
      }],
      "beforeShellExecution": [{
        "matcher": "gh pr create|git push.*origin.*(main|master)",
        "command": "node .cursor/hooks/scripts/require-tests.mjs",
        "timeout": 120
      }]
    }
  }
EOF
  echo ""
else
  cat > "$CURSOR_PROJECT_HOOKS_JSON" << 'EOF'
{
  "version": 1,
  "_scope": "project — commitado, vale para todo o time",
  "_managed_by": "dev-ai-guidelines/scripts/setup-project.sh",

  "hooks": {

    "afterFileEdit": [{
      "_comment": "Auto-formata após qualquer edição",
      "command": "node .cursor/hooks/scripts/format-on-edit.mjs",
      "timeout": 30
    }],

    "beforeShellExecution": [{
      "_comment": "Bloqueia push/PR se testes falhando",
      "matcher": "gh pr create|git push.*origin.*(main|master)",
      "command": "node .cursor/hooks/scripts/require-tests.mjs",
      "timeout": 120
    }]

  }
}
EOF
  success "hooks.json de projeto criado em $CURSOR_PROJECT_HOOKS_JSON"
fi

# =============================================================================
# .gitignore — garante que arquivos locais não sejam commitados
# =============================================================================

GITIGNORE="$PROJECT_DIR/.gitignore"

add_to_gitignore() {
  local entry="$1"
  if ! grep -qF "$entry" "$GITIGNORE" 2>/dev/null; then
    echo "$entry" >> "$GITIGNORE"
    success "Adicionado ao .gitignore: $entry"
  fi
}

add_to_gitignore ".claude/settings.local.json"
add_to_gitignore ".claude/logs/"
add_to_gitignore ".claude/plans/archive/"
add_to_gitignore ".claude/dailies/"
add_to_gitignore ".claude/plans/.active-sessions.json"

# =============================================================================
# RESUMO E PRÓXIMOS PASSOS
# =============================================================================

echo ""
echo "================================================================="
echo "  Hooks de projeto configurados"
echo "================================================================="
echo ""
echo "  Claude Code"
echo "  ├── .claude/settings.json     → format-on-edit + require-tests"
echo "  ├── .claude/hooks/            → scripts de hook"
echo "  └── .claude/plans/            → active-plan.md criado"
echo ""
echo "  Cursor"
echo "  ├── .cursor/hooks.json        → format-on-edit + require-tests"
echo "  └── .cursor/hooks/scripts/    → scripts Node.js"
echo ""
echo "  Próximos passos:"
echo "  1. Commite os arquivos gerados:"
echo "     git add .claude/settings.json .claude/hooks/ .claude/plans/"
echo "     git add .cursor/hooks.json .cursor/hooks/scripts/"
echo "     git commit -m \"chore: add ai hooks for team workflow\""
echo ""
echo "  2. Cada dev do time deve rodar setup-global.sh uma vez na sua máquina"
echo "     para ativar os hooks globais (segurança + notificações)"
echo ""
echo "  3. Os hooks de projeto (.claude/settings.json e .cursor/hooks.json)"
echo "     já valem para o time inteiro após o commit — sem setup adicional"
echo ""
