# One config, every agent

`AGENTS.md` is an [open standard](https://agents.md) read **natively** by most 2026 coding
agents — so the same project context works whether your team uses Cursor, Codex, Copilot, or
the Gemini CLI. A few tools still prefer their own filename; for those, generate the file from
`AGENTS.md` instead of maintaining it by hand.

## Who reads what

| Tool | Reads `AGENTS.md` natively? | Prefers its own file |
|---|---|---|
| Cursor | ✅ (+ `.cursor/rules`, agents, skills, hooks) | — |
| OpenAI Codex | ✅ | — |
| Gemini CLI | ✅ | `GEMINI.md` (older versions) |
| Aider | ✅ | — |
| Zed | ✅ | — |
| Windsurf | ✅ | — |
| Claude Code | ✅ (also reads `AGENTS.md`) | `CLAUDE.md` |
| GitHub Copilot | partial | `.github/copilot-instructions.md` |

(See <https://agents.md> for the current, full list — 20+ tools.)

## Keep them in sync

Don't hand-maintain duplicates. Treat `AGENTS.md` as the source of truth and generate the rest:

```bash
scripts/sync-agents.sh          # regenerate CLAUDE.md, .github/copilot-instructions.md, GEMINI.md
scripts/sync-agents.sh --check  # CI/pre-commit: fail if any is stale
```

Each generated file starts with an `AUTO-GENERATED … edit AGENTS.md` banner so nobody edits the
wrong one. Edit `TARGETS` in the script to add/remove tools.

### Wire `--check` into CI

```yaml
- name: AGENTS.md tool files are in sync
  run: scripts/sync-agents.sh --check
```

### Prefer not to track the generated files?

Add them to `.gitignore` and run `scripts/sync-agents.sh` in a `postCheckout`/setup step, or
commit them so they work in cloud/CI agents that won't run your scripts. Tracking them is the
simpler default.
