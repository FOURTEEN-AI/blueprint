# 0105. Test levels and layer disjointness

- Status: Accepted
- Date: 2026-10-15
- Extends: [0039](0039-jgiven-port-to-port-tests-with-in-memory-fakes.md), [0040](0040-playwright-e2e-placement.md), [0101](0101-full-context-api-tests-per-use-case.md)

## Context

ADRs 0039, 0040 and 0101 each add a test level, and 0101 accepts that some behavior is covered at three levels. Nothing says what each level is for, and nothing stops business logic from being tested only from the outside. A rule that's reached only through a browser or a full Spring context is slow to test, hard to diagnose, and easy to miss when the outer test changes.

## Decision

- The test levels and the question each one answers:

  | Level | Question | Tool |
  |---|---|---|
  | Domain objects | Is the rule right? | JGiven, jqwik, no framework |
  | Use case (port to port) | Is the flow right? | JGiven against in-memory fakes (0039) |
  | Adapter | Can the adapter carry everything the port expresses? | JUnit, Testcontainers |
  | API | Do the parts fit together? | `@SpringBootTest` over real HTTP (0101) |
  | Frontend | Does the UI show what the server sends? | Vitest, Testing Library |
  | End to end | Does the built artifact work in a browser? | Playwright (0040) |
  | Structure | Does the code keep its shape? | ArchUnit, Spring Modulith (0008, 0009) |

- **Overlap stays allowed** (0101). The agent picks the level for each scenario during planning and implementation. Requirements carry **no level markers**.
- **Layer disjointness**: an outer level (API, end to end) must never be the *only* level that covers a line in a module's `domain` or `application` package. Coverage is collected separately per level and checked **per Spring Modulith module**. A violation fails the build.
- Questions of look and feel aren't tested. They're judged in `/demo` (ADR 0044).

## Consequences

- Business rules are always tested where they're cheapest to run and easiest to diagnose. A line reached only from outside points to a missing inner test, not to a merit of the outer one.
- A violation names the module it belongs to.
- Coverage has to be collected per level, including the Playwright run against the built JAR. This costs build time, which ADR 0109 measures but doesn't limit.
- How the check is implemented is open ([deferred.md](../deferred.md)).
- **Rejected:**
  - Superseding 0101 so that API tests cover only wiring ("each level tests only what the level below can't"), because 0101's reasons for full use-case coverage over HTTP still hold.
  - Accepting overlap without any disjointness check, because logic tested only through a browser would go unnoticed.
  - Level markers per requirement (backend, frontend, design), because the use-case catalog (0063) has no atomic requirement list to put them on, and disjointness already catches the case that matters.
  - Checking only the `domain` package, or one global check across modules, because use-case logic lives in `application` and a global finding isn't assigned to a module.
