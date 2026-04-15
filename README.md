# dev-ai-guidelines

Playbook de desenvolvimento apoiado por agentes de IA — compatível com **Claude Code** e **Cursor**.

Contém prompts, templates, regras e rotinas testadas para estruturar projetos,
criar documentação viva e integrar agentes de IA ao ciclo diário de desenvolvimento.

---

## Estrutura do repositório

```
dev-ai-guidelines/
├── prompts/                    # Prompts prontos para uso no Claude Code
│   ├── 01-setup-hybrid-structure.md     # Setup inicial: CLAUDE.md + skills + agents
│   ├── 02-gap-analysis.md               # Atualização incremental da estrutura
│   ├── 03-project-documentation.md      # Geração do PROJECT.md
│   ├── 04-task-start.md                 # Início de qualquer tarefa
│   ├── 05-session-handoff.md            # Encerramento de sessão
│   ├── 06-cross-component-feature.md    # Features que tocam múltiplos apps
│   ├── 07-code-review.md                # Revisão de PR com agentes
│   ├── 08-tech-debt-audit.md            # Auditoria periódica de dívida técnica
│   └── 09-bug-diagnosis.md              # Diagnóstico de bugs e incidentes
│
├── templates/                  # Templates para copiar e adaptar por projeto
│   ├── CLAUDE.md               # Template do contexto principal (Claude Code)
│   ├── PROJECT.md              # Template da documentação do projeto (ambos)
│   └── active-plan.md          # Template de handoff de sessão (ambos)
│
├── agents/                     # Definições de subagentes (Claude Code)
│   ├── code-reviewer.md        # Revisor de qualidade de código
│   ├── architect.md            # Decisões de arquitetura e contratos
│   ├── qa-engineer.md          # Estratégia e escrita de testes
│   ├── security-reviewer.md    # Auditoria de segurança
│   └── tech-debt-auditor.md    # Mapeamento de dívida técnica
│
├── cursor/                     # Regras e templates para Cursor
│   ├── rules/                  # Regras .mdc — copiar para .cursor/rules/
│   │   ├── project-conventions.mdc  # [always-on] Convenções fundamentais
│   │   ├── code-reviewer.mdc       # Revisão de qualidade
│   │   ├── architect.mdc           # Arquitetura e contratos
│   │   ├── qa-engineer.mdc         # Testes e cobertura
│   │   ├── security-reviewer.mdc   # Segurança
│   │   ├── tech-debt-auditor.mdc   # Dívida técnica
│   │   ├── setup-project.mdc       # Setup inicial
│   │   ├── gap-analysis.mdc        # Atualização incremental
│   │   ├── project-documentation.mdc # Geração do PROJECT.md
│   │   ├── task-start.mdc          # Início de tarefa
│   │   ├── session-handoff.mdc     # Encerramento de sessão
│   │   ├── cross-component-feature.mdc # Features multi-componente
│   │   ├── code-review.mdc         # Revisão de PR
│   │   ├── tech-debt-audit.mdc     # Auditoria periódica
│   │   └── bug-diagnosis.mdc       # Diagnóstico de bugs
│   ├── templates/
│   │   └── cursorrules-template.md  # Template para .cursorrules
│   └── README.md               # Guia de uso com Cursor
│
├── DAILY-ROUTINE.md            # Rotina diária (Claude Code + Cursor)
└── README.md                   # Este arquivo
```

---

## Qual ferramenta usar

| Ferramenta | Melhor para | Onde configurar |
|---|---|---|
| **Claude Code** | Terminal, subagentes, operações complexas em paralelo | `CLAUDE.md` + `.claude/agents/` + `.claude/skills/` |
| **Cursor** | IDE, edição inline, Composer multi-arquivo | `.cursorrules` + `.cursor/rules/` |

Ambas as ferramentas seguem os mesmos princípios, padrões e workflows. A diferença é o formato de configuração.

---

## Como usar

### Claude Code — Novo projeto

1. Copie `templates/CLAUDE.md` para a raiz do projeto
2. Copie os agentes relevantes de `agents/` para `.claude/agents/` do projeto
3. Rode o prompt `prompts/01-setup-hybrid-structure.md` no Claude Code
4. Rode o prompt `prompts/03-project-documentation.md` para gerar o PROJECT.md

### Claude Code — Projeto existente

1. Rode o prompt `prompts/02-gap-analysis.md` — ele lê o que já existe antes de mudar qualquer coisa

### Cursor — Novo projeto

1. Copie o conteúdo de `cursor/templates/cursorrules-template.md` para `.cursorrules` na raiz
2. Copie as regras relevantes de `cursor/rules/` para `.cursor/rules/` do projeto
3. No Cursor, peça para aplicar a regra `setup-project` para configurar a estrutura
4. Peça para gerar o PROJECT.md usando a regra `project-documentation`

### Cursor — Projeto existente

1. Copie as regras para `.cursor/rules/`
2. No Cursor, peça para aplicar a regra `gap-analysis`

### Ambas as ferramentas no mesmo projeto

Se o time usa ambas, mantenha os dois conjuntos de configuração:
- `.cursorrules` + `.cursor/rules/` para quem usa Cursor
- `CLAUDE.md` + `.claude/agents/` para quem usa Claude Code
- `PROJECT.md` e `active-plan.md` são compartilhados entre as duas

### Ciclo diário

Consulte `DAILY-ROUTINE.md` para a sequência recomendada para cada ferramenta.

---

## Princípios que guiam este playbook

- **Explorar antes de agir** — nenhum agente escreve código sem antes mapear o contexto
- **Planejar antes de implementar** — aprovação explícita do plano antes de qualquer mudança
- **Documentar antes de fechar** — sessão não encerra sem handoff registrado
- **Contexto enxuto** — limpar contexto entre tarefas não relacionadas
- **Mesmos padrões, qualquer ferramenta** — Claude Code e Cursor seguem as mesmas regras

---

## Referências

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)
- [Skills Explained](https://claude.com/blog/skills-explained)
- [Cursor Rules Documentation](https://docs.cursor.com/context/rules)
