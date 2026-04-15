# [Project Name]

> Documentação viva do projeto. Serve para onboarding de desenvolvedores humanos
> e como contexto estruturado para agentes de IA.
> Atualizar quando: arquitetura mudar, onboarding revelar gaps, decisões forem tomadas.

---

## Purpose & Scope

[O que este sistema faz — 3 a 5 frases em linguagem de negócio, não técnica]

**O que este sistema NÃO faz:**
- [Limite 1]
- [Limite 2]

**Usuários finais:** [quem usa o sistema e como]

---

## Architecture Overview

```
[Diagrama ASCII ou Mermaid mostrando componentes e fluxo de dados]

Exemplo:
┌─────────────┐     REST      ┌─────────────┐
│     app     │ ────────────▶ │     api     │
│  (React)    │               │  (Node.js)  │
└─────────────┘               └──────┬──────┘
                                     │ SQL
┌─────────────┐     REST      ┌──────▼──────┐
│ backoffice  │ ────────────▶ │backoffice-  │
│  (React)    │               │    api      │
└─────────────┘               └─────────────┘
```

### Componentes

| Componente | Papel | Stack | Porta local | Entry point |
|---|---|---|---|---|
| app | [papel] | [stack] | [porta] | [arquivo] |
| api | [papel] | [stack] | [porta] | [arquivo] |
| backoffice | [papel] | [stack] | [porta] | [arquivo] |
| backoffice-api | [papel] | [stack] | [porta] | [arquivo] |

### Comunicação entre componentes

- **app → api:** [protocolo, formato, autenticação]
- **backoffice → backoffice-api:** [protocolo, formato, autenticação]
- **api ↔ backoffice-api:** [se há comunicação direta, como]

### Serviços externos

| Serviço | Propósito | Componente(s) que usa | Crítico? |
|---|---|---|---|
| [Nome] | [por que existe] | [quais apps] | [sim/não] |

### Jornadas críticas do sistema

**[Jornada 1 — ex: Login de usuário]**
1. [Passo 1]
2. [Passo 2]
3. [Passo 3]

**[Jornada 2 — ex: Processamento de pedido]**
1. [Passo 1]
2. [Passo 2]

---

## Repository Structure

```
[raiz do projeto]/
├── apps/
│   ├── app/                  # [descrição]
│   │   ├── src/              # [descrição]
│   │   └── [outros]
│   ├── api/                  # [descrição]
│   │   ├── src/              # [descrição]
│   │   └── [outros]
│   ├── backoffice/           # [descrição]
│   └── backoffice-api/       # [descrição]
├── .claude/
│   ├── agents/               # Subagentes de IA por componente
│   ├── skills/               # Skills transversais
│   └── plans/                # Planos de sessão e contratos de feature
├── CLAUDE.md                 # Contexto principal para agentes de IA
├── PROJECT.md                # Este arquivo
└── AGENTS.md                 # Índice de agentes e skills
```

**Convenções de nomenclatura:**
- Arquivos: `kebab-case`
- [Outras convenções específicas do projeto]

**Anti-padrões — o que nunca fazer:**
- [Anti-padrão 1 — com explicação]
- [Anti-padrão 2 — com explicação]

---

## Development Setup

### Pré-requisitos

| Ferramenta | Versão mínima | Como instalar |
|---|---|---|
| Node.js | [versão] | [link ou comando] |
| [Outra] | [versão] | [como] |

### Setup do zero

```bash
# 1. Clone o repositório
git clone [url]
cd [projeto]

# 2. Copie e configure variáveis de ambiente
cp .env.example .env.local
# Edite .env.local com seus valores (ver seção de variáveis abaixo)

# 3. Instale dependências
[comando]

# 4. Rode as migrações (se aplicável)
[comando]

# 5. Suba todos os serviços
[comando]
```

### Variáveis de ambiente

| Variável | Propósito | Onde obter |
|---|---|---|
| `[VAR_NAME]` | [o que faz] | [como conseguir] |

### Falhas comuns no setup

**Erro: [mensagem de erro comum]**  
Causa: [por que acontece]  
Fix: [como resolver]

---

## Coding Standards

### Padrões a seguir

[Padrão 1 — com exemplo de código do projeto real]

```[linguagem]
// Bom
[exemplo]

// Ruim
[contra-exemplo]
```

### Tratamento de erros

[Como erros são tratados neste projeto — com exemplo]

### Logging

[Convenção de logs — níveis, formato, o que logar e o que não logar]

### Segurança — regras absolutas

- Nunca commitar secrets, tokens ou credenciais
- [Regra específica 1]
- [Regra específica 2]

---

## Testing Strategy

| Tipo | Propósito | Localização | Comando |
|---|---|---|---|
| Unit | [propósito] | `[path]` | `[comando]` |
| Integration | [propósito] | `[path]` | `[comando]` |
| E2E | [propósito] | `[path]` | `[comando]` |

**O que deve sempre ter teste:**
- [Caso 1]
- [Caso 2]

**Exemplo de um teste seguindo os padrões do projeto:**

```[linguagem]
[exemplo real ou representativo]
```

**CI bloqueia merge quando:** [condições]

---

## Git Workflow

**Branches:** `[tipo]/[ticket]-[descricao]`  
Exemplos: `feat/ABC-123-user-login`, `fix/ABC-456-null-pointer-on-checkout`

**Commits:** `[type](scope): description`  
Exemplos: `feat(api): add JWT refresh endpoint`, `fix(app): correct cart total calculation`

**PR:** [tamanho esperado, processo de review, quantos aprovadores]

**Deploy:**
- `main` → [ambiente]
- `staging` → [ambiente]

**Hotfix:** [procedimento]

---

## Cross-Cutting Concerns

### Autenticação e Autorização

[Como funciona — fluxo, tokens, papéis, onde está implementado]

### Configuração e Secrets

[Estratégia — .env, vault, variáveis de CI, o que vai onde]

### Utilitários Compartilhados

[O que existe de shared, onde mora, como usar]

### Observabilidade

[Logging, tracing, métricas — ferramentas e padrões usados]

---

## Decision Log

> Esta seção é a mais valiosa para agentes de IA. Seja específico — o "por quê"
> importa mais que o "o quê".

| # | Decisão | Por quê | Trade-offs | Data |
|---|---|---|---|---|
| 1 | [decisão] | [motivação] | [o que foi sacrificado] | [data] |
| 2 | [decisão] | [motivação] | [o que foi sacrificado] | [data] |

---

## Onboarding Checklist

### Dia 1
- [ ] Leu este arquivo (PROJECT.md) por completo
- [ ] Ambiente rodando localmente seguindo o setup acima
- [ ] Primeiro teste passando
- [ ] Acesso a todos os ambientes e ferramentas necessárias

### Semana 1
- [ ] Primeiro PR aberto (tarefa pequena, não crítica)
- [ ] Feature tocada de ponta a ponta (frontend → backend → banco)
- [ ] Entendeu o fluxo das 2–3 jornadas críticas

### O que ler antes de tocar cada componente

- `app`: [o que ler]
- `api`: [o que ler]
- `backoffice`: [o que ler]
- `backoffice-api`: [o que ler]

### Definição de "done" neste projeto

- [ ] Código escrito e revisado
- [ ] Testes escritos e passando
- [ ] CI verde
- [ ] PR aprovado por [N] revisores
- [ ] Deploy em staging validado
- [ ] Documentação atualizada se necessário

---

## AI Agent Guidelines

> Como agentes de IA devem interpretar e usar este documento.

**Convenções estritas (sempre seguir):**
- [Convenção 1]
- [Convenção 2]

**Convenções preferidas (seguir a menos que haja motivo explícito):**
- [Convenção 1]
- [Convenção 2]

**Como lidar com ambiguidade:**
- Se a dúvida é sobre nomenclatura ou estrutura: seguir o padrão encontrado no código existente
- Se a dúvida é sobre comportamento de negócio: perguntar antes de assumir
- Se a dúvida é sobre arquitetura cross-componente: consultar o Decision Log primeiro

**Antes de modificar código cross-componente:**
1. Ler o contrato da feature em `.claude/plans/` se existir
2. Verificar o Decision Log para decisões relacionadas
3. Confirmar com o usuário se a mudança afeta mais de um componente

**Arquivos de referência:**
- Contexto de sessão: `CLAUDE.md`
- Agentes disponíveis: `AGENTS.md` e `.claude/agents/`
- Skills disponíveis: `.claude/skills/`
- Plano ativo: `.claude/plans/active-plan.md`

---

*generated: [YYYY-MM-DD]*  
*generated-by: Claude Code*  
*last-reviewed: [YYYY-MM-DD]*  
*review-cadence: atualizar quando arquitetura mudar ou onboarding revelar gaps*
