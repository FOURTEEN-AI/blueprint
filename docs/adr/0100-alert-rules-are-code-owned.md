# 0100. Alert rules are code-owned, dashboards are not

- Status: Accepted
- Date: 2026-10-15
- Extends: [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md) (replaces "`ops/` is not a guardrail path" for alert rules), [0089](0089-codeowners-scope-and-admin-bypass.md)

## Context

ADR 0069 versions dashboards and alert rules under `ops/grafana/` and treats that directory as unguarded, because only the deploying workflows in `.github/` were code-owned. ADR 0089 later extended CODEOWNERS to everything that can weaken the safety net without touching `.github/`. Alert rules belong in that group: an agent that deletes or loosens a rule, or changes a contact point, silences production monitoring, and the release workflow deploys that change without review.

## Decision

- Alert rules and contact points live in **`ops/grafana/alerts/`**, which is **code-owned** by the human (ADR 0089).
- **Dashboards** stay in `ops/grafana/` outside that directory and remain unowned, so the loop can add or change panels freely.

## Consequences

- Weakening or removing alerting always involves a human.
- Dashboard changes flow autonomously, because they can't silence anything.
- New alert rules proposed by the loop wait for a review.
- **Rejected:**
  - Code-owning all of `ops/grafana/`, because every dashboard tweak would wait for a review.
  - Keeping 0069 as is, because it leaves an unreviewed path to switch off production monitoring.
