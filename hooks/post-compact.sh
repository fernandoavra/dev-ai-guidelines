#!/usr/bin/env bash
# post-compact.sh
# Dispara em: SessionStart (source: "compact")
# Função: após compactação, reinjecta o plano ativo e orienta o Claude a se reorientar

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

[ -z "$CWD" ] && exit 0

PLAN_FILE="$CWD/.claude/plans/active-plan.md"
CLAUDE_MD="$CWD/CLAUDE.md"

PLAN_CONTENT=""
if [ -f "$PLAN_FILE" ]; then
  # Lê as primeiras 100 linhas para não saturar o contexto
  PLAN_CONTENT=$(head -100 "$PLAN_FILE")
else
  PLAN_CONTENT="(nenhum plano ativo encontrado em .claude/plans/active-plan.md)"
fi

CLAUDE_REF=""
[ -f "$CLAUDE_MD" ] && CLAUDE_REF="CLAUDE.md presente — leia-o para recontext antes de continuar."

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "📦 SESSÃO COMPACTADA — REORIENTAÇÃO NECESSÁRIA\n\n$CLAUDE_REF\n\nPlano ativo no momento da compactação:\n\n$PLAN_CONTENT\n\nAntes de continuar qualquer tarefa: leia CLAUDE.md, PROJECT.md e o active-plan.md acima para recuperar o contexto completo."
  }
}
EOF

exit 0
