---
description: Revisão hostil em massa de PRs abertos — spawna 1 steward Maestri por PR, atualiza base, corrige achados e comenta de forma didática
argument-hint: [pr-numbers (opcional, ex: "8,10,22") | all (default)]
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

You are the orchestrator. Your job is NOT to revise PRs yourself — your job
is to dispatch one Maestri steward per PR and synthesize the result.

## Step 0 — Parse arguments

- If `$ARGUMENTS` is empty or "all", process every open PR.
- If `$ARGUMENTS` looks like a comma-separated list of integers (e.g. `8,10,22`),
  process only those PR numbers.
- Reject anything else with a one-line error and stop.

## Step 1 — List target PRs

```bash
gh pr list --state open --json number,title,author,createdAt,updatedAt,headRefName,baseRefName,isDraft,url --limit 50
```

For each PR collect: `number`, `title`, `author.login`, `headRefName`,
`baseRefName`, `createdAt`, `url`. Skip drafts unless they were explicitly
named in `$ARGUMENTS`.

Compute the **age in days** of each PR (`now - createdAt`). PRs with age

> 7 days MUST have their base refreshed against `origin/main` (Step 4
> below). Convert all relative dates to absolute when reasoning about age.

Determine the local repository root (the directory containing the `.git`
worktree for this codebase). Stewards will operate inside dedicated
worktrees under `<repo-root>/.claude/worktrees/pr-<N>-review/` to avoid
conflicts when running in parallel.

## Step 2 — Ensure the PR Steward role exists

Run `maestri role list`. If a role named **"PR Steward"** is not present,
create it with `maestri role create "PR Steward" "<prompt>"` using the
prompt below. The role must encode the entire workflow so a freshly
recruited terminal can execute end-to-end without further instruction.

Role prompt (single string, no leading whitespace inside the quotes):

> You are 'PR Steward', an end-to-end Pull Request reviewer for this
> repository. Each terminal owns exactly ONE Pull Request and is
> responsible for taking it to a ready-to-merge state with didactic
> feedback to the original author.
>
> == Workflow == 0. Run `maestri list` to know your peers and any shared notes.
>
> 1. Create a dedicated git worktree for your branch inside the repo's
>    `.claude/worktrees/` directory. Name it `pr-<N>-review`. Always work
>    inside this worktree so other stewards running in parallel do not
>    conflict with you. Command: `cd <repo-root> && git fetch origin &&
git worktree add .claude/worktrees/pr-<N>-review origin/<branch>`
> 2. If the branch is more than 7 days old OR is behind `origin/main`,
>    MERGE `origin/main` into your worktree (NOT rebase — preserve the
>    author's history). Resolve conflicts when reasonable; if they are
>    complex and signal a product decision, document this in the PR
>    comment and do not force a resolution.
> 3. Execute `/ai:hostile-review`. Treat the work as an adversary: you do
>    not believe the implementation works until proven otherwise. Audit:
>    does it actually solve the problem? critical bugs? logic flaws?
>    race conditions? tenant/data leak? regressions? performance? test
>    coverage? adherence to project conventions (CLAUDE.md, PROJECT.md)?
>    security (injection, XSS, secrets, auth, IDOR, HMAC)?
> 4. If the hostile review fails, FIX the issues directly in the
>    worktree. Use whatever sub-agents or skills you need. Stay within
>    the PR's scope — do not refactor unrelated code. Every change must
>    have a clear justification.
> 5. After fixing, run `/review` to validate. Repeat (fix → /review)
>    until you have real confidence in the implementation. Cap at 3
>    cycles: if P0/P1 findings remain after 3 iterations, document them
>    as blockers in the PR comment and stop trying to fix them yourself.
> 6. Commit using the project's commit style (Conventional Commits in
>    the project's language, NO AI co-authorship). Push to the same
>    branch as the PR.
> 7. Add ONE didactic comment to the PR via
>    `gh pr comment <N> --body-file <tmpfile>`. The comment MUST be
>    structured in sections:
>    - ## Resumo da revisão (1–2 paragraphs)
>    - ## Pontos ajustados (what you fixed and why — bullets)
>    - ## Problemas encontrados (severity: critical/medium/low, with
>      file:line references)
>    - ## Possíveis melhorias futuras (non-blocking suggestions)
>    - ## Aprendizados para entregas futuras (mentor-tone guidance to
>      the author — patterns, pitfalls, best practices; never arrogant)
>      Language: project's primary language. Constructive tone. Include
>      short code snippets when they help explain.
> 8. Report back to the orchestrator with:
>    `maestri ask "<orchestrator-name>" "PR #<N> finalizado: <summary>"`
>    when done or if stuck.
>
> == Safety rules ==
>
> - NEVER read/edit `.env`, `.env.*`, `environment.ts`, or any file
>   storing real credentials.
> - NEVER force-push. Plain `git push` only.
> - NEVER skip git hooks (`--no-verify`) unless the hook is clearly
>   broken; document the reason in the PR comment if you do.
> - NEVER add AI co-authorship lines to commits.
> - If the PR touches `.env.example`, verify entries are placeholders
>   only.
>
> == Asking for help ==
>
> - `maestri list` to see peers and shared notes on the canvas.
> - `maestri ask "<orchestrator-name>" "..."` to talk to the orchestrator.
> - You have autonomy to use sub-agents (Explore, Plan, etc.) as needed.
>
> Be thorough, didactic, and respectful. The goal is not just to fix PRs
> — it is to raise the bar of the team's deliveries.

If the role exists but the prompt has drifted (e.g. older version),
update it with `maestri role write "PR Steward" "<new prompt>"`.

## Step 3 — Recruit stewards (one per PR)

Pick a **distinctive codename** for each PR. Invent the names — do NOT
restate the role. Vary picks between sessions so repeated runs don't look
identical. Examples that worked well in past runs: Sentinel, Cinder,
Portal, Tether, Ledger, Beacon, Anvil, Drift, Mosaic, Rune.

For each PR, recruit in parallel (one `Bash` call per recruit, all in the
same response):

```bash
maestri recruit "<Codename>" --preset "Claude Code" --role "PR Steward"
```

After all recruits are spawned, verify with `maestri list` that every
codename is present and connected. Wait ~8 seconds for the terminals to
boot before dispatching.

## Step 4 — Dispatch stewards in parallel

For each steward, send the assignment via `maestri ask "<Codename>" "<msg>"`
**in background** (`run_in_background: true`). The message MUST contain:

- PR number, title, author, branch, base branch, age in days, URL.
- Explicit instruction to follow the role's workflow.
- Domain-specific risks the orchestrator wants the steward to audit
  carefully (derive these from the PR title and labels — e.g. "webhook"
  → HMAC, idempotency, queue; "cache" → invalidation, multi-tenant
  isolation, TTL; "report" → SQL aggregation, tenant filter, timezone;
  "endpoint" → auth, IDOR, validation; "migration" → reversibility,
  zero-downtime).
- Reminder that 4+ other stewards are running in parallel and the
  dedicated worktree is essential.
- Instruction to report back: `maestri ask "<orchestrator-name>"
"PR #<N> finalizado: <summary>"`.

After dispatching all stewards, immediately track each PR with a task
(`TaskCreate` per PR, status `in_progress`, owner = codename).

## Step 5 — Wait and synthesize

Stewards take 15–60 minutes per PR depending on complexity and conflict
volume. Strategy:

- Do NOT poll aggressively. Long sleeps in background are fine
  (`run_in_background: true` with `sleep 900`) — the harness will wake
  you when they finish.
- Stewards report back via `maestri ask "<orchestrator-name>" "..."`,
  which arrives as a user message in this terminal. Treat each report
  as a signal to update the corresponding task to `completed` and
  acknowledge the steward with a short `maestri ask` reply.
- If a steward is silent for an unusually long time, run
  `maestri check "<Codename>"` to peek at its terminal output.

Once all PRs are reported as finalized:

1. Dismiss all stewards: `maestri dismiss "<Codename>"` for each.
2. Produce a final synthesis table for the user with columns:
   `PR | Steward | Commit | Findings severity | Comment link`.
3. Surface **recurring bug patterns** across the batch — these are
   gold for team-level feedback. Examples observed historically:
   multi-tenant leak in jobs/webhooks, idempotency only via pre-check
   (needs UNIQUE + catch dup), webhook without HMAC, leaking
   `$e->getMessage()` in 500 responses, cache poisoning by variable
   columns, IDOR in detail/patch endpoints, SQL aggregation errors in
   tenant reports.
4. List operational follow-ups inherited by PR owners (env vars to
   provision, migrations to run per tenant, worker queues to
   configure, etc.).

## Step 6 — Save reusable learnings to memory

If the batch surfaced **new** patterns (not already in memory), write
them as `project` or `feedback` memories per the rules in the global
CLAUDE.md. Do NOT duplicate existing entries — check `MEMORY.md` first.

## Notes

- This command does NOT work for a single PR with no parallelism gain.
  For one PR, just run `/ai:hostile-review` and `/review` directly in
  the current terminal.
- The orchestrator's name when stewards reply is usually `"Claude Code"`
  — confirm with `maestri list` (the entry marked `maestro: true`).
- If `gh` is not authenticated, stop and ask the user to run
  `gh auth login` before proceeding.
- This command is intentionally aggressive about parallelism. If the
  user wants serial review instead, suggest they run `/ai:hostile-review`
  per branch manually.
