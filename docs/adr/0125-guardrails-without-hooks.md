# 0125. Guardrails without blocking hooks

- Status: Accepted
- Date: 2026-10-16
- Extends: [0059](0059-branch-protection-and-codeowners.md), [0084](0084-project-github-app-as-bot-identity.md), [0085](0085-untrusted-build-trusted-deploy.md), [0089](0089-codeowners-scope-and-admin-bypass.md), [0102](0102-format-on-edit-and-full-build-stop-hook.md)

## Context

The agent has to be kept away from a few actions: pushing to `main`, changing guardrail files, destructive production commands and reading secrets. Hooks that deny these actions would block local work too, for example writing ADRs or skills. A hook returning `ask` also isn't a safe fallback: in non-interactive mode (`-p`) nobody can answer, and the docs say such a call is denied. The behavior in auto mode and in the cloud routine isn't documented.

## Decision

**No hook denies or asks about these actions.** The accepted hooks stay: format on edit and the full build before stopping (0102), the commit-status hook (0088), and the Stop hooks that gate the stages (0118).

Each action is made impossible or reviewed elsewhere:

| Action | Protection |
|---|---|
| Push to `main`, force-push | The repository ruleset: PRs only, linear history, no bypass for the App ([0033](0033-protected-main-squash-merge.md), [0059](0059-branch-protection-and-codeowners.md)) |
| Changing guardrail files | CODEOWNERS requires the owner's review. The App has no workflows permission ([0084](0084-project-github-app-as-bot-identity.md), [0089](0089-codeowners-scope-and-admin-bypass.md)) |
| Destructive production commands | The routines hold no Fly, Neon or Cloudflare tokens. They live in GitHub environments restricted to `main` ([0085](0085-untrusted-build-trusted-deploy.md)) |
| Reading secrets | There are no secrets in the working tree ([0037](0037-configuration-and-secrets.md)). The routine holds only the App key |
| Editing `.creation/state.json` | Every gate compares it with the previous commit ([0124](0124-gates.md)) |

- The loop's **permission allowlist** is narrow: Gradle tasks, pnpm, git on its own branch, and reading and editing the working tree. It is configured **in the routines, not in the project settings**, so it doesn't apply to local sessions.
- Until the ruleset exists (design phase), the rule in AGENTS.md applies.

## Consequences

- Local sessions are not restricted by these guardrails.
- The protection sits where the agent can't change it: on GitHub, in credentials and in the gates' comparison with git history.
- A local session can still do harm with the owner's own credentials. The guardrails protect against the loop, not against the owner.
- How the cloud routine treats permissions is still to be verified ([deferred](../deferred.md)).
- **Rejected:**
  - Deny hooks for these actions, because they block local work.
  - `ask` hooks, because they are denied without an answering human and are undocumented in auto mode.
  - Detecting the loop with an environment variable to apply stricter rules there, because the user wants the same rules everywhere.
