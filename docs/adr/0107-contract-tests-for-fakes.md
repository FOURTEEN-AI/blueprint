# 0107. Contract tests for every in-memory fake

- Status: Accepted
- Date: 2026-10-15
- Extends: [0039](0039-jgiven-port-to-port-tests-with-in-memory-fakes.md) (makes its optional contract tests mandatory)

## Context

ADR 0039 runs use-case tests against in-memory fakes and says shared contract tests *can* keep fakes behaving like the real adapters. A fake that's more lenient than reality hides bugs. A typical case: a fake repository hands out the instance it stored, so a read-modify-write cycle can never lose an update, and a lost update in the real adapter stays invisible at the use-case level.

## Decision

- Every outbound port has an **abstract contract test class**. Both the in-memory fake and the real adapter (on Testcontainers) extend it. A fake without a contract test fails the build.
- **A fake must never be more lenient than reality** where the tested promise is concerned. For example, fake repositories return copies, never the stored instance.
- **Concurrency is tested without threads.** Where requests can interleave, the test writes out the interleaving (both callers read, then both write) instead of waiting for a real race.

## Consequences

- Use-case tests stay fast and still mean something, because the fakes are tested against the same expectations as the real adapters.
- Every new outbound port costs one contract test class.
- Race conditions are reproducible instead of flaky, which ADR 0109 requires anyway.
- **Rejected:**
  - Contract tests only for ports used by `MEDIUM` or `HIGH` use cases, because a lenient fake hides bugs regardless of criticality.
  - Contract tests as a recommendation, because nothing would enforce it.
  - Tests with real threads, because they hit the race only sometimes.
