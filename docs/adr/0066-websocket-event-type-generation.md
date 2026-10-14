# 0066. Event types: JSON Schema with json-schema-to-typescript and jsonschema2pojo

- Status: Accepted
- Date: 2026-10-14
- Extends: [0015](0015-asyncapi-for-websocket-events.md)

## Context

ADR 0015 defines WebSocket events in AsyncAPI. Checking the tooling showed that the official AsyncAPI Java Spring template is apparently archived and doesn't support AsyncAPI v3. Modelina's v3 support is unconfirmed, and community plugins target Kafka or Spring Cloud Stream rather than raw WebSockets. No maintained generator was found that produces Java records.

## Decision

- Event payloads are **standalone JSON Schema files**, referenced with `$ref` from `asyncapi.yaml`. AsyncAPI documents the channel and stays the contract.
- **TypeScript** types are generated with **`json-schema-to-typescript`**.
- **Java** types are generated with **`jsonschema2pojo`** (Gradle plugin, Jackson 3 annotations for Spring Boot 4). The output is mutable classes, not records. They are used **only in the WebSocket adapter**, never in the domain (ADR 0009).

## Consequences

- Both sides are generated from one schema and can't drift, consistent with the spec-first approach for REST (ADR 0014).
- The tools are mature and independent of the AsyncAPI version.
- Generated Java classes don't match the record style used elsewhere. That's acceptable because they're confined to the adapter.
- Gradle 9 compatibility of `jsonschema2pojo` was not confirmed and has to be verified during implementation. If it fails, the fallback is hand-written records plus a contract test against the schema.
