# 0106. Criticality and quality thresholds

- Status: Accepted
- Date: 2026-10-15
- Extends: [0034](0034-code-quality-and-security-tooling.md) (decides its open thresholds), [0062](0062-backlog-items-as-cockburn-use-cases.md), [0063](0063-living-use-case-catalog-and-jgiven-report.md), [0021](0021-sample-features.md)

## Context

ADR 0034 left the coverage thresholds open. A single percentage treats a typo in a label like an error in a calculation. It also produces tests written for the number. Mutation testing (PIT) finds tests that don't actually check anything, but running it on everything is slow.

## Decision

- Every use case has a **criticality**, `LOW`, `MEDIUM` or `HIGH`, judged as likelihood × impact during refinement.

  | Level | Requirement |
  |---|---|
  | `LOW` | Every main scenario and extension has a tagged test (0063). |
  | `MEDIUM` | Additionally, every public method of the involved classes is reached by at least one domain-object or use-case test. |
  | `HIGH` | Additionally, a **mutation score of at least 99 %** on the involved classes. |

- **The use case leads**: the catalog entry's frontmatter holds the criticality and the reason for it.
- A **`@Criticality(level, useCases)`** annotation on classes or methods is the machine-readable handle. The PIT target set is derived from these annotations, never from a hand-kept list. A check verifies that every use-case ID in an annotation exists and that the levels match.
- PIT runs only the domain-object and use-case tests.
- **An empty target set is allowed** while the catalog has no `HIGH` use case. A `HIGH` use case without an annotated class fails the build.
- The **sample feature** contains one small `HIGH` use case, so blueprint's own CI (ADR 0049) exercises the mutation, criticality and disjointness checks. `/bootstrap` removes it with the sample.
- The threshold is 99 %, not 100 %, because equivalent mutants exist. Each one is listed in the exceptions register (ADR 0110).
- JaCoCo line and branch coverage is **collected and published, with no threshold**. SonarCloud's quality gate doesn't add a coverage condition on top.

## Consequences

- Test effort follows the damage a bug can do.
- The PIT configuration can't drift from the classification, because there's no second list.
- A freshly bootstrapped project starts green, and a classification without a target is still caught.
- Refinement (ADR 0042) has to judge the criticality of every use case.
- **Rejected:**
  - PIT across all `domain` and `application` classes with one fixed score, because it's slow and treats all code alike.
  - A SonarCloud percentage on new code, alone or on top, because coverage as a target produces tests written for the number.
  - Criticality only as an annotation in code, because the reason belongs with the use case. Only in the use case, because mapping use-case tags back to classes for PIT is indirect and fragile.
  - Failing on an empty target set, because every bootstrapped project would start red.
  - Keeping the sample at `LOW`, because the mutation chain would never run in blueprint's own CI.
