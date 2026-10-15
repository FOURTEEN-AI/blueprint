# 0117. "Observed, not tested" in use cases

- Status: Accepted
- Date: 2026-10-15
- Extends: [0063](0063-living-use-case-catalog-and-jgiven-report.md) (adds an exemption from traceability), [0108](0108-visibility-rules-and-invariants-in-use-cases.md) (adds a third optional section, and records why leak tests run at two levels)

## Context

Some behavior can be observed only in operation: real devices, a cold start (ADR 0023), real networks. Writing a test that pretends to check it would add false confidence. Leaving it out silently would either fail traceability (ADR 0063) or, worse, pass because some unrelated test carries the ID.

ADR 0108 requires leak tests at two levels without saying why one isn't enough.

## Decision

- The use-case template gets a third optional section: **Observed, not tested**. It lists behavior that's checked by watching, in `/demo` (ADR 0044) or through telemetry (ADR 0069).
- Entries there are **exempt from traceability**, and the JGiven report shows them as a **separate category that's never green**.
- Why leak tests (ADR 0108) run at two levels:
  - **at the port**, to find the leak early and cheaply, where the projection is built
  - **on the serialized JSON**, to find what only serialization adds, such as a getter picked up by Jackson

## Consequences

- "Observed" and "tested" can't be confused: a green report means tested.
- Each entry is a standing reminder to watch something in `/demo` or in production.
- **Rejected:**
  - Listing such behavior in the exceptions register (ADR 0110), because it's not a gap in a test but a property no test can check.
  - No rule, because the distinction between observed and tested would get lost.
