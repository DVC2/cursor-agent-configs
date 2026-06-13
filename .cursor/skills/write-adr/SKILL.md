---
name: write-adr
description: Write an Architectural Decision Record. Use when a decision affects architecture, has long-term implications, involves significant tradeoffs, or is hard to reverse.
---

# Write an ADR

Capture *why* a significant decision was made, so future readers (and agents) don't re-litigate it.

## When to write one (gate)

Write an ADR only when the decision: affects system architecture · has long-term
implications · involves real tradeoffs · changes an established pattern · or is costly to
reverse. Routine, easily-reversible choices don't need one.

## Where it goes

`docs/adr/ADR-NNN-short-slug.md`, zero-padded sequential number. Maintain a `docs/adr/README.md`
index. Decisions never get deleted — they get superseded.

## Status lifecycle

`Proposed → Accepted → Deprecated → Superseded by ADR-XXX`. When a new ADR replaces an old
one, set the old one to `Superseded by ADR-XXX` and link both ways.

## Full template

```markdown
# ADR-NNN: <title>

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-XXX

## Context
The forces at play: the problem, constraints, and what's motivating a decision now.

## Decision
What we are doing, stated plainly.

## Consequences
### Positive
- ...
### Negative
- ...
### Neutral
- ...

## Alternatives considered
- **<option>** — why it was rejected.
```

## Rapid variant (low-stakes decisions)

When a full ADR is overkill, capture just: **Option A vs Option B** (pros / cons / cost) and a
one-line recommendation. Promote to a full ADR only if the decision turns out to matter.
