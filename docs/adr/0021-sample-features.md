# 0021. Sample features: notes CRUD and live broadcast, removed by bootstrap

- Status: Accepted
- Date: 2026-10-14

## Context

The template needs real code that exercises the whole chain: spec, Spring, Flyway, React, live updates and every kind of test. Generated projects shouldn't carry demo code around.

## Decision

- Blueprint contains a small **notes CRUD** feature and a **live broadcast** of note changes to all connected devices.
- The generic WebSocket and LISTEN/NOTIFY infrastructure is a separate module from the `notes` feature.
- `/bootstrap` **always removes** the sample feature (code, migrations, spec entries, tests) and keeps the infrastructure.

## Consequences

- Blueprint's own CI exercises the full stack through the sample.
- The sample has to be cleanly deletable, which keeps module boundaries honest.
- Generated projects start empty but working.
