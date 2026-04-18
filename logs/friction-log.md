# Friction Log

## Session — 2026-04-18 (post-prevention cleanup 2)

### Friction Events

- **Prime Step 2 innovation-registry count wrong.** Registry is a pipe-delimited markdown table (rows like `| 2026-04-18 | agent | .../file.md | detected | — |`), but Prime Step 2 greps for `^- **detected**` / `status: detected` / `"status": "detected"` — list-item and JSON patterns, not table-cell patterns. Result: registry with 5 `detected` rows reported 0. Last session's wrap already flagged this as "status-check needed" — root cause is the Prime grep pattern, not registry state. Fix: Prime should grep for `| detected |` (table-cell pattern) or parse the status column directly.
- **Prime git-status snapshot can be stale vs actual HEAD.** This session's Prime reported `M .claude/hooks/pre-commit` and `?? .claude/hooks/check-skill-size.sh`, but both were actually committed in `bbd2261` and `a0c79fc` — `git diff --stat HEAD` showed those paths clean. Cost: full diagnostic detour to confirm what "loose ends" were outstanding. Not a Prime bug per se (snapshot is explicitly point-in-time), but a systematic hazard when Prime flags next-steps that depend on status claims. Possible fix: Prime's status block should invite a re-check (`git status` at step 7 or similar) rather than being treated as ground truth.

#### Write Activity
