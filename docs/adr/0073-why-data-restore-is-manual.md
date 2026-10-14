# 0073. Why restoring data from a snapshot is always manual

- Status: Accepted
- Date: 2026-10-14
- Extends: [0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md)

## Context

ADR 0029 automates the **app** rollback after a failed production smoke test, but makes restoring **data** from a pre-migration snapshot a manual step. ADR 0029 doesn't record why. Without the reasoning, a later change might "complete" the automation.

## Decision

Restoring data from a `pre-vX.Y.Z` snapshot stays a **deliberate manual step**. It is never triggered automatically by CI, the loop or any skill. The reasons:

1. **A restore destroys data.** Every write made after the snapshot is lost. An app rollback is harmless and easy to repeat; a restore is neither.
2. **The trigger is almost always a code problem.** A failed smoke test usually means a bug in the new app version, which the app rollback fixes. Expand/contract migrations (ADR 0013) keep the previous app version working on the new schema, so the database doesn't need to go back.
3. **Real data damage is hard to detect automatically.** A migration that corrupts values usually passes health checks and smoke tests. An unreliable trigger would make the automation either useless or dangerous.
4. **A restore needs judgment.** Whether to restore everything, copy individual tables or rows from the snapshot branch, or replay later writes depends on what went wrong.

The automation guarantees that recovery is *possible*: the snapshot always exists. The destructive decision stays with someone who has looked at the problem.

## Consequences

- Data damage is fixed by hand. The restore procedure must be documented as a runbook.
- **Rejected:**
  - Automatic restore when the smoke test fails, because it would mostly fire on false alarms and lose good data.
  - A semi-automatic restore that CI prepares for one-click confirmation. It was considered and not needed for now.
