# Sunset notice

**This repository is archived as of June 2026 and is no longer maintained.**

## Why

It served its purpose. The repo began in early 2025 as a collection of Cursor `.mdc` rules,
and in mid-2026 was rebuilt around the current stack (`AGENTS.md`, scoped rules, subagents,
Skills, hooks — see [`MIGRATION.md`](MIGRATION.md)). That stack now evolves faster than a
small static template repo can track, and the canonical guidance lives in actively-maintained
places. Rather than let it drift out of date again, it's being retired while it's still correct.

## The configs still work

Everything here is released into the public domain ([Unlicense](LICENSE)). Clone it, copy any
piece into your own project, and adapt freely — no attribution needed. Nothing stops working
because the repo is archived; it just won't receive updates, and issues/PRs are closed.

Good starting points if you're here for something specific:

- A project context file → [`templates/`](templates/) (generic + Next.js / Python / Go starters)
- Delegated review/verify/test agents → [`.cursor/agents/`](.cursor/agents/)
- On-demand procedures → [`.cursor/skills/`](.cursor/skills/)
- Event hooks (format-on-save, block destructive commands, secret guard) → [`.cursor/hooks/`](.cursor/hooks/) and [`examples/hooks/`](examples/hooks/)
- One config across tools → [`scripts/sync-agents.sh`](scripts/sync-agents.sh) + [`docs/cross-tool.md`](docs/cross-tool.md)

## What to follow instead

- **[agents.md](https://agents.md)** — the cross-tool `AGENTS.md` standard (read by Cursor,
  Codex, Copilot, Gemini CLI, Aider, Windsurf, Zed, and others).
- **[Cursor docs](https://cursor.com/docs)** — rules, subagents, skills, and hooks, kept current.

Thanks to everyone who used it. 🌅
