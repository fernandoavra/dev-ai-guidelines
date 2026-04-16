#!/usr/bin/env bash
# format-on-edit.sh
# Dispara em: PostToolUse (matcher: "Edit|Write|MultiEdit")
# Função: roda o formatador do projeto automaticamente após qualquer edição de arquivo

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // .tool_input.file_path // empty')

[ -z "$FILE_PATH" ] && exit 0

# Detecta o tipo de projeto e roda o formatador adequado
run_formatter() {
  local file="$1"
  local dir
  dir=$(dirname "$file")

  # JavaScript / TypeScript
  if echo "$file" | grep -qE '\.(js|ts|jsx|tsx|json|css|scss|md)$'; then
    if [ -f "package.json" ]; then
      if command -v npx &>/dev/null; then
        npx prettier --write "$file" 2>/dev/null && return 0
      fi
    fi
  fi

  # Python
  if echo "$file" | grep -q '\.py$'; then
    if command -v black &>/dev/null; then
      black "$file" 2>/dev/null && return 0
    elif command -v autopep8 &>/dev/null; then
      autopep8 --in-place "$file" 2>/dev/null && return 0
    fi
  fi

  # Go
  if echo "$file" | grep -q '\.go$'; then
    if command -v gofmt &>/dev/null; then
      gofmt -w "$file" 2>/dev/null && return 0
    fi
  fi

  # PHP
  if echo "$file" | grep -q '\.php$'; then
    if command -v php-cs-fixer &>/dev/null; then
      php-cs-fixer fix "$file" 2>/dev/null && return 0
    fi
  fi

  return 0
}

run_formatter "$FILE_PATH"

# Roda linter se disponível (não bloqueia em caso de falha)
if [ -f "package.json" ] && command -v npx &>/dev/null; then
  npx eslint --fix "$FILE_PATH" 2>/dev/null || true
fi

exit 0
