# 0059. Branch protection without required reviews, and CODEOWNERS for guardrails

- Status: Accepted
- Date: 2026-10-14
- Extends: [0033](0033-protected-main-squash-merge.md)

## Context

Agents merge on their own (ADR 0043), and GitHub doesn't let anyone approve their own PR, so required reviews would block every PR. Without any human gate, though, an agent could weaken the guardrails themselves (workflows, hooks, agent settings).

## Decision

- `main` is protected by **required status checks** (including `demo`, ADR 0060), linear history and squash merges. **No approving review is required in general.**
- **CODEOWNERS** assigns a human owner to the guardrail files: `.github/`, `.claude/`, `CODEOWNERS` itself, and any file that configures branch rules or hooks. Changes to these paths require that **human code owner's review**.
- Agent tokens have **no admin rights**, so they can't change branch protection.

## Consequences

- Normal code flows autonomously, while changes to the safety net always involve a human.
- Dependabot updates to GitHub Actions wait for that review (ADR 0058).
- `/bootstrap` sets the user as the code owner.
