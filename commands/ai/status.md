---
description: Visão rápida do estado da sessão — tarefa ativa, planos, git e daily
allowed-tools: Read, Bash, Glob
---

Gather and present a quick status of the current session. Run all checks
in parallel and present a single consolidated view.

## Data to collect (in parallel)

1. **Active task:** read `.claude/plans/.active-sessions.json`, look up
   this session by `$PPID`. If found, read the first 20 lines of the
   plan file for goal and status.

2. **Open plans:** list `.claude/plans/*.md` (excluding archive/ and
   dotfiles). Show name and status of each (read just the Status line).

3. **Git state:** run `git status --short` and `git log --oneline -3`.

4. **Latest daily:** read the most recent file in `.claude/dailies/`
   (if the directory exists). Show only the "In progress" and "Blocked"
   sections.

## Output format

Present as a compact dashboard:

```
Session: <task name or "no active task">
Status:  <planning | in-progress | blocked | none>

Open plans:
  - <name> (status)
  - <name> (status)

Git: <branch> | <N> uncommitted changes
Recent: <last 3 commit subjects, one line each>

From latest daily (<date>):
  In progress: ...
  Blocked: ...
```

Keep it short — this is a glance, not a report.
If there are no plans, no daily, or no uncommitted changes, omit those
sections entirely rather than showing empty placeholders.
