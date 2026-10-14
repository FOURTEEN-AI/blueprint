# 0045. In-repo backlog organized as status folders

- Status: Accepted
- Date: 2026-10-14

## Context

Feedback and work items have to be accessible to agents and versioned with the code. The options were GitHub Issues, one file per item with status in frontmatter, a single BACKLOG.md, or status folders.

## Decision

The backlog lives in `backlog/` as one Markdown file per item, and **the folder an item sits in is its status** (e.g. `inbox/`, `ready/`, `done/`). Items move between statuses with `git mv`. The exact set of folders and the item template will be decided along with the SDLC skills (ADR 0042).

## Consequences

- Status changes are visible in diffs and PRs.
- Agents need no API access to manage work.
- There's no web UI or board. Humans browse the folders.
