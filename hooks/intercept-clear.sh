#!/usr/bin/env bash
# intercept-clear.sh
# Dispara em: UserPromptSubmit
# Função: intercepta /clear e sugere handoff se houver tarefa ativa

set -euo pipefail

INPUT=$(cat)
PROMPT_TEXT=$(echo "$INPUT" | jq -r '.prompt // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Só age se o prompt for exatamente /clear
if ! echo "$PROMPT_TEXT" | grep -qE '^\s*/clear\s*$'; then
  exit 0
fi

[ -z "$CWD" ] && exit 0

# Verifica se há tarefa ativa nesta sessão
SESSIONS_FILE="$CWD/.claude/plans/.active-sessions.json"
TASK_NAME=""

if [ -f "$SESSIONS_FILE" ]; then
  TASK_NAME=$(jq -r --arg pid "$PPID" '.[$pid].task // empty' "$SESSIONS_FILE")
fi

# Sem tarefa ativa — /clear pode prosseguir sem handoff
[ -z "$TASK_NAME" ] && exit 0

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "/clear detectado com tarefa ativa: $TASK_NAME\n\nExecute /ai:handoff $TASK_NAME antes de limpar o contexto para não perder o estado da sessão."
  }
}
EOF

exit 0
