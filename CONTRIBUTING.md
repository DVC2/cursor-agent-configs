# Contributing

Thanks for wanting to add to this collection. It's a set of **copy-paste Cursor/agent
configs**, so the bar is: *would a real project actually want this, in the right primitive,
in the documented format?*

## What we want

- Configs that solve a real, recurring problem — not generic advice an agent already follows.
- The **right primitive** for the job (see the decision table in the [README](README.md)):
  always-on context → `AGENTS.md`; file-scoped → a rule; delegated task → a subagent;
  on-demand procedure → a Skill; deterministic enforcement → a hook.
- Honest framing. **No fabricated metrics** ("70% fewer tool calls") unless you include a
  reproducible measurement. The old version of this repo was full of invented numbers; we removed them.

## Format requirements

Match the documented frontmatter exactly — [`docs/quick-reference.md`](docs/quick-reference.md)
has every field. Common ways to get it wrong:

- **One** `---` frontmatter block per file, valid YAML. (A doubled block silently breaks the file.)
- Rules: `.mdc` extension, under 500 lines, scoped via `globs`/`description` rather than
  `alwaysApply: true` unless it's genuinely universal.
- Subagents: no `tools:` field (not a Cursor field).
- Skills: `name:` must equal the folder name; the file is `SKILL.md`.
- Hooks: valid JSON, `"version": 1`, camelCase event names, scripts executable.

## Before you open a PR

Run the same checks CI runs:

```bash
# Frontmatter is single + parseable, hooks.json is valid, hook scripts are executable.
# (CI does this in .github/workflows/ci.yml — no Node/npm required.)
python3 -c "import json; json.load(open('.cursor/hooks.json'))"
for f in .cursor/hooks/*.sh; do test -x "$f" || echo "not executable: $f"; done
```

Then: try it in a real project, keep the change focused (one config per PR is ideal), and
describe the problem it solves. Conventional-commit titles (`feat:`, `fix:`, `docs:`).

## Code of conduct

Be respectful and constructive. We review for usefulness, correct format, and honesty — not
volume.
