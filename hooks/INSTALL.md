# Instalação dos Hooks

Guia de setup completo para integrar os hooks ao Claude Code.

---

## Estrutura esperada após instalação

```
~/.claude/
├── settings.json          # Configuração global dos hooks
├── hooks/                 # Scripts executáveis
│   ├── startup-check.sh
│   ├── intercept-clear.sh
│   ├── post-compact.sh
│   ├── post-clear-orient.sh
│   ├── format-on-edit.sh
│   ├── block-dangerous.sh
│   ├── require-tests.sh
│   └── session-log.sh
└── prompts/               # Prompts referenciados pelos hooks
    ├── 01-setup-hybrid-structure.md
    ├── 02-gap-analysis.md
    ├── 03-project-documentation.md
    ├── 04-task-start.md
    ├── 05-session-handoff.md
    ├── 06-cross-component-feature.md
    ├── 07-code-review.md
    ├── 08-tech-debt-audit.md
    └── 09-bug-diagnosis.md
```

---

## Instalação passo a passo

### 1. Crie as pastas necessárias

```bash
mkdir -p ~/.claude/hooks
mkdir -p ~/.claude/prompts
```

### 2. Copie os scripts de hook

```bash
cp hooks/*.sh ~/.claude/hooks/
```

### 3. Dê permissão de execução a todos os scripts

```bash
chmod +x ~/.claude/hooks/*.sh
```

### 4. Copie os prompts

```bash
cp prompts/*.md ~/.claude/prompts/
```

### 5. Configure o settings.json global

Se você ainda não tem um `~/.claude/settings.json`:

```bash
cp hooks/settings.json ~/.claude/settings.json
```

Se já tem um `settings.json`, **não sobrescreva** — mescle a seção `"hooks"` manualmente
ou use o comando `/hooks` dentro do Claude Code para adicionar via interface.

### 6. Verifique a instalação

Abra o Claude Code em qualquer projeto e rode:

```
/hooks
```

Você deve ver todos os hooks listados e ativos.

---

## Variáveis de ambiente opcionais

| Variável | Padrão | Descrição |
|---|---|---|
| `CLAUDE_PROMPTS_DIR` | `~/.claude/prompts` | Diretório onde os prompts estão armazenados |

Adicione ao seu `.bashrc` / `.zshrc` se quiser um caminho diferente:

```bash
export CLAUDE_PROMPTS_DIR="$HOME/.claude/prompts"
```

---

## Hooks por escopo

Os hooks podem ser globais (valem para todos os projetos) ou por projeto:

| Escopo | Localização | Uso |
|---|---|---|
| **Global** | `~/.claude/settings.json` | Todos os projetos |
| **Projeto** | `.claude/settings.json` | Só este projeto (commitável) |
| **Local** | `.claude/settings.local.json` | Só este projeto (não commitável) |

Os hooks de segurança (`block-dangerous`, `require-tests`) são bons candidatos
para o escopo global. Hooks de formatação podem ser por projeto se cada um
usa uma stack diferente.

---

## Testando um hook manualmente

Você pode testar qualquer script passando um JSON de exemplo via stdin:

```bash
# Testa startup-check.sh num projeto sem CLAUDE.md
echo '{"cwd": "/tmp/projeto-teste"}' | ~/.claude/hooks/startup-check.sh

# Testa intercept-clear.sh com o prompt /clear
echo '{"prompt": "/clear"}' | ~/.claude/hooks/intercept-clear.sh

# Testa block-dangerous.sh com um comando perigoso
echo '{"tool_input": {"command": "rm -rf /"}}' | ~/.claude/hooks/block-dangerous.sh
```

---

## Desativando um hook específico

Para desativar temporariamente um hook sem apagar, adicione `"disabled": true`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write|MultiEdit",
      "disabled": true,
      "hooks": [{ "type": "command", "command": "~/.claude/hooks/format-on-edit.sh" }]
    }]
  }
}
```

---

## Troubleshooting

**Hook não está disparando**
- Verifique se o script tem permissão de execução: `ls -la ~/.claude/hooks/`
- Verifique o matcher no settings.json
- Rode o Claude Code com `--debug` para ver logs detalhados de hooks

**Hook disparando mas não tendo efeito**
- Verifique se o stdout está formatado como JSON válido
- Scripts que produzem JSON inválido são ignorados silenciosamente
- Teste manualmente com o comando acima

**`jq` não encontrado**
- Instale com: `brew install jq` (macOS) ou `apt install jq` (Linux)
- Os hooks dependem de `jq` para parsear o JSON de entrada
