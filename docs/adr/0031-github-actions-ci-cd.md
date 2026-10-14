# 0031. GitHub Actions for CI and continuous delivery

- Status: Accepted
- Date: 2026-10-14

## Context

The template promises everything from build to production deploy, and AI agents must be able to watch and fix pipeline runs.

## Decision

**GitHub Actions** runs the whole pipeline:

- On PRs: build, all tests, quality gates (ADR 0034), CodeQL, image build, and the preview deploy (ADR 0027).
- On `main`: release (ADR 0032), image push to GHCR, Neon snapshot, migrate, deploy to production, smoke test and rollback if needed (ADR 0029).
- Scheduled jobs: preview cleanup.

The devcontainer includes the GitHub CLI, and a `watch-pipeline.sh` script lets agents follow runs and react to failures.

## Consequences

- Everything is versioned in `.github/workflows/`.
- Secrets live in GitHub (`FLY_API_TOKEN`, `NEON_API_KEY`, `SONAR_TOKEN`, …) and are created by `/bootstrap`.
