---
description: Discovery estruturado de PRD/specs — entrevista o usuario antes de /ai-task ou /ai-feature
agent: build
---

If $ARGUMENTS is empty, ask the user to describe the spec topic.
Do NOT proceed without a topic.

Spec topic: $ARGUMENTS

Your job is to run a structured discovery interview that produces a
written spec (PRD) — NOT to write code or design implementation. The
spec captures WHY and WHAT, not HOW. The HOW belongs to `/ai-feature`
or `/ai-task` and is filled out later, after this spec is approved.

User-facing language is Portuguese (Brazil). Question texts and option
labels you pass to the question tool MUST be in PT-BR. Internal reasoning
stays in English.

## Step 1 — Triage (one question decides the path)

Use the question tool with question:
**"Qual o tamanho deste trabalho?"**

Options:
1. **Ajuste pequeno** — escopo claro, 1 componente, poucos arquivos.
   - Action: recommend `/ai-task <descricao>` directly and STOP. Do
     not create a spec — the task plan is enough.
2. **Feature media** — afeta 1-2 componentes, varios arquivos,
   detalhes nao totalmente claros.
   - Action: proceed to Step 2 (medium interview, ~6 questions).
3. **Iniciativa grande** — varios componentes, multiplas pessoas
   afetadas, metricas de sucesso importam.
   - Action: proceed to Step 3 (deep interview, ~10 questions).

## Step 2 — Medium interview

Run questions ONE AT A TIME via the question tool. Wait for each answer
before moving on. Adapt later questions to context from earlier
answers — if something is already clear, skip the question and tell
the user explicitly ("ja temos isso, pulando para a proxima").

Question 1 — Problema:
**"Que dor especifica este trabalho resolve? Quem hoje sente essa dor?"**
Free-form via custom input. Try to extract 1 paragraph.

Question 2 — Usuario-alvo:
**"Quem usa o resultado deste trabalho?"**
Options (multi-select):
- Usuario final externo
- Time interno (qual?)
- Operacao / suporte
- Sistema integrante (qual?)
- Outro

Question 3 — Criterios de aceitacao:
**"Como vamos saber que foi entregue? Liste 2-5 itens verificaveis
em linguagem natural."** Free-form. Examples to guide the user:
"usuario consegue exportar relatorio em PDF", "sistema rejeita CPF
invalido com erro 400".

Question 4 — Out-of-scope:
**"O que esta explicitamente FORA do escopo desta entrega?"**
Free-form. Capturing this prevents scope creep. If the user struggles,
prompt with concrete examples drawn from their problem domain.

Question 5 — Constraints:
**"Que limitacoes importam neste trabalho?"**
Options (multi-select):
- Deadline rigido
- Stack especifica imposta
- Integracao com sistema legado
- Compliance / LGPD / regulatorio
- Performance critica
- Multi-tenant / multi-empresa
- Sem breaking changes em API publica
- Orcamento limitado de infraestrutura
- Outro

Question 6 — Riscos:
**"Qual e o maior risco se isso der errado? Inclua uma ideia de
mitigacao se voce ja tem uma."** Free-form.

## Step 3 — Large interview

Run Step 2 first, then add four extra questions:

Question 7 — Personas afetadas alem do usuario primario:
**"Quem mais e afetado por essa mudanca alem do usuario-alvo principal?"**
Options (multi-select):
- Outro time interno
- Parceiro / cliente externo
- Compliance / legal
- Suporte / sucesso do cliente
- Infraestrutura / SRE
- Nenhum

Question 8 — Metricas de sucesso:
**"Como vamos medir sucesso em numeros? Ex: 'reducao de 30% no tempo
de checkout', '95% de uptime em 30 dias'."** Free-form. Push for at
least one quantitative metric. Qualitative-only ("clientes felizes")
should be flagged: ask "qual sinal mostra que ficaram felizes?".

Question 9 — Milestones:
**"Da para entregar incrementalmente? Se sim, quais marcos?"**
Free-form. If the user wants single-shot delivery, capture that
explicitly and note the risk.

Question 10 — Stakeholders:
**"Quem precisa aprovar antes do shipping? (nomes ou papeis)"**
Free-form.

## Step 4 — Synthesize and present

Sanitize the topic into a slug: lowercase, replace spaces with hyphens,
strip special chars, max 50 chars. Target file (do NOT write yet):
`.claude/plans/specs/<slug>.md`.

Build the spec document following this schema. Use only sections
relevant to the chosen granularity (medium = first 6 sections only;
large = add success-metrics, milestones, stakeholders).

```markdown
# Spec: <topic verbatim>

**Created:** YYYY-MM-DD
**Granularidade:** medium | large
**Status:** draft

## Problema
<one paragraph derived from Q1>

## Usuarios
<primary from Q2; if large, append "## Outros afetados" from Q7>

## Goals — criterios de aceitacao
- <verifiable bullet from Q3>
- <verifiable bullet>
- ...

## Non-goals
- <explicit out-of-scope from Q4>
- ...

## Constraints
- <from Q5, grouped if useful>
- ...

## Riscos
- <from Q6, with mitigation if provided>
- ...

<!-- large variant only -->
## Metricas de sucesso
- <from Q8, quantitative if possible>

## Milestones
- <from Q9, with rough sequencing>

## Stakeholders de aprovacao
- <from Q10>
<!-- end large -->

## Proximo passo
Converter este spec em plano executavel:
- Feature multi-componente: `/ai-feature <slug>`
- Tarefa focada: `/ai-task <slug>`

O plano gerado deve incluir `**Source spec:** .claude/plans/specs/<slug>.md`
no cabecalho para preservar rastreabilidade do PORQUE.

---
*last-updated: YYYY-MM-DD HH:MM*
```

Present the full draft to the user and **wait for approval**. If the
user requests edits, apply them and re-present. Iterate until approved.

## Step 5 — Save

After explicit approval:

1. Ensure the specs directory exists:
   ```bash
   mkdir -p .claude/plans/specs
   ```

2. Write the spec to `.claude/plans/specs/<slug>.md`.

3. Confirm the file path to the user.

4. Suggest the natural next step based on granularity:
   - Medium → `/ai-feature <slug>` if cross-component, else `/ai-task <slug>`
   - Large → `/ai-feature <slug>` (almost always cross-component)

5. Do NOT auto-invoke `/ai-feature` or `/ai-task`. The user decides
   when to move from spec to plan — there may be a gap (review by
   stakeholders, prioritization, etc.).

## Rules

- This command captures WHY and WHAT only. If the user starts
  describing implementation details (frameworks, libraries, function
  names), gently redirect: "Vamos guardar isso para o plano do
  /ai-feature — agora preciso fechar o problema e os criterios."
- Do not proceed past Step 1 if the triage answer was "Ajuste pequeno".
- One question per tool call. Do NOT batch all 6-10
  questions at once — each answer should inform the next.
- Skip irrelevant or already-answered questions explicitly. Ask less
  when the user has already given strong signal.
- If an answer is vague, follow up once with a clarifying question
  before moving on. Do not loop more than once per question.
- The spec is the source-of-truth for WHY. The plan (created later
  by `/ai-feature` or `/ai-task`) is the source-of-truth for HOW.
  Do not duplicate scope between them — the plan references the spec.
