---
description: Implementa feature cross-componente — contrato antes dos agentes
argument-hint: <descrição da feature>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

If $ARGUMENTS is empty, ask the user to describe the feature.
Do NOT proceed without a feature description.

This feature spans multiple components. Use agent teams.

Feature: $ARGUMENTS

## Step 1 — Contract design

Sanitize $ARGUMENTS for use as filename: lowercase, replace spaces with
hyphens, remove special characters, truncate to 50 chars max.
Example: "checkout com split payment" becomes "checkout-com-split-payment".

1. @architect-agent: design the contract between components first
   - API schema, event format, or shared type definitions
   - Save to .claude/plans/$FEATURE_NAME.md with the following structure:

```
# Feature: $ARGUMENTS

**Started:** (current date)
**Status:** contract-design

## Goal
(one clear sentence describing what this feature achieves)

## Contract

### Components involved
- [component] — role in this feature

### Interface definitions
(API schema, event format, or shared type definitions)

### Constraints
(what must be true across all implementations)

### Implementation order
(sequential or parallel — be explicit about dependencies)

## Plan
1. [step] — rationale
2. [step] — rationale
...

## Files affected
- `path/to/file` — reason for change

## Acceptance criteria
- [ ] criterion 1
- [ ] criterion 2

## Risks and edge cases
- [risk or edge case]

## Open questions
- [question that needs an answer before or during implementation]

## Decision log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| (date) | Contract designed | — | — |

---
*last-updated: YYYY-MM-DD HH:MM*
```

2. Present the contract and plan for approval.
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
