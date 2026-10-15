# 0034. Code quality and security tooling

- Status: Accepted (thresholds decided in [0106](0106-criticality-and-quality-thresholds.md))
- Date: 2026-10-14

## Context

AI agents produce a lot of code. Fast, automated feedback catches problems more reliably than reviews.

## Decision

Enforced locally (hooks) and in CI:

- **Java**: Spotless (formatting), Error Prone with NullAway, and JaCoCo coverage.
- **TypeScript**: strict mode, ESLint and Prettier.
- **Commits**: commitlint (ADR 0032).
- **Architecture**: ArchUnit and Spring Modulith verification (ADR 0008/0009).
- **SonarCloud** quality gate (free for public repositories).
- **CodeQL** code scanning for Java and JavaScript/TypeScript.

Concrete coverage thresholds (e.g. a percentage on new code, mutation testing) are **not yet decided**.

## Consequences

- Many independent gates, so a red build is common while an agent iterates. The CI feedback loop (ADR 0031) handles that.
- SonarCloud needs a project and a `SONAR_TOKEN`, both set up by `/bootstrap`.
