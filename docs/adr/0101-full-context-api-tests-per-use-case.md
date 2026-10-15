# 0101. Full-context API tests per use case

- Status: Accepted
- Date: 2026-10-15
- Extends: [0038](0038-acceptance-test-first.md), [0039](0039-jgiven-port-to-port-tests-with-in-memory-fakes.md)

## Context

JGiven scenarios run against in-memory fakes without Spring (ADR 0039), adapters get Testcontainers tests, and Playwright tests the whole app end to end (ADR 0040). Nothing in between tests the web adapter (generated interfaces, mapping, validation, error responses) together with the real Spring wiring, short of a browser.

## Decision

- Every use case gets **full-context API tests**: `@SpringBootTest` with PostgreSQL from Testcontainers, called over **real HTTP** against the generated API.
- They cover at least the use case's **main scenario**, and carry the use-case ID like the other tests (ADR 0063).
- The rest of the testing strategy (coverage thresholds, test data, fakes versus contract tests, naming) is still open ([deferred.md](../deferred.md)).

## Consequences

- Wiring, serialization, validation and error handling are tested per use case without a browser.
- Some behavior is covered at three levels (JGiven, API, Playwright). That overlap is accepted.
- These tests need Docker and are slower than JGiven, so they run in the full build and in CI.
- **Rejected:**
  - `@WebMvcTest` slices with mocked ports plus a single context test, because wiring errors would surface only in Playwright.
  - Running the JGiven scenarios a second time against the full context, because the stages would need an abstraction over both modes.
