# 0011. PostgreSQL and Flyway

- Status: Accepted
- Date: 2026-10-14

## Context

The template should demonstrate real persistence end-to-end, including schema evolution.

## Decision

- **PostgreSQL** is the only supported database, locally (Testcontainers), in tests and in production.
- **Flyway** (Community edition) manages schema migrations as versioned SQL files.

## Consequences

- There is no H2 or embedded database, so tests use the same engine as production.
- Flyway Community has no undo migrations. Rollback safety comes from expand/contract (ADR 0013) and pre-migration snapshots (ADR 0029).
- PostgreSQL features such as LISTEN/NOTIFY (ADR 0019) and transactional DDL are available to use.
