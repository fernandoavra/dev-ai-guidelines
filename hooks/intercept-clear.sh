#!/usr/bin/env bash
# intercept-clear.sh
# Dispara em: UserPromptSubmit
# Função: intercepta /clear e injeta o prompt de handoff antes de limpar o contexto

set -euo pipefail

INPUT=$(cat)
PROMPT_TEXT=$(echo "$INPUT" | jq -r '.prompt // ""')

# Só age se o prompt for exatamente /clear (ignora outros comandos)
if ! echo "$PROMPT_TEXT" | grep -qE '^\s*/clear\s*$'; then
  exit 0
fi

PROMPT_FILE="${CLAUDE_PROMPTS_DIR:-$HOME/.claude/prompts}/05-session-handoff.md"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "⚠️  Hook intercept-clear: prompt 05-session-handoff.md não encontrado em $PROMPT_FILE" >&2
  exit 0
fi

PROMPT_BODY=$(awk '/^## Prompt/{found=1; next} found && /^## /{exit} found{print}' "$PROMPT_FILE" \
  | sed '/^```/d' \
  | sed '/^---/d')

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "⚠️  /clear detectado. Antes de limpar o contexto, execute o handoff da sessão:\n\n$PROMPT_BODY\n\nApós concluir o handoff, o /clear será executado normalmente."
  }
}
EOF

exit 0
