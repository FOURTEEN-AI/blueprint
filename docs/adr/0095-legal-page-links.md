# 0095. Footer links to imprint and privacy policy

- Status: Accepted
- Date: 2026-10-15
- Extends: [0047](0047-bootstrap-skill.md)

## Context

Every generated project is a public website. Through Cloudflare and Turnstile (ADR 0052, 0053) it processes visitors' IP addresses, which in the EU requires a privacy policy, and in Germany also an imprint (Impressum). Blueprint's own public demo needs both.

## Decision

- The kept infrastructure shows **footer links to an imprint and a privacy policy**. The documents themselves live outside the repository; the template only holds their URLs as configuration (`IMPRINT_URL`, `PRIVACY_URL`).
- Blueprint ships with links to the maintainer's documents.
- `/bootstrap` requires a decision for each link: **replace it or keep it**. Generated projects never ship without them.

## Consequences

- Every deployment has its legal links from the start, with no legal text in the template.
- The operator is responsible for what the linked documents say.
- **Rejected:** legal pages only for blueprint's demo, or leaving them out entirely, because generated projects would ship without them.
