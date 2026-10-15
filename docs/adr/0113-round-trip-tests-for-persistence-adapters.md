# 0113. Round-trip tests for persistence adapters

- Status: Accepted
- Date: 2026-10-15
- Extends: [0010](0010-spring-data-jpa-with-hand-written-mappers.md), [0105](0105-test-levels-and-layer-disjointness.md)

## Context

With hand-written mappers between domain objects and JPA entities (ADR 0010), a field added to a domain object can be forgotten in the entity or the mapper. No use-case scenario notices: the scenarios run against fakes (ADR 0039), and the ones that touch the field rarely check that it survives a reload. Completeness is a structural property, not an example.

## Decision

- Every persistence adapter has a **round-trip test** against PostgreSQL from Testcontainers: save, load, compare.
- The object under test is **fully populated**: every field has a non-default value.
- The comparison is **recursive and field by field** (e.g. AssertJ `usingRecursiveComparison()`), so a new field without a mapping fails the test.
- This applies to **persistence** only. API mappers are excluded, because a response may deliberately omit fields (ADR 0108).

## Consequences

- A forgotten mapping fails the build, without anyone having to remember the field.
- Test data builders for these tests must set every field. That's the point, and it's the one place where building an object directly, not through legal transitions (ADR 0109), is intended: the adapter test works at the port's data types.
- **Rejected:**
  - A round trip inside the contract tests (ADR 0107), because it would also run against the fake, where it proves nothing about mapping.
  - Mapper unit tests without a database, because they miss JPA's own behavior (column mapping, converters).
  - No rule, because the gap isn't visible in review.
