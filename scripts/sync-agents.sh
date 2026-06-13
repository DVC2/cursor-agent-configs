#!/usr/bin/env bash
# Keep tool-specific instruction files in sync with a single source of truth: AGENTS.md.
#
# Most modern agents read AGENTS.md natively (Cursor, Codex, Aider, Gemini CLI, Zed, …), but a
# few still look for their own file. This generates those from AGENTS.md so you maintain one file.
#
#   scripts/sync-agents.sh           # (re)generate the tool files from AGENTS.md
#   scripts/sync-agents.sh --check   # exit 1 if any generated file is out of date (for CI)
#
# Run it from the repo root (the dir containing AGENTS.md).
set -euo pipefail

SOURCE="AGENTS.md"
# target file -> tool it serves
TARGETS=(
  "CLAUDE.md"                          # Claude Code
  ".github/copilot-instructions.md"    # GitHub Copilot
  "GEMINI.md"                          # Gemini CLI (also reads AGENTS.md; kept for older versions)
)

BANNER="<!-- AUTO-GENERATED from AGENTS.md by scripts/sync-agents.sh — edit AGENTS.md, not this file. -->"

[ -f "$SOURCE" ] || { echo "error: $SOURCE not found (run from your repo root)."; exit 1; }

render() { # prints the generated content for a target to stdout
  printf '%s\n\n' "$BANNER"
  cat "$SOURCE"
}

check=0
[ "${1:-}" = "--check" ] && check=1

stale=0
for target in "${TARGETS[@]}"; do
  if [ "$check" = 1 ]; then
    if [ ! -f "$target" ] || ! diff -q <(render) "$target" >/dev/null 2>&1; then
      echo "out of sync: $target"
      stale=1
    fi
  else
    mkdir -p "$(dirname "$target")"
    render > "$target"
    echo "wrote $target"
  fi
done

if [ "$check" = 1 ]; then
  [ "$stale" = 0 ] && { echo "OK: all tool files match AGENTS.md"; exit 0; }
  echo "Run scripts/sync-agents.sh to regenerate."; exit 1
fi
echo "Done. Commit the generated files (or add them to .gitignore if you'd rather not track them)."
