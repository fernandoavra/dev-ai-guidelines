#!/usr/bin/env node
// startup-check.mjs
// Cursor event: sessionStart
// Função: detecta projetos sem configuração de IA e sugere setup

import { readFileSync, existsSync } from "fs";
import { join } from "path";

const input = JSON.parse(readFileSync("/dev/stdin", "utf8").trim() || "{}");
const cwd = input.cwd || process.cwd();

const hasCursorRules =
  existsSync(join(cwd, ".cursorrules")) ||
  existsSync(join(cwd, ".cursor", "rules"));

const hasAgents = existsSync(join(cwd, ".cursor", "agents"));

if (hasCursorRules && hasAgents) {
  process.stdout.write(JSON.stringify({ continue: true, permission: "allow" }));
  process.exit(0);
}

const missing = [];
if (!hasCursorRules) missing.push(".cursorrules ou .cursor/rules");
if (!hasAgents) missing.push(".cursor/agents/");

const message = [
  "PROJETO SEM CONFIGURAÇÃO DE IA DETECTADO",
  `Ausentes: ${missing.join(", ")}`,
  "",
  "Execute o setup de IA para configurar este projeto antes de qualquer outra tarefa.",
].join("\n");

process.stdout.write(
  JSON.stringify({
    continue: true,
    permission: "allow",
    agentMessage: message,
  })
);
process.exit(0);
