#!/usr/bin/env bash
# =============================================================================
# update-commands.sh
# Atualiza APENAS os comandos /ai:* globais, sem reconfigurar hooks ou settings.
# Útil quando um comando foi adicionado ou modificado e você quer atualizar
# sem rodar setup-global.sh completo.
#
# Uso:
#   cd dev-ai-guidelines
#   ./scripts/update-commands.sh
# =============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*"; exit 1; }

[ -d "commands/ai" ] || \
  error "Execute este script a partir da raiz do repositório dev-ai-guidelines"

CLAUDE_COMMANDS_DIR="$HOME/.claude/commands/ai"
mkdir -p "$CLAUDE_COMMANDS_DIR"

count=$(ls commands/ai/*.md 2>/dev/null | wc -l | tr -d ' ')

cp commands/ai/*.md "$CLAUDE_COMMANDS_DIR/"

success "$count comandos /ai:* atualizados em $CLAUDE_COMMANDS_DIR"

echo ""
info "Comandos instalados:"
for f in commands/ai/*.md; do
  name=$(basename "$f" .md)
  echo "  /ai:$name"
done
echo ""
