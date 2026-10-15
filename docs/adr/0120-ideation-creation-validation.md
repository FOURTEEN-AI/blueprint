# 0120. The workflow is organized in three parts: ideation, creation, validation

- Status: Accepted
- Date: 2026-10-15
- Extends: [0042](0042-sdlc-skill-chain.md), [0119](0119-loop-routines-and-stages.md)

## Context

The workflow decisions (backlog, skill chain, routines, demo, release, monitoring) are spread over many ADRs. There was no common structure that says which decision belongs where and who acts in each part.

## Decision

The workflow is organized in three parts. New skills, routines, gates and ADRs on the workflow are assigned to one of them.

| Part | Content | Actor |
|---|---|---|
| **Ideation** | Inputs to `inbox/` (ideas, `/demo` feedback, Dependabot major updates, incident items), refine, triage, prioritization | triage routine ([0119](0119-loop-routines-and-stages.md)); humans for inputs |
| **Creation** | plan, implement and review+ship, up to an open PR | item routine ([0119](0119-loop-routines-and-stages.md)) |
| **Validation** | CI, preview, `/demo` including the check of assumptions, auto-merge, release and monitoring | CI and humans ([0044](0044-interactive-demo-and-feedback-triage.md), [0068](0068-demo-flow.md), [0103](0103-demo-enables-auto-merge.md)) |

- **Boundary rule.** Whatever the agent fixes itself belongs to creation, including the review agents in review+ship. Validation consists of what the agent doesn't decide alone.
- **The parts form a cycle.** Feedback from `/demo` and alerts from production become new `inbox/` items ([0068](0068-demo-flow.md), [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)). Those are the handoffs from validation to ideation.
- The **handoffs** between the parts are the backlog folders: `ready/` from ideation to creation, and the open PR from creation to validation.

## Consequences

- Each routine, skill and gate has exactly one home, and its owner is clear.
- Improving one part doesn't need changes in the others as long as the handoffs stay as they are.
- The existing ADRs stay unchanged. This ADR only adds a structure over them.
- **Rejected:** Following the classic SDLC phases (requirements, design, implementation, test, deploy, operate), because they don't match the actors and handoffs of the AI workflow.
