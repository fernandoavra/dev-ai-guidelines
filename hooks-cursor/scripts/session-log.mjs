#!/usr/bin/env node
// session-log.mjs
// Cursor event: stop
// Função: registra fim de sessão e envia notificação desktop (cross-platform)
// Plataformas: Windows, macOS, Linux

import { readFileSync, mkdirSync, appendFileSync, existsSync } from "fs";
import { join } from "path";
import { execSync } from "child_process";

const input = JSON.parse(readFileSync("/dev/stdin", "utf8").trim() || "{}");
const cwd = input.workspace_roots?.[0] || process.cwd();
const status = input.status || "completed";

// Garante que o diretório de logs existe
const logDir = join(cwd, ".cursor", "logs");
mkdirSync(logDir, { recursive: true });

function run(cmd) {
  try {
    return execSync(cmd, { encoding: "utf8", stdio: "pipe", cwd }).trim();
  } catch {
    return null;
  }
}

const branch = run("git rev-parse --abbrev-ref HEAD") || "n/a";
const changes = run("git status --porcelain")?.split("\n").filter(Boolean).length ?? 0;
const timestamp = new Date().toISOString().replace("T", " ").slice(0, 19);

const logLine = `[${timestamp}] status=${status} branch=${branch} uncommitted=${changes}\n`;
appendFileSync(join(logDir, "sessions.log"), logLine, "utf8");

const message = `Branch: ${branch} | ${changes} mudança(s) não commitada(s)`;
const title = "Claude Code / Cursor — sessão encerrada";

// Notificação cross-platform
switch (process.platform) {
  case "darwin":
    run(
      `osascript -e 'display notification "${message}" with title "${title}"'`
    );
    break;
  case "win32":
    // PowerShell toast notification (Windows 10+)
    run(
      `powershell -NoProfile -Command "` +
        `[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null;` +
        `$t = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02);` +
        `$t.GetElementsByTagName('text')[0].AppendChild($t.CreateTextNode('${title}')) | Out-Null;` +
        `$t.GetElementsByTagName('text')[1].AppendChild($t.CreateTextNode('${message}')) | Out-Null;` +
        `[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Cursor').Show([Windows.UI.Notifications.ToastNotification]::new($t))"`
    );
    break;
  default:
    // Linux
    run(`notify-send "${title}" "${message}"`);
    break;
}

process.exit(0);
