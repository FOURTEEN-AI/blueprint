# 0090. PR preview environments

- Status: Accepted
- Date: 2026-10-15
- Supersedes: [0064](0064-preview-databases-in-shared-neon-branch.md), [0055](0055-previews-on-fly-dev-and-environment-parity.md)

## Context

The rules for preview environments were spread across ADR 0027 and 0051 (both superseded, but partly still in force), 0055 and 0064. ADRs 0083, 0085 and the review of 2026-10-15 changed them further. This ADR restates every rule in force, so it is the only document to read about previews. The superseded ADRs stay for history.

Facts the decision relies on:

- Neon schema-only branches are **root branches**, and the free plan allows only 3 root branches per project, including the production branch (ADR 0064).
- A schema-only branch copies tables but no rows, including Flyway's history table, so Flyway can't migrate the copied database (ADR 0051).
- Neon branches inherit their parent's roles. As far as we know, they keep the **same passwords**.
- Fly's usual certificate validation fails behind Cloudflare's proxy, and the free plan's rule limits would cap the number of previews (ADR 0055).

## Decision

**Which PRs get a preview**

- Every PR from a branch in the main repository gets a preview, **except Dependabot PRs**. Dependabot patch and minor updates merge without a demo (ADR 0072), so a preview would only run the smoke test, and it would need Fly and Neon secrets in the Dependabot store (ADR 0085).
- **PRs from forks get no preview**, because secrets aren't available to them. A maintainer can push the branch to the main repository to get one.

**App**

- Each preview is its own Fly app named **`<app>-pr-<n>`**, running the PR's image, in the production app's organization and region.
- It's deployed by the **trusted `workflow_run` workflow** with `FLY_PREVIEW_TOKEN` (ADR 0083, 0085).
- Preview machines scale to zero when idle.

**Database**

- One persistent **`previews`** Neon branch, created by CI as a schema-only branch of production if it's missing, so it never holds production data.
- When CI creates that branch, it also creates a **`preview` role** there and **locks the role inherited from production** on that branch (new random password or no login). Preview apps only ever get the `preview` role's credentials.
- Each PR gets its **own empty database** (`pr_<n>`) in that branch, owned by the `preview` role. The release command (ADR 0012) runs all Flyway migrations from `V1`.
- Previews start **without seed data**. Reviewers create their own test data.
- Flyway `clean` stays disabled everywhere.

**Lifetime and cleanup**

- A preview (app, database and PR images, ADR 0098) is destroyed when its PR is closed or merged, or when it exceeds a **TTL**. `/demo` redeploys an expired preview on demand.
- A nightly job removes orphaned preview apps, databases and images.

**Exposure and parity**

- Previews stay on their plain **`<app>-pr-<n>.fly.dev`** URLs, **not behind Cloudflare**, with **no extra protection**. Their short lifetime, empty data and the app-level limits (ADR 0054, 0082) are the protection.
- **Every environment runs the same image and the same code paths.** Environments differ only in configuration: Turnstile test keys versus real keys, and the origin lock on or off (ADR 0052). Nothing is built specifically for previews.

## Consequences

- Previews use exactly one Neon branch, whatever the number of open PRs. PR databases share that branch's compute.
- Every preview checks that the complete migration chain applies to an empty database. Manual schema drift in production wouldn't show, but production only ever changes through Flyway.
- A preview never holds production data or production credentials. Code running in it can reach only the `previews` branch.
- Anyone who learns a preview URL can write to it while it exists. That's accepted.
- No per-PR DNS, certificates or Cloudflare rules.
- Dependabot updates are only checked in production, by the smoke test with automatic rollback (ADR 0029, 0091).
- **Rejected** (across the ADRs this one replaces):
  - A Postgres sidecar in the preview machine (ADR 0026), because of rough edges with multi-container Machines.
  - A schema-only branch per PR (ADR 0027, 0051), because of the root-branch limit and Flyway's history table.
  - An empty `preview-base` branch, and Flyway `clean` before migrating (ADR 0051).
  - A separate Neon project for previews, which would isolate them fully but needs a second project and API key.
  - Previews behind Cloudflare, private previews through `fly proxy`, and basic auth on previews only (ADR 0055).
  - Previews for Dependabot PRs.
