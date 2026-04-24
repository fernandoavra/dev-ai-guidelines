# =============================================================================
# setup-global.ps1
# Configura hooks GLOBAIS para Windows — disparam em TODOS os projetos.
# Executar UMA vez por máquina. Nunca commitar com caminhos locais.
#
# Uso (PowerShell como usuário normal, sem admin):
#   cd dev-ai-guidelines
#   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#   .\scripts\setup-global.ps1
#
# Compatível: Windows 10/11 com Node.js instalado
# =============================================================================

$ErrorActionPreference = "Stop"

function Info    { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Success { param($msg) Write-Host "[OK]   $msg" -ForegroundColor Green }
function Warn    { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Err     { param($msg) Write-Host "[ERR]  $msg" -ForegroundColor Red; exit 1 }

# Verifica que está rodando da raiz do dev-ai-guidelines
if (-not (Test-Path "hooks-cursor\scripts\startup-check.mjs")) {
    Err "Execute este script a partir da raiz do repositório dev-ai-guidelines"
}

# Verifica Node.js
try { $nodeVersion = node --version } catch { Err "Node.js não encontrado. Instale em https://nodejs.org" }
Info "Node.js encontrado: $nodeVersion"

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Blue
Write-Host "  dev-ai-guidelines — Setup Global de Hooks (Windows)"           -ForegroundColor Blue
Write-Host "=================================================================" -ForegroundColor Blue
Write-Host ""

# =============================================================================
# CLAUDE CODE — HOOKS GLOBAIS (Node.js — sem .sh no Windows)
# =============================================================================

Info "Configurando hooks globais do Claude Code..."

$ClaudeDir     = Join-Path $env:USERPROFILE ".claude"
$ClaudeHooks   = Join-Path $ClaudeDir "hooks"
$ClaudePrompts = Join-Path $ClaudeDir "prompts"

New-Item -ItemType Directory -Force -Path $ClaudeHooks   | Out-Null
New-Item -ItemType Directory -Force -Path $ClaudePrompts | Out-Null

# No Windows, usa versões .mjs dos hooks globais
# (os .sh não funcionam nativamente — veja INSTALL.md do hooks-cursor)
Copy-Item "hooks-cursor\scripts\startup-check.mjs"   $ClaudeHooks -Force
Copy-Item "hooks-cursor\scripts\block-dangerous.mjs" $ClaudeHooks -Force
Copy-Item "hooks-cursor\scripts\session-log.mjs"     $ClaudeHooks -Force
Success "Scripts Node.js copiados para $ClaudeHooks"

Copy-Item "prompts\*.md" $ClaudePrompts -Force
Success "Prompts copiados para $ClaudePrompts"

# settings.json global do Claude Code
$ClaudeSettings = Join-Path $ClaudeDir "settings.json"

if (Test-Path $ClaudeSettings) {
    Copy-Item $ClaudeSettings "$ClaudeSettings.bak" -Force
    Warn "settings.json existente salvo em $ClaudeSettings.bak"
}

$ClaudeHooksPath = $ClaudeHooks.Replace('\', '\\')

@"
{
  "_scope": "global — aplica em todos os projetos",
  "_managed_by": "dev-ai-guidelines/scripts/setup-global.ps1",
  "_note": "Windows: hooks usam Node.js (.mjs) em vez de bash (.sh)",
  "language": "Portuguese (Brazil)",
  "preferredNotifChannel": "auto",
  "remoteControlAtStartup": true,
  "skipAutoPermissionPrompt": true,

  "hooks": {

    "SessionStart": [
      {
        "_comment": "Sessão nova: verifica se o projeto tem CLAUDE.md e agentes",
        "matcher": "startup",
        "hooks": [{
          "type": "command",
          "command": "node $ClaudeHooksPath\\startup-check.mjs",
          "timeout": 10
        }]
      },
      {
        "_comment": "Após /compact: reinjecta plano ativo",
        "matcher": "compact",
        "hooks": [{
          "type": "command",
          "command": "node $ClaudeHooksPath\\post-compact.mjs",
          "timeout": 5
        }]
      }
    ],

    "PreToolUse": [
      {
        "_comment": "Bloqueia comandos Bash destrutivos",
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "node $ClaudeHooksPath\\block-dangerous.mjs",
          "timeout": 5
        }]
      }
    ],

    "Stop": [
      {
        "_comment": "Log de sessão + notificação desktop",
        "hooks": [{
          "type": "command",
          "command": "node $ClaudeHooksPath\\session-log.mjs",
          "timeout": 10
        }]
      }
    ]

  }
}
"@ | Set-Content -Path $ClaudeSettings -Encoding UTF8

Success "settings.json global do Claude Code criado em $ClaudeSettings"

# =============================================================================
# CURSOR — HOOKS GLOBAIS
# =============================================================================

Info "Configurando hooks globais do Cursor..."

$CursorDir     = Join-Path $env:USERPROFILE ".cursor"
$CursorHooks   = Join-Path $CursorDir "hooks\scripts"
$CursorPrompts = Join-Path $CursorDir "prompts"

New-Item -ItemType Directory -Force -Path $CursorHooks   | Out-Null
New-Item -ItemType Directory -Force -Path $CursorPrompts | Out-Null

Copy-Item "hooks-cursor\scripts\startup-check.mjs"   $CursorHooks -Force
Copy-Item "hooks-cursor\scripts\block-dangerous.mjs" $CursorHooks -Force
Copy-Item "hooks-cursor\scripts\session-log.mjs"     $CursorHooks -Force
Success "Scripts Node.js do Cursor copiados para $CursorHooks"

Copy-Item "prompts\*.md" $CursorPrompts -Force
Success "Prompts copiados para $CursorPrompts"

$CursorHooksJson = Join-Path $CursorDir "hooks.json"
$CursorHooksPath = $CursorHooks.Replace('\', '\\')

if (Test-Path $CursorHooksJson) {
    Copy-Item $CursorHooksJson "$CursorHooksJson.bak" -Force
    Warn "hooks.json existente salvo em $CursorHooksJson.bak"
}

@"
{
  "version": 1,
  "_scope": "global — aplica em todos os projetos",
  "_managed_by": "dev-ai-guidelines/scripts/setup-global.ps1",

  "hooks": {

    "sessionStart": [{
      "_comment": "Verifica se o projeto tem configuração de IA",
      "command": "node $CursorHooksPath\\startup-check.mjs",
      "timeout": 10
    }],

    "beforeShellExecution": [{
      "_comment": "Bloqueia comandos destrutivos",
      "command": "node $CursorHooksPath\\block-dangerous.mjs",
      "timeout": 5
    }],

    "stop": [{
      "_comment": "Log de sessão + notificação desktop",
      "command": "node $CursorHooksPath\\session-log.mjs",
      "timeout": 10
    }]

  }
}
"@ | Set-Content -Path $CursorHooksJson -Encoding UTF8

Success "hooks.json global do Cursor criado em $CursorHooksJson"

# =============================================================================
# CLAUDE.md GLOBAL — regras de orquestração para todos os projetos
# =============================================================================

Info "Instalando CLAUDE.md global..."

$GlobalClaude = Join-Path $ClaudeDir "CLAUDE.md"

if (Test-Path $GlobalClaude) {
    Copy-Item $GlobalClaude "$GlobalClaude.bak" -Force
    Warn "CLAUDE.md global existente salvo em $GlobalClaude.bak"
}

Copy-Item "templates\global-CLAUDE.md" $GlobalClaude -Force
Success "CLAUDE.md global instalado em $GlobalClaude"

# =============================================================================
# COMANDOS GLOBAIS — disponíveis em todos os projetos como /ai:*
# =============================================================================

Info "Instalando comandos globais /ai:*..."

$ClaudeCommandsDir = Join-Path $ClaudeDir "commands\ai"
New-Item -ItemType Directory -Force -Path $ClaudeCommandsDir | Out-Null

Copy-Item "commands\ai\*.md" $ClaudeCommandsDir -Force
Success "Comandos instalados em $ClaudeCommandsDir"

# =============================================================================
# VARIÁVEIS DE AMBIENTE — instrução
# =============================================================================

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Blue
Write-Host "  Configuração de Modelos"                                         -ForegroundColor Blue
Write-Host "=================================================================" -ForegroundColor Blue
Write-Host ""
Write-Host "  Adicione ao seu perfil PowerShell (`$PROFILE):" -ForegroundColor Yellow
Write-Host ""
Write-Host '  $env:ANTHROPIC_MODEL = "claude-sonnet-4-6"'
Write-Host '  # $env:ANTHROPIC_MODEL = "claude-opus-4-6"   # se tiver plano Max'
Write-Host '  $env:CLAUDE_CODE_SUBAGENT_MODEL = "claude-sonnet-4-6"'
Write-Host ""

# =============================================================================
# RESUMO
# =============================================================================

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  Hooks globais configurados com sucesso"                          -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Claude Code: $ClaudeSettings"
Write-Host "  Cursor:      $CursorHooksJson"
Write-Host ""
Write-Host "  Próximo passo: rode setup-project.ps1 na raiz de cada projeto"
Write-Host ""
