# 0069. Grafana Cloud for telemetry and alerts, with alerts becoming inbox items

- Status: Accepted (WIP consequence superseded by [0070](0070-incident-items-exempt-from-wip-limit.md))
- Date: 2026-10-14
- Extends: [0036](0036-observability.md)

## Context

[0036](0036-observability.md) defines what the app exposes (health endpoints, JSON logs, Prometheus metrics, OTLP traces) but not where the data goes or who reacts to it. Production scales to zero ([0023](0023-scale-to-zero-and-accepted-cold-start.md)), so a machine that is stopped can't be scraped and produces no data. Logs on Fly are kept only briefly. The only production signal so far is the smoke test after a deploy ([0029](0029-pre-migration-neon-snapshots-and-auto-rollback.md)). A problem that appears later goes unnoticed.

`main` is protected and every change is a squash-merged PR ([0033](0033-protected-main-squash-merge.md), [0059](0059-branch-protection-and-codeowners.md)). The backlog lives in the repo ([0061](0061-backlog-folders-and-flow.md)).

## Decision

### Telemetry goes to Grafana Cloud (free tier)

- **Metrics, logs and traces are pushed by the app over OTLP** to Grafana Cloud (Mimir, Loki, Tempo). Pushing works while the machine runs and needs no scraper. The Prometheus endpoint from 0036 stays for ad-hoc use.
- Export is **enabled only in production**, and **only when an OTLP endpoint is configured** (0036). Local runs and previews export nothing. Every signal carries the `deployment.environment` resource attribute.
- **Trace sampling is low** (a configurable ratio, default 10 %).
- **Frontend:** the React SPA uses the **Grafana Faro** web SDK for JS errors and web vitals, correlated with backend traces. Faro is off when no collector URL is configured. The Faro app key is public by design; Cloudflare and the app-level limits ([0052](0052-cloudflare-in-front-of-production.md), [0054](0054-app-level-abuse-limits.md)) apply.
- Endpoint and credentials are **environment variables / Fly secrets** ([0037](0037-configuration-and-secrets.md)).

### Alerts

- **Grafana alert rules** on the HTTP 5xx rate and request latency. Rules fire **only on data that exists**. "No data" and "machine stopped" never alert, because that is the normal idle state.
- Alerts are sent to two contact points: **email** to the owner, and a **webhook** that calls the GitHub `repository_dispatch` API.

### Alert → backlog item (PR path)

1. The webhook sends `repository_dispatch` with event type `grafana-alert`. The token is a fine-grained token that lives only in Grafana's contact point. It is limited to this repository.
2. A workflow on the default branch creates **`backlog/inbox/incident-<rule-uid>-<yyyymmdd>.md`** on a branch and opens a **`chore` PR** that auto-merges like a triage PR (0061). **Nothing is pushed to `main` directly.**
3. **Deduplication:** the workflow does nothing if an item for the same rule uid exists in `inbox/` or `ready/`, or if a PR for it is open. A rule that fires again after its item is `done/` or `rejected/` creates a new item.
4. The **payload is untrusted data.** The workflow passes it through files or environment variables, never through shell interpolation, and writes only whitelisted fields (rule name, uid, firing time, severity, values, links to dashboard and panel). Alert text is escaped before it lands in Markdown.
5. The item is a `fix` item ([0062](0062-backlog-items-as-cockburn-use-cases.md)) with `source: grafana alert <rule uid>` and priority `high`. It carries an **incident template**: alert details instead of a use-case reference, plus a security impact section. The refine skill adds the affected use case and the failing Gherkin scenario.
6. The loop triages incident items first and works them like any other item ([0046](0046-autonomous-backlog-loop.md)). The fix goes through the normal gates, including the demo gate only if the change is user-visible ([0057](0057-demo-only-for-user-visible-changes.md)). The immediate protection against a bad release remains the automatic rollback (0029).

### Dashboards and alert rules as code

- Dashboards and alert rules are versioned under **`ops/grafana/`** and deployed by the release workflow through the Grafana API, using a service-account token stored as a GitHub secret.
- `ops/` is not a guardrail path. The workflows that deploy it are, because they live in `.github/` (0059).

## Alternatives rejected

- **Fly Managed Metrics only:** no data while the machine is stopped, no logs or traces, and no alert rules in code.
- **External uptime or synthetic checks:** every check wakes the machine and defeats scale-to-zero.
- **Alert → GitHub issue:** quick and visible, but creates a second source of truth next to `backlog/`. The loop would have to read two places.
- **Exception for direct pushes to `main`:** needs a bypass actor with branch-rule rights. That contradicts 0033 and 0059 ("agent tokens have no admin rights"). A leaked token in Grafana would then write to `main` unreviewed. A `chore` PR with auto-merge costs only the CI run time.
- **A workflow that polls the Grafana API:** adds latency and cron load, and needs an inbound token as well.
- **Fly log shipper for logs:** needs a separate Fly app. OTLP logs reuse the one pipeline.
- **Manual triage of alerts:** nothing acts on an alert unless a human is watching.

## Consequences

- Production problems after the smoke test (error rate, latency) are noticed and become backlog items without a human.
- A Grafana Cloud account is needed. The template documents which values to set. Without them the app runs as before, only without export.
- The GitHub token in Grafana can start the dispatch workflow and no more. The workflow code is a guardrail file and needs the code owner's review (0059).
- The incident PR waits for CI. A burst of different rules produces one PR per rule.
- **WIP limit:** while a PR waits for a demo, the loop does no new work (0046). An incident item then waits too. Only the automatic rollback acts immediately.
- A new incident item template is needed in `backlog/`.
- Free-tier limits, the custom webhook payload and the dispatch size limits must be verified (see [deferred.md](../deferred.md)).
