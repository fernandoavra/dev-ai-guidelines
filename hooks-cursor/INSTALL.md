# Instalação dos Hooks — Cursor (Cross-platform)

Guia para Windows, macOS e Linux.

> **Importante:** os scripts são escritos em Node.js (`.mjs`) porque é o único
> runtime garantido em todas as plataformas. Scripts `.sh` **não funcionam**
> nativamente no Windows e têm bugs conhecidos no Cursor em fevereiro/2026.

---

## Pré-requisitos

| Ferramenta | Windows | macOS | Linux |
|---|---|---|---|
| Node.js | ✅ obrigatório | ✅ obrigatório | ✅ obrigatório |
| Git | ✅ Git for Windows | ✅ | ✅ |
| jq | ❌ não necessário | ❌ não necessário | ❌ não necessário |

Verifique: `node --version` deve retornar v18 ou superior.

---

## Estrutura após instalação (por projeto)

```
seu-projeto/
└── .cursor/
    ├── hooks.json          # Configuração dos hooks
    ├── hooks/
    │   └── scripts/        # Scripts Node.js cross-platform
    │       ├── startup-check.mjs
    │       ├── block-dangerous.mjs
    │       ├── format-on-edit.mjs
    │       ├── require-tests.mjs
    │       └── session-log.mjs
    ├── logs/               # Criado automaticamente
    │   └── sessions.log
    └── prompts/            # Prompts referenciados pelo startup-check
        └── 01-setup-hybrid-structure.md
```

---

## Instalação passo a passo

### 1. Copie os scripts para o projeto

```bash
# Na raiz do projeto:
mkdir -p .cursor/hooks/scripts
cp hooks-cursor/scripts/*.mjs .cursor/hooks/scripts/
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path .cursor\hooks\scripts
Copy-Item hooks-cursor\scripts\*.mjs .cursor\hooks\scripts\
```

### 2. Copie o hooks.json

```bash
cp hooks-cursor/hooks.json .cursor/hooks.json
```

### 3. Copie os prompts

```bash
# macOS/Linux
mkdir -p ~/.cursor/prompts
cp prompts/*.md ~/.cursor/prompts/

# Windows (PowerShell)
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\prompts"
Copy-Item prompts\*.md "$env:USERPROFILE\.cursor\prompts\"
```

### 4. Commite os hooks no repositório

```bash
git add .cursor/hooks.json .cursor/hooks/scripts/
git commit -m "chore: add cursor hooks for AI-assisted development"
```

Todos do time recebem os hooks automaticamente ao clonar/puxar.

---

## Escopos de configuração

| Escopo | Localização | Quando usar |
|---|---|---|
| **Por projeto** (recomendado) | `.cursor/hooks.json` | Time inteiro — commitável |
| **Global** | `~/.cursor/hooks.json` | Só você — todos os projetos |

Os dois escopos são somados: ambos disparam quando aplicável.

---

## Situação atual no Windows (abril/2026)

Scripts `.sh` **não funcionam** no Cursor no Windows — há vários bugs abertos
no fórum oficial (janeiro-fevereiro/2026). Os scripts `.mjs` deste repositório
contornam todos esses problemas.

**O que funciona no Windows:**
- ✅ `node script.mjs` — sempre funciona
- ✅ `powershell -File script.ps1` — funciona com ressalvas
- ❌ Scripts `.sh` — falham com exit code 1 (bug do launcher)
- ❌ `bash script.sh` — depende do Git Bash estar no PATH

**Recomendação para devs Windows:** use WSL2 se precisar de scripts shell
complexos. Para o fluxo deste repositório, Node.js resolve tudo.

---

## Testando um hook manualmente

**macOS/Linux:**
```bash
echo '{"cwd": "/caminho/do/projeto"}' | node .cursor/hooks/scripts/startup-check.mjs
echo '{"command": "rm -rf /"}' | node .cursor/hooks/scripts/block-dangerous.mjs
echo '{"file_path": "src/index.ts"}' | node .cursor/hooks/scripts/format-on-edit.mjs
```

**Windows (PowerShell):**
```powershell
'{"cwd": "C:\\caminho\\do\\projeto"}' | node .cursor\hooks\scripts\startup-check.mjs
'{"command": "rd /s /q C:\\"}' | node .cursor\hooks\scripts\block-dangerous.mjs
```

---

## Variáveis de ambiente

| Variável | Padrão | Descrição |
|---|---|---|
| `CURSOR_PROMPTS_DIR` | `~/.cursor/prompts` | Diretório dos prompts |

---

## Comparativo com os hooks do Claude Code

| Funcionalidade | Claude Code | Cursor |
|---|---|---|
| Startup sem config | `startup-check.sh` | `startup-check.mjs` (sessionStart) |
| Bloquear /clear | `intercept-clear.sh` | ❌ Cursor não expõe /clear |
| Pós-compact | `post-compact.sh` | `preCompact` (apenas observação) |
| Bloquear comandos | `block-dangerous.sh` | `block-dangerous.mjs` (beforeShellExecution) |
| Auto-formatação | `format-on-edit.sh` | `format-on-edit.mjs` (afterFileEdit) |
| Bloquear PR sem tests | `require-tests.sh` | `require-tests.mjs` (beforeShellExecution) |
| Log de sessão | `session-log.sh` | `session-log.mjs` (stop) |
| Notificação desktop | ✅ macOS/Linux | ✅ Windows/macOS/Linux |

---

## Troubleshooting

**Hook não dispara no Windows**
→ Verifique se `node` está no PATH: `node --version`
→ Abra o painel Output → Hooks no Cursor para ver erros

**`/dev/stdin` não existe no Windows**
→ Os scripts usam `readFileSync("/dev/stdin")` que funciona no WSL2.
   No Windows nativo (fora do WSL), substitua por:
   ```js
   import { readFileSync } from "fs";
   const chunks = [];
   process.stdin.on("data", c => chunks.push(c));
   process.stdin.on("end", () => {
     const input = JSON.parse(Buffer.concat(chunks).toString() || "{}");
     // ... resto do script
   });
   ```
   Uma versão alternativa dos scripts com stdin assíncrono está em
   `scripts/windows-compat/` se você não usa WSL2.

**Formatador não roda**
→ Confirme que `npx` está disponível: `npx --version`
→ O `afterFileEdit` é informacional — não bloqueia, só executa
