# 0071. Production telemetry and origin lock are set up by /bootstrap and checked on every release

- Status: Accepted
- Date: 2026-10-14
- Extends: [0036](0036-observability.md), [0047](0047-bootstrap-skill.md), [0052](0052-cloudflare-in-front-of-production.md), [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)

## Context

Three production features switch themselves off when their configuration is missing:

- OTLP export of metrics, logs and traces ([0036](0036-observability.md), [0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md))
- the Faro frontend SDK ([0069](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md))
- the origin-lock filter ([0052](0052-cloudflare-in-front-of-production.md))

A production deployment without them looks healthy but is unobserved, so no alert can ever fire, or is reachable around Cloudflare. Nothing reports that. [0036](0036-observability.md) calls tracing "opt-in", which doesn't fit autonomous releases that rely on production signals.

## Decision

### Mandatory in production, not opt-in

- **Telemetry (OTLP export of metrics, logs and traces, and Faro) is required in production.** The code still starts without the configuration, so local runs, tests and previews need nothing. That is a safety property of the code, not an opt-out for production.
- This replaces "Tracing is opt-in" in the consequences of 0036.
- The **origin lock** stays as in 0052: active when its secret is configured, which is production. It is also required there.

### /bootstrap sets everything up

`/bootstrap` ([0047](0047-bootstrap-skill.md)) does the following, asking for confirmation before each external step:

1. **Grafana Cloud:** asks for a stack and an API token, then creates or collects the OTLP endpoint and credentials, the Faro collector URL, and the Grafana service account for the dashboard deploy. It sets them as Fly secrets / environment variables and GitHub secrets ([0037](0037-configuration-and-secrets.md)).
2. **Alert webhook:** creates the contact points, with the fine-grained GitHub token for `repository_dispatch` (0069).
3. **Origin lock:** generates the origin secret, sets it as a Fly secret and as the value of the Cloudflare Transform Rule header (0052).
4. **Records** in `.blueprint` ([0048](0048-sync-blueprint-skill.md)) which of these steps are done.

A user may decline a step. `/bootstrap` then says explicitly what that leaves unprotected (for example: "production will not be observed, and no alert can fire") and records the step as skipped in `.blueprint`.

### The release workflow warns

- Before the production deploy, the release workflow checks that the production configuration defines the OTLP endpoint and credentials, the Faro collector URL and the origin secret. For Fly secrets it checks names only (`fly secrets list`), never values.
- A missing value produces a **warning**: a `::warning::` annotation plus an entry in the job summary, naming the missing value and the `/bootstrap` step that sets it.
- The warning **does not fail the release.** A broken or missing configuration must not block a rollback or a fix. The warning repeats on every release until the configuration exists.

## Alternatives rejected

- **Fail the release when configuration is missing:** blocks fixes and rollbacks and makes deploys of unconfigured forks impossible.
- **A runtime health check that reports missing export:** the machine is stopped when idle (0023), and Actuator output is for the platform, not for the owner.
- **Keep everything opt-in and document it:** the gap stays silent, which was the problem.

## Consequences

- Generated projects are observed and edge-protected from the first release, or the owner has been told explicitly why not.
- Grafana Cloud and Cloudflare accounts are prerequisites of `/bootstrap`. The README must state the Grafana Cloud part, as it already does for the domain (0052).
- The Grafana and Cloudflare credentials `/bootstrap` needs are broader than the secrets the app holds at runtime. They are used only during setup.
- A fork that never configures telemetry gets a warning on every release but keeps working.
- Blueprint's own deployment (0056) follows the same rules.
