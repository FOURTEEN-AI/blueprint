# 0038. Acceptance-test-first development with Gherkin criteria

- Status: Accepted
- Date: 2026-10-14

## Context

Agents need an unambiguous definition of done for every backlog item. The options were strict TDD, acceptance-test first, or tests in the same PR without a required order.

## Decision

- Each backlog item gets **acceptance criteria written in Gherkin** (Given/When/Then) during refinement.
- Implementation starts by turning those criteria into **failing tests**:
  - **Playwright** tests for end-to-end behavior (ADR 0040)
  - **JGiven** port-to-port scenarios for backend behavior (ADR 0039)
- Unit tests (JUnit for the domain, Vitest + Testing Library for the frontend) are added as needed.
- There's no Cucumber runtime. Gherkin is the specification, and the agent translates it into test code.

## Consequences

- Every feature has an executable definition of done, traceable to its backlog item.
- The refine and implement skills (ADR 0042) carry this workflow.
