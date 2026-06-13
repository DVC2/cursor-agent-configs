# Quick reference: format cheat sheet

The exact frontmatter and file layout for each Cursor primitive, as of 2026. Get these wrong
and the config silently doesn't load. Authoritative source: <https://cursor.com/docs>.

## `AGENTS.md`

Plain Markdown, no frontmatter. Lives at the repo root; add nested ones per package in a
monorepo (closest file to the edited file wins). Read natively by Cursor, Codex, Copilot,
Gemini CLI, Aider, Windsurf, Zed, and others. See [`templates/AGENTS.md`](../templates/AGENTS.md).

## Rules — `.cursor/rules/*.mdc`

```yaml
---
description: When the agent should pull this in (used in "Apply Intelligently" mode)
globs: ["**/*.ts", "**/*.tsx"]   # auto-attach when a matching file is in context
alwaysApply: false
---
Rule body in Markdown.
```

Only three fields: `description`, `globs`, `alwaysApply`. The combination picks the **mode**:

| Mode | Frontmatter | Behavior |
|---|---|---|
| Always Apply | `alwaysApply: true` | Always in context. `globs`/`description` ignored. Use sparingly. |
| Apply to Specific Files | `globs:` set, `alwaysApply: false` | Auto-attached when a matching file is in context. |
| Apply Intelligently | `description:` set, no `globs`, `alwaysApply: false` | Agent reads the description and pulls it in when relevant. |
| Apply Manually | none of the above | Only when you `@mention` the rule. |

**Rules:** keep under 500 lines; one concern per file; prefer scoped over `alwaysApply`;
reference canonical files instead of pasting style guides. The `.mdc` extension is required
(plain `.md` in this dir is ignored). Nested dirs are fine.

## Subagents — `.cursor/agents/*.md`

```yaml
---
name: code-reviewer        # lowercase + hyphens; defaults to the filename
description: Shown in Task-tool hints; the agent reads it to decide when to delegate.
model: inherit             # `inherit` (default) or a specific model id
readonly: true             # true = no edits / no state-changing shell commands
is_background: false       # true = runs without blocking the parent
---
The system prompt / instructions for this subagent.
```

Exactly five fields — **there is no `tools:` field** (that's Claude Code syntax, not Cursor).
Invoke with `/name` or by mentioning it. Project files (`.cursor/agents/`) win over
user-level (`~/.cursor/agents/`) on name conflicts.

## Skills — `.cursor/skills/<name>/SKILL.md`

```yaml
---
name: write-adr            # MUST equal the parent folder name; lowercase/numbers/hyphens
description: What it does and when to use it — the agent uses this to decide relevance.
paths: "src/**"            # optional: only surface for matching files (string or list)
disable-model-invocation: false   # true = only via /write-adr, never auto-applied
---
Skill instructions in Markdown.
```

The folder may also contain `scripts/`, `references/`, `assets/`. A Skill loads *dynamically*
only when relevant — that's the win over an always-on rule. `disable-model-invocation: true`
makes it behave like a slash command.

## Hooks — `.cursor/hooks.json` (+ scripts)

```json
{
  "version": 1,
  "hooks": {
    "afterFileEdit":        [{ "command": "./.cursor/hooks/format.sh" }],
    "beforeShellExecution": [{ "command": "./.cursor/hooks/guard-destructive.sh",
                               "matcher": "rm|git" }]
  }
}
```

Top-level `"version": 1` is required. Each event maps to an array of `{ command, timeout?,
matcher? }`. **Event names are camelCase** — not `onPreEdit`/`onPostEdit`:

| Event | Fires | Can decide? |
|---|---|---|
| `beforeShellExecution` / `beforeMCPExecution` | before a shell/MCP command | `permission`: `allow`/`deny`/`ask` |
| `beforeReadFile` / `preToolUse` / `subagentStart` | before read / tool / subagent | `permission`: `allow`/`deny` |
| `beforeSubmitPrompt` | before a prompt is submitted | `continue`: `true`/`false` |
| `afterFileEdit` | after the agent edits a file | observe-only (e.g. format) |
| `afterShellExecution` / `postToolUse` / `stop` / `sessionStart` / `sessionEnd` | after the named stage | mostly observe / append context |

Hook scripts read the event JSON on **stdin** and return a decision JSON on **stdout**
(exit code `2` also blocks). They must be executable and, in these examples, need `jq`.
See [`.cursor/hooks/`](../.cursor/hooks/) for working scripts.
