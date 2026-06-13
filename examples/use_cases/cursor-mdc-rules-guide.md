# Recipes: picking the right primitive

Short, concrete scenarios showing which of the five primitives to reach for. The configs in
this repo are the worked examples — these recipes tell you *when* to use each.

## "Every contributor's agent keeps getting our conventions wrong"

→ **`AGENTS.md`** at the repo root. Put the stack, setup commands, and the handful of
conventions a new teammate would get wrong (file naming, error handling, API response shape).
Start [from the template](../../templates/AGENTS.md). It's read by Cursor *and* every other
agent your team uses.

## "I want strict rules, but only for our TypeScript files"

→ A **scoped rule**. `.cursor/rules/typescript.mdc` with `globs: ["**/*.ts", "**/*.tsx"]` and
`alwaysApply: false` — it attaches only when a TS file is in context, and stays out of the way
otherwise. Keep it to the opinionated, non-default choices; let `tsconfig`/ESLint own the rest.
See [`.cursor/rules/typescript.mdc`](../../.cursor/rules/typescript.mdc).

## "Before I commit, review my diff like a skeptical senior engineer"

→ A **subagent**. Invoke `/code-reviewer` — it runs in its own context with a review persona
and a severity ladder, so the review doesn't pollute your main thread. Make it `readonly: true`
so it reports rather than edits. See [`.cursor/agents/code-reviewer.md`](../../.cursor/agents/code-reviewer.md).
Pair it with `/verifier` after a task is "done" to confirm the work actually runs.

## "We write ADRs, but only occasionally — I don't want that in context all the time"

→ A **Skill**. `.cursor/skills/write-adr/` loads only when you ask to write an ADR, so the
template and lifecycle rules don't sit in every request. Invoke with `/write-adr`. See
[`.cursor/skills/write-adr/SKILL.md`](../../.cursor/skills/write-adr/SKILL.md). The `debug`
skill works the same way — there when you're stuck, invisible when you're not.

## "Auto-format after the agent edits a file" / "never let it run `rm -rf /`"

→ **Hooks** — the only primitive that's deterministic enforcement, not advice. `afterFileEdit`
runs your formatter; `beforeShellExecution` can `deny` a dangerous command before it executes.
See [`.cursor/hooks.json`](../../.cursor/hooks.json) and [`.cursor/hooks/`](../../.cursor/hooks/).
A rule *asks* the model to behave; a hook *makes* it.

## Decision shortcut

- Always-on, plain project context, cross-tool → **`AGENTS.md`**
- Conditional on file type or relevance → **rule**
- A delegated job with its own context/persona → **subagent**
- On-demand procedure that should stay out of context until needed → **Skill**
- Must happen deterministically, can't be left to the model → **hook**
