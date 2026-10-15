# 0098. Container image retention in GHCR

- Status: Accepted
- Date: 2026-10-15
- Extends: [0030](0030-container-images-with-jib.md)

## Context

Every PR pushes images to GHCR (ADR 0031), and every release pushes a versioned one. Without cleanup, the package fills with thousands of PR images.

## Decision

- **PR images** are deleted together with their preview: when the PR closes or merges, when the TTL expires, and by the nightly cleanup (ADR 0090).
- **Release images** (`vX.Y.Z`): the **last 5** are kept, matching the 5 pre-migration snapshots (ADR 0065). The release workflow deletes older ones.

## Consequences

- The package stays small and readable.
- Only the last 5 releases can be redeployed, which matches the releases whose data can be restored. The automatic rollback (ADR 0029) only ever needs the previous one.
- **Rejected:** keeping every release image, and keeping everything.
