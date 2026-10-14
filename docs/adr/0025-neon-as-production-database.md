# 0025. Neon (free tier) as the production database

- Status: Accepted
- Date: 2026-10-14
- Supersedes: [0024](0024-unmanaged-fly-postgres.md)

## Context

Unmanaged Fly Postgres is archived (ADR 0024). Fly Managed Postgres reportedly starts at around $38 per month, which is heavy for template users. Other options were running our own Postgres app on Fly or an external serverless Postgres.

## Decision

Production uses **Neon** (serverless PostgreSQL, free tier) in **AWS eu-central-1 (Frankfurt)**, close to Fly `fra`. The app receives the connection through a `DATABASE_URL` secret. `/bootstrap` creates the Neon project and stores a `NEON_API_KEY` for CI.

## Consequences

- The database is managed, free to start, and its compute scales to zero along with the app.
- Neon branching enables cheap preview databases (ADR 0027) and pre-migration snapshots (ADR 0029).
- The LISTEN connection (ADR 0019) has to use the direct endpoint. The app's connection pool may use the pooler.
- There's an external dependency outside Fly, with some network latency and the free tier's limits.
