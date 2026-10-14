# Architecture Decision Records

Decisions that shape blueprint. The process is described in [0001](0001-record-architecture-decisions.md).

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
| 0034 | [Code quality and security tooling](0034-code-quality-and-security-tooling.md) | Accepted (coverage thresholds to be decided) |
| 0035 | [Dependabot for dependency updates](0035-dependabot.md) | Accepted |
| 0036 | [Observability: Actuator, JSON logs, Prometheus metrics and OpenTelemetry](0036-observability.md) | Accepted |
| 0037 | [Configuration through Spring profiles and environment variables](0037-configuration-and-secrets.md) | Accepted |
| 0038 | [Acceptance-test-first development with Gherkin criteria](0038-acceptance-test-first.md) | Accepted |
| 0039 | [JGiven port-to-port tests against in-memory fakes](0039-jgiven-port-to-port-tests-with-in-memory-fakes.md) | Accepted |
| 0040 | [Where Playwright E2E tests run](0040-playwright-e2e-placement.md) | Accepted |
| 0041 | [Claude Code first, with AGENTS.md as the source of truth](0041-claude-code-first-agents-md.md) | Accepted |
| 0042 | [SDLC skill chain: refine, plan, implement, review and ship](0042-sdlc-skill-chain.md) | Proposed (details to be designed) |
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
| 0055 | [PR previews stay on fly.dev; environments differ only in configuration](0055-previews-on-fly-dev-and-environment-parity.md) | Accepted |
| 0056 | [Safeguards for blueprint's public demo deployment](0056-demo-deployment-safeguards.md) | Accepted |
| 0057 | [A demo is required only for user-visible changes](0057-demo-only-for-user-visible-changes.md) | Accepted |
| 0058 | [Dependabot merge and release policy](0058-dependabot-merge-and-release-policy.md) | Accepted |
| 0059 | [Branch protection without required reviews, and CODEOWNERS for guardrails](0059-branch-protection-and-codeowners.md) | Accepted |
| 0060 | [Demo gate as a required status check posted with the human's credentials](0060-demo-gate-as-required-status-check.md) | Accepted |
| 0061 | [Backlog folders and flow](0061-backlog-folders-and-flow.md) | Accepted |
| 0062 | [Backlog items as Cockburn use cases with a security impact section](0062-backlog-items-as-cockburn-use-cases.md) | Accepted |
| 0063 | [Living use-case catalog, ID-tagged tests and the JGiven report](0063-living-use-case-catalog-and-jgiven-report.md) | Accepted |
| 0064 | [Preview databases: one shared Neon branch with a database per PR](0064-preview-databases-in-shared-neon-branch.md) | Accepted |
| 0065 | [Neon branch budget and snapshot retention](0065-neon-branch-budget.md) | Accepted |
| 0066 | [Event types: JSON Schema with json-schema-to-typescript and jsonschema2pojo](0066-websocket-event-type-generation.md) | Accepted |
| 0067 | [JGiven 3.x for JUnit 6 and Spring 7](0067-jgiven-3-for-junit-6.md) | Accepted |
| 0068 | [/demo flow: guided scenarios, exploration and confirmed triage](0068-demo-flow.md) | Accepted |
