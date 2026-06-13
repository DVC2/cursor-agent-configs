# Troubleshooting

Quick fixes for "my config isn't doing anything." Format details are in
[`quick-reference.md`](quick-reference.md).

## A rule isn't applying

1. **Extension.** It must be `.mdc`, inside `.cursor/rules/`. Plain `.md` there is ignored.
2. **Frontmatter.** Exactly one `---` block at the very top, valid YAML. A **doubled**
   frontmatter block (an empty one then a real one) silently breaks the rule — this was the
   most common bug in the old version of this repo.
3. **Mode mismatch.** `alwaysApply: false` with no `globs` and no `description` = manual-only;
   it loads only when you `@mention` it. Add `globs` to auto-attach, or a `description` to let
   the agent pull it in. See the mode table in the cheat sheet.
4. **Glob doesn't match.** Globs match repo-relative paths — `**/*.ts`, not `*.ts`. Open a file
   you expect to match and check the agent's context/rules panel.

## A subagent or Skill doesn't show up

- **Restart Cursor** after adding files; discovery happens at startup.
- **Version:** subagents and Skills need **Cursor 2.4+**. Check Help → About.
- **Skill `name` must equal its folder name** and be lowercase/numbers/hyphens only
  (`.cursor/skills/write-adr/SKILL.md` → `name: write-adr`). A mismatch makes it invisible.
- **File name:** the Skill file is `SKILL.md` (uppercase). Subagents are `.md` in `.cursor/agents/`.
- **`disable-model-invocation: true`** means the Skill only runs when you type `/name` — it
  won't auto-apply. That's intended; invoke it explicitly.
- Don't add a `tools:` field to a subagent — it's not a valid Cursor field and signals a config
  copied from another tool.

## A hook doesn't fire

1. `jq . .cursor/hooks.json` — it must be valid JSON with top-level `"version": 1`.
2. **Event name** must be exact camelCase (`beforeShellExecution`, `afterFileEdit`). `onPreEdit`
   and similar do **not** exist.
3. **Executable:** `chmod +x .cursor/hooks/*.sh`.
4. **Dependencies:** the example scripts need `jq` on `PATH`.
5. **Trust:** Cursor loads project hooks only in a trusted workspace. Re-open/trust the folder.
6. **Debugging:** add `echo "$(date) $input" >> /tmp/hook.log` near the top of the script to
   confirm it's being invoked and see the payload it receives.

## Rules feel like they're "fighting" each other

You likely have multiple `alwaysApply: true` rules with broad globs all loading at once — the
original anti-pattern. Scope them with `globs`, switch some to `description`-based, or move the
always-true content into `AGENTS.md`. Fewer, sharper rules beat many overlapping ones.
