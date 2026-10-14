# 0041. Claude Code first, with AGENTS.md as the source of truth

- Status: Accepted
- Date: 2026-10-14

## Context

Several coding agents exist (Claude Code, Codex, Cursor, Copilot), and AGENTS.md is an emerging cross-agent convention. Claude Code offers richer mechanisms: skills, hooks, subagents and scheduled agents.

## Decision

- The kit is **optimized for Claude Code**: skills in `.claude/skills/`, hooks and permissions in `.claude/settings.json`, and scheduled cloud agents.
- **`AGENTS.md`** is the single source of truth for project conventions (architecture rules, commands, testing, commits). `CLAUDE.md` only imports it.
- The kit includes **hooks and guardrails** and the **CI feedback loop** (ADR 0031). Their exact contents will be designed later.

## Consequences

- Other agents get the conventions through AGENTS.md but not the automation.
- Conventions live in one file and don't drift between agent-specific copies.
