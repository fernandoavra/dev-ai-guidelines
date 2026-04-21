---
description: Diagnóstico de bug — root cause antes de qualquer fix
argument-hint: <descrição do sintoma>
allowed-tools: Read, Write, Bash, Glob, Grep
---

Something is broken. Do not guess. Investigate first.

Symptom: $ARGUMENTS

## Step 1 — Context collection

Before investigating, gather or ask the user for:
- **Environment:** dev, staging, or production?
- **First observed:** when was it first noticed?
- **Frequency:** always, intermittent, or under specific conditions?
- **Recent changes:** last commits or deploys that might be relevant?

If $ARGUMENTS already contains this information, extract it. Otherwise,
ask the user before proceeding. Do NOT skip this step.

## Step 2 — Investigation (do NOT suggest a fix yet)

Use subagents to:
1. Trace the full execution path from trigger to failure point
2. Identify every file involved in that path
3. Find exactly where actual behavior diverges from expected
4. Check git log for recent changes to involved files
5. Check if there are tests covering this path and whether they pass

## Step 3 — Diagnosis (only after investigation is complete)

Do not suggest a fix until you have:
- The root cause (not a symptom)
- The specific line or decision where it breaks
- Why it breaks (not just what)
- Whether this is a regression (worked before) or never worked

Present findings in this format:

```
Root cause: [one sentence]
Evidence: [file:line + explanation]
Why it worked before (if regression): [what changed]
Proposed fix: [specific changes, not vague suggestions]
Risk of fix: [what else might be affected]
Tests to add: [to prevent regression]
```

Wait for approval before implementing the fix.

## Step 4 — Post-resolution (after fix is applied)

After the fix is implemented and verified:
1. If a plan file exists for the current task in .claude/plans/,
   append the bug to its **Decision log** with cause and fix.
2. If the bug revealed missing test coverage, note it as a risk
   in the plan or suggest adding it to the tech debt backlog
   (run /ai:debt if significant).
3. If the bug is a regression, verify the test that should have
   caught it and add one if missing.
