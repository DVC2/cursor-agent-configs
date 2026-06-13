# Hooks cookbook

Extra, ready-to-use Cursor hooks beyond the two wired into [`.cursor/hooks.json`](../../.cursor/hooks.json)
(`format.sh`, `guard-destructive.sh`). Copy the script into your project's `.cursor/hooks/`,
make it executable (`chmod +x`), and add the matching entry to `.cursor/hooks.json`.

> Hooks run shell scripts on agent events — **read each one before installing it.** These need
> `jq` on `PATH`. Event names are camelCase (`beforeShellExecution`, `sessionStart`,
> `afterFileEdit`); decision fields differ by event (see [`docs/quick-reference.md`](../../docs/quick-reference.md)).

## `guard-secrets.sh` — block commits/pushes that contain secrets

Scans staged content before `git commit`/`git push` and denies if it looks like a key/token
leaked in. Fails open (allows) on error so it can't wedge you.

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      { "command": "./.cursor/hooks/guard-secrets.sh", "matcher": "git commit|git push" }
    ]
  }
}
```

## `inject-context.sh` — give the agent git context at session start

`sessionStart` hook that returns the current branch, working-tree status, and recent commits as
`additional_context`, so the agent starts each session oriented.

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [ { "command": "./.cursor/hooks/inject-context.sh" } ]
  }
}
```

## `test-on-save.sh` — run the matching test after an edit

`afterFileEdit` hook (observe-only) that finds the test file paired with the file the agent just
edited and runs it, appending the result to `.cursor/test-on-save.log`. Best-effort and quiet;
tune the framework commands to your project.

```json
{
  "version": 1,
  "hooks": {
    "afterFileEdit": [ { "command": "./.cursor/hooks/test-on-save.sh" } ]
  }
}
```

Multiple hooks on the same event go in the same array — merge these entries with whatever you
already have in `.cursor/hooks.json`.
