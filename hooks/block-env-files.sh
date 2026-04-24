#!/usr/bin/env bash
# block-env-files.sh
# Dispara em: PreToolUse (matcher: Read, Write, Edit)
# Função: bloqueia leitura e escrita em arquivos de ambiente

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

FILE_PATH=""
case "$TOOL_NAME" in
  Read)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    ;;
  Write)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    ;;
  Edit)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    ;;
  *)
    exit 0
    ;;
esac

[ -z "$FILE_PATH" ] && exit 0

BASENAME=$(basename "$FILE_PATH")

is_env_file() {
  local name="$1"

  # .env.example é permitido
  case "$name" in
    *.example|*.sample|*.template) return 1 ;;
  esac

  # .env, .env.local, .env.production, .env.anything
  case "$name" in
    .env) return 0 ;;
    .env.*) return 0 ;;
  esac

  # environment.ts, environment.js, environment.prod.ts, etc.
  # Mas NÃO environment.example.ts
  case "$name" in
    environment.ts|environment.js) return 0 ;;
    environment.*.ts|environment.*.js) return 0 ;;
  esac

  return 1
}

if is_env_file "$BASENAME"; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Arquivo de ambiente bloqueado por política de segurança: '$BASENAME'. Arquivos .env contêm credenciais e não devem ser lidos ou modificados pelo agente. Use .env.example para documentar variáveis necessárias."
  }
}
EOF
  exit 0
fi

exit 0
