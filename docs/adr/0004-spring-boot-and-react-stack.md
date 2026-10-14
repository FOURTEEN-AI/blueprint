# 0004. Opinionated stack: Spring Boot 4 (Java 25) and a React SPA

- Status: Accepted
- Date: 2026-10-14

## Context

A template can be stack-agnostic (only the workflow kit), offer several stack presets, or commit to one stack. Stack-agnostic skills stay shallow. Deep automation (architecture checks, codegen, test conventions) needs concrete assumptions.

## Decision

Blueprint commits to **one fixed stack**:

- Backend: **Spring Boot 4.x on Java 25**, built with Gradle.
- Frontend: a **React single-page application** built with Node tooling (details in ADR 0016).

There are no alternative stack presets.

## Consequences

- Skills, hooks, CI and architecture tests can be precise and opinionated.
- Users who want another stack are not the target audience.
- Spring Boot 4.x is a new major line, so some third-party libraries may lag behind. We pick dependencies with that in mind.
