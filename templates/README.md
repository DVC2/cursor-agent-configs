# Templates

Starter `AGENTS.md` files (and a matching scoped rule) you copy into your own project.

- [`AGENTS.md`](AGENTS.md) — generic, stack-agnostic starter. Start here if your stack isn't below.
- [`nextjs/`](nextjs/) — Next.js (App Router) + TypeScript.
- [`python-uv/`](python-uv/) — Python with uv + ruff + pytest.
- [`go/`](go/) — Go modules + table-driven tests.

## Using a stack pack

Each pack has an `AGENTS.md` (copy to your repo root) and a `*.mdc` rule (copy to
`.cursor/rules/`). For example:

```bash
cp templates/nextjs/AGENTS.md   your-project/AGENTS.md
cp templates/nextjs/nextjs.mdc  your-project/.cursor/rules/nextjs.mdc
```

Then **edit the brackets** — these are starting points, not finished configs. The `AGENTS.md`
is read by every agent (Cursor, Codex, Copilot, …); the `.mdc` rule adds Cursor-specific,
glob-scoped detail. Keep the rule short and let your linter/formatter/type-checker own the rest.
