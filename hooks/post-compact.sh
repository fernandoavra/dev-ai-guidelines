#!/usr/bin/env bash
# post-compact.sh
# Dispara em: SessionStart (source: "compact")
# Função: após compactação, reinjecta o plano ativo e orienta o Claude a se reorientar

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

[ -z "$CWD" ] && exit 0

SESSIONS_FILE="$CWD/.claude/plans/.active-sessions.json"
TASK_NAME=""
PLAN_CONTENT=""

if [ -f "$SESSIONS_FILE" ]; then
  TASK_NAME=$(jq -r --arg pid "$PPID" '.[$pid].task // empty' "$SESSIONS_FILE")
fi

if [ -n "$TASK_NAME" ]; then
  PLAN_FILE="$CWD/.claude/plans/$TASK_NAME.md"
  if [ -f "$PLAN_FILE" ]; then
    PLAN_CONTENT=$(head -100 "$PLAN_FILE")
  else
    PLAN_CONTENT="(plano $TASK_NAME registrado na sessão mas arquivo não encontrado)"
  fi
else
  FIRST_PLAN=$(find "$CWD/.claude/plans" -maxdepth 1 -name '*.md' ! -name '.*' 2>/dev/null | head -1)
  if [ -n "$FIRST_PLAN" ]; then
    PLAN_CONTENT="Nenhuma tarefa ativa nesta sessão. Planos disponíveis:\n$(ls -1 "$CWD/.claude/plans/"*.md 2>/dev/null | xargs -I{} basename {} .md)"
  else
    exit 0
  fi
fi

CONTEXT="SESSÃO COMPACTADA — REORIENTAÇÃO NECESSÁRIA"
[ -f "$CWD/CLAUDE.md" ] && CONTEXT="$CONTEXT\n\nLeia CLAUDE.md e PROJECT.md para recuperar contexto."

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$CONTEXT\n\nPlano ativo:\n\n$PLAN_CONTENT"
  }
}
EOF

exit 0
