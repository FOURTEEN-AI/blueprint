# 0123. Ideation and creation PRs, and the dispatch workflow

- Status: Accepted
- Date: 2026-10-16
- Extends: [0118](0118-loop-orchestration.md), [0119](0119-loop-routines-and-stages.md), [0120](0120-ideation-creation-validation.md), [0074](0074-implemented-backlog-items-are-deleted.md). It replaces the schedule and start rules of the routines in 0118 and 0119: the routines no longer run on a schedule of their own.

## Context

ADR 0118 and 0119 give each routine its own schedule and let the item routine pick its item. Two problems remain. The WIP slot (ADR 0046) is only taken when the routine opens its PR, minutes after the start, so two runs can start on the same item. And "loop PR" is ambiguous now that there are two routines and three workflow parts (ADR 0120).

## Decision

### Terms

- **Ideation** includes triage. **Creation** is what the item routine does. **Loop** is only the collective name for the two routines.
- An **ideation PR** is made by the triage routine, or by the item routine when it returns an item to `inbox/`. Its branch is `ideation/…`. It merges automatically (ADR 0074) and **may change only `backlog/`**. A CI check enforces this for branches named `ideation/*`.
- A **creation PR** is made by the item routine for one item. Its branch is `creation/<item-id>` and its author is the project App. It occupies the WIP slot (ADR 0046).
- Ideation PRs, Dependabot PRs and human PRs don't occupy the slot.

### Dispatch workflow

A GitHub workflow starts both routines. It replaces the routines' own schedules.

- **Triggers:** an hourly cron, a push to `main`, and a manual start. It runs under a `concurrency` group, so two checks never run in parallel. It uses the `automation` environment ([0085](0085-untrusted-build-trusted-deploy.md)).
- **Logic:** a Gradle task in the `gates` source set ([0124](0124-gates.md)) decides and returns `none`, `triage` or `item <id>`. The workflow only calls the task and starts the routine with the result as its start text.
- **Triage** is chosen if `inbox/` isn't empty and either a push changed `inbox/` or no ideation PR has been made in the last 24 hours.
- **Item** is chosen by this order:
  1. an incident item in `ready/`, even if the slot is taken ([0070](0070-incident-items-exempt-from-wip-limit.md))
  2. otherwise nothing if a creation PR is open or a `creation/*` branch exists
  3. otherwise the `ready/` item with the highest `priority` whose `depends_on` items are merged, and at equal priority the oldest
- **Claim:** before it starts the routine, the workflow creates the branch `creation/<id>` from `main`. The branch is the claim. The routine works on exactly that item and doesn't pick one itself.
- **Abandoned claims:** a `creation/*` branch without a PR after **3 hours** counts as a failure ("abandoned").

### Failure path

Applies to every failure in ADR 0118 and 0119 and to abandoned claims. The creation PR (if any) is closed and its branch deleted. The routine, or the dispatch task for abandoned claims, opens an **ideation PR** that moves the item back to `inbox/` and appends an entry to the item's **Run notes** section. The entry has the date, the stage, the reason and a link to the closed PR. A Gradle task writes it, never the model by hand.

### Hand-off to validation

- During the work the PR is a draft. `ship` writes the PR text to a draft file, a gate checks it, and `ship` posts it.
- The PR text has four mandatory sections: item and use case (IDs, criticality), assumptions, demo hints (visible scenarios, preview link, what to try), and open review findings and deviations from the plan (including changed old tests).
- `ship` takes the PR out of draft and requests the owner as reviewer. GitHub notifies them, and the acceptor runs `/demo` ([0121](0121-human-roles-in-the-workflow.md)).

## Consequences

- No double start: the claim exists before the routine starts, and the dispatch task counts claims.
- The selection is deterministic and tested like every gate. The routines need no schedule of their own.
- A scheduled workflow can run late or be skipped under load. Pushes to `main` and the manual start cover this. The dispatch workflow is the place to verify it ([deferred](../deferred.md)).
- A failed run costs one ideation PR.
- The CI check for ideation PRs and the dispatch workflow live in `.github/`, which a human adds (ADR 0084).
- **Rejected:**
  - Identifying creation PRs by a label, because a human could change it.
  - Claiming the slot with a draft PR, because it needs a commit and PR text before the work starts.
  - A time window between starts, because it detects neither long runs nor failed starts.
  - Letting the routine choose its item, because it needs a second check and leaves a race.
  - Leaving an abandoned item in `ready/`, because a note needs a commit on `main` anyway.
