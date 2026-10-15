# 0085. Untrusted build, trusted deploy: secrets never reach PR code

- Status: Accepted
- Date: 2026-10-15
- Extends: [0031](0031-github-actions-ci-cd.md), [0059](0059-branch-protection-and-codeowners.md)

## Context

For a pull request from a branch in the same repository, GitHub runs the workflow files **as they are in the PR**, and the build runs the PR's Gradle and test code. CODEOWNERS (ADR 0059) blocks the merge of a workflow change but not its execution. Any job that receives a secret can therefore leak it to a PR, for example one written by a prompt-injected agent or containing a compromised dependency. The preview token (ADR 0083) can delete production, and the Neon API key can delete the production branch along with all snapshots.

Repository-level Actions secrets are available to every `pull_request` workflow, including modified ones. **Environment secrets** are available only to jobs whose ref passes the environment's deployment branch policy. `workflow_run` workflows always run the default branch's version of the workflow file, with the default branch as their ref.

## Decision

- **PR workflows are untrusted.** They build, test, analyze and push the PR image, and they receive **no Fly or Neon secrets**. The only secret they use is `SONAR_TOKEN`.
- **Preview deploys are trusted.** A separate workflow triggered by `workflow_run` (so always `main`'s code-owned definition) deploys the already built image of the PR and never checks out or runs PR code on the runner. It posts the preview URL and result back to the PR.
- **Secrets live in environments restricted to `main`**:
  - `preview`: `FLY_PREVIEW_TOKEN`, `NEON_API_KEY`
  - `production`: `FLY_DEPLOY_TOKEN`, `NEON_API_KEY`, `SMOKE_BYPASS_SECRET`
  - `automation`: the project App's private key (ADR 0084)
- **Automations that act on PRs with the App** also run through `workflow_run`. That covers enabling auto-merge on Dependabot PRs (ADR 0058) and turning major updates into backlog items (ADR 0078). They read PR metadata, never PR code.
- PR workflows push their images to the same GHCR package and could overwrite any tag there. **Production deploys and rollbacks therefore reference images by digest**, recorded by the release workflow, never by tag.
- **Dependabot PRs** can only read Dependabot secrets. They get **no previews** (ADR 0090), so `SONAR_TOKEN` is the only Dependabot secret.

## Consequences

- A PR can change code and workflows as it likes, but it can't obtain a token that touches Fly or Neon.
- PR code still runs on Fly in the preview app and its release command, with that preview's database credentials only (ADR 0090).
- To verify during implementation: that a `workflow_run` workflow following a Dependabot-triggered run receives environment secrets. If it doesn't, the Dependabot automation job gets the App key as a Dependabot secret instead, in a job that runs no dependency code.
- More workflow plumbing: passing the image reference from the PR run to the deploy run, and reporting the preview status back to the PR.
- **Rejected:**
  - Environments for production only, with preview secrets available to PR workflows, because a modified workflow could read the preview token and destroy production or the Neon data.
  - A required human approval for every preview deploy, because it would stall the autonomous loop.
