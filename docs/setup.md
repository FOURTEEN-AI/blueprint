# Setup inventory

The complete list of what a project generated from blueprint needs: accounts, secrets, configuration and repository settings. `/bootstrap` creates exactly what's listed here ([ADR 0079](adr/0079-single-setup-inventory.md)).

> **Design phase.** This is the target inventory derived from the ADRs. Names are the intended ones; if implementation renames something, update this file. Any ADR that adds or removes an account, secret or setting must update this file in the same change.

## Accounts

| Service | Used for | ADR |
|---|---|---|
| GitHub (public repository) | code, Actions, Container Registry (GHCR), Pages, Dependabot, CodeQL | [0031](adr/0031-github-actions-ci-cd.md), [0075](adr/0075-generated-projects-are-public.md) |
| Fly.io | production app and PR preview apps | [0022](adr/0022-fly-io-hosting.md) |
| Neon | PostgreSQL: production branch, `previews` branch, snapshots | [0025](adr/0025-neon-as-production-database.md), [0064](adr/0064-preview-databases-in-shared-neon-branch.md) |
| Cloudflare (free plan) + **own domain** | DNS, proxy, rate limiting, origin lock, Turnstile | [0052](adr/0052-cloudflare-in-front-of-production.md), [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| SonarCloud | quality gate | [0034](adr/0034-code-quality-and-security-tooling.md) |
| Claude Code | AI workflow and the scheduled cloud agent for the backlog loop | [0041](adr/0041-claude-code-first-agents-md.md), [0046](adr/0046-autonomous-backlog-loop.md) |

## Secrets

### GitHub Actions secrets

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `FLY_API_TOKEN` | deploy prod and previews, manage preview apps | `/bootstrap` (Fly deploy token) | [0031](adr/0031-github-actions-ci-cd.md) |
| `NEON_API_KEY` | create the `previews` branch, PR databases and snapshots | `/bootstrap` | [0025](adr/0025-neon-as-production-database.md), [0064](adr/0064-preview-databases-in-shared-neon-branch.md), [0065](adr/0065-neon-branch-budget.md) |
| `SONAR_TOKEN` | SonarCloud analysis | `/bootstrap` | [0034](adr/0034-code-quality-and-security-tooling.md) |
| `SMOKE_BYPASS_SECRET` | prod smoke test bypasses Turnstile | `/bootstrap` (random) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |

`GITHUB_TOKEN` (built in) is used for GHCR pushes, releases, Pages and the `demo` status automation.

### Fly secrets: production app

| Name | Purpose | Created by | ADR |
|---|---|---|---|
| `DATABASE_URL` | app connection pool (Neon, pooled endpoint allowed) | `/bootstrap` | [0025](adr/0025-neon-as-production-database.md) |
| `DATABASE_DIRECT_URL` | LISTEN/NOTIFY listener (Neon **direct** endpoint) | `/bootstrap` | [0019](adr/0019-cross-instance-fan-out-via-listen-notify.md) |
| `ORIGIN_AUTH_SECRET` | origin lock; the filter is active only when set | `/bootstrap` (random) | [0052](adr/0052-cloudflare-in-front-of-production.md) |
| `TURNSTILE_SECRET_KEY` | verify Turnstile tokens | `/bootstrap` (Turnstile widget) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `SESSION_SIGNING_KEY` | HMAC key for the session cookie | `/bootstrap` (random) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `SMOKE_BYPASS_SECRET` | the session endpoint accepts it instead of a Turnstile token | `/bootstrap` (same value as the GitHub secret) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |

### Fly secrets: preview apps (set by CI per PR)

| Name | Purpose | ADR |
|---|---|---|
| `DATABASE_URL` / `DATABASE_DIRECT_URL` | the PR's own database in the `previews` branch | [0064](adr/0064-preview-databases-in-shared-neon-branch.md) |
| `SESSION_SIGNING_KEY` | generated per preview | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |

Previews use Turnstile's public **test keys** and have **no** `ORIGIN_AUTH_SECRET` ([0055](adr/0055-previews-on-fly-dev-and-environment-parity.md)).

## Non-secret configuration

| Name | Value | ADR |
|---|---|---|
| `TURNSTILE_SITE_KEY` | public site key (test key in CI and previews) | [0053](adr/0053-turnstile-session-for-writes-and-websockets.md) |
| `SPRING_PROFILES_ACTIVE` | `prod`, `preview`; `migrate` for the release command | [0012](adr/0012-migrations-via-fly-release-command.md), [0037](adr/0037-configuration-and-secrets.md) |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | optional; tracing is off when unset | [0036](adr/0036-observability.md) |
| `NEON_PROJECT_ID` | GitHub Actions variable | [0064](adr/0064-preview-databases-in-shared-neon-branch.md) |

## Settings per service

### GitHub
- Repository is **public** ([0075](adr/0075-generated-projects-are-public.md)).
- Branch protection on `main`:
  - required status checks: build, tests, quality gates, CodeQL and **`demo`**
  - linear history and **squash merge only**
  - no required approving reviews in general
  - auto-merge enabled

  See [0033](adr/0033-protected-main-squash-merge.md), [0059](adr/0059-branch-protection-and-codeowners.md) and [0060](adr/0060-demo-gate-as-required-status-check.md).
- **CODEOWNERS** sets the user as owner of `.github/`, `.claude/` and `CODEOWNERS`, and requires code-owner review for those paths ([0059](adr/0059-branch-protection-and-codeowners.md)).
- **Pages** is enabled for the JGiven report ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md)).
- The **GHCR package** is public ([0030](adr/0030-container-images-with-jib.md), [0075](adr/0075-generated-projects-are-public.md)).
- `dependabot.yml`:
  - `fix(deps)` for runtime dependencies, `build(deps)` / `ci(deps)` for others
  - Gradle, npm/pnpm, GitHub Actions and the devcontainer ecosystems
  - plus the major-update workflow

  See [0035](adr/0035-dependabot.md), [0058](adr/0058-dependabot-merge-and-release-policy.md) and [0078](adr/0078-dependabot-majors-become-backlog-items.md).

### Tokens and permissions
- **Loop agent token:** fine-grained, with contents and pull requests write access. It has **no "commit statuses" permission** and **no admin rights** ([0059](adr/0059-branch-protection-and-codeowners.md), [0060](adr/0060-demo-gate-as-required-status-check.md)).
- **Human** `gh` login in the `/demo` session posts the `demo` status ([0060](adr/0060-demo-gate-as-required-status-check.md)).

### Fly.io
- Production app in region `fra`, at least 512 MB, auto-stop and auto-start with a minimum of 0 machines ([0022](adr/0022-fly-io-hosting.md), [0023](adr/0023-scale-to-zero-and-accepted-cold-start.md)).
- Certificate for the custom domain.
- `release_command` runs the image with the `migrate` profile ([0012](adr/0012-migrations-via-fly-release-command.md)).
- Only the application port is a public service. Health checks and `[metrics]` use the internal management port ([0077](adr/0077-actuator-on-internal-management-port.md)).
- Preview apps are named `<app>-pr-<n>` ([0027](adr/0027-pr-preview-environments.md)).

### Neon
- Project in `aws-eu-central-1`. The `main` branch is production ([0025](adr/0025-neon-as-production-database.md)).
- CI creates the `previews` branch (schema-only) if it's missing ([0064](adr/0064-preview-databases-in-shared-neon-branch.md)).
- Snapshot branches `pre-vX.Y.Z`, with the last 5 kept ([0065](adr/0065-neon-branch-budget.md)).

### Cloudflare
- A DNS record for the production domain pointing to Fly, proxied ([0052](adr/0052-cloudflare-in-front-of-production.md)).
- A request-header Transform Rule adding `X-Origin-Auth: <ORIGIN_AUTH_SECRET>` ([0052](adr/0052-cloudflare-in-front-of-production.md)).
- One rate-limiting rule (IP-based) for writes, the session endpoint and WebSocket upgrades ([0052](adr/0052-cloudflare-in-front-of-production.md)).
- A cache rule that bypasses the cache for everything ([0080](adr/0080-no-edge-caching.md)).
- A Turnstile widget for the production hostname ([0053](adr/0053-turnstile-session-for-writes-and-websockets.md)).
- The Cloudflare API token is used only by `/bootstrap` and isn't stored as a CI secret.

### SonarCloud
- A project bound to the repository, with a quality gate. Thresholds are to be decided ([0034](adr/0034-code-quality-and-security-tooling.md), [deferred](deferred.md)).

### Claude Code
- A scheduled cloud agent (routine) for the backlog loop ([0046](adr/0046-autonomous-backlog-loop.md)).
