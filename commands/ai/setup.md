---
description: Setup inicial de IA para um projeto novo — cria CLAUDE.md, agents e skills
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Use subagents to thoroughly explore this project before doing anything else.

Map the full structure, paying special attention to:
- The root and each subdirectory inside apps/ (or equivalent component folders)
- Tech stack, frameworks, languages and versions used in each component
- Shared dependencies, environment files, scripts and config patterns
- Existing documentation, README files and inline comments
- Communication patterns between components (REST, events, shared DB, etc.)
- Testing strategy and CI/CD setup if present

After the exploration, create the following hybrid structure optimized for this
specific project. Do NOT proceed to create files before completing the full
exploration.

CREATE the following structure:

1. CLAUDE.md at project root
   - Project overview (max 3 lines)
   - Apps/ structure map with one-line role for each component
   - Cross-cutting conventions (commit format, env vars, naming)
   - Commands cheatsheet (dev, build, test for each app)
   - Reference links to skills (do NOT embed full content here)
   - Compaction instructions: "When compacting, preserve: modified files list,
     active plan, architectural decisions, cross-component dependencies"

2. .claude/skills/ — one skill per cross-cutting concern found in the codebase:
   - Each skill as a folder with SKILL.md
   - description field written as a trigger ("Invoke when...")
   - Focus on what Claude gets wrong without guidance, not obvious things
   - Include a Gotchas section with failure points specific to this codebase
   - Add executable scripts in scripts/ where a procedure can be automated

3. .claude/agents/ — one subagent per component in apps/:
   - Each agent knows its component deeply (stack, patterns, constraints)
   - tools restricted to what the agent actually needs
   - model: haiku for lightweight tasks, sonnet for logic
   - Each agent references relevant skills
   - description written so Claude auto-delegates correctly

4. .claude/plans/active-plan.md
   - Empty template ready to be filled per task

5. AGENTS.md at project root
   - Quick reference: which agent to call for which task
   - How skills relate to agents
   - When to /clear vs /compact for this project

After creating all files, output a summary of:
- What was found in each component
- Which skills were created and why
- Which agents were created and their tool restrictions
- Any gaps or ambiguities that should be clarified
