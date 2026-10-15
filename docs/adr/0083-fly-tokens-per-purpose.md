# 0083. Fly tokens: app-scoped deploy token for production, org token for previews

- Status: Accepted
- Date: 2026-10-15
- Extends: [0031](0031-github-actions-ci-cd.md)

## Context

ADR 0031 mentions one `FLY_API_TOKEN`. Fly **deploy tokens are scoped to a single app**, so they can't create or destroy the per-PR preview apps (ADR 0090). That needs an **org token**, which can act on every app in the organization, production included.

## Decision

- **`FLY_DEPLOY_TOKEN`**: an app-scoped deploy token for the production app, used only by the release and rollback workflows.
- **`FLY_PREVIEW_TOKEN`**: an org token, used only by the trusted preview workflows (create, deploy, destroy, nightly cleanup).
- Both live in the same Fly organization. Their exposure is limited by where CI makes them available (ADR 0085).

## Consequences

- The production deploy path holds only the minimal right it needs.
- The preview token could still delete production if it leaked. That's accepted, because it is never available to untrusted code (ADR 0085).
- **Rejected:**
  - A separate Fly organization for previews, which would isolate production fully but adds a second organization (and possibly billing) to every project.
  - A single org token for everything, because the production path doesn't need org rights.
