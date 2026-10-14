# 0050. Minimal open-source community files

- Status: Accepted
- Date: 2026-10-14

## Context

Public repositories often ship CONTRIBUTING, CODE_OF_CONDUCT, SECURITY.md and issue templates. Every extra file also has to be maintained and handled by `/bootstrap`.

## Decision

Blueprint ships only a **README**, the **LICENSE** (Apache-2.0) and a **PR template**.

## Consequences

- Less to maintain and adapt in generated projects.
- No formal contribution or security-reporting process for now. It can be added later.
