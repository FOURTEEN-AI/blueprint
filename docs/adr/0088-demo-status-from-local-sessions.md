# 0088. Demo status from local sessions: a hook as a speed bump

- Status: Accepted
- Date: 2026-10-15
- Extends: [0060](0060-demo-gate-as-required-status-check.md)

## Context

ADR 0060 relies on the autonomous loop's identity lacking the "commit statuses" permission (ADR 0084). Local Claude Code sessions, however, run with the human's GitHub credentials: the devcontainer passes the human's `GH_TOKEN` into the container. Any local session, not just `/demo`, could post `demo = success`. As long as the agent can use the human's credential, no mechanism inside the session can fully prevent that.

## Decision

- `/demo` posts the status itself after the human confirms the result (ADR 0044).
- A Claude Code **hook blocks calls to the commit status API** (`gh api …/statuses/…` and equivalents) outside the `/demo` flow. Together with permission deny rules, it's a speed bump, not a guarantee.
- The remaining risk is accepted: local sessions are supervised by the human who runs them.

## Consequences

- An agent can't post the demo status by accident or as a shortcut in a normal session.
- A determined or prompt-injected local agent could still work around the hook, for example with a script. The gate is fully enforced only against the cloud loop.
- **Rejected:**
  - Having the human type the final status command themselves, because it adds friction to every demo for a risk that only exists in supervised sessions.
  - Removing `GH_TOKEN` from the devcontainer, because agents would lose `gh` for PRs and CI watching.
