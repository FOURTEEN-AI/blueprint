# 0043. Agents merge autonomously after a green build and a demo

- Status: Accepted
- Date: 2026-10-14

## Context

We have to decide how much autonomy agents get in the git workflow: stop at an open PR, auto-merge, or local commits only. Merging to `main` triggers a production release (ADR 0032).

## Decision

- Claude may **merge PRs itself** once all required checks are green **and** the PR has passed a `/demo` (ADR 0044).
- There is no separate human approval gate based on file types (migrations, CI files) or on breaking changes.
- The safety net is: quality gates (ADR 0034), expand/contract migrations (ADR 0013), pre-migration snapshots, and auto-rollback (ADR 0029).

## Consequences

- The human role shifts from code review to **reviewing behavior** in demos.
- The guardrails (hooks, branch protection, CI) are the critical safety mechanisms and have to be robust.
