# 0070. Incident items are exempt from the WIP limit

- Status: Accepted
- Date: 2026-10-14
- Extends: [0046](0046-autonomous-backlog-loop.md), [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)

## Context

[0046](0046-autonomous-backlog-loop.md) allows at most one PR waiting for a demo, and the loop does no new work while one waits. Items created from production alerts ([0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)) would wait behind that PR, and demos are paced by humans. Only the automatic rollback ([0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md)) would act in the meantime.

## Decision

- **Incident items do not count towards the WIP limit and are not blocked by it.** An incident is an item created by the alert workflow (0069): `type: fix` with `incident: true` in its frontmatter.
- The loop works an incident item even while a regular PR waits for its demo.
- **Incidents are worked one at a time among themselves.** A second incident item waits until the PR of the first is merged or closed.
- Nothing else changes for incident fixes. They go through CI, the required checks and the demo gate if user-visible ([0057](0057-demo-only-for-user-visible-changes.md)). A user-visible incident fix can therefore wait for a demo alongside the one regular PR.

## Alternatives rejected

- **Keep incidents under the limit:** a pending demo could block the fix for a production problem for hours.
- **No limit among incidents:** parallel fixes risk merge conflicts and raise preview costs, the reasons for the limit in 0046.

## Consequences

- Two PRs may wait for a demo at the same time: one regular and one incident fix. Throughput of incident work no longer depends on how often humans run `/demo`.
- A flood of alerts can't open more than one extra PR. The remaining incident items queue in the backlog.
- The consequence in 0069 that an incident item waits behind a demo no longer applies.
- The alert workflow and the item template must set `incident: true`.
