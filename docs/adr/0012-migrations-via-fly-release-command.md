# 0012. Run Flyway migrations as a Fly release_command

- Status: Accepted
- Date: 2026-10-14

## Context

Migrations can run on application startup or as a separate step before rollout. With several machines, running them at startup races between instances (Flyway serializes them with a lock), and a bad migration makes every instance crash-loop.

## Decision

Migrations run through Fly's **`release_command`**: the same Jib image starts once under a dedicated *migrate-only* Spring profile (web server disabled), runs Flyway and exits. The new release rolls out only if this step succeeds. Flyway is disabled at normal application startup in deployed environments.

## Consequences

- A failed migration aborts the deploy before any new app version takes traffic. On PostgreSQL, transactional DDL rolls the failed migration back. Non-transactional statements such as `CREATE INDEX CONCURRENTLY` are the exception.
- The pre-migration snapshot (ADR 0029) runs in or before this step.
- PR previews use the same mechanism against their Neon branch.
