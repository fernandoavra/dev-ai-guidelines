# Severity scale

All review agents (code-reviewer, security-reviewer, qa-engineer,
hostile-reviewer, db-auditor, tech-debt-auditor) MUST use this scale.
A unified scale makes findings comparable when multiple agents run on
the same change (e.g. `/ai:review` invokes code + security + qa).

## Levels

**P0 — Blocking**
The change cannot ship. Data loss, security hole, broken behavior,
goal not met, contract violated. Author MUST fix before merge.

**P1 — Major**
Should not ship as-is. Convention violation, missing test coverage on
critical path, performance regression, accessibility violation (WCAG AA),
significant maintainability hit. Author SHOULD fix before merge unless
explicitly deferred with a tracked follow-up.

**P2 — Minor**
Annoyance with a workaround. Style drift, suboptimal naming, refactor
opportunity, missing nice-to-have test. Fix in next pass.

**P3 — Polish**
Nice-to-fix, no real user or maintainer impact. Optional.

## Output format

Each finding MUST be tagged with `[P0]`, `[P1]`, `[P2]`, or `[P3]` and
include `file:line` when applicable.

Example:

```
[P0] agents/foo.md:42 — Hardcoded API token in default config.
     Impact: anyone reading the repo can authenticate as the service.
     Recommendation: move to env var, rotate token.

[P2] commands/ai/bar.md:18 — Inconsistent gate phrasing vs sibling commands.
     Impact: drift in user-facing wording.
     Recommendation: align with task.md gate language.
```

## Anti-patterns

- Do not invent new levels (no "critical", "major", "important", "blocker").
- Do not collapse two findings of different severity into one entry.
- Do not down-rank a finding to avoid noise — leave it at true severity,
  filter at the synthesis step instead.
