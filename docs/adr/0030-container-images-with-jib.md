# 0030. Build container images with Jib and publish them to GHCR

- Status: Accepted
- Date: 2026-10-14

## Context

The single JAR (ADR 0005) needs a container image. The options were a multi-stage Dockerfile, Jib, and Spring Boot's `bootBuildImage` (Cloud Native Buildpacks).

## Decision

**Jib** (Gradle plugin) builds the image without a Docker daemon and pushes it to the **GitHub Container Registry**. Fly deploys that pushed image. There is no Dockerfile.

## Consequences

- Builds are reproducible and layered, with no Docker daemon needed in CI.
- Build-time steps that need to run the app (e.g. a JVM AOT-cache training run) are awkward. That's one reason cold start is accepted (ADR 0023).
- The migrate-only release command runs the same image with a different Spring profile (ADR 0012).
