# AGENTS.md

Context for AI coding agents working **on this repository**. This repo is itself a
collection of agent configs, so this file doubles as a worked example of the format
documented at <https://agents.md> (read natively by Cursor, Codex, Copilot, Gemini CLI,
Aider, Windsurf, Zed, and ~20 other tools).

> Want a starter you can drop into *your own* project? Copy [`templates/AGENTS.md`](templates/AGENTS.md).

## Project overview

A curated set of **Cursor / agent configuration examples** for the 2026 stack:

- `AGENTS.md` — cross-tool project context (this file + the template).
- `.cursor/rules/*.mdc` — short, glob-scoped rules.
- `.cursor/agents/*.md` — delegated subagents (review, verify, test).
- `.cursor/skills/*/SKILL.md` — on-demand procedures (debug, write-adr).
- `.cursor/hooks.json` + `.cursor/hooks/` — deterministic event hooks.

There is **no build step and no Node/npm dependency** — the repo is plain Markdown,
shell, and JSON. Don't reintroduce a `package.json`.

## Validating changes

CI (`.github/workflows/ci.yml`) checks the things that actually matter here. To run the
equivalent locally:

```bash
# 1. Every .mdc and SKILL.md must have a SINGLE, well-formed YAML frontmatter block.
#    (A doubled `---` block is the historical bug in this repo — never ship one.)
# 2. hooks.json must be valid JSON with a top-level "version": 1.
python3 -c "import json,sys; json.load(open('.cursor/hooks.json'))"
# 3. Hook scripts must be executable.
test -x .cursor/hooks/format.sh
```

## Conventions for editing configs

- **Keep rules under 500 lines and scoped.** Prefer `globs:` or a `description:` over
  `alwaysApply: true`. A giant always-on rule burns every request's context budget —
  that's the anti-pattern this repo was rebuilt to escape. See [`MIGRATION.md`](MIGRATION.md).
- **One concern per file.** If a rule covers two unrelated things, split it.
- **No fabricated metrics.** Don't claim "67% fewer tool calls" or "75% time savings"
  without a reproducible measurement. The old docs were full of these; don't bring them back.
- **Match the documented frontmatter exactly** (see each primitive's section in the README).
  Notably: subagents have no `tools:` field; a Skill's `name:` must equal its folder name;
  hook events are camelCase (`beforeShellExecution`, `afterFileEdit`), not `onPreEdit`.
- **Reference, don't copy.** Point at canonical files instead of pasting style guides that
  go stale — let ESLint/Prettier/tsconfig own formatting and strictness.

## PR / commit conventions

- Conventional-commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`.
- Keep the README primitive table and the file tree in sync with reality.
