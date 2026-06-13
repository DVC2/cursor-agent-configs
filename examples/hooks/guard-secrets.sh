#!/usr/bin/env bash
# beforeShellExecution hook: block `git commit`/`git push` when staged content looks like it
# contains a secret. Wire with matcher "git commit|git push".
#
# stdin: event JSON (incl. .command). stdout: { "permission": "allow"|"deny", ... }.
# Fails OPEN (allows) on any error so a false negative never blocks legitimate work — this is a
# safety net, not your only secret scanner. Add a real pre-commit scanner (gitleaks/trufflehog) too.
set -uo pipefail

input="$(cat)"
command="$(printf '%s' "$input" | jq -r '.command // empty')"

allow() { echo '{ "permission": "allow" }'; exit 0; }
deny()  { jq -n --arg m "$1" '{permission:"deny", user_message:$m, agent_message:$m}'; exit 0; }

# Only act on commit/push; let everything else through.
printf '%s' "$command" | grep -Eq 'git[[:space:]]+(commit|push)' || allow

staged="$(git diff --cached 2>/dev/null || true)"
[ -n "$staged" ] || allow   # nothing staged (e.g. push only) — nothing to scan here

# High-signal secret patterns. Tune for your stack; keep it conservative to limit false positives.
patterns='(AKIA[0-9A-Z]{16})|(-----BEGIN [A-Z ]*PRIVATE KEY-----)|(gh[pousr]_[A-Za-z0-9]{20,})|(xox[baprs]-[A-Za-z0-9-]{10,})|((secret|token|api[_-]?key|password)["'"'"']?\s*[:=]\s*["'"'"'][^"'"'"']{12,})'

if printf '%s' "$staged" | grep -Eiq "$patterns"; then
  deny "Blocked: staged changes look like they contain a secret (key/token/password). Remove it, rotate it if it was real, and stage again."
fi
allow
