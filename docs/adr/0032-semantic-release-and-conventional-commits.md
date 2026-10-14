# 0032. semantic-release with Conventional Commits

- Status: Accepted
- Date: 2026-10-14

## Context

Releases should be automatic and versioned meaningfully, with no human bookkeeping. We considered release-please (release PRs), tagged promotion from staging, and semantic-release.

## Decision

- Commit messages follow **Conventional Commits**, enforced by **commitlint** in a local hook and on PR titles in CI.
- **semantic-release** runs on `main`: it works out the next version, creates the tag, GitHub release and changelog, and triggers the production deploy.

## Consequences

- Every releasable merge (`feat`, `fix`, …) ships to production automatically.
- Version numbers carry meaning: `feat!` / `BREAKING CHANGE` produce a major release.
- Squash-merge PR titles must be valid Conventional Commits (ADR 0033).
