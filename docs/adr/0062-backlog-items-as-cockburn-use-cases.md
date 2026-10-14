# 0062. Backlog items as Cockburn use cases with a security impact section

- Status: Accepted
- Date: 2026-10-14

## Context

Items have to be easy to write (often from demo feedback) yet precise enough for agents to implement autonomously. Alistair Cockburn's use-case forms range from *casual* to *fully dressed*. Their main success scenario and extensions map naturally to Gherkin scenarios (ADR 0038).

## Decision

- Every item has **frontmatter**: id, title, type, priority, source (e.g. "demo of PR #n"), created.
- **Feature items** (`feat`) are Cockburn use cases:
  - In `inbox/` they are **casual**: title, primary actor, goal level, a short main success scenario and extensions.
  - The **refine** skill expands them to **fully dressed** before they move to `ready/`: primary actor, scope, goal level, stakeholders and interests, preconditions, minimal and success guarantees, trigger, a numbered main success scenario, and extensions. It also adds Gherkin acceptance criteria derived from the scenario and extensions.
- **Bug items** (`fix`) reference the affected use case and step, and describe the reproduction as a **failing Gherkin scenario**.
- **Chore items** state the goal and the done criteria.
- **Every item type** has a **security impact** section, filled in no later than refinement.

## Consequences

- Agents get a structured, complete specification. Humans can still write a quick casual item.
- Security is considered explicitly for every change.
- The templates live in `backlog/` and are used by refine and `/demo`.
