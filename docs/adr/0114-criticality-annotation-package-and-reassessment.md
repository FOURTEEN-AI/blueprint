# 0114. Criticality: annotation package and re-assessment after bugs

- Status: Accepted
- Date: 2026-10-15
- Extends: [0106](0106-criticality-and-quality-thresholds.md), [0062](0062-backlog-items-as-cockburn-use-cases.md) (adds a field to bug items)

## Context

ADR 0106 introduces `@Criticality` but doesn't say where it lives. It must be usable in every Spring Modulith module and in the domain, where Spring and JPA are forbidden (ADR 0009). ADR 0106 also judges criticality only during refinement, although a bug that actually happened is the best evidence of likelihood there is. And it keeps JaCoCo without a threshold, without saying what JaCoCo is then for.

## Decision

- **`@Criticality` lives in its own package** shared by all modules. The package contains **only annotations** and **depends on nothing**. ArchUnit checks both. It's a pure marker without runtime behavior, like JSpecify or jMolecules annotations.
- **Every bug item (`fix`) re-assesses the criticality** of the affected use case, with a reason. The likelihood is now proven, so raising the level is the default. Keeping it needs a reason.
- **JaCoCo is a search aid**: its report shows forgotten error paths and untested branches when looking for missing tests. It's never a target.

## Consequences

- The annotation can't drag dependencies into the domain.
- Criticality follows what actually happens, not only what was expected during refinement.
- Raising a level to `HIGH` brings the affected classes into the mutation run, through the annotation (ADR 0106).
- **Rejected:**
  - `@Criticality` from an external annotation library, because that depends on the gate tooling, which is still open ([deferred.md](../deferred.md)).
  - Raising the level automatically with every bug, because every use case would end up `HIGH`.
  - Re-assessment only after production incidents, because ordinary bugs prove likelihood just as well.
