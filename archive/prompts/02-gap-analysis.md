# Prompt 02 — Gap Analysis: Atualização Incremental

**Quando usar:** Projeto já tem CLAUDE.md e/ou agentes. Atualizar sem sobrescrever.  
**Pré-requisito:** Abrir o Claude Code na raiz do projeto.  
**Resultado:** Estrutura existente preservada e complementada apenas onde necessário.

---

## Prompt

```
Use subagents to explore this project before doing anything else.

FIRST, read and internalize all existing configuration:
- CLAUDE.md at project root (if exists)
- All files inside .claude/agents/ (if exists)
- All files inside .claude/skills/ (if exists)
- All files inside .claude/commands/ (if exists)
- All component directories (apps/ or equivalent)

After reading everything, produce a gap analysis before touching any file:
- What the existing CLAUDE.md covers well vs. what's missing or outdated
- Which agents exist, their scope, and what's not yet covered
- Which skills exist and which cross-cutting concerns still lack one
- Inconsistencies between existing agents/skills and the actual codebase

Wait for my approval of the gap analysis before proceeding.

---

After approval, apply only the necessary changes:

1. CLAUDE.md — update, don't rewrite
   - Preserve what's working
   - Add missing sections (commands cheatsheet, skills references,
     compaction instructions)
   - Remove or fix anything outdated
   - Keep under 150 lines

2. .claude/agents/ — extend, don't replace
   - Keep existing agents intact unless they conflict with findings
   - Create new agents only for components/roles not yet covered
   - Align tool restrictions and model selection across all agents
     (haiku for lightweight tasks, sonnet for logic and orchestration)

3. .claude/skills/ — fill the gaps
   - Create skills only for cross-cutting concerns not yet covered
   - Each skill as a folder with SKILL.md + Gotchas section
   - description written as a trigger ("Invoke when...")

4. AGENTS.md at project root (create or update)
   - Quick reference: which agent handles which task
   - Which skills each agent uses
   - When to /clear vs /compact for this project

Output a final summary of every file changed, created or left untouched, and why.
```

---

## Por que o gap analysis com aprovação é essencial

Evita que o Claude sobrescreva decisões tomadas intencionalmente nos agentes
existentes. Você vê o que ele encontrou antes de qualquer mudança ser feita.

## Notas de uso

- Se a exploração revelar que o CLAUDE.md está muito desatualizado, pode
  valer mais rodar o **Prompt 01** do zero
- Rode este prompt sempre que: novo componente for adicionado ao projeto,
  stack mudar significativamente, ou após um grande refactor
