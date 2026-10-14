# 0056. Safeguards for blueprint's public demo deployment

- Status: Accepted
- Date: 2026-10-14

## Context

Blueprint's own production deployment runs the notes sample (ADR 0021) publicly and without authentication. Even with edge and bot protection, a public writable demo collects junk and could be used to publish abusive content.

## Decision

These measures belong to the **notes sample feature** and are removed by `/bootstrap` along with it:

- **Content limits**: short notes, plain text only, links never rendered as links.
- **Global cap**: at most N notes in total. Inserting beyond the cap deletes the oldest notes **in the same transaction**, and the deletions emit change notifications (ADR 0018/0019) so clients update. The demo is always writable.
- **Banner**: the UI says this is a public demo and that everything written is visible to everyone.

## Consequences

- Storage stays bounded, and spam is pushed out over time.
- A determined spammer can push out legitimate notes. That's acceptable for a demo.
- Generated projects don't inherit any demo-specific behavior.
