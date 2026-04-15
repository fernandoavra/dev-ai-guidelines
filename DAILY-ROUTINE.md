# Rotina Diária de Desenvolvimento com Agentes de IA

Checklist para estruturar cada sessão de trabalho com **Claude Code** ou **Cursor**.
Adapte conforme o tipo de tarefa do dia e a ferramenta utilizada.

---

## ☀️ Início da sessão

### 1. Orientação de contexto (sempre)
- [ ] Abra a ferramenta na raiz do projeto (Claude Code no terminal ou Cursor na IDE)
- [ ] Verifique se existe `active-plan.md` (em `.claude/plans/` ou `.cursor/plans/`)
  - Se sim: leia o "Next session start" antes de qualquer prompt
  - Se não: consulte o último commit do git para se orientar
- [ ] Defina mentalmente: *qual é o resultado concreto desta sessão?*

### 2. Escolha o modo de trabalho

| Situação | Claude Code | Cursor |
|---|---|---|
| Nova tarefa clara e isolada | Prompt `04-task-start.md` | Regra `task-start` carrega automaticamente |
| Feature que toca múltiplos apps | Prompt `06-cross-component-feature.md` | Regra `cross-component-feature` |
| Bug ou incidente | Prompt `09-bug-diagnosis.md` | Regra `bug-diagnosis` |
| Continuação da sessão anterior | Leia `active-plan.md` | Leia `active-plan.md` |
| Revisão de PR | Prompt `07-code-review.md` | Regra `code-review` |

---

## 🔄 Durante a sessão

### A cada tarefa concluída

| Ação | Claude Code | Cursor |
|---|---|---|
| Limpar contexto entre tarefas | `/clear` | Novo Chat (Ctrl+L) |
| Contexto pesado no meio de tarefa | `/compact` | Contexto gerenciado automaticamente |
| IA errando repetidamente | `/clear` + prompt específico | Novo Chat + prompt específico |

### Sinais de que algo está errado
- IA pediu informação que já foi fornecida → contexto saturado → limpar e recomeçar
- IA gerou código inconsistente com a arquitetura → verifique se leu PROJECT.md
- IA tomou uma decisão sem perguntar → volte à aprovação explícita do plano
- Sessão está longa e as respostas piorando → faça handoff e comece nova

### Boas práticas no meio do fluxo

**Claude Code:**
- [ ] Delegue investigações para subagentes: `"use subagents to investigate X"`
- [ ] Para explorar o codebase: `"use the Explore agent to map files related to X"`
- [ ] Para tarefas em paralelo: `"run agents in parallel for A, B and C"`

**Cursor:**
- [ ] Use `@codebase` para buscas amplas no projeto
- [ ] Use `@arquivo` para referenciar arquivos específicos
- [ ] Use **Composer** para mudanças multi-arquivo
- [ ] Use **Ctrl+K** para edições inline localizadas

**Ambos:**
- [ ] Confirme aprovação antes de cada implementação significativa

---

## 🌙 Encerramento da sessão

### Sempre antes de encerrar (ambas as ferramentas)
- [ ] Rode o handoff (Claude Code: prompt `05-session-handoff.md` | Cursor: peça para aplicar regra `session-handoff`)
- [ ] Confirme que `active-plan.md` foi atualizado
- [ ] Faça commit do trabalho concluído com mensagem descritiva
- [ ] Se algo ficou pela metade: documente o estado exato no active-plan.md

### Checklist de saída
- [ ] O que foi feito está commitado?
- [ ] O active-plan.md reflete o estado real?
- [ ] Há alguma decisão tomada que deveria ir para o Decision Log do PROJECT.md?
- [ ] Algum padrão novo foi descoberto que deveria ir para `.cursorrules` ou `CLAUDE.md`?

---

## 📅 Cadência semanal

### Segunda-feira (orientação)
- [ ] Revise o `active-plan.md` da semana anterior
- [ ] Defina a tarefa principal da semana
- [ ] Verifique se CLAUDE.md e PROJECT.md ainda refletem o estado real do projeto

### Sexta-feira (consolidação)
- [ ] Rode `08-tech-debt-audit.md` se faz mais de 2 semanas sem rodar
- [ ] Atualize o Decision Log do PROJECT.md com decisões da semana
- [ ] Arquive planos concluídos de `.claude/plans/`

---

## 📊 Cadência mensal

- [ ] Revise todos os agentes em `.claude/agents/` — ainda refletem o projeto?
- [ ] Revise skills em `.claude/skills/` — há novos padrões a documentar?
- [ ] Releia PROJECT.md como se fosse um dev novo — está desatualizado?
- [ ] Verifique dependências com vulnerabilidades conhecidas

---

## 🚨 Situações especiais

### Onboarding de novo desenvolvedor (humano)
1. Compartilhe acesso ao repositório
2. Peça que leia `PROJECT.md` antes de qualquer outra coisa
3. Primeira tarefa: rodar o setup local seguindo o PROJECT.md e reportar gaps
4. Primeira PR: pequena, não crítica, para validar o fluxo

### Onboarding de novo agente de IA no projeto
1. Copie o agente relevante de `agents/` para `.claude/agents/`
2. Rode `02-gap-analysis.md` para verificar consistência com o estado atual
3. Teste o agente com uma tarefa pequena antes de delegar trabalho real

### Incidente em produção
1. Não peça fix imediato — use `09-bug-diagnosis.md` primeiro
2. Root cause antes de qualquer código
3. Documente a causa e a correção no Decision Log após resolver

---

## Referência rápida de comandos

### Claude Code

| Comando | Quando usar |
|---|---|
| `/clear` | Entre tarefas não relacionadas, sempre |
| `/compact` | No meio de uma tarefa longa com contexto pesado |
| `/init` | Ao criar CLAUDE.md pela primeira vez num projeto |
| `/agents` | Para ver todos os agentes disponíveis na sessão |
| `@agent-name` | Para invocar um agente específico explicitamente |
| `Ctrl+B` | Para enviar um agente para background e continuar trabalhando |

### Cursor

| Comando / Ação | Quando usar |
|---|---|
| `Ctrl+L` (Novo Chat) | Entre tarefas não relacionadas |
| `@codebase` | Para buscas amplas no projeto |
| `@arquivo` | Para referenciar arquivo específico no prompt |
| `Ctrl+K` | Para edição inline localizada em um arquivo |
| `Ctrl+I` (Composer) | Para mudanças que tocam múltiplos arquivos |
| `Ctrl+Shift+I` | Para abrir Composer em tela cheia |
