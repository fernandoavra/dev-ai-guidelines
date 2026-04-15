# Template: .cursorrules

> Equivalente ao `CLAUDE.md` para projetos que usam Cursor.
> Copie o conteúdo abaixo para `.cursorrules` na raiz do projeto e adapte.
> Mantenha abaixo de 150 linhas — referencie, não emita conteúdo completo.

---

```
# [Nome do Projeto]

## Visão Geral

[3 linhas máximo: o que o sistema faz, para quem, em que contexto de negócio]

## Estrutura de Componentes

apps/
├── app/              # [papel em uma linha]
├── api/              # [papel em uma linha]
├── backoffice/       # [papel em uma linha]
└── backoffice-api/   # [papel em uma linha]

Documentação detalhada: ver `PROJECT.md`

## Idioma e Comunicação

- Respostas sempre em **português (PT-BR)**
- Nomes de variáveis, funções e classes em **inglês**
- Comentários no código em **português**
- Mensagens de validação e erros ao usuário em **português**

## Convenções Transversais

**Commits:** `tipo: descrição imperativa em português`
Tipos: `feat | fix | chore | docs | refactor | test`
Máximo 72 caracteres. Sem ponto final. Modo imperativo.
NUNCA incluir Co-Authored-By referenciando IA.

**Branches:** `tipo/descricao-em-kebab-case`
Exemplos: `feat/integracao-whatsapp`, `fix/timeout-conexao-banco`
Sempre a partir de `main` atualizada. Sem acentos.

**Variáveis de ambiente:** sempre em `.env.local`, nunca commitadas. Ver `.env.example`.

**Nomenclatura:**
- Arquivos: `kebab-case`
- Componentes React: `PascalCase`
- Funções/variáveis: `camelCase`
- Constantes: `UPPER_SNAKE_CASE`

**Locale:** pt-BR | Timezone: America/Sao_Paulo | Moeda: BRL (R$) | Data: DD/MM/YYYY

## Comandos Essenciais

# Rodar todos os componentes
[comando]

# Rodar componente individual
cd apps/[nome] && [comando]

# Testes
[comando de teste global]

# Build
[comando de build]

## Regras Críticas

- Nunca commitar secrets, tokens ou credenciais — sem exceção
- Ler código existente antes de modificar — entender o contexto
- Seguir padrões e convenções já existentes no projeto
- Não adicionar abstrações, utilitários ou helpers desnecessários
- Não adicionar funcionalidades além do solicitado
- Não supor regras de negócio — perguntar quando em dúvida
- Confirmar antes de ações destrutivas ou irreversíveis
- [Regra específica do projeto 1]
- [Regra específica do projeto 2]

## Regras em .cursor/rules/

Regras especializadas carregadas automaticamente quando relevantes:
- `code-reviewer.mdc` — revisão de qualidade de código
- `architect.mdc` — decisões cross-componente e contratos
- `qa-engineer.mdc` — estratégia e escrita de testes
- `security-reviewer.mdc` — auditoria de segurança
- `tech-debt-auditor.mdc` — mapeamento de dívida técnica
- `task-start.mdc` — início de qualquer tarefa
- `code-review.mdc` — revisão completa de PR
- `bug-diagnosis.mdc` — diagnóstico de bugs e incidentes

## Gerenciamento de Contexto

- Inicie um novo chat entre tarefas não relacionadas
- Referencie @PROJECT.md ao precisar de contexto completo
- Referencie @arquivo específico ao trabalhar em código localizado
- Consulte `.cursor/plans/active-plan.md` ao retomar trabalho

## Referências

- Documentação completa: `PROJECT.md`
- Plano de sessão ativo: `.cursor/plans/active-plan.md`

---
last-updated: [YYYY-MM-DD]
updated-by: [quem atualizou]
```
