# 0084. A project GitHub App is the identity of all automation, including the loop

- Status: Accepted
- Date: 2026-10-15
- Extends: [0046](0046-autonomous-backlog-loop.md), [0058](0058-dependabot-merge-and-release-policy.md), [0060](0060-demo-gate-as-required-status-check.md), [0078](0078-dependabot-majors-become-backlog-items.md) (replaces the fine-grained token for the loop)

## Context

Several automations act on the repository: the 0078 workflow opens a `chore` PR, Dependabot PRs get auto-merge enabled (ADR 0058), and the autonomous loop opens and merges PRs (ADR 0046). Two facts shape the identity they use:

- Actions taken with the built-in **`GITHUB_TOKEN` don't trigger other workflows**. A PR opened with it never runs CI, so its required checks never report and it can't merge. A merge done through auto-merge enabled with it may not start the release workflow.
- The demo gate (ADR 0060) relies on the loop **not** having the "commit statuses" permission. Claude Code cloud routines normally act through the Claude GitHub App, whose permissions we don't control. Fine-grained personal access tokens can't be created through an API, expire, and act as the human's account.

## Decision

- Every project has its own **GitHub App** (the "project bot"), installed only on that repository, with:
  - **contents: write** and **pull requests: write**
  - **no commit statuses**, **no administration** and **no workflows** permission
- Workflows obtain short-lived tokens with `actions/create-github-app-token`. That covers the 0078 workflow, enabling auto-merge on Dependabot PRs, the `chore` PR for incident items from Grafana alerts (ADR 0069), and the revert PR after a rollback (ADR 0091).
- The **autonomous loop** uses the same App: the routine mints its own tokens from the App's key, and the Claude GitHub App isn't needed on the repository.
- `/bootstrap` guides creating the App. That includes a manual browser step, because GitHub requires one to create an App.

## Consequences

- Bot actions trigger CI and releases like a human's would, and they're attributed to a clear bot identity.
- The loop can't open the demo gate, change branch rules, or push changes to `.github/workflows/` (GitHub rejects such pushes without the workflows permission). Workflow changes are always made by a human.
- The App's private key is a credential held in CI and in the routine's environment.
- To verify during implementation: that a Claude Code cloud routine can authenticate to GitHub with the App instead of the Claude GitHub App.
- **Rejected:**
  - Letting the loop handle Dependabot merges and major updates, because patches would wait for the next loop run.
  - A fine-grained token of the maintainer, because it's tied to one person, expires and can't be created by `/bootstrap`.
  - The Claude GitHub App for the loop, because the demo gate's safety would depend on a third-party permission set.
