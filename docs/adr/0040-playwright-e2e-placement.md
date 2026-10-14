# 0040. Where Playwright E2E tests run

- Status: Accepted
- Date: 2026-10-14

## Context

End-to-end tests are the most realistic and also the slowest. They can run against the built artifact in CI, against previews, and against production.

## Decision

- **CI**: the full Playwright suite runs against the built JAR, with PostgreSQL from Testcontainers.
- **PR preview**: a tagged **smoke** subset runs against the deployed preview.
- **Production**: the smoke subset runs after every deploy and triggers the automatic rollback on failure (ADR 0029).

## Consequences

- Full coverage runs without a dependency on Fly, and deployed environments still get a quick real-world check.
- Tests need tags (`@smoke`) and a configurable base URL.
- Smoke tests against production must not leave harmful data behind, so they are read-only or clean up after themselves.
