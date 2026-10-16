# 0122. The refine skill

- Status: Accepted
- Date: 2026-10-16
- Extends: [0042](0042-sdlc-skill-chain.md), [0062](0062-backlog-items-as-cockburn-use-cases.md), [0116](0116-use-case-size-and-slicing.md), [0119](0119-loop-routines-and-stages.md)

## Context

Refine turns an `inbox/` item into a fully dressed item in `ready/` ([0062](0062-backlog-items-as-cockburn-use-cases.md)). It runs in the triage routine without a human ([0119](0119-loop-routines-and-stages.md)), so it has to question itself. Its contents were open.

## Decision

### Questioning itself

- refine goes through a **fixed checklist**: actor, preconditions, failure cases, security, visibility rules and invariants ([0108](0108-visibility-rules-and-invariants-in-use-cases.md)), the catalog and criticality.
- A **fresh counter-check subagent** then looks for gaps and contradictions in the result. Its findings carry a severity. refine has to fix **blocking** findings, in at most **2 rounds**. Whatever remains becomes an assumption.
- **Open questions** are decided by default rules, and each decision is recorded in the mandatory **Assumptions** section ([0119](0119-loop-routines-and-stages.md)):
  1. follow an existing pattern in the catalog or code
  2. choose the more restrictive variant, for security and visibility
  3. choose the smallest scope; an extension becomes a new item

### Item contents

- **Security impact** is mandatory for every item and never empty. It names the affected trust boundaries and data, and the abuse cases. "No impact" needs a one-sentence reason. Every abuse case becomes a scenario or gets a justified "Observed, not tested" entry ([0117](0117-observed-not-tested.md)). The gate allows none to stay open.
- **Gherkin rules:**
  - declarative and in domain language, without UI details
  - one scenario per main flow and per extension, each referencing its step or extension
  - one behavior per scenario, with Given, When and Then exactly once
- **Criticality** is judged by anchor questions in the skill (money, data, security, rights, irreversibility, number of users, complexity). The result and its reason go into the catalog frontmatter ([0106](0106-criticality-and-quality-thresholds.md)). The counter-check subagent reviews it.
- **Catalog link.** refine searches `docs/use-cases/` and records whether the item creates a new use case or changes an existing ID, with the affected steps. Duplicates are rejected.
- **Language.** refine translates the item into English ([0003](0003-english-as-project-language.md)). The original wording stays in `source`.
- **Types.**
  - `fix`: the affected use case and step are named, the reproduction runs as a failing Gherkin scenario, and the criticality is re-assessed ([0114](0114-criticality-annotation-package-and-reassessment.md)).
  - `chore`: goal and done criteria are checkable.
  - Items created by automation (incidents, Dependabot majors) take the same path. Incidents get `priority` and `type: incident`. Dependabot majors become `chore` items with the migration notes from the release notes ([0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0078](0078-dependabot-majors-become-backlog-items.md)).

### Size and dependencies

- If an item exceeds the limits of [0116](0116-use-case-size-and-slicing.md), refine **splits it vertically**. The parts return to `inbox/` as casual items and are refined one by one.
- Dependencies between parts go into the frontmatter field **`depends_on`** (item IDs). The item routine picks only items whose dependencies are merged, which a script checks ([0119](0119-loop-routines-and-stages.md)).

### Rejection

Triage moves an item to `rejected/` with a reason if it contradicts an accepted ADR (naming it), duplicates an item or a use case in the catalog, or can't be implemented or understood even after the default rules.

### Gate

A script checks the item format: mandatory sections, at most twelve scenarios, exactly one criticality, no open abuse case and valid `depends_on` IDs. It runs as a **Stop hook in refine** and as a **CI check on the triage PR** ([0118](0118-loop-orchestration.md), [0059](0059-branch-protection-and-codeowners.md)).

## Consequences

- Items in `ready/` are complete and checkable, whoever wrote them.
- Wrong assumptions are possible. They are visible in the item, the PR and `/demo` ([0119](0119-loop-routines-and-stages.md)).
- Splitting adds triage rounds, because every part is refined separately.
- The counter-check subagent costs usage per item.
- The checklist, the anchor questions, the counter-check prompt and the gate script are written with the skill and the gate tooling ([deferred](../deferred.md)).
- **Rejected:**
  - A checklist alone without a second look.
  - A counter-check subagent that only advises, or one that keeps items in `inbox/` with a veto.
  - Splitting items directly into `ready/`, because every part should be refined by itself.
  - Dependencies only through `priority`, because the item routine couldn't check them.
  - Letting `fix` and `chore` items skip refine or use the feature checklist.
