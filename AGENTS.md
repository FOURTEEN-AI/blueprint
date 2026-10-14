# AGENTS.md

Instructions for AI coding agents working in this repository.

## Project context

- **blueprint** is a public project template (Spring Boot 4 + React on Fly.io) with an AI workflow kit for Claude Code. AI agents take work from backlog item to production, and humans demo and decide. See [README.md](README.md).
- **Current phase: design.** There is no application code, build, CI or branch protection yet. The work consists of making design decisions and recording them.
- **Decisions** are recorded as ADRs in [docs/adr/](docs/adr/README.md). The index lists every ADR and its status.
- **Deferred topics** and facts still to be verified are listed in [docs/deferred.md](docs/deferred.md).

## ADR rules

- Before changing or proposing anything, **read the relevant ADRs**. Don't contradict an accepted ADR silently. If a change conflicts with one, point that out.
- **Never edit an accepted ADR's content.** To change a decision, write a new ADR that supersedes it, and change only the old ADR's status line to `Superseded by [NNNN](…)`. Additions that don't reverse a decision get a new ADR with an `Extends:` line.
- New ADRs:
  - are numbered sequentially: `docs/adr/NNNN-kebab-case-title.md`
  - use the format Status, Date, Context, Decision, Consequences (see [0001](docs/adr/0001-record-architecture-decisions.md))
  - record the rejected alternatives and the facts the decision relies on
- Keep [docs/adr/README.md](docs/adr/README.md) up to date, and add or remove entries in [docs/deferred.md](docs/deferred.md) when a topic is deferred or resolved.

## Working conventions

- **English only**: code, file names, comments, docs and commit messages ([0003](docs/adr/0003-english-as-project-language.md)).
- **Conventional Commits** for every commit message, e.g. `docs: add ADR for …` ([0032](docs/adr/0032-semantic-release-and-conventional-commits.md)).
- **Commit directly to `main` for now.** Once CI and branch protection exist, the PR-only workflow with squash merges from [0033](docs/adr/0033-protected-main-squash-merge.md) applies, and this rule must be updated.
