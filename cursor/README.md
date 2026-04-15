# Cursor — Guia de Configuração

Regras e templates adaptados do playbook de desenvolvimento com IA para uso com o **Cursor**.

Todas as regras seguem os mesmos princípios e padrões do Claude Code, adaptados para o sistema de regras `.mdc` do Cursor.

---

## Instalação rápida

### Novo projeto

1. Copie `.cursorrules` da template para a raiz do projeto:
   ```bash
   # Use o conteúdo de cursor/templates/cursorrules-template.md
   # e adapte para o seu projeto
   ```

2. Copie as regras relevantes para `.cursor/rules/` do projeto:
   ```bash
   mkdir -p .cursor/rules
   cp cursor/rules/*.mdc .cursor/rules/
   ```

3. Abra o Cursor no projeto e peça para configurar:
   > "Aplique a regra setup-project para configurar a estrutura de IA deste projeto"

### Projeto existente

1. Copie as regras para `.cursor/rules/`
2. Peça ao Cursor:
   > "Aplique a regra gap-analysis para analisar e atualizar a configuração existente"

---

## Estrutura de regras

```
cursor/
├── rules/                                  # Copiar para .cursor/rules/ do projeto
│   ├── project-conventions.mdc             # [always-on] Convenções fundamentais
│   │
│   │   # Roles especializados
│   ├── code-reviewer.mdc                   # Revisão de qualidade
│   ├── architect.mdc                       # Arquitetura e contratos
│   ├── qa-engineer.mdc                     # Testes e cobertura
│   ├── security-reviewer.mdc               # Segurança
│   ├── tech-debt-auditor.mdc               # Dívida técnica
│   │
│   │   # Workflows
│   ├── setup-project.mdc                   # Setup inicial do projeto
│   ├── gap-analysis.mdc                    # Atualização incremental
│   ├── project-documentation.mdc           # Geração do PROJECT.md
│   ├── task-start.mdc                      # Início de tarefa
│   ├── session-handoff.mdc                 # Encerramento de sessão
│   ├── cross-component-feature.mdc         # Features multi-componente
│   ├── code-review.mdc                     # Revisão completa de PR
│   ├── tech-debt-audit.mdc                 # Auditoria periódica
│   └── bug-diagnosis.mdc                   # Diagnóstico de bugs
│
└── templates/
    └── cursorrules-template.md             # Template para .cursorrules na raiz
```

---

## Como as regras funcionam no Cursor

O Cursor carrega regras de `.cursor/rules/` automaticamente baseado em triggers:

| Tipo | Comportamento | Exemplo |
|------|--------------|---------|
| **Always-on** | Sempre carregada em toda interação | `project-conventions.mdc` |
| **Agent-requested** | IA decide quando carregar baseado na `description` | `code-reviewer.mdc`, `task-start.mdc` |
| **Glob-based** | Carregada quando arquivos matching estão no contexto | Não usado neste playbook |

As regras de roles e workflows usam o campo `description` como trigger. O Cursor lê esse campo e decide automaticamente quando incluir a regra na conversa.

---

## Mapeamento Claude Code ↔ Cursor

| Claude Code | Cursor | Notas |
|---|---|---|
| `CLAUDE.md` | `.cursorrules` | Contexto principal do projeto |
| `.claude/agents/*.md` | `.cursor/rules/*.mdc` | Roles são regras com description |
| `.claude/skills/` | `.cursor/rules/*.mdc` | Skills viram regras com globs |
| Prompts (copiar/colar) | Regras auto-carregadas | Cursor carrega automaticamente |
| `@agent-name` | Automático via description | Sem invocação manual |
| `/clear` | Novo Chat | Limpa contexto entre tarefas |
| `/compact` | Não existe | Cursor gerencia contexto internamente |
| Subagentes paralelos | Composer | Use Composer para mudanças multi-arquivo |
| `.claude/plans/` | `.cursor/plans/` | Mesma estrutura de planos |

---

## Templates compartilhados

Estes templates são agnósticos de ferramenta e servem tanto para Claude Code quanto Cursor:

- `templates/PROJECT.md` — documentação viva do projeto
- `templates/active-plan.md` — estado de sessão entre contextos

---

## Rotina diária com Cursor

### Início da sessão

1. Verifique se existe `.cursor/plans/active-plan.md`
   - Se sim: leia o "Next session start" antes de qualquer prompt
   - Se não: consulte o último commit do git para se orientar
2. Defina mentalmente: *qual é o resultado concreto desta sessão?*

### Durante a sessão

- **Novo Chat** entre tarefas não relacionadas (equivalente ao `/clear`)
- Use `@arquivo` para referenciar arquivos específicos
- Use `@codebase` para buscas amplas no projeto
- Se o Cursor errou duas vezes a mesma coisa: novo chat + prompt mais específico
- Confirme aprovação antes de cada implementação significativa
- Use **Composer** para mudanças que tocam múltiplos arquivos

### Encerramento da sessão

1. Peça: "Aplique o workflow de session-handoff para salvar o estado"
2. Confirme que `.cursor/plans/active-plan.md` foi atualizado
3. Faça commit do trabalho concluído

---

## Dicas específicas do Cursor

- **@-mentions são seu melhor amigo:** `@PROJECT.md`, `@arquivo.ts`, `@codebase`
- **Composer > Chat** para implementação multi-arquivo
- **Chat** para exploração, perguntas e análise
- **Ctrl+K** (inline edit) para mudanças localizadas em um arquivo
- **Novo Chat** funciona como `/clear` — use entre tarefas
- Se precisar que uma regra específica seja aplicada, mencione-a explicitamente: "Siga a regra de code-review para revisar este PR"
