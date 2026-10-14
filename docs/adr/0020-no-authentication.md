# 0020. No authentication in the template

- Status: Accepted
- Date: 2026-10-14

## Context

Authentication is highly project-specific (OIDC provider, session or token, roles). We considered OIDC with a backend-for-frontend, a Spring Security skeleton, and an optional module added by `/bootstrap`.

## Decision

Blueprint ships **without authentication**. All endpoints are public.

## Consequences

- The template stays lean and neutral.
- The deployed sample app and every PR preview are publicly reachable. That's acceptable because they contain no sensitive data (see ADR 0027 on preview data).
- Projects add auth themselves, and the onion structure leaves room for it.
