# 0102. Hooks: format on every edit, full build before stopping

- Status: Accepted
- Date: 2026-10-15
- Extends: [0041](0041-claude-code-first-agents-md.md), [0034](0034-code-quality-and-security-tooling.md)

## Context

ADR 0041 ships hooks with the kit but left their contents open. Two candidates are about feedback speed rather than blocking dangerous actions: formatting, and the checks an agent must pass before ending its turn. Without them, format slips and broken tests surface only in CI, one round trip later.

## Decision

- **Format on edit**: a `PostToolUse` hook formats every file an agent writes or edits:
  - Java with Spotless, for that single file
  - TypeScript, CSS, JSON and Markdown with Prettier

  A file that can't be formatted (e.g. a syntax error) doesn't block the edit; the build reports it later.
- **Full build before stopping**: a `Stop` hook runs the **full local build**, including Testcontainers tests, the full-context API tests (ADR 0101) and the Playwright suite. If it fails, the hook blocks stopping and feeds the errors back to the agent.
  - It runs only if files changed since the last green run, so ending a turn to ask a question costs nothing.
  - After several consecutive failed attempts it lets the agent stop, with the failure reported, so an unfixable error can't loop forever.
- Both hooks live in `.claude/settings.json` and the scripts it calls, which are code-owned (ADR 0089).
- Blocking dangerous commands and the permission allowlist are still open ([deferred.md](../deferred.md)).

## Consequences

- Agents always work on formatted code, and diffs carry no format noise.
- A turn only ends green, so CI failures are rare and mostly environment-specific.
- Ending a turn after changes takes as long as the full build. Every environment an agent works in needs Docker, including the cloud routine (to be verified).
- **Rejected:**
  - Formatting once before stopping, because the agent would work on unformatted code in between.
  - A fast suite without Docker, or only compile and lint, because more failures would reach CI.
  - No stop hook, because nothing would enforce the checks.
