---
name: init-agents-md
description: Draft an AGENTS.md tailored to this repository. Use when a project has no AGENTS.md (or a stale one) and the user wants agent-readable project context set up.
---

# Initialize AGENTS.md

Produce a concrete, repo-specific `AGENTS.md` — not a generic template dump.

## Steps

1. **Detect the stack.** Run the helper and read its output:
   ```bash
   bash "$(dirname "$0")/scripts/detect-stack.sh" 2>/dev/null || bash .cursor/skills/init-agents-md/scripts/detect-stack.sh
   ```
   It reports language(s), package manager (from the lockfile), framework, test runner, and the
   real build/test/lint commands it found in `package.json` / `pyproject.toml` / `Makefile` / etc.

2. **Read the evidence, don't guess.** Skim the manifest (`package.json`, `pyproject.toml`,
   `go.mod`, `Cargo.toml`), the test config, the lint/format config, and the top-level dir
   layout. Pull the *actual* commands and conventions — never invent scripts that don't exist.

3. **Draft `AGENTS.md`** with these sections (omit any you genuinely can't fill):
   *Project overview · Setup commands · Code style · Project conventions · Testing · Security · PRs.*
   Base the shape on `templates/AGENTS.md`; for a recognized stack, start from the matching
   `templates/<stack>/AGENTS.md`.

4. **Ask, don't assume, for the unknowables.** Use the ask-questions tool for things the repo
   can't tell you: deploy targets, directories agents must not touch, response/error conventions,
   the "what a new teammate always gets wrong" gotcha. Keep it to 2–4 sharp questions.

5. **Write it to the repo root.** Keep it tight (a screen or two). Tell the user what you inferred
   vs. what they should review, and mention `scripts/sync-agents.sh` if they use Copilot/Claude/Gemini too.

## Principles

- Specific > generic. "Run `pnpm test`" beats "run the tests." Delete sections you'd only fill with filler.
- Don't restate what a linter/formatter/tsconfig already enforces — point to it instead.
