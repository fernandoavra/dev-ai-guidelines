#!/usr/bin/env bash
# require-tests.sh
# Dispara em: PreToolUse (matcher: "mcp__github__create_pull_request")
# Função: bloqueia abertura de PR se os testes não estiverem passando

set -euo pipefail

# Detecta o runner de testes disponível e roda
run_tests() {
  if [ -f "package.json" ]; then
    if grep -q '"test"' package.json 2>/dev/null; then
      npm test --silent 2>&1
      return $?
    fi
    if [ -f "pnpm-lock.yaml" ]; then
      pnpm test --silent 2>&1
      return $?
    fi
  fi

  if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    python -m pytest -q 2>&1
    return $?
  fi

  if [ -f "go.mod" ]; then
    go test ./... 2>&1
    return $?
  fi

  # Nenhum runner encontrado — deixa passar com aviso
  echo "⚠️  Nenhum runner de testes detectado. PR liberado sem validação." >&2
  exit 0
}

OUTPUT=$(run_tests 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  SUMMARY=$(echo "$OUTPUT" | tail -20)
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "PR bloqueado: testes falhando.\n\nÚltimas linhas do output:\n$SUMMARY\n\nCorrija os testes antes de abrir o PR."
  }
}
EOF
  exit 0
fi

exit 0
