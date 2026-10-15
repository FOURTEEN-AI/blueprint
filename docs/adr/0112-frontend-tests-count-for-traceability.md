# 0112. Frontend tests count for traceability

- Status: Accepted
- Date: 2026-10-15
- Extends: [0063](0063-living-use-case-catalog-and-jgiven-report.md) (adds Vitest to the tagged test kinds), [0105](0105-test-levels-and-layer-disjointness.md)

## Context

ADR 0063 defines use-case tags for JGiven and Playwright only. An extension that only affects the UI, such as showing a hint, could then be traced only through a Playwright test, even when a Vitest test checks it faster and more precisely. ADR 0105 lists the frontend level but doesn't say how its tests are driven.

## Decision

- **Vitest tests carry use-case IDs** like the other test kinds, e.g. through a small helper `useCase('UC-012', '3a', …)` that sets the test title and tag.
- The **traceability check** (ADR 0063) reads JGiven, Playwright and Vitest. A main scenario or extension is covered if any of them carries its ID.
- **Frontend tests are driven through the data interface**: the API client is replaced, and the test hands in server data in the shape it arrives over the wire. Each test is "server data in, visible output out". The frontend level checks only that projection. Server-side rules (who may see what, what's computed) stay on the backend levels.

## Consequences

- A UI-only extension can be traced with a fast component test instead of a browser test.
- The ID check has to parse three test formats.
- Frontend tests don't repeat backend rules, so a frontend test can't mask a missing backend test (see ADR 0105).
- **Rejected:**
  - UI-only extensions traced only through Playwright, because a browser test is slower and less precise for a single component.
  - Vitest tags for the report only, without counting for traceability, because they would carry an ID that proves nothing.
