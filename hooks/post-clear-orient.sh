#!/usr/bin/env bash
# post-clear-orient.sh
# Dispara em: SessionStart (source: "clear")
# Função: após /clear, reinjecta o plano ativo para que Claude saiba de onde continuar

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

[ -z "$CWD" ] && exit 0

PLAN_FILE="$CWD/.claude/plans/active-plan.md"

if [ ! -f "$PLAN_FILE" ]; then
  # Sem plano ativo — sessão limpa sem orientação adicional
  exit 0
fi

NEXT_STEPS=$(awk '/^## Next session start/{found=1; next} found && /^## /{exit} found{print}' "$PLAN_FILE")

if [ -z "$NEXT_STEPS" ]; then
  exit 0
fi

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "🔄 CONTEXTO LIMPO (/clear executado)\n\nProximos passos registrados no handoff anterior:\n\n$NEXT_STEPS\n\nLeia CLAUDE.md antes de iniciar qualquer nova tarefa."
  }
}
EOF

exit 0
