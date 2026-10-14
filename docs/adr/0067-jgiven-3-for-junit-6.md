# 0067. JGiven 3.x for JUnit 6 and Spring 7

- Status: Accepted
- Date: 2026-10-14
- Extends: [0039](0039-jgiven-port-to-port-tests-with-in-memory-fakes.md)

## Context

Spring Boot 4 comes with Spring Framework 7 and JUnit 6. JGiven 2.0.x doesn't support JUnit 6, and projects migrating to Boot 4 have reported errors with it.

## Decision

Use **JGiven 3.x** with the **`jgiven-junit6`** module, and **`jgiven-spring-junit6`** where a Spring test context is needed. JGiven 3.x requires Java 21 or later.

## Consequences

- JGiven works with the chosen stack.
- Java 25 is implied by JGiven's Java 21 minimum but not explicitly confirmed. Verify it during implementation.
- For comparison, Error Prone/NullAway were confirmed to run on JDK 25, which is even recommended for NullAway's JSpecify mode (ADR 0034).
