# 0111. Test naming and the two-part JGiven report

- Status: Accepted
- Date: 2026-10-15
- Extends: [0063](0063-living-use-case-catalog-and-jgiven-report.md), [0009](0009-strict-domain-core-enforced-by-archunit.md) (reads its "no framework" for domain tests as no application framework)

## Context

The JGiven report is public documentation (ADR 0063). It's only useful if a reader who knows the use cases but not the code can follow it. ADR 0063 groups the report by use case, so the domain language itself, the terms the use cases are written in, appears nowhere as a whole. ADR 0009 says domain tests are "plain unit tests with no framework".

## Decision

- **Scenario wording** uses only terms from the use-case catalog: no class names, no IDs, no JSON.
- **JGiven stage classes** live in a dedicated package per module. ArchUnit checks that every stage is there.
- **Plain unit test methods** are named `should_<result>_when_<condition>`.
- **The JGiven report has two parts**:
  1. **Domain objects**: domain-object tests written in JGiven and tagged `@DomainObject`. They form the executable glossary of the domain language.
  2. **Use cases**: grouped by `@UseCase` and `@Extension`, as in ADR 0063.
- ADR 0009's "no framework" means **no application framework** (no Spring, no JPA). JGiven is a test library and is allowed in domain tests.

## Consequences

- The report explains the domain's terms before it shows the flows that use them.
- Domain tests use JGiven, which is more verbose than plain JUnit.
- Wording stays a review rule. Only the stage location is checked automatically.
- **Rejected:**
  - Wording as a review rule only, without a fixed stage location, because nothing would keep stages together.
  - Test method names equal to the scenario title as the only rule, because it says nothing about the vocabulary.
  - A report with use cases only, because the domain language would have no place in it.
  - Domain-object scenarios only for `HIGH` use cases, because the glossary would have gaps.
