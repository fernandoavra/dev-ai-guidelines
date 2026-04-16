#!/usr/bin/env node
// require-tests.mjs
// Cursor event: beforeShellExecution (matcher: "gh pr create|git push")
// Função: bloqueia push/PR se os testes estiverem falhando
// Plataformas: Windows, macOS, Linux

import { readFileSync, existsSync } from "fs";
import { join } from "path";
import { execSync } from "child_process";

const input = JSON.parse(readFileSync("/dev/stdin", "utf8").trim() || "{}");
const command = input.command || "";

// Só age em comandos de PR/push para branches principais
const isPrCommand = /gh\s+pr\s+create|git\s+push.*origin.*(main|master)/.test(command);
if (!isPrCommand) {
  process.stdout.write(JSON.stringify({ continue: true, permission: "allow" }));
  process.exit(0);
}

const cwd = input.workspace_roots?.[0] || process.cwd();

function runTests() {
  // Node / npm / pnpm / yarn
  if (existsSync(join(cwd, "package.json"))) {
    const pkg = JSON.parse(readFileSync(join(cwd, "package.json"), "utf8"));
    if (pkg.scripts?.test) {
      try {
        execSync(
          existsSync(join(cwd, "pnpm-lock.yaml")) ? "pnpm test" : "npm test",
          { cwd, stdio: "pipe", timeout: 120_000 }
        );
        return { ok: true };
      } catch (e) {
        return { ok: false, output: e.stderr?.toString() || e.stdout?.toString() || "" };
      }
    }
  }

  // Python
  if (existsSync(join(cwd, "pytest.ini")) || existsSync(join(cwd, "pyproject.toml"))) {
    try {
      execSync("python -m pytest -q", { cwd, stdio: "pipe", timeout: 120_000 });
      return { ok: true };
    } catch (e) {
      return { ok: false, output: e.stderr?.toString() || "" };
    }
  }

  // Go
  if (existsSync(join(cwd, "go.mod"))) {
    try {
      execSync("go test ./...", { cwd, stdio: "pipe", timeout: 120_000 });
      return { ok: true };
    } catch (e) {
      return { ok: false, output: e.stderr?.toString() || "" };
    }
  }

  // Nenhum runner detectado — deixa passar com aviso
  return { ok: true, warn: "Nenhum runner de testes detectado." };
}

const result = runTests();

if (!result.ok) {
  const tail = result.output?.split("\n").slice(-15).join("\n") || "";
  process.stdout.write(
    JSON.stringify({
      continue: false,
      permission: "deny",
      userMessage: "PR bloqueado: testes falhando. Corrija antes de abrir o PR.",
      agentMessage: `Testes falhando. Corrija antes de fazer push.\n\nOutput:\n${tail}`,
    })
  );
} else {
  process.stdout.write(JSON.stringify({ continue: true, permission: "allow" }));
}

process.exit(0);
