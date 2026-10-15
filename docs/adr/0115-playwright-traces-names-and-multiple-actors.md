# 0115. Playwright: traces, fixed names and one context per actor

- Status: Accepted
- Date: 2026-10-15
- Extends: [0040](0040-playwright-e2e-placement.md)

## Context

ADR 0040 says where Playwright runs, but not how its runs are recorded or how scenarios with several people are driven. A failed run without a trace is hard to diagnose, especially for an agent that wasn't watching. Names with timestamps make reports and traces hard to read. Use cases with several actors, such as one person changing something another sees live, can't be tested in a single browser.

## Decision

- **Traces are always recorded** and kept as a CI artifact. They serve debugging and `/demo` (ADR 0044). **Video** is recorded on failure only.
- Scenarios use **fixed, meaningful names** ("Anna", "Ben", "Team notes"), not timestamps. Independence between runs comes from the fresh database (ADR 0109), not from throwaway names. Smoke tests against production still follow ADR 0040 (read-only or cleaning up).
- A use case with **several actors** runs with **one browser context per actor**.

## Consequences

- Every run, green or red, can be replayed step by step.
- Traces take storage in CI artifacts.
- Live updates between devices (ADR 0018) are tested where they actually happen: in a second browser.
- **Rejected:**
  - Video always on plus a slowed-down, visible presentation mode, because `/demo` on the preview already serves presentation.
  - Only the multiple-context rule, with Playwright's default artifacts, because a green run would leave nothing to look at.
  - None of it, because a failed end-to-end run without a trace costs the most time to diagnose.
