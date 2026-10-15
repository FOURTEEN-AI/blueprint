# 0092. Infrastructure smoke tests survive bootstrap

- Status: Accepted
- Date: 2026-10-15
- Extends: [0021](0021-sample-features.md), [0040](0040-playwright-e2e-placement.md), [0063](0063-living-use-case-catalog-and-jgiven-report.md)

## Context

`/bootstrap` removes the sample feature (ADR 0021) along with its tests. A generated project would then have no smoke tests. Playwright fails when it finds no tests, and the automatic rollback (ADR 0029) would have nothing to trigger on.

ADR 0036 says smoke tests can rely on the health endpoints, but ADR 0077 made those internal-only, and smoke tests run through the public URL.

## Decision

- Smoke tests for the kept infrastructure are part of the template and **survive `/bootstrap`**:
  - the SPA shell loads
  - a session can be obtained (through the bypass header in production, ADR 0053)
  - the WebSocket connects and the UI shows the live state
- They are tagged `@smoke` and **exempt from the use-case traceability check** (ADR 0063), because they test infrastructure, not a use case.
- Smoke tests check behavior through the public URL. They don't use the Actuator endpoints.

## Consequences

- Every generated project has a working rollback trigger from its first deploy.
- The most common broken deploys (app doesn't start, no session, no WebSocket) are caught everywhere.
- **Rejected:**
  - A single "app loads" test, because it misses broken sessions and WebSockets.
  - Running Playwright with `--pass-with-no-tests`, because rollback would have no trigger until the first feature.
