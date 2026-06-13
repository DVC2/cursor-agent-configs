#!/usr/bin/env bash
# beforeShellExecution hook: block obviously destructive commands before they run.
#
# Cursor passes the event payload as JSON on stdin (including `.command`). For
# beforeShellExecution we return a decision on stdout:
#   { "permission": "allow" | "deny" | "ask", "user_message": ..., "agent_message": ... }
# Exiting with code 2 also blocks. This script fails OPEN (allows) on any error so a
# broken hook never wedges the agent — flip to fail-closed if your threat model needs it.
#
# Requires `jq`.
set -uo pipefail

input="$(cat)"
command="$(printf '%s' "$input" | jq -r '.command // empty')"

deny() {
  jq -n --arg msg "$1" \
    '{permission: "deny", user_message: $msg, agent_message: $msg}'
  exit 0
}

# Patterns worth stopping a human (and an agent) on.
if printf '%s' "$command" | grep -Eq 'rm[[:space:]]+(-[a-zA-Z]*f[a-zA-Z]*[[:space:]]+)?(-[a-zA-Z]+[[:space:]]+)*(/|~|\*|\.)([[:space:]]|$)'; then
  deny "Blocked: 'rm -rf' targeting a root/home/wildcard path. Delete a specific path instead."
fi

if printf '%s' "$command" | grep -Eq 'git[[:space:]]+push[[:space:]].*(--force|-f)([[:space:]]|$)' \
   && ! printf '%s' "$command" | grep -q -- '--force-with-lease'; then
  deny "Blocked: 'git push --force'. Use '--force-with-lease' so you don't clobber others' work."
fi

if printf '%s' "$command" | grep -Eq '(:\(\)\{|mkfs|dd[[:space:]]+if=.*of=/dev/)'; then
  deny "Blocked: command matches a known system-destroying pattern."
fi

echo '{ "permission": "allow" }'
exit 0
