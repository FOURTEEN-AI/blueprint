# 0001. Record architecture decisions

- Status: Accepted
- Date: 2026-10-14

## Context

Blueprint is a template that both people and AI agents will build on. Many of its choices only make sense together, and many trade-offs aren't visible in the code. Agents in particular need a durable, machine-readable record of *why* things are the way they are, so they don't undo deliberate decisions.

## Decision

We record architecturally significant decisions as Architecture Decision Records (ADRs) in `docs/adr/`:

- One Markdown file per decision, named `NNNN-kebab-case-title.md`, numbered sequentially.
- Format: Status, Date, Context, Decision, Consequences.
- Status is one of `Proposed`, `Accepted`, `Superseded by NNNN` or `Deprecated`.
- ADRs are immutable once accepted. A changed decision gets a new ADR that supersedes the old one, and the old one stays for history.
- `docs/adr/README.md` keeps an index.

## Consequences

- Reviewers and agents can check a change against the ADRs. AGENTS.md points to this directory.
- Superseded ADRs stay in the repo, so the history of a decision stays readable.
- Writing ADRs adds a little overhead to architectural changes. That's intended.
