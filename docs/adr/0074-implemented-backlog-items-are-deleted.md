# 0074. Implemented backlog items are deleted, not kept in done/

- Status: Accepted
- Date: 2026-10-14
- Supersedes: [0061](0061-backlog-folders-and-flow.md)

## Context

ADR 0061 moved implemented items to `backlog/done/`. After implementation, though, everything in a done item exists elsewhere: the use case is in the living catalog, the Gherkin scenarios are in the tests and the JGiven report (ADR 0063), and the history is in git. Keeping done items creates a second, drifting copy and contradicts ADR 0063.

## Decision

- Folders: **`backlog/inbox/`**, **`backlog/ready/`**, **`backlog/rejected/`**. There is **no `done/` folder** and no in-progress folder (the open PR shows what's being worked on).
- The PR that implements an item **deletes it from `ready/`**, so merging means done. The same PR creates or updates the use case in `docs/use-cases/` and the tagged tests (ADR 0063).
- **Triage** (inbox → ready or rejected, the latter with a reason) is done by the autonomous loop in its **own `chore` PR**, which auto-merges.
- **Feedback from `/demo`** is written as new `inbox/` items and **committed to the demoed PR** before it merges.

## Consequences

- The catalog and the tests are the only lasting specification. There is no redundant copy.
- An item's history (its original wording, refinement and source) is still available through git history and the implementing PR.
- `rejected/` items stay, because their reasons aren't recorded anywhere else.
