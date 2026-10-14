# 0016. Frontend: Vite, TypeScript and React Router data mode

- Status: Accepted
- Date: 2026-10-14

## Context

The React SPA needs a build tool, a language, routing and a way to load data. The candidates were TanStack Router + Query, React Router with TanStack Query, and React Router's built-in data APIs.

## Decision

- **Vite** as the build tool and dev server.
- **TypeScript** in strict mode.
- **React Router** in data mode: **loaders** fetch data and **actions** perform mutations, both through the generated OpenAPI client (ADR 0014).
- No separate data-fetching or cache library.

## Consequences

- Fewer dependencies and mainstream patterns.
- Live updates have to trigger `revalidate()` instead of updating a query cache (ADR 0018).
- If caching needs grow, adding TanStack Query later is possible, but that would need a new ADR.
