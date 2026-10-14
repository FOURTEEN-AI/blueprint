# 0028. Pre-migration pg_dump to Tigris

- Status: Superseded by [0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md)
- Date: 2026-10-14

## Context

Flyway can't undo migrations, and unmanaged Fly Postgres (ADR 0024) only offered daily volume snapshots. With autonomous releases, a destructive migration could lose data.

## Decision

Before migrating, the release command writes a `pg_dump` to **Tigris** (Fly's S3-compatible object storage), with a retention rule.

## Consequences

Superseded when we moved to Neon (ADR 0025). Neon branches give instant snapshots without separate object storage.
