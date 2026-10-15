# Setup inventory

The complete list of what a project generated from blueprint needs: accounts, secrets, configuration and repository settings. `/bootstrap` creates exactly what's listed here ([ADR 0079](adr/0079-single-setup-inventory.md)).

> **Design phase.** This is the target inventory derived from the ADRs. Names are the intended ones; if implementation renames something, update this file. Any ADR that adds or removes an account, secret or setting must update this file in the same change.

## Accounts

| Service | Used for | ADR |
|---|---|---|
| GitHub (public repository) | code, Actions, Container Registry (GHCR), Pages, Dependabot, CodeQL | [0031](adr/0031-github-actions-ci-cd.md), [0075](adr/0075-generated-projects-are-public.md) |
| GitHub App ("project bot") | identity of the autonomous loop and all automation workflows | [0084](adr/0084-project-github-app-as-bot-identity.md) |
| Fly.io | production app and PR preview apps, in one organization | [0022](adr/0022-fly-io-hosting.md), [0083](adr/0083-fly-tokens-per-purpose.md) |
| Neon | PostgreSQL: production branch, `previews` branch, snapshots | [0025](adr/0025-neon-as-production-database.md), [0090](adr/0090-pr-preview-environments.md) |
| Cloudflare (free plan) + **own domain** | DNS, proxy, rate limiting, origin lock, Turnstile | [0052](adr/0052-cloudflare-in-front-of-production.md), [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| Grafana Cloud (free tier) | metrics, logs and traces over OTLP, Faro, dashboards, alerts | [0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md) |
| SonarCloud | quality gate | [0034](adr/0034-code-quality-and-security-tooling.md) |
| Claude Code | AI workflow and the scheduled cloud agent for the backlog loop | [0041](adr/0041-claude-code-first-agents-md.md), [0046](adr/0046-autonomous-backlog-loop.md) |

## Secrets

Workflows that run PR code get no Fly or Neon secrets. Those secrets live in GitHub **environments restricted to `main`** and are used only by trusted workflows ([0085](adr/0085-untrusted-build-trusted-deploy.md)).

### GitHub: repository secrets

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `SONAR_TOKEN` | SonarCloud analysis | `/bootstrap` | [0034](adr/0034-code-quality-and-security-tooling.md) |

### GitHub: environment `preview` (restricted to `main`)

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `FLY_PREVIEW_TOKEN` | Fly **org** token: create, deploy and destroy preview apps | `/bootstrap` | [0083](adr/0083-fly-tokens-per-purpose.md) |
| `NEON_API_KEY` | create the `previews` branch, the `preview` role and PR databases | `/bootstrap` | [0090](adr/0090-pr-preview-environments.md) |

### GitHub: environment `production` (restricted to `main`)

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `FLY_DEPLOY_TOKEN` | Fly **deploy** token for the production app: deploy and rollback | `/bootstrap` | [0083](adr/0083-fly-tokens-per-purpose.md) |
| `NEON_API_KEY` | pre-migration snapshots and their retention | `/bootstrap` | [0029](adr/0029-pre-migration-neon-snapshots-and-auto-rollback.md), [0065](adr/0065-neon-branch-budget.md) |
| `SMOKE_BYPASS_SECRET` | prod smoke test bypasses Turnstile | `/bootstrap` (random) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `GRAFANA_SERVICE_ACCOUNT_TOKEN` | deploy dashboards and alert rules from `ops/grafana/` | `/bootstrap` | [0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md) |

### GitHub: environment `automation` (restricted to `main`)

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `BOT_APP_PRIVATE_KEY` | mint project App tokens: Dependabot auto-merge, major-update items, incident-item PRs, revert PR after a rollback | `/bootstrap` (App creation needs a manual browser step) | [0084](adr/0084-project-github-app-as-bot-identity.md), [0091](adr/0091-release-safety.md) |

### GitHub: Dependabot secrets

| Name | Purpose | ADR |
|---|---|---|
| `SONAR_TOKEN` | SonarCloud analysis on Dependabot PRs | [0085](adr/0085-untrusted-build-trusted-deploy.md) |

`GITHUB_TOKEN` (built in) is used for GHCR pushes, releases, Pages and the automatic `demo` status for PRs that don't need a demo.

### Fly secrets: production app

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `DATABASE_URL` | Neon **direct** endpoint, for the pool, Flyway and LISTEN | `/bootstrap` | [0086](adr/0086-single-direct-neon-endpoint.md) |
| `ORIGIN_AUTH_SECRET` | origin lock; the filter is active only when set | `/bootstrap` (random) | [0052](adr/0052-cloudflare-in-front-of-production.md) |
| `TURNSTILE_SECRET_KEY` | verify Turnstile tokens | `/bootstrap` (Turnstile widget) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `SESSION_SIGNING_KEY` | HMAC key for the session cookie | `/bootstrap` (random) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `SMOKE_BYPASS_SECRET` | the session endpoint accepts it instead of a Turnstile token | `/bootstrap` (same value as the GitHub secret) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `OTEL_EXPORTER_OTLP_HEADERS` | Grafana Cloud OTLP credentials | `/bootstrap` | [0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md) |

### Fly secrets: preview apps (set by CI per PR)

| Name | Purpose | ADR |
|---|---|---|
| `DATABASE_URL` | the PR's own database in the `previews` branch, as the `preview` role | [0090](adr/0090-pr-preview-environments.md) |
| `SESSION_SIGNING_KEY` | generated per preview | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |

Previews use Turnstile's public **test keys** and have **no** `ORIGIN_AUTH_SECRET` ([0090](adr/0090-pr-preview-environments.md)).

### Project App and the loop

- The loop's routine holds the project App's private key and mints its own tokens ([0084](adr/0084-project-github-app-as-bot-identity.md)).
- The **human's** `gh` login in the `/demo` session posts the `demo` status ([0060](adr/0060-demo-gate-as-required-status-check.md), [0088](adr/0088-demo-status-from-local-sessions.md)).

## Non-secret configuration

| Name | Value | ADR |
|---|---|---|
| `TURNSTILE_SITE_KEY` | public site key (test key in CI and previews) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `SPRING_PROFILES_ACTIVE` | `prod`, `preview`; `migrate` for the release command | [0012](adr/0012-migrations-via-fly-release-command.md), [0037](adr/0037-configuration-and-secrets.md) |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | Grafana Cloud OTLP endpoint. **Required in production**; export is off when unset (local, previews) | [0036](adr/0036-observability.md), [0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md) |
| `FARO_COLLECTOR_URL` | Grafana Faro collector for the frontend. Required in production; Faro is off when unset | [0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md) |
| `GRAFANA_URL` | GitHub Actions variable: the Grafana stack the release workflow deploys dashboards to | [0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md) |
| `IMPRINT_URL`, `PRIVACY_URL` | footer links to the operator's legal documents; `/bootstrap` requires replacing or keeping them | [0095](adr/0095-legal-page-links.md) |
| `NEON_PROJECT_ID` | GitHub Actions variable | [0090](adr/0090-pr-preview-environments.md) |
| `FLY_ORG` | GitHub Actions variable: the organization preview apps are created in | [0083](adr/0083-fly-tokens-per-purpose.md) |
| `BOT_APP_ID` | GitHub Actions variable: the project App's ID | [0084](adr/0084-project-github-app-as-bot-identity.md) |

## Settings per service

### GitHub
- Repository is **public** ([0075](adr/0075-generated-projects-are-public.md)).
- Branch rules on `main` as a **repository ruleset**:
  - required status checks: build, tests, quality gates, CodeQL, PR title lint and **`demo`**
  - linear history and **squash merge only**
  - no required approving reviews in general, but **code-owner review** for code-owned paths
  - bypass list: the repository admin, **for pull requests only**; the project App has no bypass

  See [0033](adr/0033-protected-main-squash-merge.md), [0059](adr/0059-branch-protection-and-codeowners.md), [0060](adr/0060-demo-gate-as-required-status-check.md) and [0089](adr/0089-codeowners-scope-and-admin-bypass.md).
- Auto-merge enabled. Default squash commit message: **PR title** only ([0096](adr/0096-pr-title-is-the-only-conventional-commit.md)).
- **Environments** `preview`, `production` and `automation`, each with a deployment branch policy allowing only `main` ([0085](adr/0085-untrusted-build-trusted-deploy.md)).
- **CODEOWNERS** sets the user as owner of the guardrail files and requires their review for them ([0059](adr/0059-branch-protection-and-codeowners.md), [0089](adr/0089-codeowners-scope-and-admin-bypass.md)):
  - `.github/`, `.claude/`, `CODEOWNERS`
  - `build.gradle`, `settings.gradle`, `fly.toml`
  - `AGENTS.md`, `CLAUDE.md`, `docs/adr/`
  - the architecture tests, the traceability check, and the lint, format, TypeScript and test-runner configuration
- **Pages** is enabled for the JGiven report ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md)).
- The **GHCR package** is public ([0030](adr/0030-container-images-with-jib.md), [0075](adr/0075-generated-projects-are-public.md)). PR images are deleted with their preview, and the last 5 release images are kept ([0098](adr/0098-ghcr-image-retention.md)).
- `dependabot.yml`:
  - `fix(deps)` for runtime dependencies, `build(deps)` / `ci(deps)` for others
  - Gradle, npm/pnpm, GitHub Actions and the devcontainer ecosystems
  - plus the major-update workflow, with deduplication

  See [0035](adr/0035-dependabot.md), [0058](adr/0058-dependabot-merge-and-release-policy.md), [0078](adr/0078-dependabot-majors-become-backlog-items.md) and [0099](adr/0099-dependabot-major-items-are-deduplicated.md).

### Project GitHub App
- Installed only on the project repository ([0084](adr/0084-project-github-app-as-bot-identity.md)).
- Permissions: **contents: write**, **pull requests: write**.
- **No** commit statuses, administration or workflows permission.

### Fly.io
- Production app in region `fra`, at least 512 MB, auto-stop and auto-start with a minimum of 0 machines ([0022](adr/0022-fly-io-hosting.md), [0023](adr/0023-scale-to-zero-and-accepted-cold-start.md)).
- Certificate for the custom domain, validated through DNS (`_acme-challenge`) ([0087](adr/0087-production-origin-tls.md)).
- `release_command` runs the image with the `migrate` profile ([0012](adr/0012-migrations-via-fly-release-command.md)).
- Only the application port is a public service. Health checks and `[metrics]` use the internal management port ([0077](adr/0077-actuator-on-internal-management-port.md)).
- Preview apps are named `<app>-pr-<n>` and live in the same organization ([0090](adr/0090-pr-preview-environments.md)).

### Neon
- Project in `aws-eu-central-1`. The `main` branch is production ([0025](adr/0025-neon-as-production-database.md)).
- CI creates the `previews` branch (schema-only) if it's missing. On that branch it creates the `preview` role and locks the role inherited from production ([0090](adr/0090-pr-preview-environments.md)).
- Snapshot branches `pre-vX.Y.Z`, with the last 5 kept ([0065](adr/0065-neon-branch-budget.md)).

### Cloudflare
- A DNS record for the production domain pointing to Fly, proxied ([0052](adr/0052-cloudflare-in-front-of-production.md)).
- The `_acme-challenge` CNAME for the Fly certificate, **not** proxied ([0087](adr/0087-production-origin-tls.md)).
- SSL/TLS mode **Full (strict)** ([0087](adr/0087-production-origin-tls.md)).
- A request-header Transform Rule adding `X-Origin-Auth: <ORIGIN_AUTH_SECRET>` ([0052](adr/0052-cloudflare-in-front-of-production.md)).
- One rate-limiting rule (IP-based) on the **session endpoint and WebSocket paths** ([0082](adr/0082-edge-rate-limit-on-session-and-websocket-paths.md)).
- A cache rule that bypasses the cache for everything ([0080](adr/0080-no-edge-caching.md)).
- A Turnstile widget for the production hostname ([0053](adr/0053-turnstile-session-for-writes-and-websockets.md)).
- The Cloudflare API token is used only by `/bootstrap` and isn't stored as a CI secret.

### Grafana Cloud
- A stack with OTLP ingestion and a Faro app ([0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md), [0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md)).
- A service account for deploying `ops/grafana/` from the release workflow.
- Alert rules on the HTTP 5xx rate and latency, firing only on existing data.
- Contact points: **email** to the owner, and a **webhook** calling GitHub's `repository_dispatch` with event type `grafana-alert`. The webhook holds a fine-grained GitHub token limited to this repository. GitHub has no API for creating such tokens, so `/bootstrap` asks the user to create it.
- `/bootstrap` records completed and skipped steps in `.blueprint`, and the release workflow warns about missing production telemetry or origin-lock configuration ([0071](adr/0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md)).

### SonarCloud
- A project bound to the repository, with a quality gate. Thresholds are to be decided ([0034](adr/0034-code-quality-and-security-tooling.md), [deferred](deferred.md)).
- **Automatic Analysis** is turned off, because the analysis runs in CI.

### Claude Code
- A scheduled cloud agent (routine) for the backlog loop, authenticated to GitHub as the project App ([0046](adr/0046-autonomous-backlog-loop.md), [0084](adr/0084-project-github-app-as-bot-identity.md)).
