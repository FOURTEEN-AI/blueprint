# Deferred design topics

These topics were deliberately deferred during the design of blueprint (2026-10-14 and 2026-10-15). The decisions already made are recorded as ADRs in [docs/adr/](adr/README.md). When a topic gets resolved, record it as an ADR and remove it here.

## 1. Guardrails and gates (AI kit)

**Open:** which actions hooks hard-block and which go through a permission prompt, and the permission allowlist. Candidates discussed:
- block dangerous commands: pushing to `main`, force-push, editing guardrail files, reading secret-like files, destructive `fly`/Neon commands against prod
- a permission allowlist

**Already decided (inputs):**
- Claude Code first, with AGENTS.md as the source of truth ([0041](adr/0041-claude-code-first-agents-md.md)).
- Hooks format every edit and run the full build before the agent stops ([0102](adr/0102-format-on-edit-and-full-build-stop-hook.md)).
- CODEOWNERS protects `.github/`, `.claude/`, the guardrail configuration and the alert rules ([0059](adr/0059-branch-protection-and-codeowners.md), [0089](adr/0089-codeowners-scope-and-admin-bypass.md), [0100](adr/0100-alert-rules-are-code-owned.md)).
- A hook blocks commit-status API calls outside `/demo` ([0088](adr/0088-demo-status-from-local-sessions.md)).
- The loop's GitHub App has no workflows permission ([0084](adr/0084-project-github-app-as-bot-identity.md)).
- Conventional Commits are checked on PR titles in CI only, not by a local hook ([0096](adr/0096-pr-title-is-the-only-conventional-commit.md)).
- No secrets in the working tree ([0037](adr/0037-configuration-and-secrets.md)).

## 2. SDLC skill details

**Open:** what each skill in the chain actually contains ([0042](adr/0042-sdlc-skill-chain.md), status *Proposed*):

- **refine**: casual use case → fully dressed use case, with security impact and Gherkin. How does it question itself when running autonomously?
- **plan**: the format of the plan, and how it covers modules, onion layers, spec and migration changes.
- **implement**: the order of steps (acceptance test, spec, code), and when to stop and ask.
- **review + ship**: the self-review checklist (architecture rules, expand/contract migrations, correct commit type), and handling CI failures.
- The gate script for each stage (what exactly it checks) and the format of the stage state file.

**Already decided (inputs):**
- How the loop chains the skills, handles failures and starts follow-up runs ([0118](adr/0118-loop-orchestration.md)).
- Backlog folders and flow ([0074](adr/0074-implemented-backlog-items-are-deleted.md)).
- Item templates as Cockburn use cases ([0062](adr/0062-backlog-items-as-cockburn-use-cases.md)).
- The existing `grill-me` skill as the model for interactive refinement.
- Refine runs during triage, so items in `ready/` are always fully dressed ([0062](adr/0062-backlog-items-as-cockburn-use-cases.md)).
- `/demo` enables auto-merge after a passed demo ([0103](adr/0103-demo-enables-auto-merge.md)).
- Size and slicing rules refine has to apply: one criticality, at most twelve scenarios, vertical slices ([0116](adr/0116-use-case-size-and-slicing.md)).
- Refine judges criticality ([0106](adr/0106-criticality-and-quality-thresholds.md)) and fills in the optional sections Visibility rules, Invariants and Observed, not tested ([0108](adr/0108-visibility-rules-and-invariants-in-use-cases.md), [0117](adr/0117-observed-not-tested.md)).

## 3. Test gate tooling

**Open:** how the test checks are implemented. Candidates: an external Gradle plugin (e.g. deterministic-gates), a convention plugin in this repository, or standard tools where they suffice (PIT, ArchUnit, Spring Modulith).

**Already decided (inputs):** the rules to enforce:
- layer disjointness per module ([0105](adr/0105-test-levels-and-layer-disjointness.md))
- criticality, PIT target set and thresholds ([0106](adr/0106-criticality-and-quality-thresholds.md))
- a contract test for every fake ([0107](adr/0107-contract-tests-for-fakes.md))
- the exceptions register ([0110](adr/0110-test-exceptions-register.md))
- the stage package location ([0111](adr/0111-test-naming-and-report-structure.md))
- use-case traceability across JGiven, Playwright and Vitest, with the "Observed, not tested" exemption ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md), [0112](adr/0112-frontend-tests-count-for-traceability.md), [0117](adr/0117-observed-not-tested.md))
- the criticality annotation package ([0114](adr/0114-criticality-annotation-package-and-reassessment.md))
- the item format: one criticality, at most twelve scenarios ([0116](adr/0116-use-case-size-and-slicing.md))

## To do during implementation

Not open decisions, but deliverables that ADRs require:

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
