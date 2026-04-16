#!/usr/bin/env node
// startup-check.mjs
// Cursor event: sessionStart
// Função: detecta projetos sem configuração de IA e injeta prompt de setup
// Plataformas: Windows, macOS, Linux

import { readFileSync, existsSync } from "fs";
import { join } from "path";
import { homedir } from "os";

const input = JSON.parse(readFileSync("/dev/stdin", "utf8").trim() || "{}");
const cwd = input.cwd || process.cwd();

const hasCursorRules =
  existsSync(join(cwd, ".cursorrules")) ||
  existsSync(join(cwd, ".cursor", "rules"));

const hasAgents = existsSync(join(cwd, ".cursor", "agents"));

// Projeto já configurado — não interfere
if (hasCursorRules && hasAgents) {
  process.stdout.write(JSON.stringify({ continue: true, permission: "allow" }));
  process.exit(0);
}

// Localiza o prompt de setup
const promptsDir =
  process.env.CURSOR_PROMPTS_DIR || join(homedir(), ".cursor", "prompts");
const promptFile = join(promptsDir, "01-setup-hybrid-structure.md");

if (!existsSync(promptFile)) {
  process.stderr.write(
    `⚠️  startup-check: prompt não encontrado em ${promptFile}\n`
  );
  process.stdout.write(JSON.stringify({ continue: true, permission: "allow" }));
  process.exit(0);
}

const promptContent = readFileSync(promptFile, "utf8");

// Extrai o corpo após "## Prompt"
const promptBody = promptContent
  .split("## Prompt")[1]
  ?.split(/\n## /)[0]
  ?.replace(/```/g, "")
  ?.trim();

const missing = [];
if (!hasCursorRules) missing.push(".cursorrules ou .cursor/rules");
if (!hasAgents) missing.push(".cursor/agents/");

const message = [
  "⚠️  PROJETO SEM CONFIGURAÇÃO DE IA DETECTADO",
  `Ausentes: ${missing.join(", ")}`,
  "",
  "Execute o seguinte ANTES de qualquer tarefa:",
  "",
  promptBody || "(prompt não pôde ser extraído)",
].join("\n");

process.stdout.write(
  JSON.stringify({
    continue: true,
    permission: "allow",
    agentMessage: message,
  })
);
process.exit(0);
