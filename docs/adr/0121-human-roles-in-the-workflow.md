# 0121. Human roles in the workflow

- Status: Accepted
- Date: 2026-10-16
- Extends: [0120](0120-ideation-creation-validation.md)

## Context

ADR 0120 assigns the workflow to three parts and names the actors as "CI and humans". It doesn't say which part interacts with humans, or in which role. The roles follow from earlier ADRs, but are not written down in one place.

## Decision

Humans act in these roles:

| Part | Role | What the human does | ADRs |
|---|---|---|---|
| Ideation | **Idea giver** | Writes items into `inbox/` and can refine one together with `grill-me`. Triage is autonomous and its `chore` PR merges automatically, so the human sees `ready/` and `rejected/` (with reason) only afterwards. | [0062](0062-backlog-items-as-cockburn-use-cases.md), [0074](0074-implemented-backlog-items-are-deleted.md) |
| Creation | none during a run | The agent works alone. | [0046](0046-autonomous-backlog-loop.md), [0118](0118-loop-orchestration.md) |
| Validation | **Acceptor** | Runs `/demo`: plays the scenarios, checks the assumptions, posts the `demo` status with their own credentials. Only for user-visible changes. Feedback becomes new `inbox/` items. `/demo` then enables auto-merge. | [0057](0057-demo-only-for-user-visible-changes.md), [0060](0060-demo-gate-as-required-status-check.md), [0068](0068-demo-flow.md), [0088](0088-demo-status-from-local-sessions.md), [0103](0103-demo-enables-auto-merge.md) |
| any | **Guardrail owner** | Reviews changes to code-owned paths (`.github/`, `.claude/`, ADRs, build and test configuration, alert rules). The admin may bypass for pull requests only. | [0059](0059-branch-protection-and-codeowners.md), [0089](0089-codeowners-scope-and-admin-bypass.md), [0100](0100-alert-rules-are-code-owned.md) |
| any | **Operator** | Receives alert emails, restores data from snapshots manually, and does the manual setup steps. | [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0073](0073-why-data-restore-is-manual.md), [0079](0079-single-setup-inventory.md) |

- The roles describe the work, not people. One person can hold all of them.
- No human approves an item before it moves from `inbox/` to `ready/`. A wrong assumption is caught at the earliest in `/demo` ([0119](0119-loop-routines-and-stages.md)).

## Consequences

- The acceptor role is the bottleneck. With WIP limit 1, the frequency of `/demo` bounds the throughput ([0046](0046-autonomous-backlog-loop.md)). Dependabot fixes ([0072](0072-demo-status-exemption-for-dependency-fixes.md)) and changes without visible effect ([0057](0057-demo-only-for-user-visible-changes.md)) skip it.
- Ideation has no human gate before `ready/`. If that proves too late, the refine design can add one.
- A future ADR that adds a human touchpoint names its role from this table, or adds a new one.
- **Rejected:** Adding this table to the accepted ADR 0120, because accepted ADRs are not edited.
