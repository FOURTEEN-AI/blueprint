# 0027. PR preview environments: a Fly app plus a Neon schema-only branch

- Status: Superseded by [0051](0051-preview-databases-as-fresh-database-in-pr-branch.md)
- Date: 2026-10-14
- Supersedes: [0026](0026-pr-previews-with-postgres-sidecar.md)

## Context

Every PR should be demoable on a real deployment (ADR 0044) without touching production data and without running up costs.

## Decision

- Each PR from the main repository gets its own **Fly app** (e.g. `<app>-pr-<n>`) that runs the PR's image.
- Its database is a **Neon schema-only branch** of production: the schema without any data. Flyway then applies the PR's new migrations through the release command (ADR 0012). Previews start **without seed data**.
- **Cost and cleanup**:
  - preview machines scale to zero when idle
  - the app and its branch are destroyed when the PR closes or merges
  - previews older than a TTL are destroyed and can be redeployed on demand, e.g. by `/demo`
  - a nightly job deletes orphaned previews and branches
- **PRs from forks get no preview**, because secrets aren't available to them and `pull_request_target` is a known security trap. A maintainer can push the branch to the main repository to get a preview.

## Consequences

- Previews contain no production data, which matters because there is no authentication (ADR 0020).
- Reviewers create their own test data.
- Neon branch limits on the free tier cap how many previews can exist at once. The work-in-progress limit of one (ADR 0046) keeps us well inside them.
