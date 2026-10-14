# 0014. Spec-first OpenAPI

- Status: Accepted
- Date: 2026-10-14

## Context

Backend and frontend have to agree on the REST contract. Options were generating the spec from the code (springdoc), spec-first with code generation, or hand-written types on both sides.

## Decision

`openapi.yaml` is the **source of truth**. The build generates:

- Spring server interfaces and DTOs (used only in the web adapter, see ADR 0009), and
- a TypeScript client and types for the frontend.

## Consequences

- API changes start in the spec, which suits planning and review by agents.
- The two sides can't drift apart, because both compile against generated code.
- Codegen configuration lives in the Gradle build. Generated code is never edited or committed.
