# OpenCode — Guia de Configuracao

Comandos, agentes e skills adaptados do playbook de desenvolvimento com IA para uso com o **OpenCode**.

Todos os recursos seguem os mesmos principios e padroes do Claude Code, adaptados para o formato nativo do OpenCode (Markdown com YAML frontmatter).

---

## Instalacao rapida

### Novo projeto

1. Copie os comandos para `.opencode/commands/` do projeto:
   ```bash
   mkdir -p .opencode/commands
   cp dev-ai-guidelines/.opencode/commands/*.md .opencode/commands/
   ```

2. Copie os agentes para `.opencode/agents/` do projeto:
   ```bash
   mkdir -p .opencode/agents
   cp dev-ai-guidelines/.opencode/agents/*.md .opencode/agents/
   ```

3. Copie as skills para `.opencode/skills/` do projeto:
   ```bash
   mkdir -p .opencode/skills
   cp -r dev-ai-guidelines/.opencode/skills/* .opencode/skills/
   ```

4. Abra o OpenCode no projeto:
   ```bash
   opencode
   ```

5. Execute o comando de setup:
   ```
   /ai-setup
   ```

### Instalacao global

Para ter os recursos disponiveis em todos os projetos:

```bash
# Comandos globais
mkdir -p ~/.config/opencode/commands
cp dev-ai-guidelines/.opencode/commands/*.md ~/.config/opencode/commands/

# Agentes globais
mkdir -p ~/.config/opencode/agents
cp dev-ai-guidelines/.opencode/agents/*.md ~/.config/opencode/agents/

# Skills globais
mkdir -p ~/.config/opencode/skills
cp -r dev-ai-guidelines/.opencode/skills/* ~/.config/opencode/skills/
```

---

## Estrutura de recursos OpenCode

```
.opencode/
├── commands/                        # 21 comandos (slash commands)
│   ├── ai-setup.md                  # Setup inicial de IA para projeto novo
│   ├── ai-update.md                 # Gap analysis de projeto existente
│   ├── ai-docs.md                   # Geracao/atualizacao do PROJECT.md
│   ├── ai-ask.md                    # Perguntas respondidas via documentacao
│   ├── ai-spec.md                   # Discovery estruturado de PRD/specs
│   ├── ai-task.md                   # Inicio de tarefa com plano
│   ├── ai-task-finish.md            # Conclusao formal de tarefa
│   ├── ai-task-delete.md            # Descarte de tarefa nao executada
│   ├── ai-handoff.md                # Handoff de sessao
│   ├── ai-resume.md                 # Retomada de tarefa salva
│   ├── ai-daily-close.md            # Encerramento do dia
│   ├── ai-daily-start.md            # Briefing de inicio do dia
│   ├── ai-review.md                 # Code review pre-PR (3 agentes em paralelo)
│   ├── ai-hostile-review.md         # Gate adversarial GO/NO-GO
│   ├── ai-pr-review.md              # Revisao em massa de PRs
│   ├── ai-debt.md                   # Auditoria de divida tecnica
│   ├── ai-db-audit.md               # Auditoria de banco de dados
│   ├── ai-bug.md                    # Diagnostico de bug
│   ├── ai-feature.md                # Feature cross-componente
│   ├── ai-add.md                    # Integracao de novo componente
│   └── ai-status.md                 # Dashboard rapido da sessao
│
├── agents/                          # 7 subagentes especializados
│   ├── architect.md                 # Design de contratos entre componentes
│   ├── code-reviewer.md             # Revisao de qualidade de codigo
│   ├── db-auditor.md                # Auditoria de banco de dados
│   ├── hostile-reviewer.md          # Revisao adversarial (valida se resolve o problema)
│   ├── qa-engineer.md               # Escrita de testes e cobertura
│   ├── security-reviewer.md         # Scan de vulnerabilidades
│   └── tech-debt-auditor.md         # Auditoria de divida tecnica
│
└── skills/
    └── severity-scale/
        └── SKILL.md                 # Escala P0-P3 unificada para todos os agentes
```

---

## Mapeamento Claude Code ↔ OpenCode

| Claude Code | OpenCode | Notas |
|---|---|---|
| `CLAUDE.md` | `AGENTS.md` (gerado por `/init`) | Contexto principal do projeto |
| `commands/ai/*.md` (slash `/ai:*`) | `.opencode/commands/ai-*.md` (slash `/ai-*`) | Comandos customizados |
| `agents/*.md` | `.opencode/agents/*.md` | Subagentes com `mode: subagent` |
| `agents/severity-scale.md` (doc) | `.opencode/skills/severity-scale/SKILL.md` | Escala compartilhada como skill |
| `allowed-tools: [Read, Bash, ...]` | `permission: { read: allow, bash: allow, ... }` | Controle de ferramentas |
| `model: sonnet` | `model: anthropic/claude-sonnet-4-20250514` | Ou omitir (herda do agente pai) |
| `tools: Read, Grep, Glob` | `permission: { read: allow, glob: allow, grep: allow }` | Ferramentas permitidas |
| `@agent-name` | `@agent-name` | Mesmo mecanismo de mencão |
| `$ARGUMENTS` | `$ARGUMENTS` | Igual — argumentos do comando |
| `/clear` | Sessão nova | OpenCode gerencia contexto automaticamente |
| `/compact` | Compaction automática | Gerenciado pelo OpenCode |
| `argument-hint:` (frontmatter) | `$ARGUMENTS` no corpo | Argumentos via template |
| Subagentes paralelos | @general, @explore, @scout | Built-in + custom agents |
| `.claude/plans/` | `.claude/plans/` | Mesma estrutura de planos |

### Principais diferencas de formato

**Claude Code agent:**
```yaml
---
name: architect
description: Design contracts...
tools: Read, Grep, Glob
model: sonnet
---
```

**OpenCode agent:**
```yaml
---
description: Design contracts...
mode: subagent
temperature: 0.1
permission:
  read: allow
  glob: allow
  grep: allow
  edit: deny
  bash: deny
---
```

**Claude Code command:**
```yaml
---
description: Setup inicial...
argument-hint: <nome>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---
```

**OpenCode command:**
```yaml
---
description: Setup inicial...
agent: build
subtask: true
---
```

---

## Como os comandos funcionam no OpenCode

OpenCode carrega comandos de `.opencode/commands/` e `~/.config/opencode/commands/` automaticamente. Cada arquivo `.md` vira um slash command:

| Arquivo | Comando |
|---|---|
| `ai-task.md` | `/ai-task` |
| `ai-review.md` | `/ai-review` |
| `ai-spec.md` | `/ai-spec` |

### Opcoes de comando

| Campo | Descricao |
|---|---|
| `description` | Texto mostrado no autocomplete do TUI |
| `agent` | Agente que executa o comando (`build`, `plan`, etc.) |
| `subtask` | Se `true`, executa como subagente isolado |
| `model` | Modelo especifico para o comando |

### Placeholders nos templates

| Placeholder | Descricao |
|---|---|
| `$ARGUMENTS` | Todos os argumentos passados ao comando |
| `$1`, `$2`, `$3` | Argumentos posicionais |
| `` !`comando` `` | Output de comando bash inline |
| `@arquivo` | Conteudo do arquivo incluido no prompt |

---

## Como os agentes funcionam no OpenCode

Agentes sao carregados de `.opencode/agents/` e `~/.config/opencode/agents/`. Subagentes podem ser invocados:

- **Automaticamente** pelo agente principal baseado na `description`
- **Manualmente** via `@agent-name` na mensagem

### Permissoes de agentes

| Chave | Ferramentas que controla |
|---|---|
| `read` | Leitura de arquivos |
| `edit` | Escrita, edicao, patches |
| `glob` | Busca de arquivos por padrao |
| `grep` | Busca de conteudo em arquivos |
| `bash` | Comandos shell |
| `task` | Invocacao de subagentes |
| `webfetch` | Requisicoes HTTP |
| `skill` | Carregamento de skills |

Valores: `allow` (permitido), `deny` (bloqueado), `ask` (pergunta ao usuario).

---

## Skills no OpenCode

Skills sao instrucoes reutilizaveis que agentes carregam sob demanda via `skill({ name: "..." })`. O playbook inclui uma skill compartilhada:

### `severity-scale`

Escala de severidade P0-P3 usada por todos os agentes de review. Garante que findings de diferentes agentes sejam comparaveis e possam ser sintetizados em uma lista unificada.

Carregar via: `skill({ name: "severity-scale" })`

---

## Rotina diaria com OpenCode

### Inicio da sessao

1. Abra o OpenCode no projeto: `opencode`
2. Execute `/ai-daily-start` para ver o briefing do dia anterior
3. Escolha uma tarefa para retomar ou iniciar nova

### Durante a sessao

- Use **Tab** para alternar entre agente Build (implementacao) e Plan (analise)
- Use `/ai-task <descricao>` para iniciar uma nova tarefa
- Use `/ai-handoff <nome>` para salvar estado antes de pausar
- Use `/ai-resume <nome>` para retomar tarefa pausada
- Use `@agent-name` para invocar subagentes especializados
- Use `/ai-review` antes de abrir um PR
- Use `/ai-hostile-review` como gate de validacao

### Encerramento da sessao

1. `/ai-daily-close` para gerar resumo do dia
2. Commite o trabalho concluido

---

## Referencias

- [OpenCode Docs](https://opencode.ai/docs/)
- [OpenCode Agents](https://opencode.ai/docs/agents/)
- [OpenCode Commands](https://opencode.ai/docs/commands/)
- [OpenCode Skills](https://opencode.ai/docs/skills/)
- [OpenCode Config](https://opencode.ai/docs/config/)
