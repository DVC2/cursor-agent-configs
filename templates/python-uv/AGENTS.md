# AGENTS.md

> Python starter using uv + ruff + pytest. Copy to your repo root and edit the brackets.

## Project overview

[What this project is, the package layout (`src/<pkg>/`), and entry points.]

## Setup commands

```bash
uv sync                 # create venv + install from uv.lock (deterministic)
uv run pytest           # run tests
uv run ruff check .     # lint
uv run ruff format .    # format
uv run mypy src         # type-check
```

Use `uv` for everything — don't call `pip`/`python` directly or hand-edit the venv.
Add deps with `uv add <pkg>` (and `uv add --dev <pkg>` for dev tools), which updates `uv.lock`.

## Code style & conventions

- Target Python [3.12+]. **Type-annotate all public functions**; `mypy` (strict) is the source
  of truth. Style/format/imports are owned by `ruff` — don't hand-format.
- Prefer `pathlib.Path` over `os.path`; `dataclasses`/`pydantic` over ad-hoc dicts for structured data.
- Raise specific exceptions; never `except:` bare or swallow errors. Use `logging`, not `print`.
- Keep functions small and pure where practical; side effects at the edges.

## Testing

- pytest, tests in `tests/` mirroring `src/`. Use fixtures over setup/teardown; parametrize
  instead of copy-pasting cases. Assert on behavior, not internals. Run `uv run pytest` before committing.

## Security & gotchas

- Validate/parse all external input (env, requests, files) — prefer pydantic models.
- Never interpolate untrusted input into SQL or shell; use parameterized queries / `subprocess`
  arg lists (never `shell=True` with user data). No secrets in code or logs.

## PRs

- Conventional Commits. `ruff check`, `mypy`, and `pytest` must pass.
