# 0024. Unmanaged Fly Postgres as the production database

- Status: Superseded by [0025](0025-neon-as-production-database.md)
- Date: 2026-10-14

## Context

The production database should run close to the app on Fly. Fly offered Managed Postgres (paid) and the older unmanaged Fly Postgres (`fly postgres create`, Postgres on Machines with a volume).

## Decision

Use **unmanaged Fly Postgres**, scripted by `/bootstrap`, for its low cost and private networking. Backups, upgrades and failover are the operator's job.

## Consequences

Superseded the same day. Fly's documentation states that unmanaged Fly Postgres is **no longer maintained and not supported by Fly Support**, and Fly staff have said the `fly postgres` commands will be removed or repurposed. A public template can't build on that.
