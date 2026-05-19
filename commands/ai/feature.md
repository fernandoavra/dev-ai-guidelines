---
description: Implementa feature cross-componente — contrato antes dos agentes
argument-hint: <descrição da feature>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

If $ARGUMENTS is empty, ask the user to describe the feature.
Do NOT proceed without a feature description.

This feature spans multiple components. Use agent teams.

Feature: $ARGUMENTS

## Step 0 — Check for an existing spec

Sanitize $ARGUMENTS into a slug (same rule as Step 1) and check for
`.claude/plans/specs/<slug>.md`. If it exists, read it first — its
Problem, Goals, Non-goals, Constraints, Risks (and for large specs,
Success metrics, Milestones, Stakeholders) become the starting
context. The plan file MUST include `**Source spec:** .claude/plans/specs/<slug>.md`
in the header (right after Status). Do not duplicate the WHY content
verbatim — reference the spec for it; the plan focuses on the HOW.

If no spec exists, suggest `/ai:spec` first when the feature feels
under-defined. Proceed only if the user confirms the feature is
already well-understood and a spec would add no value.

## Step 1 — Contract design

Sanitize $ARGUMENTS for use as filename: lowercase, replace spaces with
hyphens, remove special characters, truncate to 50 chars max.
Example: "checkout com split payment" becomes "checkout-com-split-payment".

1. Dispatch @architect first to design the contract between components:
   - API schema, event format, or shared type definitions
   - Save to `.claude/plans/$FEATURE_NAME.md` following the **Feature
     variant** of the schema in `.claude/plans/.plan-template.md` (base
     schema + the `## Contract` section). Read that template first if you
     have not seen it in this session.
   - Use `**Status:** contract-design` initially.
   - Architect does not begin implementation — its only deliverable is
     the contract written to the plan file.

2. IMMEDIATELY after creating the plan file, register this task as active
   for the current terminal session by running:

   ```bash
   FILE=".claude/plans/.active-sessions.json"
   [ -f "$FILE" ] || echo '{}' > "$FILE"
   jq --arg pid "$PPID" --arg task "$FEATURE_NAME" \
     '.[$pid] = {"task": $task, "started": (now | todate)}' \
     "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
   ```

   Do NOT skip this — the statusline depends on it to display the active task.

3. Present the contract and plan for approval.
   **Wait for my approval before any agent proceeds.**

## Step 2 — Parallel implementation

After approval, update the plan status to "in-progress" and add a
decision log entry: "Contract approved — implementation started".

Identify which agents to run in parallel based on the components
affected and run them simultaneously.
Each agent must read .claude/plans/$FEATURE_NAME.md before starting.

## Step 3 — Validation

1. @code-reviewer: validate that all implementations match the contract
2. @qa-engineer: write integration tests covering the full cross-component flow

## Step 4 — Keep the plan alive (CRITICAL)

Update .claude/plans/$FEATURE_NAME.md whenever:
- A decision changes the contract or approach
- A component implementation deviates from the contract (document why)
- A new file is added or a planned file is no longer needed
- A risk materializes or a new risk is discovered
- An open question is answered
- A step is completed (check off acceptance criteria)
- Status changes (contract-design → in-progress → review → done)

For each scope-affecting decision, append a row to the **Decision log** table.
Update the **last-updated** timestamp on every write.

If during implementation the feature turns out larger than expected:
- Communicate clearly
- Propose splitting into smaller parts
- Do NOT silently reduce scope

No agent should begin implementation before the contract is approved.
This ensures /ai:handoff can read the plan file and produce a handoff
with minimal effort — the plan IS the source of truth for this feature.
