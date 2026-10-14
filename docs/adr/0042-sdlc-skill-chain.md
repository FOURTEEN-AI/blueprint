# 0042. SDLC skill chain: refine, plan, implement, review and ship

- Status: Proposed (details to be designed)
- Date: 2026-10-14

## Context

The autonomous loop (ADR 0046) has to move a backlog item to a merge-ready PR in reproducible steps.

## Decision

Each SDLC stage is its own skill, and the loop chains them:

1. **refine**: turn a backlog item into Gherkin acceptance criteria (ADR 0038). Grill-me style when a human is present, self-questioning when running alone.
2. **plan**: design across modules and onion layers, listing port, spec and migration changes.
3. **implement**: acceptance tests first, then spec, then code, until everything is green, following AGENTS.md.
4. **review + ship**: self-review (code review, architecture rules, expand/contract check), open the PR, watch CI, fix failures, then hand off to `/demo` (ADR 0044).

## Consequences

- Each stage can be improved and tested in isolation.
- The exact contents of each skill are still open and will be decided in follow-up ADRs.
