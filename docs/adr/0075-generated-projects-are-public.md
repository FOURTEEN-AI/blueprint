# 0075. Generated projects are public repositories

- Status: Accepted
- Date: 2026-10-14
- Extends: [0047](0047-bootstrap-skill.md)

## Context

Several decisions depend on free tiers for public repositories, but no ADR said whether generated projects are public. For private repositories:

- SonarCloud costs money
- CodeQL needs paid GitHub Advanced Security
- GitHub Pages (for the JGiven report, ADR 0063) needs a paid plan
- Fly would need credentials to pull private GHCR images (ADR 0022, 0030)

## Decision

Projects generated from blueprint are **public repositories**. `/bootstrap` creates them as public, and the template makes no provision for private repositories.

## Consequences

- SonarCloud, CodeQL and GitHub Pages stay free, and Fly pulls public GHCR images without credentials.
- Nothing confidential may be committed. That's already required by ADR 0037 (secrets only in environment variables).
- Users who need private repositories are outside the template's scope. They would have to adapt the tooling and accept the costs themselves.
