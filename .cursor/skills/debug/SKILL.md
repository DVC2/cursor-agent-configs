---
name: debug
description: A systematic debugging procedure. Use when stuck on a bug, a flaky test, or a regression — especially when "it worked before" or the cause isn't obvious.
---

# Debug

A loop for finding root causes instead of guessing. Reach for this when the obvious fix
hasn't worked within a few minutes.

## Triage first (answer before diving in)

- Is the error message clear, or is it masking the real failure?
- Can I reproduce it consistently? (If not, that's the first problem to solve.)
- Did it work before? **What changed recently?**
- Is it environment-specific (only CI, only one machine, only prod data)?

## The loop

1. **Reproduce** — get the smallest, most reliable repro before changing anything.
2. **Isolate** — shrink to the smallest failing case; bisect the input or the code path.
3. **Diagnose** — find the *root cause*, not the symptom. When inspecting a null/undefined
   chain, log one structured object with all the link states at once
   (`{ hasUser, hasProfile, keys }`) rather than scattering print statements.
4. **Fix** — make the smallest change that addresses the root cause. Change one thing at a time.
5. **Verify** — reproduce the original failure and confirm it's gone; run the surrounding tests.

## High-value techniques

- **Regression ("worked before, broken now"): `git bisect`.**
  ```bash
  git bisect start
  git bisect bad                 # current commit is broken
  git bisect good <known-good>   # a commit that worked
  # test each step, mark `git bisect good` / `git bisect bad`, then:
  git bisect reset
  ```
- **Time-box to avoid rabbit-holing:** ~5 min on the obvious checks → ~15 min systematic
  isolation → then step back, ask for help, or write down what you've ruled out.
