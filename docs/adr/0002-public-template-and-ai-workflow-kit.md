# 0002. Blueprint is a public project template with an AI workflow kit

- Status: Accepted
- Date: 2026-10-14

## Context

We want a reusable starting point for new projects where AI coding agents do most of the software development lifecycle (SDLC) work. Options ranged from a plain template repo, through a reference app or a bare kit of agent skills, to a concrete product.

## Decision

Blueprint is **both**:

1. A **project template**: a working Spring Boot + React application with a devcontainer, CI/CD and deployment already wired up.
2. An **AI development workflow kit**: agent instructions, skills, hooks and a CI feedback loop that let agents take work from backlog item to production.

It is published publicly under Apache-2.0.

## Consequences

- Everything must be generic enough for strangers to use: no personal infrastructure, no hard-coded accounts, no company-specific conventions.
- Documentation (the README) has to be good enough for self-service onboarding.
- The kit and the app evolve together. Skills may assume the stack defined in later ADRs.
