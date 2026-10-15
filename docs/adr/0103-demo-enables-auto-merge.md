# 0103. /demo enables auto-merge after a passed demo

- Status: Accepted
- Date: 2026-10-15
- Extends: [0043](0043-autonomous-merge-gated-by-demo.md), [0068](0068-demo-flow.md)

## Context

ADR 0043 lets Claude merge once the checks are green and the demo has passed, and ADR 0068 ends `/demo` with posting `demo = success`. Who then merges was open: the `/demo` session, or the loop on its next run.

## Decision

Right after posting `demo = success`, `/demo` **enables GitHub auto-merge** (squash) on the PR, with the human's credentials. GitHub merges once all required checks are green.

## Consequences

- No waiting for the next loop run, and the WIP slot (ADR 0046) frees up as soon as the PR merges.
- The human doesn't have to wait in the session for CI.
- The merge is attributed to the human who ran the demo, and it triggers the release like any other merge.
- **Rejected:**
  - `/demo` merging directly, because the session would have to wait for CI.
  - The loop merging on its next run, because it delays the release by up to one loop interval.
