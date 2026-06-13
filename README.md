# Cursor & Agent Configs

> ⚠️ **Archived — no longer maintained (as of June 2026).** This repo is read-only.
> The configs still work and are public domain — copy what's useful. For current, living
> guidance see [agents.md](https://agents.md) and the [Cursor docs](https://cursor.com/docs).
> See [`SUNSET.md`](SUNSET.md) for why, and [`MIGRATION.md`](MIGRATION.md) for the history.

[![CI](https://github.com/DVC2/cursor-agent-configs/workflows/CI/badge.svg)](https://github.com/DVC2/cursor-agent-configs/actions)
[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](LICENSE)
[![Cursor](https://img.shields.io/badge/Cursor-2.4%2B-black.svg)](https://cursor.com/docs)

Copy-paste configuration for getting the most out of [Cursor](https://cursor.com) and other
AI coding agents in 2026 — built around the primitives Cursor actually ships today:
**`AGENTS.md`, scoped rules, subagents, Skills, and hooks**.

> **This repo was rebuilt in 2026.** It started in early 2025 as a pile of giant always-on
> `.mdc` rules — an approach that's now an anti-pattern (it burns context and predates
> subagents/Skills/hooks entirely). If you used the old version, see [`MIGRATION.md`](MIGRATION.md).

## The five primitives — and when to use each

| Primitive | Lives in | Use it when… | Reads cross-tool? |
|---|---|---|---|
| **`AGENTS.md`** | repo root (+ nested) | You want always-on project context: stack, conventions, commands. **Start here.** | ✅ Cursor, Codex, Copilot, Gemini CLI, Aider, Windsurf, Zed… |
| **Rules** (`.mdc`) | `.cursor/rules/` | You need *scoped* guidance — applies only to matching files (`globs`) or when the agent judges it relevant (`description`). | Cursor only |
| **Subagents** | `.cursor/agents/` | A task needs its own isolated context or a specialized persona (review, verify, test) — possibly run in parallel. | Cursor (+ `.claude`/`.codex` dirs) |
| **Skills** | `.cursor/skills/<name>/SKILL.md` | You have an on-demand procedure that should load *only when relevant* (e.g. "write an ADR"), keeping context lean. | Cursor (+ compat dirs) |
| **Hooks** | `.cursor/hooks.json` + `.cursor/hooks/` | You need *deterministic*, non-negotiable behavior around agent actions — format on save, block destructive commands. | Cursor |

Rule of thumb: **`AGENTS.md` first.** Add a scoped rule only when you hit a real scoping
need; reach for a subagent/Skill/hook when the job is delegation, on-demand knowledge, or
hard enforcement respectively.

## What's in here

```
cursor-agent-configs/
├── AGENTS.md                       # this repo's own agent context (a worked example)
├── templates/
│   ├── AGENTS.md                   # generic starter to copy into YOUR project
│   ├── nextjs/                     # stack pack: Next.js + TS (AGENTS.md + scoped rule)
│   ├── python-uv/                  # stack pack: Python + uv + ruff + pytest
│   └── go/                         # stack pack: Go modules + table-driven tests
├── .cursor/
│   ├── rules/
│   │   ├── javascript.mdc          # short, glob-scoped — defers style to ESLint/Prettier
│   │   └── typescript.mdc          # short, glob-scoped — defers strictness to tsconfig
│   ├── agents/
│   │   ├── code-reviewer.md        # read-only diff reviewer with a severity ladder
│   │   ├── verifier.md             # confirms "done" work actually runs
│   │   └── test-author.md          # writes regression-catching tests
│   ├── skills/
│   │   ├── debug/                  # systematic debug loop (reproduce→isolate→…→verify)
│   │   ├── write-adr/              # ADR template, lifecycle, and when-to-write gate
│   │   └── init-agents-md/         # inspects a repo and drafts a tailored AGENTS.md
│   ├── hooks.json
│   └── hooks/
│       ├── format.sh               # afterFileEdit: format the edited file
│       └── guard-destructive.sh    # beforeShellExecution: block rm -rf /, force-push, …
├── examples/hooks/                 # hooks cookbook: secret-guard, context-inject, test-on-save
├── docs/                           # cheat sheet, cross-tool sync, troubleshooting
├── scripts/                        # install.sh / install.ps1 / sync-agents.sh
└── MIGRATION.md
```

### Also in here

- **Stack starter packs** — [`templates/`](templates/): copy a ready `AGENTS.md` + matching
  scoped rule for Next.js, Python (uv), or Go.
- **One config, every agent** — [`scripts/sync-agents.sh`](scripts/sync-agents.sh) generates
  `CLAUDE.md` / `.github/copilot-instructions.md` / `GEMINI.md` from your `AGENTS.md`. See
  [`docs/cross-tool.md`](docs/cross-tool.md).
- **Hooks cookbook** — [`examples/hooks/`](examples/hooks/): more ready-to-wire hooks (block
  committing secrets, inject git context at session start, run the matching test on save).
- **`/init-agents-md`** — a Skill that inspects your repo and drafts an `AGENTS.md` for you.

## Quick start

**Copy what you want — nothing here requires a build step, Node, or npm.**

```bash
git clone https://github.com/DVC2/cursor-agent-configs.git

# Option A: scripted (interactive, backs up anything it would overwrite)
cd your-project && /path/to/cursor-agent-configs/scripts/install.sh

# Option B: manual — copy only the pieces you want
cp -r cursor-agent-configs/.cursor/agents   your-project/.cursor/
cp -r cursor-agent-configs/.cursor/skills   your-project/.cursor/
cp    cursor-agent-configs/templates/AGENTS.md  your-project/AGENTS.md   # then edit it
```

Then restart Cursor. Rules auto-attach by glob; Skills/subagents load on demand (invoke a
subagent with `/code-reviewer`, a Skill with `/debug`).

> ⚠️ **Hooks run shell scripts on agent events.** Read `.cursor/hooks/*.sh` before installing
> them, and only commit hooks your team trusts. They require `jq`.

## Verify it loaded

- Rules: open a `.ts`/`.js` file — the matching rule attaches in the agent's context panel.
- Subagents/Skills: type `/` in Agent and confirm `code-reviewer`, `debug`, etc. appear.
- Hooks: `jq . .cursor/hooks.json` should parse; try a blocked command to see the guard fire.

## Compatibility

Subagents and Skills require **Cursor 2.4+** (nested subagents: 2.5+). `AGENTS.md` and
`.cursor/rules` work broadly. The legacy single-file `.cursorrules` is deprecated — migrate to
`AGENTS.md` + `.cursor/rules`.

## Docs

- [`docs/quick-reference.md`](docs/quick-reference.md) — frontmatter & format cheat sheet for every primitive.
- [`docs/troubleshooting.md`](docs/troubleshooting.md) — "my rule/Skill/hook isn't firing."
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how to add a config.

## License

[The Unlicense](LICENSE) — public domain. Copy freely.
