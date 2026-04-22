#!/usr/bin/env bash
# startup-check.sh
# Dispara em: SessionStart (source: "startup")
# Função: detecta projetos sem CLAUDE.md e sugere /ai:setup

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

[ -z "$CWD" ] && exit 0

CLAUDE_MD="$CWD/CLAUDE.md"
AGENTS_DIR="$CWD/.claude/agents"

# Projeto já configurado — não interfere
if [ -f "$CLAUDE_MD" ] && [ -d "$AGENTS_DIR" ]; then
  exit 0
fi

MISSING=""
[ ! -f "$CLAUDE_MD" ]   && MISSING="CLAUDE.md"
[ ! -d "$AGENTS_DIR" ]  && MISSING="${MISSING:+$MISSING, }.claude/agents/"

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "PROJETO SEM CONFIGURAÇÃO DE IA DETECTADO\nAusentes: $MISSING\n\nExecute /ai:setup para configurar a estrutura de IA deste projeto antes de qualquer outra tarefa."
  }
}
EOF

exit 0
