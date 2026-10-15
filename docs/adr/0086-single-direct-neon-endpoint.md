# 0086. A single direct Neon connection for the pool, Flyway and LISTEN

- Status: Accepted
- Date: 2026-10-15
- Extends: [0019](0019-cross-instance-fan-out-via-listen-notify.md), [0025](0025-neon-as-production-database.md) (drops the pooled endpoint)

## Context

ADRs 0019 and 0025 have the app pool use Neon's pooled endpoint (PgBouncer in transaction mode) and the LISTEN connection the direct one. Flyway, which runs in the release command (ADR 0012), takes a **session-level advisory lock**, which isn't reliable through a transaction-mode pooler, so migrations need the direct endpoint as well. A project runs one or two machines with a small Hikari pool, far below the connection limit of Neon's direct endpoint.

## Decision

- There is **one `DATABASE_URL`**, pointing at Neon's **direct** endpoint. The Hikari pool, Flyway and the LISTEN connection all use it.
- `DATABASE_DIRECT_URL` and the pooled endpoint aren't used.

## Consequences

- One secret instead of two, and none of PgBouncer's transaction-mode caveats.
- A project that scales to many machines would have to reintroduce the pooler for the app pool. That needs a new ADR.
- **Rejected:** a pooled URL for the app plus a direct URL for Flyway and LISTEN, because the extra configuration buys capacity the template doesn't need.
