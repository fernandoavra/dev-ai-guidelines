#!/usr/bin/env bash
# =============================================================================
# update-statusline.sh
# Atualiza APENAS a configuração de statusline globalmente:
#   - Copia .claude/statusline-command.sh para ~/.claude/statusline-command.sh
#   - Garante que ~/.claude/settings.json contém o bloco "statusLine" apontando
#     para esse script (merge cirúrgico, preserva hooks/permissions/etc.)
#
# Útil quando o statusline foi modificado e você quer atualizar sem rodar
# setup-global.sh completo (que reescreve o settings.json inteiro).
#
# Uso:
#   cd dev-ai-guidelines
#   ./scripts/update-statusline.sh
# =============================================================================

set -euo pipefail

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; exit 1; }

# Valida que estamos na raiz do repositório
SRC_SCRIPT=".claude/statusline-command.sh"
[ -f "$SRC_SCRIPT" ] || \
  error "Execute este script a partir da raiz do repositório dev-ai-guidelines (não encontrei $SRC_SCRIPT)"

# Requer jq para merge cirúrgico no settings.json
command -v jq >/dev/null 2>&1 || \
  error "jq não encontrado no PATH. Instale com 'brew install jq' (macOS) ou 'apt install jq' (Linux)."

CLAUDE_DIR="$HOME/.claude"
DEST_SCRIPT="$CLAUDE_DIR/statusline-command.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

mkdir -p "$CLAUDE_DIR"

# -----------------------------------------------------------------------------
# 1) Copia o script de statusline
# -----------------------------------------------------------------------------
info "Copiando statusline-command.sh para $DEST_SCRIPT..."
cp "$SRC_SCRIPT" "$DEST_SCRIPT"
chmod +x "$DEST_SCRIPT"
success "statusline-command.sh atualizado"

# -----------------------------------------------------------------------------
# 2) Garante o bloco statusLine no settings.json global
# -----------------------------------------------------------------------------
STATUSLINE_JSON='{
  "type": "command",
  "command": "bash ~/.claude/statusline-command.sh"
}'

if [ -f "$SETTINGS" ]; then
  # Backup antes de qualquer escrita
  cp "$SETTINGS" "$SETTINGS.bak"
  warn "Backup do settings.json atual salvo em $SETTINGS.bak"

  # Merge cirúrgico: substitui apenas a chave .statusLine, preserva o resto
  tmp=$(mktemp)
  jq --argjson sl "$STATUSLINE_JSON" '.statusLine = $sl' "$SETTINGS" > "$tmp"
  mv "$tmp" "$SETTINGS"
  success "Bloco statusLine atualizado em $SETTINGS"
else
  # Cria settings.json mínimo só com statusLine
  jq -n --argjson sl "$STATUSLINE_JSON" '{statusLine: $sl}' > "$SETTINGS"
  success "settings.json criado em $SETTINGS com bloco statusLine"
fi

echo ""
echo "================================================================="
echo "  Statusline atualizado"
echo "================================================================="
echo ""
echo "  Script    → $DEST_SCRIPT"
echo "  Settings  → $SETTINGS (chave .statusLine)"
echo ""
echo "  A próxima sessão do Claude Code já usará o novo statusline."
echo ""
