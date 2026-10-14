# 0065. Neon branch budget and snapshot retention

- Status: Accepted
- Date: 2026-10-14
- Extends: [0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md)

## Context

Neon's free plan allows **10 branches per project** (third-party sources and Neon docs agree). ADR 0029 kept "the last N" pre-migration snapshots without fixing N.

## Decision

- Branch budget: `main` (production), `previews` (ADR 0064), and pre-migration snapshots.
- **The last 5 `pre-vX.Y.Z` snapshots are kept.** The release workflow deletes older ones before creating a new one.
- That leaves a buffer of 3 branches for manual work, e.g. a restore.

## Consequences

- Branch creation never fails because of the plan limit during a release.
- Data can be restored only to one of the last 5 releases.
