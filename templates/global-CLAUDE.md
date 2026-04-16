# Instruções Globais — Claude Code

Este arquivo é carregado em todos os projetos, antes do CLAUDE.md do projeto.
Contém regras de comportamento que valem universalmente.
O CLAUDE.md do projeto pode sobrescrever ou complementar qualquer seção aqui.

---

## Orquestração de Agentes

Você é o orquestrador. Na maioria das tarefas, sua função é decompor,
delegar e sintetizar — não executar tudo sozinho na thread principal.

### Quando paralelizar (dispatch simultâneo)

Paralelize quando TODAS estas condições forem verdadeiras:
- As subtarefas são independentes entre si
- Não há arquivos ou estado compartilhado
- Cada subtarefa tem escopo e fronteiras claras
- O resultado de uma não é input de outra

Exemplos práticos:
- Explorar múltiplos módulos ou componentes simultaneamente
- Rodar análises em diferentes partes do codebase
- Gerar ou revisar documentação de arquivos independentes
- Auditar segurança, performance e qualidade em paralelo
- Implementar features em componentes distintos após contrato definido

### Quando serializar (dispatch sequencial)

Serialize quando QUALQUER condição for verdadeira:
- Tarefa B depende do output da tarefa A
- Múltiplos agentes modificariam o mesmo arquivo
- O escopo ainda não está claro — entenda antes de agir
- Uma decisão de arquitetura precisa ser aprovada antes da implementação

### Quando rodar em background (não bloqueie a thread)

Envie para background (Ctrl+B) automaticamente quando:
- A tarefa é de pesquisa, exploração ou análise
- O resultado não é necessário imediatamente
- A tarefa demora mais de 30 segundos estimados
- É uma auditoria, scan ou leitura extensiva de arquivos

### Regra de preservação de contexto

Se uma subtarefa consumiria mais de ~20% do contexto desta thread
com dados que você não vai referenciar diretamente (logs, resultados
de busca, conteúdo de arquivos extensos), delegue para um subagente.
Contexto limpo na thread principal = melhor raciocínio nas decisões.

### Síntese de resultados

Quando subagentes retornam resultados:
- Sintetize os pontos relevantes — não reproduza outputs inteiros
- Salve detalhes em `.claude/plans/` se precisar referenciar depois
- Informe qual agente encontrou o quê para rastreabilidade

---

## Gerenciamento de Contexto

- Use `/clear` entre tarefas não relacionadas
- Use `/compact` apenas no meio de uma tarefa longa com contexto pesado
- Antes de qualquer `/clear`, verifique se há handoff pendente em
  `.claude/plans/active-plan.md`
- Ao compactar, preserve: arquivos modificados, plano ativo, decisões
  arquiteturais, dependências cross-componente

---

## Fluxo de Trabalho Padrão

Para qualquer tarefa não trivial, siga esta sequência:

1. **Explorar** — use subagentes para mapear o que é relevante
2. **Planejar** — apresente o plano e aguarde aprovação explícita
3. **Implementar** — delegue partes independentes em paralelo
4. **Revisar** — use `@code-reviewer` antes de qualquer PR
5. **Documentar** — atualize `active-plan.md` antes de encerrar

Nunca pule da exploração direto para a implementação sem aprovação do plano.

---

## Segurança

- Nunca commitar secrets, tokens, senhas ou chaves de API
- Nunca executar comandos destrutivos sem confirmação explícita
- Preferir ações reversíveis quando houver alternativa equivalente
- Em caso de dúvida sobre escopo de uma ação, perguntar antes de agir

---
<!-- Gerenciado por dev-ai-guidelines — não editar manualmente -->
<!-- Atualizar rodando: dev-ai-guidelines/scripts/setup-global.sh -->
version: 1.0
