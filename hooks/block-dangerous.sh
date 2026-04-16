#!/usr/bin/env bash
# block-dangerous.sh
# Dispara em: PreToolUse (matcher: "Bash")
# Função: bloqueia comandos destrutivos antes de executar

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

# Padrões bloqueados — adicione os específicos do seu projeto
BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \*"
  "dd if="
  "> /dev/sda"
  "mkfs"
  ":(){ :|:& };:"          # fork bomb
  "curl.*|.*bash"          # curl pipe bash
  "wget.*|.*bash"          # wget pipe bash
  "DROP DATABASE"
  "DROP TABLE"
  "TRUNCATE TABLE"
  "DELETE FROM.*WHERE 1"
  "git push.*--force.*main"
  "git push.*--force.*master"
  "git push.*-f.*main"
  "git push.*-f.*master"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Comando bloqueado por política de segurança: padrão '$pattern' detectado. Se isto for intencional, execute manualmente no terminal."
  }
}
EOF
    exit 0
  fi
done

exit 0
