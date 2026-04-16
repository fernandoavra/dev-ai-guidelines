---
description: Integra um novo componente/repositório à estrutura de IA existente — atualização cirúrgica sem reescrever o que já funciona
argument-hint: <caminho ou nome do novo componente>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

A new component has been added to this project. Your job is to integrate it
into the existing AI structure with surgical precision — update only what needs
updating, preserve everything that already works.

New component: $ARGUMENTS

---

## Phase 1 — Read before touching anything

Use subagents in parallel to:

1. Read the existing structure completely:
   - CLAUDE.md (all sections)
   - AGENTS.md (if exists)
   - PROJECT.md (if exists)
   - All files in .claude/agents/
   - All files in .claude/skills/
   - .claude/plans/active-plan.md (if exists)

2. Explore the new component deeply:
   - Full directory tree
   - Tech stack, frameworks, language and version
   - Entry points, main scripts, package.json or equivalent
   - How it communicates with other components (REST, events, shared DB, imports)
   - Existing README or documentation
   - Test structure and commands
   - Environment variables it requires
   - Any scripts or Makefile targets

Do NOT write anything until both subagents have completed.

---

## Phase 2 — Impact analysis

Before making any change, present:

**What this component does:**
- Role in one sentence
- How it fits into the existing architecture
- Which existing components it interacts with and how

**What needs to change:**
- CLAUDE.md sections that need updating (list exactly which sections)
- Agents that need updating (list which ones and why)
- New agent needed? (yes/no — justify)
- Skills that need updating (list which ones)
- New skill needed? (yes/no — justify)
- PROJECT.md sections that need updating (list which ones)
- AGENTS.md changes (if exists)

**What must NOT change:**
- List existing agents and skills that are unaffected
- Confirm their scope is still accurate after this addition

Wait for my approval before making any changes.

---

## Phase 3 — Apply changes (after approval)

Apply only the changes identified above:

### CLAUDE.md
- Add the new component to the structure map with its one-line role
- Add its dev/build/test commands to the cheatsheet
- Add any new environment variables to the conventions section
- Add reference to its agent if a new one was created
- Do NOT rewrite existing sections — append or patch only

### .claude/agents/ (if new agent is needed)
Create `.claude/agents/[component-name]-agent.md` with:
- name matching the component directory name
- description written as an auto-delegation trigger
- tools restricted to what this component actually needs
- model: haiku for lightweight tasks, sonnet for logic
- References to relevant skills (existing and new)
- Deep knowledge of this component's stack and conventions

### .claude/agents/ (if existing agent needs updating)
Patch only the affected section — do not rewrite the entire file.

### .claude/skills/ (if new skill is needed)
Only create a new skill if this component introduces a cross-cutting concern
not already covered. Follow the existing skill structure exactly.

### PROJECT.md (if exists)
- Add the component to the Architecture Overview table
- Add it to the Repository Structure tree
- Add its setup steps to Development Setup
- Add any new cross-cutting concerns it introduces
- Update the Decision Log if an architectural decision was made

### AGENTS.md (if exists)
- Add the new agent entry
- Update the "which agent for which task" table

---

## Phase 4 — Verification

After all changes are applied:

1. Read CLAUDE.md back and confirm the structure map is accurate
2. Confirm the new agent (if created) has correct tool restrictions
3. Confirm no existing agent or skill was unintentionally modified
4. List every file that was changed and every file that was not

Output a final summary:
- Component integrated: [name and role]
- Files created: [list]
- Files modified: [list with what changed]
- Files left untouched: [count]
- Recommended next step: run `/ai:docs` if PROJECT.md needs significant expansion
