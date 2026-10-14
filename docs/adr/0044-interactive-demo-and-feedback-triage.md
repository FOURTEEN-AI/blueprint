# 0044. Interactive /demo with feedback triage

- Status: Accepted (skill details to be designed)
- Date: 2026-10-14

## Context

Humans review behavior rather than code (ADR 0043). Their feedback should improve the product without blocking delivery unnecessarily.

## Decision

- **`/demo`** runs **interactively in the terminal**. Claude guides the human through the PR's **preview app** (ADR 0027), redeploying it first if the TTL has expired.
- Claude **sorts the feedback**, and the human confirms the result:
  - **Blocking**: broken or wrong behavior, a data or security risk, a UX regression, or anything the human explicitly marks as blocking. Claude updates the PR, and the demo repeats.
  - **Everything else** (ideas, polish, nice-to-haves) goes to the **in-repo backlog** (ADR 0045), and the PR is merged.

## Consequences

- Feedback flows back into the SDLC instead of stalling PRs.
- Demos need a human session, which is the throughput bottleneck the work-in-progress limit accounts for (ADR 0046).
