# Rotina Diária de Desenvolvimento com Agentes de IA

Checklist para estruturar cada sessão de trabalho com Claude Code.
Adapte conforme o tipo de tarefa do dia.

---

## ☀️ Início da sessão

### 1. Orientação de contexto (sempre)
- [ ] Abra o Claude Code na raiz do projeto
- [ ] Verifique se existe `.claude/plans/active-plan.md`
  - Se sim: leia o "Next session start" antes de qualquer prompt
  - Se não: consulte o último commit do git para se orientar
- [ ] Defina mentalmente: *qual é o resultado concreto desta sessão?*

### 2. Escolha o modo de trabalho

| Situação | Ação |
|---|---|
| Nova tarefa clara e isolada | Use o prompt `04-task-start.md` |
| Feature que toca múltiplos apps | Use o prompt `06-cross-component-feature.md` |
| Bug ou incidente | Use o prompt `09-bug-diagnosis.md` |
| Continuação da sessão anterior | Leia o `active-plan.md` e continue de onde parou |
| Revisão de PR | Use o prompt `07-code-review.md` |

---

## 🔄 Durante a sessão

### A cada tarefa concluída
- [ ] Rode `/clear` antes de iniciar a próxima tarefa não relacionada
- [ ] Se estiver no meio de uma tarefa longa e o contexto estiver pesado: `/compact`
- [ ] Se Claude errou duas vezes a mesma coisa: `/clear` + prompt mais específico

### Sinais de que algo está errado
- Claude pediu informação que já foi fornecida → contexto saturado → `/clear`
- Claude gerou código inconsistente com a arquitetura → verifique se leu PROJECT.md
- Claude tomou uma decisão sem perguntar → volte à aprovação explícita do plano
- Sessão está longa e as respostas piorando → use `05-session-handoff.md` e comece nova

### Boas práticas no meio do fluxo
- [ ] Delegue investigações para subagentes: `"use subagents to investigate X"`
- [ ] Para explorar o codebase: `"use the Explore agent to map files related to X"`
- [ ] Para tarefas em paralelo: `"run agents in parallel for A, B and C"`
- [ ] Confirme aprovação antes de cada implementação significativa

---

## 🌙 Encerramento da sessão

### Sempre antes de `/clear` ou fechar o terminal
- [ ] Rode o prompt `05-session-handoff.md`
- [ ] Confirme que `.claude/plans/active-plan.md` foi atualizado
- [ ] Faça commit do trabalho concluído com mensagem descritiva
- [ ] Se algo ficou pela metade: documente o estado exato no active-plan.md

### Checklist de saída
- [ ] O que foi feito está commitado?
- [ ] O active-plan.md reflete o estado real?
- [ ] Há alguma decisão tomada que deveria ir para o Decision Log do PROJECT.md?
- [ ] Algum padrão novo foi descoberto que deveria ir para o CLAUDE.md?

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
3. Configure as variáveis de modelo no ambiente local (ver seção abaixo)
4. Primeira tarefa: rodar o setup local seguindo o PROJECT.md e reportar gaps
5. Primeira PR: pequena, não crítica, para validar o fluxo

**Configuração de modelo para novos devs** — adicionar ao `~/.zshrc` ou `~/.bashrc`:
```bash
# Escolha o modelo da sessão principal conforme sua preferência e plano
export ANTHROPIC_MODEL="claude-sonnet-4-6"        # padrão seguro para qualquer plano
# export ANTHROPIC_MODEL="claude-opus-4-6"        # se tiver plano Max/Team Premium

# Subagentes rodam Sonnet independente do modelo principal (recomendado)
export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-6"
```
> Se não configurar nada, o Claude Code usa automaticamente o padrão do seu plano.

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

| Comando | Quando usar |
|---|---|
| `/clear` | Entre tarefas não relacionadas, sempre |
| `/compact` | No meio de uma tarefa longa com contexto pesado |
| `/init` | Ao criar CLAUDE.md pela primeira vez num projeto |
| `/agents` | Para ver todos os agentes disponíveis na sessão |
| `@agent-name` | Para invocar um agente específico explicitamente |
| `Ctrl+B` | Para enviar um agente para background e continuar trabalhando |
