# 0005. Ship backend and frontend as a single deployable

- Status: Accepted
- Date: 2026-10-14

## Context

A Spring Boot backend and a React SPA can ship as two artifacts (an API image plus an nginx image) or as one, with the SPA bundled into the Spring Boot JAR.

## Decision

Production ships as **one JAR and one container image**. The Gradle build compiles the React app and packages it into Spring Boot's static resources. Spring Boot serves the SPA (with a fallback route for client-side routing) and the API from the same origin.

## Consequences

- One Fly app per environment, one image and one version number.
- Same origin, so no CORS setup is needed.
- The frontend can't be deployed or scaled on its own. That's acceptable for the template's scope.
- Fast frontend development still needs a separate dev loop (ADR 0007).
