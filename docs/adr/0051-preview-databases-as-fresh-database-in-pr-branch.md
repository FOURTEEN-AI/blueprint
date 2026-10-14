# 0051. PR previews use a fresh database inside their Neon branch

- Status: Accepted
- Date: 2026-10-14
- Supersedes: [0027](0027-pr-preview-environments.md)

## Context

ADR 0027 creates each preview database as a **Neon schema-only branch** of production. A schema-only branch copies table definitions but no rows, and that includes Flyway's `flyway_schema_history` table. On such a branch Flyway finds the tables already present but an empty history. It then tries to apply `V1` against existing tables, and the preview deploy fails.

We considered three alternatives:

- **An empty `preview-base` branch**, created once by `/bootstrap`. Rejected: it couples previews to a one-time setup step and breaks if the branch is missing or ever gets written to.
- **Flyway `clean`** before migrating. Rejected: `clean` would have to be enabled in some configuration, which risks wiping production if the configuration is ever mixed up.
- **A fresh database inside the PR's branch.** Chosen.

## Decision

Everything in ADR 0027 still applies, except how the preview database is set up. For each PR, CI:

1. creates the PR's Neon branch as a **schema-only branch** of production, as before, so no production data is copied, and
2. creates a **new, empty database** in that branch (e.g. `preview`) and points the preview app's `DATABASE_URL` at it.

The preview's release command (ADR 0012) then runs **all** Flyway migrations from `V1` through the PR's newest one, against that empty database. The tables copied into the branch's original database are never used.

The rest is unchanged from ADR 0027:

- one Fly app per PR
- no seed data
- scale to zero, destroyed on close or merge (deleting the branch removes the database), TTL, nightly cleanup of orphans
- no previews for PRs from forks

## Consequences

- Flyway history and schema are always consistent, because the history is built along with the schema.
- Previews need no one-time setup, so `/bootstrap` has nothing to do with them beyond the usual Neon project and secrets.
- Every preview also checks that the complete migration chain applies cleanly to an empty database.
- Previews never contain production data, as before.
- The preview schema comes from the migration files, not from production. Manual schema drift in production wouldn't show up in previews, but production is only ever changed through Flyway.
- Flyway `clean` stays disabled everywhere.
