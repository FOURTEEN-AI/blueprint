# 0003. English as the project language

- Status: Accepted
- Date: 2026-10-14

## Context

Early artifacts (devcontainer comments, a referenced script `ci/pipeline-beobachten.sh`) were written in German. Blueprint targets a public, international audience (ADR 0002).

## Decision

All code, identifiers, file names, comments, documentation, skills, commit messages and ADRs are written in **English**.

## Consequences

- Existing German comments and names get translated, e.g. `pipeline-beobachten.sh` becomes `watch-pipeline.sh`.
- Agent instructions and skills are written in English, so agents produce English output by default.
