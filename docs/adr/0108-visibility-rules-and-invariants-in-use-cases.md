# 0108. Visibility rules and invariants in use cases

- Status: Accepted
- Date: 2026-10-15
- Extends: [0062](0062-backlog-items-as-cockburn-use-cases.md), [0063](0063-living-use-case-catalog-and-jgiven-report.md)

## Context

Two kinds of rules escape example-based scenarios and traceability:

- **Absences**: something must *not* be visible to someone, such as another user's answer before a deadline. A leak comes from code without a requirement, such as a new field in a response, so every use case still has its green test.
- **Universal statements**: something must hold after every step, such as a sum being preserved or nothing going negative. Examples never prove them.

Not every project has such rules, so making these tests mandatory everywhere would be noise.

## Decision

- The use-case template gets two optional sections: **Visibility rules** and **Invariants**. Refinement fills them in when they apply.
- If **Visibility rules** has an entry:
  - **Leak tests** check the output surface: every field of every response in the restricted state must be on an allow list. An unknown field fails.
  - They run at two levels: at the port, and on the serialized HTTP or WebSocket JSON.
  - Each leak test has a **counter-check** after the restriction ends, so a field that's always empty doesn't pass.
- If **Invariants** has an entry:
  - Every use-case scenario of that module checks the invariants **after each step**.
  - Each invariant also gets a **property test** with **jqwik**, which is part of the template.

## Consequences

- Where they apply, these rules are checked against every scenario and against generated inputs, not against a few examples.
- Projects without such rules pay nothing.
- A field added to a restricted response forces an explicit decision.
- **Rejected:**
  - Mandatory leak and invariant tests for every use case, because trivial CRUD cases would carry useless allow lists.
  - Describing them only as a pattern, because nothing would say when they're required.
  - Leaving them out as project-specific, because the trigger is generic even if the rules aren't.
  - jqwik as an optional tool without a rule, because invariants would then be checked only by examples.
