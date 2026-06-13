#!/usr/bin/env bash
# afterFileEdit hook: run the test paired with the file the agent just edited.
# stdin: event JSON (incl. .file_path). Observe-only: no decision is returned, always exit 0.
# Best-effort and quiet — results are appended to .cursor/test-on-save.log, not surfaced inline.
set -uo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.file_path // .path // empty')"
log=".cursor/test-on-save.log"
[ -n "$file" ] && [ -f "$file" ] || exit 0

run() { echo "[$(date '+%H:%M:%S')] $*" >> "$log"; eval "$* >>'$log' 2>&1" || true; }

case "$file" in
  # Already a test file → run it directly.
  *.test.ts|*.test.tsx|*.test.js|*.spec.ts|*.spec.js)
    command -v npx >/dev/null && run "npx vitest run '$file'" ;;
  *_test.go)
    run "go test \"./$(dirname "$file")/...\"" ;;
  test_*.py|*_test.py)
    command -v uv >/dev/null && run "uv run pytest '$file'" ;;

  # Source file → look for its sibling test and run that.
  *.ts|*.tsx|*.js)
    base="${file%.*}"
    for t in "$base.test.${file##*.}" "$base.spec.${file##*.}"; do
      [ -f "$t" ] && command -v npx >/dev/null && run "npx vitest run '$t'" && break
    done ;;
  *.go)
    t="${file%.go}_test.go"
    [ -f "$t" ] && run "go test \"./$(dirname "$file")/...\"" ;;
  *.py)
    t="$(dirname "$file")/test_$(basename "$file")"
    [ -f "$t" ] && command -v uv >/dev/null && run "uv run pytest '$t'" ;;
esac

exit 0
