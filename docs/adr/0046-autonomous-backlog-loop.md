# 0046. Autonomous backlog loop as a scheduled cloud agent, WIP limit 1

- Status: Accepted
- Date: 2026-10-14

## Context

Work should keep moving without a human starting each item. The loop could run in a local session (`/loop`), in GitHub Actions, or as a scheduled cloud agent.

## Decision

- A **scheduled Claude Code cloud agent** (routine) runs the loop. It **triages and prioritizes** `inbox/` on its own, picks the next item and runs the SDLC skill chain (ADR 0042).
- **At most one PR** may wait for a demo at any time. While one is waiting, the loop does no new work.

## Consequences

- No machine has to stay on.
- Sequential work avoids merge conflicts and keeps preview costs low.
- Throughput is bounded by how often humans run `/demo`.
