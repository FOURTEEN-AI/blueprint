# 0096. The PR title is the only Conventional Commit that matters

- Status: Accepted
- Date: 2026-10-15
- Extends: [0032](0032-semantic-release-and-conventional-commits.md) (drops the local commitlint hook), [0033](0033-protected-main-squash-merge.md)

## Context

ADR 0032 enforces commitlint in a local hook for every commit, while ADR 0033 says commits inside a PR don't have to follow Conventional Commits. semantic-release reads only the squash commit on `main`. With GitHub's default squash message, that commit's body lists every PR commit, so a stray `BREAKING CHANGE:` line in one of them would trigger a major release.

## Decision

- The repository's default squash commit message is the **PR title only**, with an empty body.
- **CI lints the PR title** with commitlint as a required check. There's **no local commitlint hook**.
- Breaking changes are marked with `!` in the PR title (e.g. `feat!: …`).
- Commits inside a PR should follow Conventional Commits by convention, but aren't checked.

## Consequences

- Only the PR title decides the version. Commits inside a PR can't affect releases.
- Agents don't hit hook failures for messages that are squashed away anyway.
- The changelog contains PR titles only, without descriptions.
- **Rejected:**
  - PR title and description as the squash message, because the PR template's text must then never contain `BREAKING CHANGE:`.
  - Linting every PR commit in CI, because agents would have to rewrite history to fix an intermediate commit.
