# AGENTS.md

> Go starter (modules + table-driven tests). Copy to your repo root and edit the brackets.

## Project overview

[What this service/CLI is, the module path, and the package layout (`cmd/`, `internal/`, `pkg/`).]

## Setup commands

```bash
go build ./...
go test ./...                 # run tests (add -race for concurrency-sensitive code)
go vet ./...                  # static checks
gofmt -l .                    # list unformatted files (must be empty)
golangci-lint run             # if configured
```

## Code style & conventions

- Formatting is owned by `gofmt`/`goimports` — never hand-format. Lint via `golangci-lint`.
- **Errors:** return errors, don't panic in library code. Wrap with context using
  `fmt.Errorf("doing X: %w", err)`; check with `errors.Is`/`errors.As`. Don't discard errors with `_`.
- Accept interfaces, return concrete types. Keep interfaces small and defined at the consumer.
- Use `context.Context` as the first arg for anything I/O-bound or cancelable; never store it in a struct.
- Guard shared state; run `go test -race` on concurrent code. Prefer channels/sync primitives over ad-hoc locking.
- Keep exported identifiers documented (`// Name ...`).

## Testing

- Table-driven tests with subtests (`t.Run`). Co-locate `_test.go` files. Use `t.Helper()` in helpers.
  Prefer the standard library + `testify` only if already a dep. Run `go test ./...` before committing.

## Security & gotchas

- Validate all external input. Use parameterized queries (`database/sql` placeholders), never string-built SQL.
- Set timeouts on HTTP clients/servers; don't use the default no-timeout client. No secrets in code.

## PRs

- Conventional Commits. `gofmt`, `go vet`, `go test ./...` (and lint) must pass.
