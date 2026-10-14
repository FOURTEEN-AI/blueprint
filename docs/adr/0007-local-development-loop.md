# 0007. Local development loop: Vite dev server proxying to bootTestRun

- Status: Accepted
- Date: 2026-10-14

## Context

The production artifact is a single JAR (ADR 0005), but rebuilding the JAR for every frontend change is too slow. Local development also needs a PostgreSQL database.

## Decision

- The frontend runs with the **Vite dev server** (hot module replacement). It proxies `/api` and the WebSocket endpoint to the backend.
- The backend runs through **`./gradlew bootTestRun`**, using Spring Boot's development-time Testcontainers support (`@ServiceConnection`), which starts PostgreSQL automatically.
- The single JAR is built only in CI and for production.

## Consequences

- Local development needs no configuration: Docker plus the two commands are enough.
- The devcontainer provides Docker-in-Docker for Testcontainers.
- Developers run two processes. Docs and skills say so explicitly.
