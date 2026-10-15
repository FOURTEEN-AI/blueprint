# Testing strategy (draft)

- Status: Draft, input for ADRs
- Date: 2026-10-15

This draft resolves topic 1 of [deferred.md](deferred.md) as a whole. Once reviewed, it's split into ADRs (see [Planned ADRs](#planned-adrs)), the topic is removed from `deferred.md`, and this file is deleted. Until then, the accepted ADRs win wherever they disagree with this draft.

It builds on the decisions already made: acceptance tests first ([0038](adr/0038-acceptance-test-first.md)), JGiven port-to-port tests against in-memory fakes ([0039](adr/0039-jgiven-port-to-port-tests-with-in-memory-fakes.md), [0067](adr/0067-jgiven-3-for-junit-6.md)), Playwright placement ([0040](adr/0040-playwright-e2e-placement.md)), use-case tags and traceability ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md)), quality tooling ([0034](adr/0034-code-quality-and-security-tooling.md)), infrastructure smoke tests ([0092](adr/0092-infrastructure-smoke-tests.md)), full-context API tests ([0101](adr/0101-full-context-api-tests-per-use-case.md)) and the full-build stop hook ([0102](adr/0102-format-on-edit-and-full-build-stop-hook.md)).

The draft states rules, not tools. How each rule is enforced (an existing plugin, a convention plugin in this repository, or standard tooling) is decided separately.

## 1. Test levels

| Level | Question | Tool | Runs against |
|---|---|---|---|
| Domain objects | Is the rule right? | JGiven, jqwik | Domain classes, no framework |
| Use case (port to port) | Is the flow right? | JGiven | Inbound ports, in-memory fakes ([0039](adr/0039-jgiven-port-to-port-tests-with-in-memory-fakes.md)) |
| Adapter | Can the adapter carry everything the port expresses? | JUnit, Testcontainers | One adapter, real infrastructure |
| API | Do the parts fit together? | `@SpringBootTest`, real HTTP ([0101](adr/0101-full-context-api-tests-per-use-case.md)) | Full context, PostgreSQL from Testcontainers |
| Frontend | Does the UI show what the server sends? | Vitest, Testing Library | Components with the API client replaced |
| End to end | Does the built artifact work in a browser? | Playwright ([0040](adr/0040-playwright-e2e-placement.md)) | Built JAR, previews, production (smoke) |
| Structure | Does the code keep its shape? | ArchUnit, Spring Modulith ([0008](adr/0008-modulith-modules-with-onion-layers.md), [0009](adr/0009-strict-domain-core-enforced-by-archunit.md)) | Compiled classes |

**Overlap is allowed** ([0101](adr/0101-full-context-api-tests-per-use-case.md)). The planning and implementing agent picks the level for each scenario. There are no per-requirement level markers.

**Layer disjointness.** An outer level (API, end to end) must never be the *only* level that covers a line in a module's `domain` or `application` package. Coverage is collected separately per level, and the check runs **per Modulith module**. A line reached only from outside is a gap further in, not a merit of the outer level. This catches backend logic that slipped past JGiven without forbidding overlap.

Questions of look and feel aren't tested. They're judged in `/demo` ([0044](adr/0044-interactive-demo-and-feedback-triage.md)).

## 2. Criticality and thresholds

Every use case has a **criticality**: `LOW`, `MEDIUM` or `HIGH`, judged as likelihood × impact during refinement.

| Level | Requirement |
|---|---|
| `LOW` | Every main scenario and extension has a tagged test ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md)). |
| `MEDIUM` | Additionally, every public method of the involved classes is reached by at least one domain-object or use-case test. |
| `HIGH` | Additionally, a **mutation score of at least 99 %** (PIT) on the involved classes. |

- The **use case leads**: its criticality and the reason for it are in the catalog entry's frontmatter (`docs/use-cases/UC-xxx-<slug>.md`).
- A `@Criticality(level, useCases)` annotation on classes or methods is the **machine-readable handle** for the mutation run. The PIT target set is derived from these annotations, never from a hand-kept list.
- A check compares both sides: every use-case ID in an annotation exists, and the levels match.
- PIT runs only the fast levels (domain objects and use case).
- **The target set may be empty** as long as the catalog has no `HIGH` use case. A `HIGH` use case without any annotated class fails the build. That way a freshly bootstrapped project starts green, and a classification without a target is still caught.
- **The sample feature** ([0021](adr/0021-sample-features.md)) contains one small `HIGH` use case, so blueprint's own CI ([0049](adr/0049-template-self-test-scope.md)) runs the mutation, criticality and disjointness checks. `/bootstrap` removes it with the sample.
- 99 %, not 100 %, because equivalent mutants exist. Each one is named and justified in the exceptions register (section 6).
- JaCoCo line and branch coverage is **collected and published, with no threshold**. As a target, coverage produces tests written for the number. As a search aid, it shows forgotten error paths.

This resolves the open thresholds in [0034](adr/0034-code-quality-and-security-tooling.md).

## 3. Fakes and contract tests

[0039](adr/0039-jgiven-port-to-port-tests-with-in-memory-fakes.md) says shared contract tests *can* keep fakes honest. This draft makes them **mandatory**:

- Every outbound port has an abstract contract test class. Both the in-memory fake and the real adapter (on Testcontainers) extend it.
- A fake without a contract test fails the build.
- **A fake must never be more lenient than reality** where the tested promise is concerned. For example, a fake repository returns copies, never the instance it stored. Otherwise a lost update in a read-modify-write cycle is invisible at the use-case level.
- **Concurrency is tested without threads.** Where requests can interleave, the test writes out the interleaving (both callers read, then both write) instead of waiting for a real race. Real threads would hit the case only sometimes, which makes a flaky test (section 5).

## 4. Visibility rules, invariants and properties

The use-case catalog entry gets two optional sections. If one is filled in, the matching tests are mandatory.

**Visibility rules**: something must *not* be visible to someone (e.g. another user's answer before a deadline).
- Leak tests check the **output surface**, not the requirements: every field of every response in the restricted state must be on an allow list. An unknown field fails, even if nobody knows what it is.
- Two levels are needed: at the port (cheap, early) and on the serialized HTTP/WebSocket JSON (catches what only serialization adds).
- Each leak test has a **counter-check** after the restriction ends. Otherwise a field that's always empty would pass.

**Invariants**: something holds after every step (e.g. a sum is preserved, nothing goes negative).
- Every use-case scenario of that module checks the invariants **after each step**.
- Each invariant also gets a **property test** (jqwik), because examples never prove a universal statement.

jqwik is part of the template.

## 5. Test hygiene

- **No retries**, on any level, including the smoke tests against production. A flaky test is a failure. A flaky smoke test triggers the rollback ([0029](adr/0029-pre-migration-neon-snapshots-and-auto-rollback.md)), and that's intended: the test is broken.
- **No `sleep`.** Tests wait for a state, with a timeout.
- **Databases always come from Testcontainers**, on every level including end to end. No `docker run` in scripts.
- **Test data is built only through legal transitions**: inbound ports or domain transitions, never setters or direct inserts. A state reachable only through a setter doesn't exist in production. Exception: adapter tests build their input from the port's data types, so that they don't add domain coverage.
- **No shared fixtures** between tests. Each test gets a fresh database (truncated before each test, one container per JVM run).
- **No fixed time budget.** Build and test duration is measured and reported. If the stop hook ([0102](adr/0102-format-on-edit-and-full-build-stop-hook.md)) gets too slow, that's a new decision.

## 6. Exceptions register

Every suppression is listed in `docs/test-exceptions.md` with a reason and a date:

- equivalent mutants
- disabled tests (`@Disabled`, Playwright `test.skip`/`test.fixme`)
- any other deliberate gap

A check compares the register and the code **in both directions**: a suppression without an entry fails, and so does an entry without a suppression.

The smoke tests from [0092](adr/0092-infrastructure-smoke-tests.md) stay exempt from traceability through their `@smoke` tag, not through the register.

## 7. Naming and report

**Scenario wording** uses only terms from the use-case catalog: no class names, no IDs, no JSON. The report is public documentation ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md)).

**JGiven stage classes** live in a dedicated package per module. ArchUnit checks that every stage is there.

**Plain unit test methods** are named `should_<result>_when_<condition>`.

**The JGiven report has two parts**:

1. **Domain objects**: domain-object tests written in JGiven and tagged `@DomainObject`. They form the executable glossary of the domain language.
2. **Use cases**: grouped by `@UseCase` and `@Extension`, as in [0063](adr/0063-living-use-case-catalog-and-jgiven-report.md).

[0009](adr/0009-strict-domain-core-enforced-by-archunit.md) says domain tests are "plain unit tests with no framework". This draft reads that as *no application framework* (no Spring). JGiven is a test library and is allowed. The ADR for this section has to state that reading explicitly.

## Planned ADRs

| ADR | Content | Relation |
|---|---|---|
| Test levels and layer disjointness | Section 1 | Extends 0101, 0039, 0040 |
| Criticality and quality thresholds | Section 2 | Extends 0034, 0062, 0063, 0021 |
| Contract tests for fakes | Section 3 | Extends 0039 |
| Visibility rules and invariants in use cases | Section 4 | Extends 0062, 0063 |
| Test hygiene | Section 5 | Extends 0040 |
| Test exceptions register | Section 6 | Extends 0092 |
| Test naming and report structure | Section 7 | Extends 0063, reading of 0009 |

After that: remove topic 1 from `deferred.md`, update the status line of 0034, and add a new deferred topic **Gate tooling** (how the checks above are implemented).

## To verify

- JaCoCo coverage per level, including the Playwright run against the built JAR (JaCoCo agent on the JAR), as input for layer disjointness.
- PIT with Java 25, JUnit 6 and JGiven 3.x ([0067](adr/0067-jgiven-3-for-junit-6.md)).
- jqwik with JUnit 6.
