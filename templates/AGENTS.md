# AGENTS.md

> **Starter template.** Copy this to your repo root, delete what doesn't apply, and fill in
> the brackets. `AGENTS.md` is plain Markdown read natively by Cursor, Codex, Copilot,
> Gemini CLI, Aider, Windsurf, Zed and others — it's the README for your coding agents.
> Use `.cursor/rules/*.mdc` only when you need glob-scoped or auto-attached behavior that a
> single root file can't express. In a monorepo, add a nested `AGENTS.md` per package; the
> closest one to the edited file wins.

## Project overview

[One paragraph: what this project is, the stack, and the high-level architecture.]

## Setup commands

```bash
[install deps]   # e.g. pnpm install
[start dev]      # e.g. pnpm dev
[run tests]      # e.g. pnpm test
```

## Code style

- [Language + the few opinionated, non-default choices. Let the linter/formatter own the rest.]
- Document **why, not what** — comments should explain the reasoning a reader can't infer
  from the code (e.g. "retry with backoff because the upstream rate-limits bursts"), not
  restate it.

## Project conventions

[The durable, discovered conventions a new teammate or agent would otherwise get wrong:]

- File naming: [e.g. kebab-case files, `*.test.ts` for tests]
- Exports: [e.g. named exports, no default exports]
- Errors: [e.g. throw `AppError`; never swallow errors silently]
- API shape: [e.g. every endpoint returns `{ success, data, error }`]
- Test stack: [e.g. Vitest + Testing Library; colocate tests next to source]

## Working agreements

- **Reproduce before fixing.** Confirm the failure, change one thing at a time, then verify.
- **Batch independent work.** Issue independent reads/searches/commands together rather than
  one-at-a-time; don't re-read what's already in context.
- **Detect the package manager from the lockfile** (`pnpm-lock.yaml`→pnpm, `yarn.lock`→yarn,
  `bun.lockb`→bun, else `npm ci`) — don't assume npm. Use the deterministic install in CI.
- **Be honest about outcomes.** If tests fail or a step was skipped, say so.

## Security

- Never build SQL/shell strings by interpolating untrusted input — use parameterized queries
  and validated args.
- Never commit secrets. [List any directories or files agents must not touch.]
- Don't auto-fix security findings without human review.

## Testing & PRs

- Run [the full suite] before committing; all checks in CI must pass.
- Commit style: [e.g. Conventional Commits — `feat:`, `fix:`, `docs:`].
- Architectural decisions go in `docs/adr/ADR-NNN-slug.md` (see the `write-adr` skill).
