#!/usr/bin/env bash
# sessionStart hook: orient the agent with current git context.
# stdin: event JSON. stdout: { "additional_context": "..." } (sessionStart may also return "env").
# Observe-only — there's nothing to allow/deny. Fails safe by emitting empty context on error.
set -uo pipefail

cat >/dev/null   # drain stdin (we don't need the payload here)

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo '{}'; exit 0
fi

branch="$(git branch --show-current 2>/dev/null || echo 'detached')"
status="$(git status --short 2>/dev/null | head -20)"
recent="$(git log --oneline -5 2>/dev/null)"

context="$(printf 'Git context at session start:\n- Branch: %s\n\nUncommitted changes:\n%s\n\nRecent commits:\n%s\n' \
  "$branch" "${status:-(clean)}" "${recent:-(none)}")"

jq -n --arg c "$context" '{ additional_context: $c }'
exit 0
