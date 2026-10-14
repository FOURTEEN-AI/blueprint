# 0009. Strict domain core, enforced by ArchUnit

- Status: Accepted
- Date: 2026-10-14

## Context

In onion architecture the domain core is often "pragmatically" polluted with JPA annotations or generated API types. That couples the domain to frameworks and makes the rules fuzzy for agents.

## Decision

The domain layer must not depend on Spring, JPA/Jakarta Persistence or generated OpenAPI/AsyncAPI types. JPA entities live in infrastructure; API DTOs live in the web adapter. **ArchUnit tests** (optionally with jMolecules annotations) enforce these rules and the inward-only dependency direction, and they run in every build.

## Consequences

- The rules are checked automatically, so an agent breaking them gets a failing build rather than a review comment.
- Mapping code is needed between domain, persistence and API models (ADR 0010).
- Domain tests are plain unit tests with no framework.
