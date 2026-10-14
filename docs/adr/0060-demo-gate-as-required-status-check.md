# 0060. Demo gate as a required status check posted with the human's credentials

- Status: Accepted
- Date: 2026-10-14
- Extends: [0043](0043-autonomous-merge-gated-by-demo.md), [0044](0044-interactive-demo-and-feedback-triage.md)

## Context

ADR 0043 requires a passed demo for `feat`/`fix` PRs (ADR 0057), but nothing enforced it technically. A gate that the agent can open itself provides no protection.

## Decision

- **`demo`** is a required commit status on `main`.
- For PRs whose title type doesn't need a demo, a workflow posts `demo = success` automatically. For `feat`/`fix` PRs it posts `pending`.
- **`/demo`** posts `demo = success` for the PR's **head commit** once the demo passes. Every new push therefore resets the gate.
- The status is posted **with the human's own GitHub credentials** from the interactive session. The autonomous loop's token has **no "commit statuses" permission**, so it can't open the gate itself.

## Consequences

- A demo-requiring PR can't be merged without a human having been present in a `/demo` session.
- Pushing feedback items into the demoed PR (ADR 0061) happens **before** the status is posted, so the final commit is the demoed one.
- Token permissions are part of the security model, and `/bootstrap` has to set them up correctly.
