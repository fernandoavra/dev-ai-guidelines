# dev-ai-guidelines

Playbook de desenvolvimento apoiado por agentes de IA — focado em Claude Code.

Contém prompts, templates e rotinas testadas para estruturar projetos,
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
│   ├── CLAUDE.md               # Template do arquivo de contexto principal
│   ├── PROJECT.md              # Template da documentação do projeto
│   └── active-plan.md          # Template de handoff de sessão
│
├── agents/                     # Definições de subagentes prontos para uso
│   ├── code-reviewer.md        # Revisor de qualidade de código
│   ├── architect.md            # Decisões de arquitetura e contratos
│   ├── qa-engineer.md          # Estratégia e escrita de testes
│   ├── security-reviewer.md    # Auditoria de segurança
│   └── tech-debt-auditor.md    # Mapeamento de dívida técnica
│
├── DAILY-ROUTINE.md            # Rotina diária de desenvolvimento com agentes
└── README.md                   # Este arquivo
```

---

## Como usar

### Novo projeto

1. Copie `templates/CLAUDE.md` para a raiz do projeto
2. Copie os agentes relevantes de `agents/` para `.claude/agents/` do projeto
3. Rode o prompt `prompts/01-setup-hybrid-structure.md` no Claude Code
4. Rode o prompt `prompts/03-project-documentation.md` para gerar o PROJECT.md

### Projeto existente

1. Rode o prompt `prompts/02-gap-analysis.md` — ele lê o que já existe antes de mudar qualquer coisa

### Ciclo diário

Consulte `DAILY-ROUTINE.md` para a sequência recomendada de cada tipo de sessão.

---

## Princípios que guiam este playbook

- **Explorar antes de agir** — nenhum agente escreve código sem antes mapear o contexto
- **Planejar antes de implementar** — aprovação explícita do plano antes de qualquer mudança
- **Documentar antes de fechar** — sessão não encerra sem handoff registrado
- **Contexto enxuto** — `/clear` entre tarefas, `/compact` apenas no meio de uma tarefa longa
- **Agentes especializados** — haiku para tarefas leves, sonnet para lógica e orquestração

---

## Referências

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)
- [Skills Explained](https://claude.com/blog/skills-explained)
