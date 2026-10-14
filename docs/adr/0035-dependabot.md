# 0035. Dependabot for dependency updates

- Status: Accepted
- Date: 2026-10-14

## Context

Dependencies across Gradle, pnpm and GitHub Actions have to stay current. The options were Renovate (with or without automerge) and Dependabot.

## Decision

Use **Dependabot** for Gradle, npm/pnpm, GitHub Actions and the devcontainer.

## Consequences

- GitHub-native, with no extra app to install.
- Grouping and automerge control is weaker than Renovate's.
- Dependabot PRs go through the same gates as any other PR.
