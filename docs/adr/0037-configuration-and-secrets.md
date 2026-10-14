# 0037. Configuration through Spring profiles and environment variables

- Status: Accepted
- Date: 2026-10-14

## Context

The app runs locally, in previews and in production. Secrets must never be committed, and AI agents read the working tree, so even gitignored secret files there are a leak risk.

## Decision

- `application.yml` holds safe defaults. Thin `preview` and `prod` profiles hold the per-environment differences, plus a `migrate` profile for the release command (ADR 0012).
- **Secrets exist only as environment variables**: Fly secrets at runtime, GitHub secrets in CI.
- Local development needs no secrets at all, because Testcontainers supplies the database (ADR 0007).
- There is **no `.env` file** support.

## Consequences

- There are no secret files in the working tree for agents to leak.
- Every configurable value has to be documented as an environment variable.
