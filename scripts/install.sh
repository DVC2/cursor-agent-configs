#!/usr/bin/env bash
# Install Cursor/agent configs from this repo into the current project.
# Copies the .cursor primitives you choose, plus the AGENTS.md starter template.
# Backs up anything it would overwrite. No Node/npm required.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$(dirname "$SCRIPT_DIR")"          # repo root (source)
DEST="$(pwd)"                            # target project (current dir)
STAMP="$(date +%Y%m%d_%H%M%S)"

say()  { printf '  %s\n' "$1"; }
ask()  { local p="$1" d="${2:-y}" r; read -r -p "  $p " r; r="${r:-$d}"; [[ "$r" =~ ^[Yy]$ ]]; }

backup_then_copy() { # $1=src path  $2=dest path
  local s="$1" d="$2"
  if [ -e "$d" ]; then
    local b="${d}.backup_${STAMP}"
    cp -r "$d" "$b"
    say "backed up existing $(basename "$d") -> $b"
  fi
  mkdir -p "$(dirname "$d")"
  cp -r "$s" "$d"
  say "installed $d"
}

echo "Installing Cursor configs into: $DEST"
[ "$SRC" = "$DEST" ] && { echo "Refusing to install into the source repo itself."; exit 1; }

if ask "Copy rules (.cursor/rules)? [Y/n]";  then backup_then_copy "$SRC/.cursor/rules"  "$DEST/.cursor/rules";  fi
if ask "Copy subagents (.cursor/agents)? [Y/n]"; then backup_then_copy "$SRC/.cursor/agents" "$DEST/.cursor/agents"; fi
if ask "Copy skills (.cursor/skills)? [Y/n]"; then backup_then_copy "$SRC/.cursor/skills" "$DEST/.cursor/skills"; fi

echo
echo "  Hooks run shell scripts on agent events. Review them before installing:"
echo "    $SRC/.cursor/hooks/"
if ask "Copy hooks (.cursor/hooks.json + scripts)? [y/N]" "n"; then
  backup_then_copy "$SRC/.cursor/hooks.json" "$DEST/.cursor/hooks.json"
  backup_then_copy "$SRC/.cursor/hooks"      "$DEST/.cursor/hooks"
  chmod +x "$DEST"/.cursor/hooks/*.sh 2>/dev/null || true
  command -v jq >/dev/null || say "note: the example hooks need 'jq' on PATH."
fi

if [ ! -e "$DEST/AGENTS.md" ] && ask "Add an AGENTS.md from the template? [Y/n]"; then
  cp "$SRC/templates/AGENTS.md" "$DEST/AGENTS.md"
  say "created AGENTS.md — open it and fill in the bracketed sections."
elif [ -e "$DEST/AGENTS.md" ]; then
  say "AGENTS.md already exists — left untouched."
fi

echo
echo "Done. Restart Cursor to load the new configs."
