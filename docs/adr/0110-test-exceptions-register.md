# 0110. Test exceptions register

- Status: Accepted
- Date: 2026-10-15
- Extends: [0063](0063-living-use-case-catalog-and-jgiven-report.md), [0106](0106-criticality-and-quality-thresholds.md)

## Context

Some gaps are legitimate: equivalent mutants can't be killed (ADR 0106), and a test may have to be disabled for a while. Unrecorded, such suppressions become invisible, and nobody knows whether the reason still holds.

## Decision

- Every suppression is listed in **`docs/test-exceptions.md`** with a reason and a date:
  - equivalent mutants
  - disabled tests (`@Disabled`, Playwright `test.skip` and `test.fixme`)
  - any other deliberate gap in traceability or thresholds
- A check compares the register and the code **in both directions**. A suppression without an entry fails the build, and so does an entry without a suppression.
- The infrastructure smoke tests stay exempt from traceability through their `@smoke` tag (ADR 0092), not through the register.

## Consequences

- Every gap has one place where it's explained, and stale entries are caught.
- Equivalent mutants are named instead of being hidden in the 1 % tolerance.
- **Rejected:**
  - A reason only at the suppression in the code, because there's no overview and nothing catches a stale reason.
  - Forbidding suppressions entirely, because equivalent mutants are unavoidable.
