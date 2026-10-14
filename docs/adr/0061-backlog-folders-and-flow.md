# 0061. Backlog folders and flow

- Status: Accepted
- Date: 2026-10-14
- Extends: [0045](0045-in-repo-backlog-status-folders.md)

## Context

ADR 0045 introduced status folders without fixing the folder set or how moves reach the protected `main` branch.

## Decision

- Folders: **`backlog/inbox/`**, **`backlog/ready/`**, **`backlog/done/`**, **`backlog/rejected/`**. There is no in-progress folder: the open PR shows what's being worked on.
- **Triage** (inbox → ready or rejected, the latter with a reason) is done by the autonomous loop in its **own `chore` PR**, which auto-merges.
- **ready → done** happens **inside the PR that implements the item**, so merging means done.
- **Feedback from `/demo`** is written as new `inbox/` items and **committed to the demoed PR** before it merges, so the feature and its feedback land together.

## Consequences

- The backlog state on `main` always matches what has shipped.
- Triage creates small extra PRs, which auto-merge because they're not user-visible.
