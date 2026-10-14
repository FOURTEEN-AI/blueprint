# 0072. Demo status exemption for Dependabot dependency fixes

- Status: Accepted
- Date: 2026-10-14
- Extends: [0060](0060-demo-gate-as-required-status-check.md)

## Context

ADR 0060 has a workflow post `demo = pending` for every `feat` and `fix` PR. ADR 0058, however, titles runtime dependency updates `fix(deps)` (so they trigger a release) and lets patch and minor updates auto-merge without a demo. Under ADR 0060 alone, those PRs would wait for a demo forever.

## Decision

The workflow that sets the `demo` status posts **`success` automatically** for PRs that are **both**:

- **authored by Dependabot**, and
- titled **`fix(deps): …`**, i.e. patch and minor runtime dependency updates (majors never become PRs that merge directly, see ADR 0058).

All other `feat` and `fix` PRs get `pending` as before, including human- or agent-authored `fix(deps)` PRs.

## Consequences

- Runtime security patches flow to production without a human, as ADR 0058 intended.
- The exemption depends on the PR author, not just the title, so an agent can't skip the demo by choosing a `deps` scope.
- A dependency update that changes behavior isn't demoed. The quality gates and the production smoke test with auto-rollback (ADR 0029) are the safety net.
