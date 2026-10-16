# Deferred design topics

These topics were deliberately deferred during the design of blueprint (2026-10-14 and 2026-10-15). The decisions already made are recorded as ADRs in [docs/adr/](adr/README.md). When a topic gets resolved, record it as an ADR and remove it here.

## 1. SDLC skill texts

**Open:** the texts and implementations behind the decided design ([0042](adr/0042-sdlc-skill-chain.md), status *Proposed*):

- **refine**: the checklist, the anchor questions for criticality, the counter-check prompt ([0122](adr/0122-refine-skill.md)).
- **plan, implement, review + ship**: the skill texts, and the definitions of the six read-only review agents ([0119](adr/0119-loop-routines-and-stages.md), [0124](adr/0124-gates.md)).
- **The gates**: the Java code in the `gates` source set, the JSON schema of `state.json` and the exact checks ([0124](adr/0124-gates.md)).
- **The narrow permission allowlist** of the routines ([0125](adr/0125-guardrails-without-hooks.md)).
- **The dispatch workflow** and its Gradle task ([0123](adr/0123-pr-kinds-and-dispatch.md)).

**Already decided (inputs):**
- Gates, stage files and the test-gate tooling ([0124](adr/0124-gates.md)).
- Ideation and creation PRs, the dispatch workflow, the failure path and the hand-off to `/demo` ([0123](adr/0123-pr-kinds-and-dispatch.md)).
- Guardrails without blocking hooks ([0125](adr/0125-guardrails-without-hooks.md)).
- Human roles and the three workflow parts ([0121](adr/0121-human-roles-in-the-workflow.md), [0120](adr/0120-ideation-creation-validation.md)).
- What refine does ([0122](adr/0122-refine-skill.md)), the two routines and the contents of plan, implement and review+ship ([0119](adr/0119-loop-routines-and-stages.md)), and how a run is orchestrated ([0118](adr/0118-loop-orchestration.md)).
- Claude Code first, with AGENTS.md as the source of truth ([0041](adr/0041-claude-code-first-agents-md.md)).
- Backlog folders and flow ([0074](adr/0074-implemented-backlog-items-are-deleted.md)) and item templates as Cockburn use cases ([0062](adr/0062-backlog-items-as-cockburn-use-cases.md)).
- The existing `grill-me` skill as the model for interactive refinement.
- `/demo` enables auto-merge after a passed demo ([0103](adr/0103-demo-enables-auto-merge.md)).
- Size and slicing rules ([0116](adr/0116-use-case-size-and-slicing.md)), criticality ([0106](adr/0106-criticality-and-quality-thresholds.md)) and the optional item sections ([0108](adr/0108-visibility-rules-and-invariants-in-use-cases.md), [0117](adr/0117-observed-not-tested.md)).
- The rules the test gates enforce: [0105](adr/0105-test-levels-and-layer-disjointness.md), [0106](adr/0106-criticality-and-quality-thresholds.md), [0107](adr/0107-contract-tests-for-fakes.md), [0110](adr/0110-test-exceptions-register.md), [0111](adr/0111-test-naming-and-report-structure.md), [0063](adr/0063-living-use-case-catalog-and-jgiven-report.md), [0112](adr/0112-frontend-tests-count-for-traceability.md), [0114](adr/0114-criticality-annotation-package-and-reassessment.md).

## To do during implementation

Not open decisions, but deliverables that ADRs require:

- **CI checks and ruleset**: the `ideation/*` path check and the `.creation/` absence check ([0123](adr/0123-pr-kinds-and-dispatch.md), [0124](adr/0124-gates.md)), and the ruleset that replaces the AGENTS.md rule about committing to `main` ([0125](adr/0125-guardrails-without-hooks.md)).
- **Restore runbook** for restoring data from a `pre-vX.Y.Z` snapshot ([0073](adr/0073-why-data-restore-is-manual.md)).

## To verify during implementation

These aren't open decisions, but facts that couldn't be fully confirmed:

- **Cloudflare free plan**: one IP-based rate-limiting rule with a short fixed window. Cloudflare's docs confirm that free-plan rules can match only on path ([0052](adr/0052-cloudflare-in-front-of-production.md), [0082](adr/0082-edge-rate-limit-on-session-and-websocket-paths.md)).
- **Neon free plan**: root-branch and total-branch limits, and the monthly compute-hour allowance ([0065](adr/0065-neon-branch-budget.md), [0090](adr/0090-pr-preview-environments.md)).
- **Neon roles on branches**: whether a branch inherits its parent's role passwords, and how to lock the inherited role on the `previews` branch ([0090](adr/0090-pr-preview-environments.md)).
- **Grafana Cloud free tier**: limits for metrics series, log volume, trace volume and alert rules ([0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)).
- **GitHub token for `repository_dispatch`**: which fine-grained permission it needs. If it is Contents write, the token in Grafana can also push branches, which is more than ADR 0069 assumes ([0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)).
- **Grafana webhook contact point**: whether a custom payload can produce the `repository_dispatch` body (`event_type`, `client_payload`), and whether the `client_payload` limits (10 top-level properties, 65535 characters) are enough ([0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)).
- **OTLP export from Spring Boot 4**: metrics via the Micrometer OTLP registry, logs via the OpenTelemetry Logback appender, to Grafana Cloud's OTLP endpoint ([0069](adr/0069-grafana-cloud-telemetry-and-alert-driven-incidents.md)).
- **Claude Code cloud routine**: that it can authenticate to GitHub as the project App, and that its sandbox runs Java 25, Docker (Testcontainers) and Playwright browsers ([0046](adr/0046-autonomous-backlog-loop.md), [0084](adr/0084-project-github-app-as-bot-identity.md)).
- **Routine trigger from a workflow**: that a Claude Code routine can be started through an API call from GitHub Actions, and which token that needs ([0118](adr/0118-loop-orchestration.md)).
- **Subscription billing for `claude -p` and routines**: Anthropic paused the move of programmatic usage to a separate credit. Re-check before relying on it ([0118](adr/0118-loop-orchestration.md)).
- **Scheduled workflow reliability**: that the hourly cron of the dispatch workflow runs often enough, since GitHub may delay or skip scheduled runs ([0123](adr/0123-pr-kinds-and-dispatch.md)).
- **Routine permissions**: how the cloud routine treats permission rules and denied calls without a human, and whether it behaves like `claude -p` ([0125](adr/0125-guardrails-without-hooks.md)).
- **Dependabot and `workflow_run`**: that a `workflow_run` workflow following a Dependabot-triggered run receives environment secrets ([0085](adr/0085-untrusted-build-trusted-deploy.md)).
- **Dependabot with Gradle**: whether it distinguishes runtime from development dependencies for the `fix(deps)` / `build(deps)` prefixes. If not, Gradle plugin updates become patch releases, which is harmless ([0058](adr/0058-dependabot-merge-and-release-policy.md)).
- **openapi-generator** `spring` generator with Spring Boot 4 and Jackson 3 ([0097](adr/0097-openapi-generators.md)).
- **Jib** on Java 25 (probably needs an explicit base image) and Gradle 9 ([0030](adr/0030-container-images-with-jib.md)).
- **Fly `release_command`** with a Jib image, which has a fixed entrypoint and no shell ([0012](adr/0012-migrations-via-fly-release-command.md)).
- **`jsonschema2pojo`** with Gradle 9, Java 25 and Jackson 3. If it fails, fall back to hand-written records plus a contract test ([0066](adr/0066-websocket-event-type-generation.md)).
- **Fly health checks and metrics scraping** don't wake scaled-to-zero machines ([0077](adr/0077-actuator-on-internal-management-port.md)).
- **JGiven 3.x** on Java 25 ([0067](adr/0067-jgiven-3-for-junit-6.md)).
- **JaCoCo per test level**, including the Playwright run against the built JAR (JaCoCo agent on the JAR), as input for layer disjointness ([0105](adr/0105-test-levels-and-layer-disjointness.md)).
- **PIT** with Java 25, JUnit 6 and JGiven 3.x ([0106](adr/0106-criticality-and-quality-thresholds.md), [0067](adr/0067-jgiven-3-for-junit-6.md)).
- **jqwik** with JUnit 6 ([0108](adr/0108-visibility-rules-and-invariants-in-use-cases.md)).
