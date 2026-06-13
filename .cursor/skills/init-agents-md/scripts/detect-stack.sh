#!/usr/bin/env bash
# Best-effort, read-only stack detector for the `init-agents-md` skill.
# Prints what it finds; never writes anything. Run from the repo root.
set -uo pipefail

say() { printf '%s\n' "$1"; }
has() { [ -e "$1" ]; }

say "== Stack detection =="

# --- Package manager (from lockfile) ---
if   has pnpm-lock.yaml;     then pm="pnpm (pnpm-lock.yaml)"
elif has yarn.lock;          then pm="yarn (yarn.lock)"
elif has bun.lockb;          then pm="bun (bun.lockb)"
elif has package-lock.json;  then pm="npm (package-lock.json -> use 'npm ci')"
elif has uv.lock;            then pm="uv (uv.lock)"
elif has poetry.lock;        then pm="poetry (poetry.lock)"
elif has Cargo.lock;         then pm="cargo (Cargo.lock)"
elif has go.sum;             then pm="go modules (go.sum)"
else pm="(no lockfile found)"; fi
say "Package manager: $pm"

# --- Languages / manifests ---
langs=""
has package.json   && langs="$langs JavaScript/TypeScript"
{ has tsconfig.json || ls ./*.ts >/dev/null 2>&1; } && langs="$langs (tsconfig present)"
{ has pyproject.toml || has setup.py || has requirements.txt; } && langs="$langs Python"
has go.mod         && langs="$langs Go"
has Cargo.toml     && langs="$langs Rust"
say "Languages:${langs:- (unknown)}"

# --- Framework hints (JS) ---
if has package.json; then
  deps="$(cat package.json)"
  fw=""
  printf '%s' "$deps" | grep -q '"next"'    && fw="$fw Next.js"
  printf '%s' "$deps" | grep -q '"react"'   && fw="$fw React"
  printf '%s' "$deps" | grep -q '"vue"'     && fw="$fw Vue"
  printf '%s' "$deps" | grep -q '"svelte"'  && fw="$fw Svelte"
  printf '%s' "$deps" | grep -q '"express"' && fw="$fw Express"
  printf '%s' "$deps" | grep -q '"fastify"' && fw="$fw Fastify"
  say "JS framework:${fw:- (none detected)}"

  test_rt=""
  printf '%s' "$deps" | grep -q '"vitest"'  && test_rt="$test_rt vitest"
  printf '%s' "$deps" | grep -q '"jest"'    && test_rt="$test_rt jest"
  printf '%s' "$deps" | grep -q '"playwright"' && test_rt="$test_rt playwright"
  say "JS test runner:${test_rt:- (none detected)}"

  say "package.json scripts:"
  if command -v jq >/dev/null 2>&1; then
    jq -r '.scripts // {} | to_entries[] | "  \(.key): \(.value)"' package.json 2>/dev/null || say "  (could not parse)"
  else
    grep -A30 '"scripts"' package.json | grep ':' | sed 's/^/  /' | head -20
  fi
fi

# --- Python test/lint hints ---
if has pyproject.toml; then
  grep -qi 'pytest'  pyproject.toml && say "Python tests: pytest configured"
  grep -qi 'ruff'    pyproject.toml && say "Python lint/format: ruff configured"
  grep -qi 'mypy'    pyproject.toml && say "Python types: mypy configured"
fi

# --- Make / task runners ---
has Makefile        && say "Makefile targets: $(grep -oE '^[a-zA-Z0-9_-]+:' Makefile | tr -d ':' | tr '\n' ' ')"
has Taskfile.yml    && say "Taskfile.yml present"
has justfile        && say "justfile present"

# --- Existing config ---
has AGENTS.md && say "NOTE: AGENTS.md already exists — review/update rather than overwrite."
has .cursor/rules && say "Existing .cursor/rules: $(ls .cursor/rules 2>/dev/null | tr '\n' ' ')"

# --- Top-level layout ---
say "Top-level entries:"
ls -1 2>/dev/null | grep -vE '^(node_modules|\.git|dist|build|\.next|target|__pycache__)$' | sed 's/^/  /' | head -25
