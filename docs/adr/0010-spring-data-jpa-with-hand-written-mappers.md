# 0010. Spring Data JPA with hand-written mappers

- Status: Accepted
- Date: 2026-10-14

## Context

With a strict domain core (ADR 0009), persistence happens in infrastructure. Candidates were Spring Data JPA, Spring Data JDBC and jOOQ. Mapping between models could be generated (MapStruct) or written by hand.

## Decision

- **Spring Data JPA** with separate JPA entity classes in each module's infrastructure layer.
- **Hand-written mappers** (plain classes or static methods) translate between domain objects, JPA entities and generated API DTOs. There is no MapStruct.

## Consequences

- JPA is familiar to most Spring developers.
- Mappers are explicit code that agents can read, change and test without annotation-processor magic.
- More boilerplate, and the cost of mapping plus the complexity of JPA (lazy loading, dirty checking) both stay with us.
