#!/usr/bin/env bash
# startup-check.sh
# Dispara em: SessionStart (source: "startup")
# Função: detecta projetos sem CLAUDE.md e injeta o prompt de setup híbrido

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Sem diretório de trabalho, nada a fazer
[ -z "$CWD" ] && exit 0

CLAUDE_MD="$CWD/CLAUDE.md"
AGENTS_DIR="$CWD/.claude/agents"
PROMPT_FILE="${CLAUDE_PROMPTS_DIR:-$HOME/.claude/prompts}/01-setup-hybrid-structure.md"

# Projeto já configurado — não interfere
if [ -f "$CLAUDE_MD" ] && [ -d "$AGENTS_DIR" ]; then
  exit 0
fi

# Prompt de setup não encontrado — avisa mas não bloqueia
if [ ! -f "$PROMPT_FILE" ]; then
  echo "⚠️  Hook startup-check: prompt 01-setup-hybrid-structure.md não encontrado em $PROMPT_FILE" >&2
  exit 0
fi

# Extrai o corpo do prompt (bloco após "## Prompt")
PROMPT_BODY=$(awk '/^## Prompt/{found=1; next} found && /^## /{exit} found{print}' "$PROMPT_FILE" \
  | sed '/^```/d' \
  | sed '/^---/d')

MISSING=""
[ ! -f "$CLAUDE_MD" ]   && MISSING="CLAUDE.md"
[ ! -d "$AGENTS_DIR" ]  && MISSING="$MISSING .claude/agents/"

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "⚠️  PROJETO SEM CONFIGURAÇÃO DE IA DETECTADO\nAusentes: $MISSING\n\nExecute o seguinte ANTES de qualquer outra tarefa:\n\n$PROMPT_BODY"
  }
}
EOF

exit 0
