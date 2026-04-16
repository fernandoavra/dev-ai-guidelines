---
description: Diagnóstico de bug — root cause antes de qualquer fix
argument-hint: <descrição do sintoma>
allowed-tools: Read, Bash, Glob, Grep
---

Something is broken. Do not guess. Investigate first.

Symptom: $ARGUMENTS

Use subagents to:
1. Trace the full execution path from trigger to failure point
2. Identify every file involved in that path
3. Find exactly where actual behavior diverges from expected
4. Check git log for recent changes to involved files
5. Check if there are tests covering this path and whether they pass

Do not suggest a fix until you have:
- The root cause (not a symptom)
- The specific line or decision where it breaks
- Why it breaks (not just what)
- Whether this is a regression (worked before) or never worked

Present findings in this format:

Root cause: [one sentence]
Evidence: [file:line + explanation]
Why it worked before (if regression): [what changed]
Proposed fix: [specific changes, not vague suggestions]
Risk of fix: [what else might be affected]
Tests to add: [to prevent regression]
