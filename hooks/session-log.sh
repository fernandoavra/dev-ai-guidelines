#!/usr/bin/env bash
# session-log.sh
# Dispara em: Stop
# Função: registra fim de sessão com timestamp e notifica o desenvolvedor

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

[ -z "$CWD" ] && exit 0

LOG_DIR="$CWD/.claude/logs"
LOG_FILE="$LOG_DIR/sessions.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a")
CHANGES=$(git -C "$CWD" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

echo "[$TIMESTAMP] session=$SESSION_ID branch=$BRANCH uncommitted_changes=$CHANGES" >> "$LOG_FILE"

# Notificação desktop (macOS)
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"Branch: $BRANCH | $CHANGES mudanças não commitadas\" with title \"Claude Code — sessão encerrada\"" 2>/dev/null || true
fi

# Notificação desktop (Linux com notify-send)
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code — sessão encerrada" "Branch: $BRANCH | $CHANGES mudanças não commitadas" 2>/dev/null || true
fi

exit 0
