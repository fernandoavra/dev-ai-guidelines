---
description: Auditoria de banco de dados — schema, migrations, indexes, modelagem e plano de acao
argument-hint: <path dos repos ou descrição do escopo>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

If $ARGUMENTS is empty, scan the current working directory.
If $ARGUMENTS contains paths, scan each path as a separate repo/component.
If $ARGUMENTS is a description, use it to focus the audit scope.

## Step 1 — Discover database stack

Use subagents in parallel to scan each target path for:
- ORM and database type (Prisma, Eloquent, ActiveRecord, Django ORM, GORM, etc.)
- Migration files location and count
- Model/entity files location
- Database config files
- Query/repository files

If multiple repos are provided, scan all in parallel. Label each finding with
the repo name.

If no database-related files are found, report this to the user and stop.

## Step 2 — Full audit with @db-auditor

Delegate the full audit to @db-auditor for each repo/component discovered.
Run agents in parallel for independent repos.

Each agent receives:
- The database type and ORM detected
- The paths to migration, model, and query files
- The scope focus from $ARGUMENTS (if any)

Also add to the scan (not covered by the agent):
- Cross-repo relationship mapping: how databases in different repos relate to each other
- Shared tables or duplicated schemas across repos
- Data flow between databases (ETL patterns, replication, sync jobs)

## Step 3 — Synthesize and persist

Sanitize the audit scope for use as filename: lowercase, replace spaces with
hyphens, remove special characters, truncate to 50 chars max. Default to
"db-audit" if no meaningful name can be derived.

Save the consolidated output to .claude/plans/$AUDIT_NAME-$(date +%Y-%m-%d).md
with the following structure:

```
# Database Audit: $SCOPE

**Date:** (current date)
**Repos scanned:** (list of repos/paths)
**Database types:** (list of databases found)

## Executive Summary
- Total findings by category and priority
- Overall database health score (A-F) per repo
- Top 5 highest-priority items across all repos

## Database Map
(visual overview of all databases, their tables, and cross-repo relationships)

## Findings by Category

### Critical
(items that need immediate attention — data loss risk, security issues)

### Schema and Modeling
(full list from @db-auditor)

### Migrations
(full list from @db-auditor)

### Indexes and Performance
(full list from @db-auditor)

### Data Integrity
(full list from @db-auditor)

### Security
(full list from @db-auditor)

### Cross-Repo Issues
(shared tables, duplicated schemas, data flow problems)

## Action Plan

### Phase 1 — Quick wins (< 1 week)
- [ ] (item — effort estimate — repo)

### Phase 2 — Planned improvements (next sprint)
- [ ] (item — effort estimate — repo)

### Phase 3 — Architectural changes (requires planning)
- [ ] (item — effort estimate — repo — dependencies)

## Risks
- (risks of NOT acting on critical items)
- (risks of the proposed changes themselves)
```

## Step 4 — Present results

Present to the user:
1. Executive summary with health scores
2. Top 5 critical/high-priority items
3. The 3-phase action plan overview
4. Path to the full audit file

Do NOT start fixing anything. This is an audit — document only.
Ask the user which phase or items they want to tackle first.
If the user wants to proceed with fixes, suggest using /ai:task for
individual items or /ai:feature for cross-component changes.
