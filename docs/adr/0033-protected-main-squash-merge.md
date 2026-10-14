# 0033. Protected main, PR-only changes, squash merge

- Status: Accepted
- Date: 2026-10-14

## Context

Agents and humans both contribute, and semantic-release reads the commit history on `main`.

## Decision

- `main` is protected: no direct pushes, and all required checks must pass.
- Every change goes through a pull request and is **squash-merged**. The PR title becomes the Conventional Commit message.
- `/bootstrap` configures these rules.

## Consequences

- The history on `main` is linear, one commit per change, and each commit produces a clean changelog entry.
- Individual commits inside a PR don't have to follow Conventional Commits. Only the PR title does.
