#!/usr/bin/env bash
# post-clear-orient.sh
# Dispara em: SessionStart (source: "clear")
# Função: após /clear, reinjecta próximos passos do plano ativo

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

[ -z "$CWD" ] && exit 0

SESSIONS_FILE="$CWD/.claude/plans/.active-sessions.json"
TASK_NAME=""

if [ -f "$SESSIONS_FILE" ]; then
  TASK_NAME=$(jq -r --arg pid "$PPID" '.[$pid].task // empty' "$SESSIONS_FILE")
fi

[ -z "$TASK_NAME" ] && exit 0

PLAN_FILE="$CWD/.claude/plans/$TASK_NAME.md"
[ ! -f "$PLAN_FILE" ] && exit 0

NEXT_STEPS=$(awk '/^## Next session start/{found=1; next} found && /^## /{exit} found{print}' "$PLAN_FILE")
HANDOFF_STATUS=$(awk '/^### Status at close/{found=1; next} found && /^### /{exit} found{print}' "$PLAN_FILE")

CONTEXT=""
[ -n "$HANDOFF_STATUS" ] && CONTEXT="Estado no último handoff:\n$HANDOFF_STATUS\n\n"
[ -n "$NEXT_STEPS" ] && CONTEXT="${CONTEXT}Próximos passos:\n$NEXT_STEPS"

[ -z "$CONTEXT" ] && exit 0

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "CONTEXTO LIMPO — tarefa ativa: $TASK_NAME\n\n$CONTEXT\n\nUse /ai:resume $TASK_NAME para retomar com verificação completa."
  }
}
EOF

exit 0
