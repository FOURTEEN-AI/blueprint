# 0013. Backward-compatible (expand/contract) migrations

- Status: Accepted
- Date: 2026-10-14

## Context

Agents merge to production on their own (ADR 0043), and rolling back means redeploying the previous image (ADR 0029). Redeploying an old image does not roll back the schema, so the old app version has to keep working against the new schema.

## Decision

Every migration must be **backward compatible with the previous release**:

- *Expand*: add tables, columns (nullable or with defaults) and indexes, and deploy the code that uses them.
- *Contract*: remove or rename old structures only in a **later** release, once no deployed version uses them.

Destructive changes (drop, rename, type narrowing) in the same release as the code change are forbidden. AGENTS.md states this rule, and the review skill checks it.

## Consequences

- Rolling back the app to the previous image is always safe.
- Some changes take two releases.
- Agents need explicit guidance and review checks, because this rule can't be fully enforced by tooling.
