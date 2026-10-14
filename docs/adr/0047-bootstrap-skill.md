# 0047. /bootstrap: GitHub template plus init script, fully automated with confirmation

- Status: Accepted
- Date: 2026-10-14

## Context

Users need a way to turn blueprint into their own project. The options were the template button with manual find/replace, a CLI generator, or a Claude-driven setup.

## Decision

A **`/bootstrap` skill** drives the process. It uses GitHub's "Use this template" and calls a deterministic **init script**. It automates **everything** and asks for confirmation before each external step:

- rename the project, Java package and app names, and **remove the sample feature** (ADR 0021)
- create the Fly app, the Neon project, and the SonarCloud project
- set GitHub secrets and branch protection (ADR 0033)
- write the `.blueprint` metadata (ADR 0048)

Generated projects **keep the Apache-2.0 license**.

## Consequences

- Going from template to deployed project takes a single command.
- The script part is testable and repeatable. Claude handles questions and recovering from errors.
- External steps need the user's credentials (`fly`, `gh`, a Neon API key, a Sonar token).
