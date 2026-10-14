# 0079. A single setup inventory owned by /bootstrap

- Status: Accepted
- Date: 2026-10-14
- Extends: [0047](0047-bootstrap-skill.md), [0031](0031-github-actions-ci-cd.md)

## Context

The accounts, secrets and settings a project needs are scattered across many ADRs (0031, 0047, 0052, 0053, 0059, 0060, 0063, …). ADR 0031 lists only three secrets. Without one complete list, `/bootstrap` and users setting things up by hand will miss something.

## Decision

- **[docs/setup.md](../setup.md)** is the single, complete inventory of:
  - external accounts
  - every secret: name, where it's stored, who creates it, and what uses it
  - every configuration value and repository setting a project needs
- `/bootstrap` creates exactly what this inventory lists. It is the inventory's executable counterpart.
- **Every ADR that introduces or removes an account, secret or setting must update `docs/setup.md` in the same change.**

## Consequences

- One place to check what a project needs, for people, for `/bootstrap` and for `/sync-blueprint`.
- The inventory is a living document, not an ADR: it changes without supersedes.
- Names in the inventory are the intended names. Implementation may rename them but must update the inventory.
