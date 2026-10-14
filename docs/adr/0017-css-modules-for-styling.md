# 0017. CSS Modules for styling

- Status: Accepted
- Date: 2026-10-14

## Context

We considered Material UI (rejected: Emotion runtime CSS-in-JS, bundle size, a recognizably "Material" look), Tailwind with or without shadcn/ui, Mantine and CSS Modules.

## Decision

Components are styled with **CSS Modules**, which Vite supports out of the box. There is no UI component library. A small set of design tokens (CSS custom properties) is defined globally.

## Consequences

- No styling dependencies and no runtime cost, and template users are free to adopt any library.
- Basic components (buttons, inputs, layout) are built by hand, and accessibility is our responsibility.
