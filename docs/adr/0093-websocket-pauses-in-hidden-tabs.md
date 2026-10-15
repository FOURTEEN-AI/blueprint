# 0093. The WebSocket pauses while the tab is hidden

- Status: Accepted
- Date: 2026-10-15
- Extends: [0018](0018-live-updates-via-websocket-change-notifications.md), [0023](0023-scale-to-zero-and-accepted-cold-start.md)

## Context

The client opens its WebSocket on page load and reconnects automatically (ADR 0018). An open WebSocket keeps the Fly machine running (ADR 0023), and the LISTEN connection keeps Neon compute active (ADR 0019). A single tab left open in the background would keep production from ever scaling to zero.

## Decision

- The client **closes the WebSocket** when the tab has been **hidden for about a minute** (Page Visibility API).
- When the tab becomes visible again, it reconnects and revalidates, as after any reconnect.
- While paused, the UI shows a paused state instead of "live".

## Consequences

- Background tabs no longer keep production awake.
- A **visible** but forgotten tab (e.g. on a second monitor) still keeps the machine and Neon compute running. That cost risk is accepted.
- **Rejected:**
  - Also disconnecting after a period without user input, which would cover visible but forgotten tabs, but interrupts people who watch live updates without interacting.
  - Keeping the connection while the tab is open.
