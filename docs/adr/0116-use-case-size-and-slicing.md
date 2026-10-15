# 0116. Use-case size and vertical slicing

- Status: Accepted
- Date: 2026-10-15
- Extends: [0062](0062-backlog-items-as-cockburn-use-cases.md), [0106](0106-criticality-and-quality-thresholds.md)

## Context

A backlog item that's too large can't be implemented, reviewed and demoed in one go. A common failure is slicing along layers (domain, persistence, API, UI), so nothing is usable until the last slice is done. Items that mix several criticality levels can't get one mutation threshold (ADR 0106).

## Decision

- **One use case has exactly one criticality.** Parts with different criticality are separate use cases.
- **At most twelve Gherkin scenarios** per use case (main scenario plus extensions). More means the item has to be split.
- Use cases are **sliced vertically**: each slice goes thinly through all layers and is usable on its own. An item doesn't contain its own table of build stages; listing stages means the split already happened inside one item.
- These rules apply during refinement (ADR 0042). How refine slices is part of the refine skill, and how the item format is checked automatically is part of the gate tooling (both in [deferred.md](../deferred.md)).

## Consequences

- Every item can be demoed on its own (ADR 0044).
- More, smaller items in the backlog.
- A layered split still passes the size limits. The limits catch size, not direction; the direction stays a judgment in refine.
- **Rejected:**
  - Recording this only as input for the refine skill, because the rule then exists only once the skill is designed.
  - Vertical slicing and one criticality without a numeric limit, because a size rule without a number can't be checked.
