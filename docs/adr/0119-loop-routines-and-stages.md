# 0119. Two loop routines, and the contents of the stages

- Status: Accepted (schedules, start rules and item choice replaced by [0123](0123-pr-kinds-and-dispatch.md))
- Date: 2026-10-15
- Extends: [0118](0118-loop-orchestration.md) (splits its single routine in two), [0042](0042-sdlc-skill-chain.md), [0046](0046-autonomous-backlog-loop.md), [0062](0062-backlog-items-as-cockburn-use-cases.md)

## Context

ADR 0118 fixes how one loop run is orchestrated, but assumes a single routine that does triage and item work. It leaves open what each stage does. Refine runs during triage ([0062](0062-backlog-items-as-cockburn-use-cases.md)), the WIP limit applies only to item work, and incidents are exempt from it ([0070](0070-incident-items-exempt-from-wip-limit.md)).

## Decision

### Two routines

- **Triage routine.** It runs refine on `inbox/` items and moves them to `ready/` or `rejected/` in its own `chore` PR ([0074](0074-implemented-backlog-items-are-deleted.md)). It is not subject to the WIP limit. It runs **daily**, and a workflow also starts it when a push to `main` changes `inbox/`.
- **Item routine.** It runs plan, implement and review+ship for one item. It runs **hourly** and after every merge of a loop PR (ADR 0118).
- Both routines use the failure path, the stage state file and the skill-scoped gates from ADR 0118.

### Choosing the item

The item routine's first steps are scripts, not model judgement:

1. If `ready/` contains an incident item, work on it, even if a loop PR is open ([0070](0070-incident-items-exempt-from-wip-limit.md)).
2. Otherwise, if a loop PR is open, end the run.
3. Otherwise pick the `ready/` item with the highest `priority` and, at equal priority, the oldest one.

Each item carries `priority` and `type` (incident or not) in its frontmatter. Triage sets them.

### refine (in triage)

- If refine finds a question only a human can decide, it **decides by default rules and records the assumption**. The item gets a mandatory **Assumptions** section, and goes to `ready/`.
- Assumptions are shown in three places: the item, the PR description (written by `ship`) and `/demo`, which checks each assumption during the demo ([0068](0068-demo-flow.md)).

### plan

- plan is its own stage. Its result is a **plan file on the feature branch** with fixed sections: affected modules and onion layers, new or changed ports, spec changes (OpenAPI, AsyncAPI), migrations with their expand/contract steps, and the test for each scenario.
- The stage's gate checks that the sections are complete and that every scenario of the item maps to a test.
- Like the state file, the plan file is deleted by `ship`, and the same CI check fails while it exists.

### implement

- Order: spec, then acceptance tests (which must fail for the right reason), then code until green. The stage gate is the full build including traceability and the architecture tests ([0102](0102-format-on-edit-and-full-build-stop-hook.md)).
- If the plan doesn't hold (for example a missing port or an impossible migration), implement **hands the item back to plan** with the reason recorded in the state file. After **2 hand-backs**, the run fails and takes the failure path.

### review + ship

- Several **review agents with explicit focus areas** check the diff: architecture, security, data and migration, and tests and scenario coverage. More focus areas can be added later.
- Each agent reports findings with a severity. **Blocking findings are fixed**, in at most 2 rounds. All other findings go into the PR description for `/demo`.
- Further gates before the PR (for example PR title type, catalog up to date) are still to be decided.
- CI failures are fixed in at most 3 rounds (ADR 0118).

## Consequences

- Triage keeps running while a demo is pending, so `ready/` stays filled and ordered.
- Two routines mean two setups and two usage consumers. The trigger workflow needs two start paths.
- Assumed answers can be wrong. They are visible in the item, the PR and the demo, but nothing blocks them. A human catches them in `/demo`.
- A plan that turns out wrong costs at most two extra rounds.
- **Rejected:**
  - A single routine for triage and item work, because the WIP limit and the hourly check don't fit triage.
  - Leaving items with open questions in `inbox/`, because the user prefers documented assumptions that `/demo` checks.
  - No separate plan file, because the architecture gate and the resume point need an artifact.
  - Fixing all review findings including nits, because it risks ping-pong.
