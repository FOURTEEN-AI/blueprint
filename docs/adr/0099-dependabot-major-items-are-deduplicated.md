# 0099. Backlog items for Dependabot major updates are deduplicated

- Status: Accepted
- Date: 2026-10-15
- Extends: [0078](0078-dependabot-majors-become-backlog-items.md)

## Context

The workflow of ADR 0078 closes a Dependabot PR for a major update after writing a backlog item. Dependabot ignores the closed version, but opens a new PR for the next release of the same major (e.g. 5.0.1 after 5.0.0), which would create a second item for the same upgrade.

## Decision

Before writing an item, the workflow checks `backlog/inbox/`, `backlog/ready/` and `backlog/rejected/` for an item on the **same dependency and major version**. If one exists, it only closes the Dependabot PR.

## Consequences

- One item per major upgrade, however many releases of that major appear.
- A major upgrade that was rejected stays rejected until a newer major appears.
- Items are matched by the dependency and major version recorded in their frontmatter, so the workflow has to write them consistently.
