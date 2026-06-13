# AGENTS.md

> Next.js (App Router) + TypeScript starter. Copy to your repo root and edit the brackets.

## Project overview

[A Next.js app using the App Router, TypeScript, and Tailwind. Brief architecture: where
routes, server actions, and shared UI live.]

## Setup commands

```bash
pnpm install
pnpm dev            # local dev server
pnpm test           # unit tests
pnpm lint           # eslint + typecheck
pnpm build          # production build (must pass before merge)
```

## Code style & conventions

- TypeScript strict mode; `unknown` over `any`. Style/format owned by ESLint + Prettier.
- **Server Components by default.** Add `'use client'` only when you need state, effects, or
  browser APIs — and keep client components small and leaf-level.
- Data fetching happens in Server Components / server actions, not in `useEffect`.
- Co-locate components with their route under `app/`; shared UI in `components/`.
- Use the `@/` path alias for absolute imports. No default exports for components — named only.
- Environment variables: server-only secrets are never prefixed `NEXT_PUBLIC_`. Validate env
  at startup (e.g. zod) rather than reading `process.env` ad hoc.

## Testing

- [Unit/component: Vitest + Testing Library. E2E: Playwright.] Co-locate `*.test.tsx`.
- Test behavior and rendered output, not implementation details. Run `pnpm test` before committing.

## Security & gotchas

- Never expose secrets to the client bundle. Validate and sanitize all route/server-action input.
- `revalidate`/caching: be explicit about `cache`/`revalidate` on fetches; don't rely on defaults.

## PRs

- Conventional Commits (`feat:`, `fix:`). `pnpm lint && pnpm build` must pass.
