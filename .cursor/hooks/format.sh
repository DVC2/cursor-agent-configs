#!/usr/bin/env bash
# afterFileEdit hook: format the file the agent just edited.
#
# Cursor passes the event payload as JSON on stdin. afterFileEdit is observe-only —
# there is no decision to return, so we just format and exit 0.
#
# Requires `jq`. Adjust the formatter commands to your project's toolchain.
set -euo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.file_path // .path // empty')"

# Nothing to do if we didn't get a path or the file is gone.
[ -n "$file" ] && [ -f "$file" ] || exit 0

case "$file" in
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.md)
    command -v prettier >/dev/null 2>&1 && prettier --write "$file" >/dev/null 2>&1 || true
    ;;
  *.py)
    command -v ruff >/dev/null 2>&1 && ruff format "$file" >/dev/null 2>&1 || true
    ;;
  *.go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$file" >/dev/null 2>&1 || true
    ;;
esac

exit 0
