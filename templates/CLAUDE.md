# [Project Name]

<!-- 
  INSTRUÇÕES PARA PREENCHIMENTO:
  - Mantenha este arquivo abaixo de 150 linhas
  - Não emita conteúdo aqui — referencie skills e documentos
  - Documente o que Claude erra sem orientação, não o óbvio
  - Atualize quando: novo componente, mudança de stack, padrão descoberto
-->

## Visão Geral

[3 linhas máximo: o que o sistema faz, para quem, em que contexto de negócio]

## Estrutura de Componentes

```
apps/
├── app/              # [papel em uma linha — ex: frontend React para usuários finais]
├── api/              # [papel em uma linha — ex: API REST Node.js, autenticação e dados]
├── backoffice/       # [papel em uma linha — ex: painel administrativo interno]
└── backoffice-api/   # [papel em uma linha — ex: API exclusiva do backoffice]
```

Documentação detalhada: ver `PROJECT.md`

## Convenções Transversais

**Commits:** `[type](scope): description` — ex: `feat(api): add user authentication endpoint`  
Types: `feat | fix | chore | docs | refactor | test`

**Branches:** `[type]/[ticket-id]-short-description` — ex: `feat/ABC-123-user-login`

**Variáveis de ambiente:** sempre em `.env.local`, nunca commitadas. Ver `.env.example`.

**Nomenclatura:**
- Arquivos: `kebab-case`
- Componentes React: `PascalCase`
- Funções/variáveis: `camelCase`
- Constantes: `UPPER_SNAKE_CASE`

## Comandos Essenciais

```bash
# Rodar todos os componentes
[comando]

# Rodar componente individual
cd apps/[nome] && [comando]

# Testes
[comando de teste global]

# Build
[comando de build]
```

## Regras Críticas

<!-- Liste apenas o que Claude ignora sem instrução explícita -->

- Nunca commitar secrets, tokens ou credenciais — sem exceção
- [Regra específica do projeto 1]
- [Regra específica do projeto 2]
- [Regra específica do projeto 3]

## Agentes Disponíveis

Ver `AGENTS.md` para referência completa. Agentes em `.claude/agents/`:

- `@[component]-agent` — [quando invocar]
- `@code-reviewer` — após qualquer implementação antes de PR
- `@architect-agent` — para decisões cross-componente
- `@qa-engineer` — para estratégia e escrita de testes

## Skills Disponíveis

Skills em `.claude/skills/` (carregadas automaticamente quando relevantes):

- `[skill-name]` — [trigger: quando é invocada]
- `[skill-name]` — [trigger: quando é invocada]

## Configuração de Modelos

O projeto não impõe um modelo fixo — cada desenvolvedor configura o seu
ambiente local conforme sua preferência e plano de assinatura.

**Padrão do projeto** (fallback para quem não configurar nada):
- Usa o modelo padrão do plano de cada desenvolvedor automaticamente
- Opus 4.6 → planos Max e Team Premium
- Sonnet 4.6 → planos Pro e Team Standard

**Configuração pessoal recomendada** — adicione ao seu `~/.zshrc` ou `~/.bashrc`:

```bash
# Modelo da sessão principal (orquestração e tarefas complexas)
# Opções: claude-opus-4-6 | claude-sonnet-4-6 | claude-haiku-4-5 | opusplan
export ANTHROPIC_MODEL="claude-opus-4-6"

# Modelo dos subagentes (tarefas focadas e execução)
# Recomendado: sonnet — mais rápido e eficiente para trabalho delegado
export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-6"
```

> Se nenhuma variável for definida, o Claude Code usa automaticamente o modelo
> padrão do seu plano. Nenhuma configuração é obrigatória.

**Alias `opusplan`** — alternativa ao Opus puro:
usa Opus em plan mode e muda automaticamente para Sonnet em execution mode.
```bash
claude --model opusplan
```

**Regras do projeto para modelos:**
- Variáveis de ambiente são **pessoais** — nunca commitar no repositório
- Cada dev é responsável pela sua própria configuração
- Subagentes definidos em `.claude/agents/` têm `model:` no frontmatter
  como documentação de intenção — a variável `CLAUDE_CODE_SUBAGENT_MODEL`
  tem precedência em tempo de execução

## Gerenciamento de Contexto

**Ao compactar (`/compact`), sempre preserve:**
- Lista de arquivos modificados na sessão
- Plano ativo e próximos passos
- Decisões arquiteturais tomadas
- Dependências cross-componente identificadas

**Use `/clear` entre tarefas não relacionadas.**  
**Use `/compact` apenas no meio de uma tarefa longa.**

## Referências

- Documentação completa do projeto: `PROJECT.md`
- Plano de sessão ativo: `.claude/plans/active-plan.md`
- Índice de agentes e skills: `AGENTS.md`

---
<!-- Não remover este bloco -->
last-updated: [YYYY-MM-DD]
updated-by: [quem atualizou]
