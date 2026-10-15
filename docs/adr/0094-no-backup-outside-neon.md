# 0094. No backup outside Neon

- Status: Accepted
- Date: 2026-10-15
- Extends: [0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md), [0065](0065-neon-branch-budget.md)

## Context

After ADR 0028 (pg_dump to Tigris) was superseded, every recovery option lives inside Neon: its point-in-time restore window and the last 5 pre-migration snapshots (ADR 0065). Two cases aren't covered: an app bug that damages data between releases and is noticed after the restore window, and losing the Neon project or account.

## Decision

The template ships **no backup outside Neon**. The README tells projects holding valuable data to add their own.

## Consequences

- No extra account, secret or encryption key to manage.
- Data damage noticed too late, or loss of the Neon project, can't be recovered by the template's means. This is an accepted risk for a template whose sample data is public and disposable.
- **Rejected:**
  - A scheduled, encrypted `pg_dump` to Cloudflare R2, because it adds a token and possibly a payment method.
  - An encrypted dump as a GitHub Actions artifact, because artifacts last at most 90 days and are downloadable by any signed-in user for public repositories.
