# Migration: from the 2025 rules collection to the 2026 stack

If you cloned this repo before mid-2026, it was a collection of **11 large, mostly
always-on `.mdc` rules** (~5,500 lines). That design predates Cursor's subagents, Skills,
and hooks, and it runs against current best practice: giant always-on rules consume context
budget on every request and degrade results. [Cursor's own guidance](https://cursor.com/blog/agent-best-practices)
is now "keep rules under 500 lines, scope them, and prefer `AGENTS.md` for plain project context."

So each old rule moved to the primitive that actually fits its job. Nothing valuable was
lost — it was re-homed. Full history is in git.

## Where each old rule went

| Old rule (`.cursor/rules/`) | New home | Why |
|---|---|---|
| `audit.mdc` | **`.cursor/agents/code-reviewer.md`** | A multi-step review is a delegation task → a subagent with its own context. Kept the severity ladder + anti-pattern checklist; dropped the fake "ML pattern learning." |
| `debugging.mdc` | **`.cursor/skills/debug/SKILL.md`** | On-demand procedure → a Skill. Kept the reproduce→isolate→diagnose→fix→verify loop + `git bisect` + time-boxing; dropped the `console.log` helper snippets. |
| `ADR.mdc` | **`.cursor/skills/write-adr/SKILL.md`** | Episodic, explicitly-invoked → a Skill. Kept the template, status lifecycle, and when-to-write gate. (Also fixed its doubled YAML frontmatter.) |
| `efficiency.mdc` | **`AGENTS.md` / `templates/AGENTS.md`** | Reduced to the one durable line: batch/parallelize independent calls, don't re-read context. The "EFFICIENCY_SCORE A+/D" rubric was removed. |
| `terminal.mdc` | **`templates/AGENTS.md`** (+ `hooks/`) | Kept package-manager-from-lockfile detection and git guards; the destructive-command guarding became a real **hook**. The defensive-bash framework was dropped — the harness already gives structured results, timeouts, retries. |
| `commonsense.mdc` | **`templates/AGENTS.md`** | Kept only the non-obvious survivors: "document *why*, not *what*" and "never string-interpolate untrusted input into SQL." The rest was linter/formatter territory. |
| `javascript.mdc` (1,250 lines) | **`.cursor/rules/javascript.mdc`** (~20 lines) | Trimmed to project-specific choices; style/formatting delegated to ESLint + Prettier. |
| `typescript.mdc` (767 lines) | **`.cursor/rules/typescript.mdc`** (~20 lines) | Trimmed to opinionated patterns; strictness delegated to a strict `tsconfig.json` + typescript-eslint. |
| `memory-management.mdc` | **Removed** | Manual context-window management is now native to the agent; instructing the model to "prune Level 4 items" wastes tokens doing what the harness already does. |
| `session-coordinator.mdc` | **Removed** (1 idea → `AGENTS.md`) | Manual checkpoint/handoff scaffolding is superseded by native session context + git. The one survivor — "record discovered project conventions" — became the *Project conventions* section of the AGENTS.md template. |
| `development-journal.mdc` | **Removed** | Velocity charts / burndown / focus-score tracking was aspirational ceremony. Progress tracking is native; changelogs belong to conventional-commits tooling. |

## Other changes

- **`tools/metrics-dashboard/`** — removed. It was a static vanity dashboard of invented metrics.
- **Fabricated performance numbers** ("67% fewer tool calls", "+100% context retention") —
  removed throughout. None were measured.
- **CI** — the old workflow ran `npm ci` against a `package.json` that doesn't exist, so it
  failed on every run. Rewritten to validate what's actually here (frontmatter, JSON, scripts)
  with no Node dependency.
- **`LICENSE`** — added (The Unlicense), to match the "public domain" claim the README always made.

## If you depended on an old rule

Grab it from history:

```bash
git log --oneline --all -- .cursor/rules/audit.mdc
git show <commit>:.cursor/rules/audit.mdc > audit.mdc
```
