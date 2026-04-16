#!/usr/bin/env node
// format-on-edit.mjs
// Cursor event: afterFileEdit
// Função: roda o formatador do projeto após qualquer edição de arquivo
// Plataformas: Windows, macOS, Linux
// Nota: afterFileEdit é informacional — não pode bloquear, apenas reagir

import { readFileSync, existsSync } from "fs";
import { extname, join } from "path";
import { execSync } from "child_process";

const input = JSON.parse(readFileSync("/dev/stdin", "utf8").trim() || "{}");
const filePath = input.file_path || "";

if (!filePath) {
  process.exit(0);
}

const ext = extname(filePath).toLowerCase();
const cwd = process.cwd();

function run(cmd) {
  try {
    execSync(cmd, { stdio: "pipe", cwd });
    return true;
  } catch {
    return false;
  }
}

function commandExists(cmd) {
  // Verifica disponibilidade do comando (cross-platform)
  const check = process.platform === "win32" ? `where ${cmd}` : `which ${cmd}`;
  try {
    execSync(check, { stdio: "pipe" });
    return true;
  } catch {
    return false;
  }
}

const hasPackageJson = existsSync(join(cwd, "package.json"));

// JavaScript / TypeScript / JSON / CSS / Markdown
if ([".js", ".ts", ".jsx", ".tsx", ".json", ".css", ".scss", ".md"].includes(ext)) {
  if (hasPackageJson) {
    // Tenta prettier via npx (cross-platform)
    run(`npx --yes prettier --write "${filePath}"`);
  }
}

// Python
if (ext === ".py") {
  if (commandExists("black")) run(`black "${filePath}"`);
  else if (commandExists("autopep8")) run(`autopep8 --in-place "${filePath}"`);
}

// Go
if (ext === ".go") {
  if (commandExists("gofmt")) run(`gofmt -w "${filePath}"`);
}

// PHP
if (ext === ".php") {
  if (commandExists("php-cs-fixer")) run(`php-cs-fixer fix "${filePath}"`);
}

// Sempre sai com 0 — afterFileEdit não suporta bloqueio
process.exit(0);
