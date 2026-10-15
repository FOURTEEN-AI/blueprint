# Deferred design topics

These topics were deliberately deferred during the design of blueprint (2026-10-14 and 2026-10-15). The decisions already made are recorded as ADRs in [docs/adr/](adr/README.md). When a topic gets resolved, record it as an ADR and remove it here.

## 1. Testing strategy (as a whole)

To be designed as a single piece, not item by item.

**Open:**
- Coverage and quality-gate thresholds (JaCoCo, SonarCloud "new code"), e.g. a percentage, or mutation testing (PIT) on the domain and application layers.
- How the test levels fit together, and what belongs on which level.
- Test data strategy, fakes versus contract tests for fakes, and test naming conventions.

**Already decided (inputs):**
- Acceptance tests come first, with Gherkin criteria ([0038](adr/0038-acceptance-test-first.md)).
- JGiven port-to-port tests run against in-memory fakes; adapters get Testcontainers integration tests ([0039](adr/0039-jgiven-port-to-port-tests-with-in-memory-fakes.md), [0067](adr/0067-jgiven-3-for-junit-6.md)).
- Playwright runs the full suite in CI and a smoke subset against previews and prod ([0040](adr/0040-playwright-e2e-placement.md)).
- Use-case IDs are tags on tests, with a traceability check and the JGiven report on Pages ([0063](adr/0063-living-use-case-catalog-and-jgiven-report.md)).
- Quality tooling is chosen; thresholds are open ([0034](adr/0034-code-quality-and-security-tooling.md)).
- Infrastructure smoke tests survive `/bootstrap` and are exempt from the traceability check ([0092](adr/0092-infrastructure-smoke-tests.md)).

## 2. Hooks and guardrails (AI kit)

**Open:** which Claude Code hooks and settings the kit ships. Candidates discussed:
- format on edit (Spotless/Prettier)
- block dangerous commands: pushing to `main`, force-push, editing guardrail files, reading secret-like files, destructive `fly`/Neon commands against prod
- fast checks before the agent may stop (compile, unit tests, ArchUnit)
- a permission allowlist

**Already decided (inputs):**
- Claude Code first, with AGENTS.md as the source of truth ([0041](adr/0041-claude-code-first-agents-md.md)).
- CODEOWNERS protects `.github/`, `.claude/` and the guardrail configuration ([0059](adr/0059-branch-protection-and-codeowners.md), [0089](adr/0089-codeowners-scope-and-admin-bypass.md)).
- A hook blocks commit-status API calls outside `/demo` ([0088](adr/0088-demo-status-from-local-sessions.md)).
- The loop's GitHub App has no workflows permission ([0084](adr/0084-project-github-app-as-bot-identity.md)).
- Conventional Commits are checked on PR titles in CI only, not by a local hook ([0096](adr/0096-pr-title-is-the-only-conventional-commit.md)).
- No secrets in the working tree ([0037](adr/0037-configuration-and-secrets.md)).

## 3. SDLC skill details

**Open:** what each skill in the chain actually contains ([0042](adr/0042-sdlc-skill-chain.md), status *Proposed*):

- **refine**: casual use case → fully dressed use case, with security impact and Gherkin. How does it question itself when running autonomously?
- **plan**: the format of the plan, and how it covers modules, onion layers, spec and migration changes.
- **implement**: the order of steps (acceptance test, spec, code), and when to stop and ask.
- **review + ship**: the self-review checklist (architecture rules, expand/contract migrations, correct commit type), and handling CI failures.
- How the autonomous loop chains these skills and what it does when one fails ([0046](adr/0046-autonomous-backlog-loop.md)).
- Who merges after a passed demo: the `/demo` session itself, or the autonomous loop on its next run ([0068](adr/0068-demo-flow.md)).

**Already decided (inputs):**
- Backlog folders and flow ([0074](adr/0074-implemented-backlog-items-are-deleted.md)).
- Item templates as Cockburn use cases ([0062](adr/0062-backlog-items-as-cockburn-use-cases.md)).
- The existing `grill-me` skill as the model for interactive refinement.

## 4. Skills catalog

Declined for now: an AGENTS.md section listing every skill (existing or planned) with its defining ADR. Planned skills are currently documented only in the ADRs.

## To do during implementation

Not open decisions, but deliverables that ADRs require:

- **Restore runbook** for restoring data from a `pre-vX.Y.Z` snapshot ([0073](adr/0073-why-data-restore-is-manual.md)).
- **Devcontainer**: add pnpm and read `.node-version` ([0081](adr/0081-pnpm-standalone-without-corepack.md)); add `flyctl`, which `/bootstrap` needs ([0047](adr/0047-bootstrap-skill.md)).

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
- **Dependabot and `workflow_run`**: that a `workflow_run` workflow following a Dependabot-triggered run receives environment secrets ([0085](adr/0085-untrusted-build-trusted-deploy.md)).
- **Dependabot with Gradle**: whether it distinguishes runtime from development dependencies for the `fix(deps)` / `build(deps)` prefixes. If not, Gradle plugin updates become patch releases, which is harmless ([0058](adr/0058-dependabot-merge-and-release-policy.md)).
- **openapi-generator** `spring` generator with Spring Boot 4 and Jackson 3 ([0097](adr/0097-openapi-generators.md)).
- **Jib** on Java 25 (probably needs an explicit base image) and Gradle 9 ([0030](adr/0030-container-images-with-jib.md)).
- **Fly `release_command`** with a Jib image, which has a fixed entrypoint and no shell ([0012](adr/0012-migrations-via-fly-release-command.md)).
- **`jsonschema2pojo`** with Gradle 9, Java 25 and Jackson 3. If it fails, fall back to hand-written records plus a contract test ([0066](adr/0066-websocket-event-type-generation.md)).
- **Fly health checks and metrics scraping** don't wake scaled-to-zero machines ([0077](adr/0077-actuator-on-internal-management-port.md)).
- **JGiven 3.x** on Java 25 ([0067](adr/0067-jgiven-3-for-junit-6.md)).
