---
description: Implementa feature cross-componente — contrato antes dos agentes
argument-hint: <descrição da feature>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

This feature spans multiple components. Use agent teams.

Feature: $ARGUMENTS

Orchestration plan:
1. @architect-agent: design the contract between components first
   - API schema, event format, or shared type definitions
   - Output to .claude/plans/[feature-slug]-contract.md
   - Wait for my approval before any agent proceeds

2. After approval, identify which agents to run in parallel based on
   the components affected by this feature and run them simultaneously.
   Each agent must read the contract file before starting.

3. @code-reviewer: validate that all implementations match the contract

4. @qa-engineer: write integration tests covering the full cross-component flow

No agent should begin implementation before the contract is approved.
