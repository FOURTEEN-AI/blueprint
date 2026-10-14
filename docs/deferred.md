# Deferred design topics

These topics were deliberately deferred during the design of blueprint (2026-10-14). The decisions already made are recorded as ADRs in [docs/adr/](adr/README.md). When a topic gets resolved, record it as an ADR and remove it here.

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

## 2. Hooks and guardrails (AI kit)

**Open:** which Claude Code hooks and settings the kit ships. Candidates discussed:
- format on edit (Spotless/Prettier)
- block dangerous commands: pushing to `main`, force-push, editing guardrail files, reading secret-like files, destructive `fly`/Neon commands against prod
- fast checks before the agent may stop (compile, unit tests, ArchUnit)
- commitlint on agent commits
- a permission allowlist

**Already decided (inputs):**
- Claude Code first, with AGENTS.md as the source of truth ([0041](adr/0041-claude-code-first-agents-md.md)).
- CODEOWNERS protects `.github/` and `.claude/` ([0059](adr/0059-branch-protection-and-codeowners.md)).
- No secrets in the working tree ([0037](adr/0037-configuration-and-secrets.md)).

## 3. SDLC skill details

**Open:** what each skill in the chain actually contains ([0042](adr/0042-sdlc-skill-chain.md), status *Proposed*):

- **refine**: casual use case → fully dressed use case, with security impact and Gherkin. How does it question itself when running autonomously?
- **plan**: the format of the plan, and how it covers modules, onion layers, spec and migration changes.
- **implement**: the order of steps (acceptance test, spec, code), and when to stop and ask.
- **review + ship**: the self-review checklist (architecture rules, expand/contract migrations, correct commit type), and handling CI failures.
- How the autonomous loop chains these skills and what it does when one fails ([0046](adr/0046-autonomous-backlog-loop.md)).

**Already decided (inputs):**
- Backlog folders and flow ([0061](adr/0061-backlog-folders-and-flow.md)).
- Item templates as Cockburn use cases ([0062](adr/0062-backlog-items-as-cockburn-use-cases.md)).
- The existing `grill-me` skill as the model for interactive refinement.

## 4. Skills catalog

Declined for now: an AGENTS.md section listing every skill (existing or planned) with its defining ADR. Planned skills are currently documented only in the ADRs.

## To verify during implementation

These aren't open decisions, but facts that couldn't be fully confirmed:

- **Cloudflare free plan**: one IP-based rate-limiting rule with a short fixed window ([0052](adr/0052-cloudflare-in-front-of-production.md)).
- **Neon free plan**: root-branch and total-branch limits ([0064](adr/0064-preview-databases-in-shared-neon-branch.md), [0065](adr/0065-neon-branch-budget.md)).
- **`jsonschema2pojo`** with Gradle 9, Java 25 and Jackson 3. If it fails, fall back to hand-written records plus a contract test ([0066](adr/0066-websocket-event-type-generation.md)).
- **JGiven 3.x** on Java 25 ([0067](adr/0067-jgiven-3-for-junit-6.md)).
