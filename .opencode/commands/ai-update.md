---
description: Atualiza a estrutura de IA de um projeto existente — gap analysis antes de qualquer mudanca
agent: build
subtask: true
---

Use subagents to explore this project before doing anything else.

FIRST, read and internalize all existing configuration:
- CLAUDE.md at project root (if exists)
- All files inside .claude/agents/ (if exists)
- All files inside .claude/skills/ (if exists)
- All files inside .claude/commands/ (if exists)
- All files inside .opencode/agents/ (if exists)
- All files inside .opencode/commands/ (if exists)
- All component directories (apps/ or equivalent)

After reading everything, produce a gap analysis before touching any file:
- What the existing CLAUDE.md covers well vs. what's missing or outdated
- Which agents exist, their scope, and what's not yet covered
- Which skills exist and which cross-cutting concerns still lack one
- Inconsistencies between existing agents/skills and the actual codebase

Wait for my approval of the gap analysis before proceeding.

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

3. .claude/skills/ — fill the gaps
   - Create skills only for cross-cutting concerns not yet covered
   - Each skill as a folder with SKILL.md + Gotchas section
   - description written as a trigger ("Invoke when...")

4. .opencode/agents/ — extend, don't replace
   - Keep existing agents intact unless they conflict with findings
   - Create new agents only for components/roles not yet covered

5. .opencode/commands/ — fill the gaps
   - Create commands only for workflows not yet covered

6. AGENTS.md at project root (create or update)
   - Quick reference: which agent handles which task
   - Which skills each agent uses
   - Coverage across both Claude Code and OpenCode environments

Output a final summary of every file changed, created or left untouched, and why.
