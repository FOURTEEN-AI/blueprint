# 0109. Test hygiene: no retries, no sleeps, data through legal transitions

- Status: Accepted
- Date: 2026-10-15
- Extends: [0040](0040-playwright-e2e-placement.md) (no retries for the smoke tests either), [0102](0102-format-on-edit-and-full-build-stop-hook.md)

## Context

Agents iterate on test results. A flaky test teaches them to retry instead of to fix, and a retry policy turns flakiness into an accepted state. Test data built through shortcuts describes states that can't occur in production, and shared fixtures make tests depend on each other.

## Decision

- **No retries**, on any level, including the smoke tests against production. A flaky test is a failure. A flaky smoke test triggers the automatic rollback (ADR 0029), and that's intended: the test is broken.
- **No `sleep`.** Tests wait for a state, with a timeout.
- **Databases always come from Testcontainers**, on every level including end to end. No `docker run` in scripts.
- **Test data is built only through legal transitions**: inbound ports or domain transitions, never setters or direct inserts. Adapter tests are the exception: they build their input from the port's data types, so they don't add domain coverage.
- **No shared fixtures** between tests. Each test starts from an empty database (truncated before each test, one container per JVM run).
- **No fixed time budget.** Build and test duration is measured and reported.

## Consequences

- Red means broken, on every level.
- A smoke test against production has to be robust against cold starts (ADR 0023) by waiting for state, not by retrying.
- Without a time budget, a slow stop hook (ADR 0102) needs a new decision rather than an automatic cut in test scope.
- **Rejected:**
  - One retry for production smoke tests, because a retry hides exactly the instability the rollback should react to.
  - Retries with a warning, because warnings get ignored.
  - Test data builders with free defaults, because they allow states production can't reach.
  - A fixed time budget, because it would force cuts in coverage before anyone knows where the time goes.
