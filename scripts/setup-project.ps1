# =============================================================================
# setup-project.ps1
# Configura hooks POR PROJETO no Windows.
# Commitado no repositório: vale para todo o time automaticamente.
#
# Uso:
#   cd seu-projeto
#   /caminho/para/dev-ai-guidelines/scripts/setup-project.ps1
#
# Compatível: Windows 10/11 com Node.js instalado
# =============================================================================

$ErrorActionPreference = "Stop"

function Info    { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Success { param($msg) Write-Host "[OK]   $msg" -ForegroundColor Green }
function Warn    { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Err     { param($msg) Write-Host "[ERR]  $msg" -ForegroundColor Red; exit 1 }

$ScriptDir     = Split-Path -Parent $MyInvocation.MyCommand.Path
$GuidelinesDir = Split-Path -Parent $ScriptDir
$ProjectDir    = Get-Location

if ($ProjectDir.Path -eq $GuidelinesDir) {
    Err "Execute este script a partir da raiz do SEU PROJETO, não do dev-ai-guidelines"
}

if (-not (Test-Path (Join-Path $GuidelinesDir "hooks-cursor\scripts\format-on-edit.mjs"))) {
    Err "Não foi possível localizar dev-ai-guidelines em $GuidelinesDir"
}

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Blue
Write-Host "  dev-ai-guidelines — Setup de Hooks por Projeto (Windows)"       -ForegroundColor Blue
Write-Host "  Projeto: $ProjectDir"                                            -ForegroundColor Blue
Write-Host "=================================================================" -ForegroundColor Blue
Write-Host ""

# =============================================================================
# CLAUDE CODE — HOOKS POR PROJETO
# =============================================================================

Info "Configurando hooks do Claude Code para este projeto..."

$ClaudeDir   = Join-Path $ProjectDir ".claude"
$ClaudeHooks = Join-Path $ClaudeDir "hooks"
$ClaudePlans = Join-Path $ClaudeDir "plans"

New-Item -ItemType Directory -Force -Path $ClaudeHooks | Out-Null
New-Item -ItemType Directory -Force -Path $ClaudePlans | Out-Null

Copy-Item (Join-Path $GuidelinesDir "hooks-cursor\scripts\format-on-edit.mjs") $ClaudeHooks -Force
Copy-Item (Join-Path $GuidelinesDir "hooks-cursor\scripts\require-tests.mjs")  $ClaudeHooks -Force
Success "Scripts Node.js do Claude Code copiados para $ClaudeHooks"

$ClaudeSettings = Join-Path $ClaudeDir "settings.json"

if (Test-Path $ClaudeSettings) {
    Warn "settings.json já existe. Adicione manualmente a seção de hooks abaixo:"
    Write-Host @"

  {
    "hooks": {
      "PostToolUse": [{
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [{ "type": "command", "command": "node .claude/hooks/format-on-edit.mjs", "timeout": 30 }]
      }],
      "PreToolUse": [{
        "matcher": "mcp__github__create_pull_request",
        "hooks": [{ "type": "command", "command": "node .claude/hooks/require-tests.mjs", "timeout": 120 }]
      }]
    }
  }

"@
} else {
    @"
{
  "_scope": "project — commitado, vale para todo o time",
  "_managed_by": "dev-ai-guidelines/scripts/setup-project.ps1",
  "_note": "Windows: scripts usam Node.js (.mjs)",

  "model": "claude-sonnet-4-6",

  "hooks": {

    "PostToolUse": [{
      "_comment": "Auto-formata após qualquer edição",
      "matcher": "Edit|Write|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/format-on-edit.mjs",
        "timeout": 30
      }]
    }],

    "PreToolUse": [{
      "_comment": "Bloqueia PR se testes falhando",
      "matcher": "mcp__github__create_pull_request",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/require-tests.mjs",
        "timeout": 120
      }]
    }]

  }
}
"@ | Set-Content -Path $ClaudeSettings -Encoding UTF8
    Success "settings.json de projeto criado em $ClaudeSettings"
}

$ActivePlanSrc = Join-Path $GuidelinesDir "templates\active-plan.md"
$ActivePlanDst = Join-Path $ClaudePlans "active-plan.md"
if (-not (Test-Path $ActivePlanDst)) {
    Copy-Item $ActivePlanSrc $ActivePlanDst -Force
    Success "Template active-plan.md criado em .claude\plans\"
}

# =============================================================================
# CURSOR — HOOKS POR PROJETO
# =============================================================================

Info "Configurando hooks do Cursor para este projeto..."

$CursorDir   = Join-Path $ProjectDir ".cursor"
$CursorHooks = Join-Path $CursorDir "hooks\scripts"

New-Item -ItemType Directory -Force -Path $CursorHooks | Out-Null

Copy-Item (Join-Path $GuidelinesDir "hooks-cursor\scripts\format-on-edit.mjs") $CursorHooks -Force
Copy-Item (Join-Path $GuidelinesDir "hooks-cursor\scripts\require-tests.mjs")  $CursorHooks -Force
Success "Scripts Node.js do Cursor copiados para $CursorHooks"

$CursorHooksJson = Join-Path $CursorDir "hooks.json"

if (Test-Path $CursorHooksJson) {
    Warn "hooks.json já existe. Adicione manualmente as entradas abaixo."
} else {
    @"
{
  "version": 1,
  "_scope": "project — commitado, vale para todo o time",
  "_managed_by": "dev-ai-guidelines/scripts/setup-project.ps1",

  "hooks": {

    "afterFileEdit": [{
      "_comment": "Auto-formata após qualquer edição",
      "command": "node .cursor/hooks/scripts/format-on-edit.mjs",
      "timeout": 30
    }],

    "beforeShellExecution": [{
      "_comment": "Bloqueia push/PR se testes falhando",
      "matcher": "gh pr create|git push.*origin.*(main|master)",
      "command": "node .cursor/hooks/scripts/require-tests.mjs",
      "timeout": 120
    }]

  }
}
"@ | Set-Content -Path $CursorHooksJson -Encoding UTF8
    Success "hooks.json de projeto criado em $CursorHooksJson"
}

# =============================================================================
# .gitignore
# =============================================================================

$GitIgnore = Join-Path $ProjectDir ".gitignore"
$entries = @(".claude/settings.local.json", ".claude/logs/", ".claude/plans/archive/")

foreach ($entry in $entries) {
    $content = if (Test-Path $GitIgnore) { Get-Content $GitIgnore -Raw } else { "" }
    if ($content -notlike "*$entry*") {
        Add-Content -Path $GitIgnore -Value $entry
        Success "Adicionado ao .gitignore: $entry"
    }
}

# =============================================================================
# RESUMO
# =============================================================================

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  Hooks de projeto configurados"                                   -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Claude Code"
Write-Host "  ├── .claude\settings.json     → format-on-edit + require-tests"
Write-Host "  ├── .claude\hooks\            → scripts Node.js"
Write-Host "  └── .claude\plans\            → active-plan.md criado"
Write-Host ""
Write-Host "  Cursor"
Write-Host "  ├── .cursor\hooks.json        → format-on-edit + require-tests"
Write-Host "  └── .cursor\hooks\scripts\    → scripts Node.js"
Write-Host ""
Write-Host "  Próximos passos:" -ForegroundColor Yellow
Write-Host "  1. git add .claude\settings.json .claude\hooks\ .claude\plans\"
Write-Host "     git add .cursor\hooks.json .cursor\hooks\scripts\"
Write-Host "     git commit -m `"chore: add ai hooks for team workflow`""
Write-Host ""
Write-Host "  2. Cada dev deve rodar setup-global.ps1 uma vez na sua máquina"
Write-Host ""
