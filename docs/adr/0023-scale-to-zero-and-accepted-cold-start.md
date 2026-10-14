# 0023. Scale to zero in production and accept the JVM cold start

- Status: Accepted
- Date: 2026-10-14

## Context

The template should be cheap to run. Fly can stop idle machines and start them on the next request, but a Spring Boot + JPA app takes several seconds to start. We considered a Java 25 AOT cache built by a CI training run (awkward with Jib), GraalVM native images, keeping one machine warm, and accepting the delay.

## Decision

- Production uses **auto-stop/auto-start with a minimum of zero machines**.
- The cold start is **accepted**, with light tuning: lazy initialization where safe, tuned JVM flags, and a frontend "waking up" state while the first request is pending.

## Consequences

- Minimal cost when idle.
- The first request after an idle period takes a few seconds.
- Open WebSocket connections keep machines running while clients are connected.
- AOT caching or native images can be revisited later with a new ADR.
