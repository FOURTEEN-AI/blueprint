# 0118. Loop orchestration: one session, skill-scoped gates, committed stage state

- Status: Accepted (schedule and start rules replaced by [0123](0123-pr-kinds-and-dispatch.md))
- Date: 2026-10-15
- Extends: [0042](0042-sdlc-skill-chain.md), [0046](0046-autonomous-backlog-loop.md)

## Context

ADR 0042 defines the skill chain and ADR 0046 the scheduled loop. Open were how the loop runs the chain, how stage results are checked, what happens on failure and when the next run starts. Orchestration should be as deterministic as possible, and run on the Claude subscription.

## Decision

- **One session per run.** The routine runs the skills of the chain one after another in a single session.
- **Gates are scripts, not LLM judgement.** Each skill declares a Stop hook in its frontmatter. The hook blocks the end of the stage until the stage's gate script passes (extends [0102](0102-format-on-edit-and-full-build-stop-hook.md)). The same gates apply to local sessions and the loop.
- **Stage state is a file on the feature branch.** Each skill writes the current stage and resume information to a state file, which is committed. The hooks and a resumed run read it. `ship` deletes it as its last step, and a CI check fails while the file exists in a PR.
- **Failure path.** If a stage fails, the item returns to `backlog/inbox/` with a note describing the failure, and the PR is closed. There is no failure counter: triage decides again on every run.
- **CI fixes are capped.** `ship` fixes a red CI on its own PR in at most 3 rounds. After that, the run counts as failed.
- **Schedule.** The routine starts hourly. Its first step is a script check: if a PR from the loop is still open (waiting for a demo or for auto-merge), the run ends without further work. The slot (ADR 0046) is free when that PR is merged or closed.
- **Follow-up run after a demo.** A workflow on `push` to `main` starts the routine when a loop PR was merged. The next item then starts from the current `main`.

## Consequences

- Stage order and transitions are enforced by hooks and scripts. The model only works inside a stage.
- A lost container loses only the session. Branch, state file and item are intact, and the next run can resume.
- A failing item can be picked up again on every run and cost usage each time. Accepted for now. A failure counter can be added later without changing this design.
- The hourly check still starts a (minimal) routine session.
- `claude -p` and routines currently draw from the subscription limits. Anthropic paused its plan to move programmatic usage to a separate credit. It may return, so scripts call `claude` only through one thin wrapper.
- The CI check and the trigger workflow live in `.github/`, which the project App cannot change (ADR 0084). A human adds them.
- A new secret triggers the routine from the workflow ([setup inventory](../setup.md)).
- **Rejected:**
  - A script that starts a fresh `claude -p` session per stage, because the user preferred one session with script-checked gates.
  - Prose-only orchestration in a single skill, because nothing would enforce the order or the gates.
  - A gitignored, local state file, because resuming after container loss would not work.
  - Starting the next run directly from `/demo`, because the base would be stale until auto-merge completes.
  - A failure counter or a `needs-human` marker, because the user accepted re-triage on every run.
