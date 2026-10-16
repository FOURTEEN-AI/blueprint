# Architecture Decision Records

Decisions that shape blueprint. The process is described in [0001](0001-record-architecture-decisions.md), and the `Extends` relation in [0076](0076-extends-relation-between-adrs.md).

Accepted ADRs are never edited, so older ADRs may still refer to ADRs that have since been superseded (e.g. 0027 or 0061). In that case, follow the *Superseded by* chain to the ADR in force.

| # | Decision | Status |
|---|----------|--------|
| 0001 | [Record architecture decisions](0001-record-architecture-decisions.md) | Accepted |
| 0002 | [Blueprint is a public project template with an AI workflow kit](0002-public-template-and-ai-workflow-kit.md) | Accepted |
| 0003 | [English as the project language](0003-english-as-project-language.md) | Accepted |
| 0004 | [Opinionated stack: Spring Boot 4 (Java 25) and a React SPA](0004-spring-boot-and-react-stack.md) | Accepted |
| 0005 | [Ship backend and frontend as a single deployable](0005-single-deployable-jar.md) | Accepted |
| 0006 | [Single Gradle project with the Groovy DSL, and pnpm](0006-single-gradle-project-groovy-dsl-pnpm.md) | Accepted |
| 0007 | [Local development loop: Vite dev server proxying to bootTestRun](0007-local-development-loop.md) | Accepted |
| 0008 | [Spring Modulith feature modules with onion layers inside](0008-modulith-modules-with-onion-layers.md) | Accepted |
| 0009 | [Strict domain core, enforced by ArchUnit](0009-strict-domain-core-enforced-by-archunit.md) | Accepted |
| 0010 | [Spring Data JPA with hand-written mappers](0010-spring-data-jpa-with-hand-written-mappers.md) | Accepted |
| 0011 | [PostgreSQL and Flyway](0011-postgresql-and-flyway.md) | Accepted |
| 0012 | [Run Flyway migrations as a Fly release_command](0012-migrations-via-fly-release-command.md) | Accepted |
| 0013 | [Backward-compatible (expand/contract) migrations](0013-expand-contract-migrations.md) | Accepted |
| 0014 | [Spec-first OpenAPI](0014-spec-first-openapi.md) | Accepted |
| 0015 | [AsyncAPI for WebSocket events](0015-asyncapi-for-websocket-events.md) | Accepted |
| 0016 | [Frontend: Vite, TypeScript and React Router data mode](0016-frontend-vite-typescript-react-router.md) | Accepted |
| 0017 | [CSS Modules for styling](0017-css-modules-for-styling.md) | Accepted |
| 0018 | [Live updates over a raw WebSocket carrying change notifications](0018-live-updates-via-websocket-change-notifications.md) | Accepted |
| 0019 | [Cross-instance fan-out via PostgreSQL LISTEN/NOTIFY](0019-cross-instance-fan-out-via-listen-notify.md) | Accepted |
| 0020 | [No authentication in the template](0020-no-authentication.md) | Accepted |
| 0021 | [Sample features: notes CRUD and live broadcast, removed by bootstrap](0021-sample-features.md) | Accepted |
| 0022 | [Host on Fly.io, region fra](0022-fly-io-hosting.md) | Accepted |
| 0023 | [Scale to zero in production and accept the JVM cold start](0023-scale-to-zero-and-accepted-cold-start.md) | Accepted |
| 0024 | [Unmanaged Fly Postgres as the production database](0024-unmanaged-fly-postgres.md) | Superseded by 0025 |
| 0025 | [Neon (free tier) as the production database](0025-neon-as-production-database.md) | Accepted |
| 0026 | [PR previews with a Postgres sidecar container](0026-pr-previews-with-postgres-sidecar.md) | Superseded by 0027 |
| 0027 | [PR preview environments: a Fly app plus a Neon schema-only branch](0027-pr-preview-environments.md) | Superseded by 0051 |
| 0028 | [Pre-migration pg_dump to Tigris](0028-pre-migration-backup-to-tigris.md) | Superseded by 0029 |
| 0029 | [Pre-migration Neon snapshots and automatic app rollback](0029-pre-migration-neon-snapshots-and-auto-rollback.md) | Accepted |
| 0030 | [Build container images with Jib and publish them to GHCR](0030-container-images-with-jib.md) | Accepted |
| 0031 | [GitHub Actions for CI and continuous delivery](0031-github-actions-ci-cd.md) | Accepted |
| 0032 | [semantic-release with Conventional Commits](0032-semantic-release-and-conventional-commits.md) | Accepted |
| 0033 | [Protected main, PR-only changes, squash merge](0033-protected-main-squash-merge.md) | Accepted |
| 0034 | [Code quality and security tooling](0034-code-quality-and-security-tooling.md) | Accepted (thresholds decided in [0106](0106-criticality-and-quality-thresholds.md)) |
| 0035 | [Dependabot for dependency updates](0035-dependabot.md) | Accepted |
| 0036 | [Observability: Actuator, JSON logs, Prometheus metrics and OpenTelemetry](0036-observability.md) | Accepted (tracing no longer opt-in in production, see [0071](0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md)) |
| 0037 | [Configuration through Spring profiles and environment variables](0037-configuration-and-secrets.md) | Accepted |
| 0038 | [Acceptance-test-first development with Gherkin criteria](0038-acceptance-test-first.md) | Accepted |
| 0039 | [JGiven port-to-port tests against in-memory fakes](0039-jgiven-port-to-port-tests-with-in-memory-fakes.md) | Accepted |
| 0040 | [Where Playwright E2E tests run](0040-playwright-e2e-placement.md) | Accepted |
| 0041 | [Claude Code first, with AGENTS.md as the source of truth](0041-claude-code-first-agents-md.md) | Accepted |
| 0042 | [SDLC skill chain: refine, plan, implement, review and ship](0042-sdlc-skill-chain.md) | Proposed (details to be designed; orchestration decided in [0118](0118-loop-orchestration.md)) |
| 0043 | [Agents merge autonomously after a green build and a demo](0043-autonomous-merge-gated-by-demo.md) | Accepted |
| 0044 | [Interactive /demo with feedback triage](0044-interactive-demo-and-feedback-triage.md) | Accepted (flow in [0068](0068-demo-flow.md); skill text to be written) |
| 0045 | [In-repo backlog organized as status folders](0045-in-repo-backlog-status-folders.md) | Accepted |
| 0046 | [Autonomous backlog loop as a scheduled cloud agent, WIP limit 1](0046-autonomous-backlog-loop.md) | Accepted |
| 0047 | [/bootstrap: GitHub template plus init script, fully automated with confirmation](0047-bootstrap-skill.md) | Accepted |
| 0048 | [/sync-blueprint for upstream template updates](0048-sync-blueprint-skill.md) | Accepted |
| 0049 | [Blueprint's CI tests only the template app](0049-template-self-test-scope.md) | Accepted |
| 0050 | [Minimal open-source community files](0050-minimal-community-files.md) | Accepted |
| 0051 | [PR previews use a fresh database inside their Neon branch](0051-preview-databases-as-fresh-database-in-pr-branch.md) | Superseded by 0064 |
| 0052 | [Cloudflare in front of production](0052-cloudflare-in-front-of-production.md) | Accepted |
| 0053 | [Turnstile bot check once per session for writes and WebSockets](0053-turnstile-session-for-writes-and-websockets.md) | Accepted |
| 0054 | [Generic app-level abuse limits](0054-app-level-abuse-limits.md) | Accepted |
| 0055 | [PR previews stay on fly.dev; environments differ only in configuration](0055-previews-on-fly-dev-and-environment-parity.md) | Superseded by 0090 |
| 0056 | [Safeguards for blueprint's public demo deployment](0056-demo-deployment-safeguards.md) | Accepted |
| 0057 | [A demo is required only for user-visible changes](0057-demo-only-for-user-visible-changes.md) | Accepted |
| 0058 | [Dependabot merge and release policy](0058-dependabot-merge-and-release-policy.md) | Accepted |
| 0059 | [Branch protection without required reviews, and CODEOWNERS for guardrails](0059-branch-protection-and-codeowners.md) | Accepted |
| 0060 | [Demo gate as a required status check posted with the human's credentials](0060-demo-gate-as-required-status-check.md) | Accepted |
| 0061 | [Backlog folders and flow](0061-backlog-folders-and-flow.md) | Superseded by 0074 |
| 0062 | [Backlog items as Cockburn use cases with a security impact section](0062-backlog-items-as-cockburn-use-cases.md) | Accepted |
| 0063 | [Living use-case catalog, ID-tagged tests and the JGiven report](0063-living-use-case-catalog-and-jgiven-report.md) | Accepted |
| 0064 | [Preview databases: one shared Neon branch with a database per PR](0064-preview-databases-in-shared-neon-branch.md) | Superseded by 0090 |
| 0065 | [Neon branch budget and snapshot retention](0065-neon-branch-budget.md) | Accepted |
| 0066 | [Event types: JSON Schema with json-schema-to-typescript and jsonschema2pojo](0066-websocket-event-type-generation.md) | Accepted |
| 0067 | [JGiven 3.x for JUnit 6 and Spring 7](0067-jgiven-3-for-junit-6.md) | Accepted |
| 0068 | [/demo flow: guided scenarios, exploration and confirmed triage](0068-demo-flow.md) | Accepted |
| 0069 | [Grafana Cloud for telemetry and alerts, with alerts becoming inbox items](0069-grafana-cloud-telemetry-and-alert-driven-incidents.md) | Accepted (WIP consequence superseded by [0070](0070-incident-items-exempt-from-wip-limit.md)) |
| 0070 | [Incident items are exempt from the WIP limit](0070-incident-items-exempt-from-wip-limit.md) | Accepted |
| 0071 | [Production telemetry and origin lock are set up by /bootstrap and checked on every release](0071-production-telemetry-and-origin-lock-set-up-by-bootstrap.md) | Accepted |
| 0072 | [Demo status exemption for Dependabot dependency fixes](0072-demo-status-exemption-for-dependency-fixes.md) | Accepted |
| 0073 | [Why restoring data from a snapshot is always manual](0073-why-data-restore-is-manual.md) | Accepted |
| 0074 | [Implemented backlog items are deleted, not kept in done/](0074-implemented-backlog-items-are-deleted.md) | Accepted |
| 0075 | [Generated projects are public repositories](0075-generated-projects-are-public.md) | Accepted |
| 0076 | [The "Extends" relation between ADRs](0076-extends-relation-between-adrs.md) | Accepted |
| 0077 | [Actuator on an internal management port, and health groups](0077-actuator-on-internal-management-port.md) | Accepted |
| 0078 | [A workflow turns Dependabot major updates into backlog items](0078-dependabot-majors-become-backlog-items.md) | Accepted |
| 0079 | [A single setup inventory owned by /bootstrap](0079-single-setup-inventory.md) | Accepted |
| 0080 | [No edge caching at Cloudflare](0080-no-edge-caching.md) | Accepted |
| 0081 | [pnpm installed standalone, without corepack](0081-pnpm-standalone-without-corepack.md) | Accepted |
| 0082 | [Edge rate limit on session and WebSocket paths, per-session write limit in the app](0082-edge-rate-limit-on-session-and-websocket-paths.md) | Accepted |
| 0083 | [Fly tokens: app-scoped deploy token for production, org token for previews](0083-fly-tokens-per-purpose.md) | Accepted |
| 0084 | [A project GitHub App is the identity of all automation, including the loop](0084-project-github-app-as-bot-identity.md) | Accepted |
| 0085 | [Untrusted build, trusted deploy: secrets never reach PR code](0085-untrusted-build-trusted-deploy.md) | Accepted |
| 0086 | [A single direct Neon connection for the pool, Flyway and LISTEN](0086-single-direct-neon-endpoint.md) | Accepted |
| 0087 | [Production origin TLS: Fly certificate via DNS-01, Cloudflare Full (strict)](0087-production-origin-tls.md) | Accepted |
| 0088 | [Demo status from local sessions: a hook as a speed bump](0088-demo-status-from-local-sessions.md) | Accepted |
| 0089 | [CODEOWNERS covers all guardrail configuration; admin bypass for the maintainer](0089-codeowners-scope-and-admin-bypass.md) | Accepted |
| 0090 | [PR preview environments](0090-pr-preview-environments.md) | Accepted |
| 0091 | [Release safety: serialized releases and a revert after every rollback](0091-release-safety.md) | Accepted |
| 0092 | [Infrastructure smoke tests survive bootstrap](0092-infrastructure-smoke-tests.md) | Accepted |
| 0093 | [The WebSocket pauses while the tab is hidden](0093-websocket-pauses-in-hidden-tabs.md) | Accepted |
| 0094 | [No backup outside Neon](0094-no-backup-outside-neon.md) | Accepted |
| 0095 | [Footer links to imprint and privacy policy](0095-legal-page-links.md) | Accepted |
| 0096 | [The PR title is the only Conventional Commit that matters](0096-pr-title-is-the-only-conventional-commit.md) | Accepted |
| 0097 | [OpenAPI generators: openapi-generator for Spring, openapi-typescript for the client](0097-openapi-generators.md) | Accepted |
| 0098 | [Container image retention in GHCR](0098-ghcr-image-retention.md) | Accepted |
| 0099 | [Backlog items for Dependabot major updates are deduplicated](0099-dependabot-major-items-are-deduplicated.md) | Accepted |
| 0100 | [Alert rules are code-owned, dashboards are not](0100-alert-rules-are-code-owned.md) | Accepted |
| 0101 | [Full-context API tests per use case](0101-full-context-api-tests-per-use-case.md) | Accepted |
| 0102 | [Hooks: format on every edit, full build before stopping](0102-format-on-edit-and-full-build-stop-hook.md) | Accepted |
| 0103 | [/demo enables auto-merge after a passed demo](0103-demo-enables-auto-merge.md) | Accepted |
| 0104 | [Devcontainer tools come from official sources, not community features](0104-devcontainer-tools-from-official-sources.md) | Accepted |
| 0105 | [Test levels and layer disjointness](0105-test-levels-and-layer-disjointness.md) | Accepted |
| 0106 | [Criticality and quality thresholds](0106-criticality-and-quality-thresholds.md) | Accepted |
| 0107 | [Contract tests for every in-memory fake](0107-contract-tests-for-fakes.md) | Accepted |
| 0108 | [Visibility rules and invariants in use cases](0108-visibility-rules-and-invariants-in-use-cases.md) | Accepted |
| 0109 | [Test hygiene: no retries, no sleeps, data through legal transitions](0109-test-hygiene.md) | Accepted |
| 0110 | [Test exceptions register](0110-test-exceptions-register.md) | Accepted |
| 0111 | [Test naming and the two-part JGiven report](0111-test-naming-and-report-structure.md) | Accepted |
| 0112 | [Frontend tests count for traceability](0112-frontend-tests-count-for-traceability.md) | Accepted |
| 0113 | [Round-trip tests for persistence adapters](0113-round-trip-tests-for-persistence-adapters.md) | Accepted |
| 0114 | [Criticality: annotation package and re-assessment after bugs](0114-criticality-annotation-package-and-reassessment.md) | Accepted |
| 0115 | [Playwright: traces, fixed names and one context per actor](0115-playwright-traces-names-and-multiple-actors.md) | Accepted |
| 0116 | [Use-case size and vertical slicing](0116-use-case-size-and-slicing.md) | Accepted |
| 0117 | ["Observed, not tested" in use cases](0117-observed-not-tested.md) | Accepted |
| 0118 | [Loop orchestration: one session, skill-scoped gates, committed stage state](0118-loop-orchestration.md) | Accepted (schedule and start rules replaced by [0123](0123-pr-kinds-and-dispatch.md)) |
| 0119 | [Two loop routines, and the contents of the stages](0119-loop-routines-and-stages.md) | Accepted (schedules, start rules and item choice replaced by [0123](0123-pr-kinds-and-dispatch.md)) |
| 0120 | [The workflow is organized in three parts: ideation, creation, validation](0120-ideation-creation-validation.md) | Accepted |
| 0121 | [Human roles in the workflow](0121-human-roles-in-the-workflow.md) | Accepted |
| 0122 | [The refine skill](0122-refine-skill.md) | Accepted |
| 0123 | [Ideation and creation PRs, and the dispatch workflow](0123-pr-kinds-and-dispatch.md) | Accepted |
| 0124 | [Gates: one source set, Gradle tasks and the stage files](0124-gates.md) | Accepted |
| 0125 | [Guardrails without blocking hooks](0125-guardrails-without-hooks.md) | Accepted |
