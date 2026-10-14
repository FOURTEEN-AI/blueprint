# 0029. Pre-migration Neon snapshots and automatic app rollback

- Status: Accepted
- Date: 2026-10-14
- Supersedes: [0028](0028-pre-migration-backup-to-tigris.md)

## Context

Releases reach production without a human gate after the demo (ADR 0043). Flyway only moves forward. Two kinds of failure need a recovery path: a broken app version, and a migration that damages data.

## Decision

1. **Snapshot**: before Flyway runs in production, a Neon branch named `pre-vX.Y.Z` is created from the production branch. Only the most recent N snapshots are kept.
2. **Smoke test**: after the deploy, a tagged Playwright smoke suite runs against production (ADR 0040).
3. **Automatic app rollback**: if the smoke test fails, CI redeploys the previous image. Expand/contract migrations (ADR 0013) make this safe without touching the schema.
4. **Data restore** from a snapshot is a deliberate, documented manual step. It is never automatic.

## Consequences

- Broken releases are reverted automatically within minutes.
- Data damage can be recovered from the last pre-migration snapshot, but any writes made after it are lost.
- Snapshot branches count against Neon's limits, hence the retention of N.
