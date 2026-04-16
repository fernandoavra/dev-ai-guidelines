#!/usr/bin/env node
// block-dangerous.mjs
// Cursor event: beforeShellExecution
// Função: bloqueia comandos destrutivos antes de executar
// Plataformas: Windows, macOS, Linux

import { readFileSync } from "fs";

const input = JSON.parse(readFileSync("/dev/stdin", "utf8").trim() || "{}");
const command = input.command || "";

// Padrões bloqueados — adicione os específicos do seu projeto
const BLOCKED = [
  /rm\s+-rf\s+\//,
  /rm\s+-rf\s+~/,
  /rm\s+-rf\s+\*/,
  /rm\s+-rf\s+"\*"/,
  /dd\s+if=/,
  />\s*\/dev\/sda/,
  /mkfs/,
  /:\(\)\s*\{\s*:\|:&\s*\};:/, // fork bomb
  /curl[^|]*\|[^|]*bash/,
  /wget[^|]*\|[^|]*bash/,
  /DROP\s+DATABASE/i,
  /DROP\s+TABLE/i,
  /TRUNCATE\s+TABLE/i,
  /DELETE\s+FROM.*WHERE\s+1\s*=/i,
  /git\s+push.*--force.*(main|master)/,
  /git\s+push\s+-f.*(main|master)/,
  // Windows-specific
  /rd\s+\/s\s+\/q\s+C:\\/i,
  /del\s+\/f\s+\/s\s+\/q/i,
  /format\s+C:/i,
];

const matched = BLOCKED.find((pattern) => pattern.test(command));

if (matched) {
  process.stdout.write(
    JSON.stringify({
      continue: false,
      permission: "deny",
      userMessage: `Comando bloqueado por política de segurança.`,
      agentMessage: `Comando bloqueado: padrão perigoso detectado em "${command}". Se isto for intencional, execute manualmente no terminal.`,
    })
  );
} else {
  process.stdout.write(
    JSON.stringify({ continue: true, permission: "allow" })
  );
}

process.exit(0);
