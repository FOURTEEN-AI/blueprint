# 0091. Release safety: serialized releases and a revert after every rollback

- Status: Accepted
- Date: 2026-10-15
- Extends: [0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md), [0031](0031-github-actions-ci-cd.md), [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0070](0070-incident-items-exempt-from-wip-limit.md) (items from a rollback are incidents too, not only items from alerts)

## Context

ADR 0029 rolls production back to the previous image when the smoke test fails. Three things were left open:

- After a rollback, `main` and the latest release still contain the broken change. The next release, even an unrelated Dependabot fix, ships it again and triggers another rollback.
- Several merges can land close together (Dependabot, `chore` PRs, features), so release workflows can overlap: snapshot, migrate, deploy, smoke test and rollback interleaving.
- No one is told about a rollback. Grafana alerts (ADR 0069) cover production between deploys, but a rollback happens inside CI.

Facts: semantic-release releases `revert` commits as a patch by default. A GitHub Actions concurrency group lets one run proceed and keeps only the newest pending run.

## Decision

- **Serialized releases**: release, rollback and revert workflows share one concurrency group, `production`, **without** `cancel-in-progress`. A running release always finishes. If several runs wait, only the newest one runs, which is enough because semantic-release always releases `main`'s head, which includes the skipped commits.
- **After an automatic rollback**, the rollback workflow, acting as the project App (ADR 0084):
  1. opens a **`revert:` PR** for the failed release's commits. It needs no demo (ADR 0057), merges once green, and ships as a patch release, so `main` and production agree again;
  2. writes a **bug item** to `backlog/inbox/` with the smoke-test failure, which the loop fixes forward. It is an **incident item** (`incident: true`), so it isn't blocked by the WIP limit (ADR 0070).
- **Rollbacks are reported through GitHub**:
  - the rollback marks its workflow run as failed, which GitHub notifies the maintainer about
  - the revert PR and the bug item mention the maintainer
- Problems **between deploys** are detected by the Grafana alerts of ADR 0069. This ADR adds nothing there.

## Consequences

- A broken change is out of `main` shortly after the rollback, and it can't come back with an unrelated release.
- Releases never interleave, at the cost of waiting.
- A rollback is reported without depending on Grafana, so it's noticed even when telemetry isn't configured.
- **Rejected:**
  - A release freeze until a human clears it, because every merge after the rollback would pile up undeployed.
  - Only a bug item, because the next release would redeploy the broken change.
  - Queuing every single release, because it needs a custom queue for little gain.
  - A scheduled release train, because it slows delivery and makes each release larger.
  - A scheduled smoke test against production, because it wakes the machine and Grafana alerts already cover production between deploys.
