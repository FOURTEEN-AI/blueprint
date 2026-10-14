# 0068. /demo flow: guided scenarios, exploration and confirmed triage

- Status: Accepted
- Date: 2026-10-14
- Extends: [0044](0044-interactive-demo-and-feedback-triage.md)

## Context

ADR 0044 fixed the purpose of `/demo` (interactive, preview-based, feedback triage) but left the flow open. ADR 0060 defines the `demo` status check, ADR 0061 where feedback is stored.

## Decision

- **Structure: hybrid.**
  1. **Guided phase**: Claude derives steps from the PR's Gherkin criteria. The human walks through them in the preview.
  2. **Exploration phase**: the human tries the preview freely.
- **No Gherkin criteria** (e.g. a bug fix without a backlog item): Claude derives scenarios from the diff and the PR description, including a reproduction of the bug. The human confirms or amends them before the demo starts.
- **Capture**: in the guided phase, each scenario is marked *ok* or *deviating* with a comment. In the exploration phase, Claude records free-text observations as a list.
- **Triage**: Claude shows one table with every item, a proposed class (*blocking* or *backlog*) and a reason. The human corrects outliers and confirms once. Classification rules are those of ADR 0044.
- **Blocking items**: Claude proposes how to proceed based on the extent of the defects, and the human confirms. Options are:
  - fix in the session and repeat only the affected scenarios, plus a short smoke run
  - fix in the session and repeat the whole demo
  - hand the items back to the autonomous loop and demo again later
- **Preview redeploy**: if the preview is expired or missing, `/demo` triggers the preview workflow for the PR head via `workflow_dispatch` and waits for the health check. Deploy logic stays in CI.
- **Multi-client features** (WebSocket): the human uses two browser tabs or devices. Scenarios mark multi-client steps, and Claude says which client does what.
- **Release**: before posting `demo = success` (ADR 0060), Claude shows a checklist: head SHA, scenario results, zero blocking items, backlog items committed to the PR (ADR 0061). After the human's explicit confirmation, Claude verifies that the head SHA is unchanged and then posts the status.

## Consequences

- Demos are reproducible: the guided phase follows the acceptance criteria, the exploration phase catches what they miss.
- The human confirms twice (triage, release), which keeps the gate meaningful at the cost of a few extra interactions.
- Deriving scenarios without Gherkin relies on Claude's reading of the diff, so the human's confirmation step is essential.
- Simulated second clients (e.g. via Playwright) were rejected: real devices catch more, and no extra tooling is needed. Posting statuses without an explicit confirmation was rejected because the gate is meant to prove human presence.
- Deploying the preview from the local session with `flyctl` was rejected: it would duplicate CI's deploy logic.
