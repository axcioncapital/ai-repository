---
model: opus
---

Evaluate a proposed structural change against five risk dimensions before landing. Delegates to the `risk-check-reviewer` subagent (fresh context); produces a structured report and a chat verdict: GO / PROCEED-WITH-CAUTION / RECONSIDER. Does NOT execute the change.

Input: `$ARGUMENTS` — free-text description of the proposed change, optionally referencing file paths.

Examples:
- `/risk-check edit .claude/hooks/friday-checkup-reminder.sh to add stale-state detection derived from audits/friday-checkup-*.md listing`
- `/risk-check add new slash command /route-change and docs/repo-architecture.md`
- `/risk-check allow Bash(rg:*) in workspace settings.json`

Required-when-mandatory change classes (per `ai-resources/docs/audit-discipline.md` § Risk-check change classes):
- Hook edits (`.claude/hooks/*.sh`)
- Permission changes (`settings.json` `allow` / `ask` / `deny` edits)
- CLAUDE.md edits that are cross-cutting (workspace-level or project-level always-loaded)
- New commands or skills
- New symlinks
- Automation with shared-state effects (scripts that auto-write to logs, cross-repo writes, auto-commit)

For non-listed change classes, `/risk-check` is optional and operator-invoked as judgment dictates.

Invocation semantics: operator-typed, or inline-prompted by other commands (e.g., `/friday-act`). There is NO SessionStart / Stop / PreToolUse hook that auto-fires `/risk-check` — that would over-escalate on ordinary edits.

---

### Step 1: Input Validation

1. If `$ARGUMENTS` is empty, abort with:
   ```
   /risk-check requires a description of the proposed change.
   Example: /risk-check edit .claude/hooks/X.sh to add Y detection
   ```

2. Set `CHANGE_DESCRIPTION` = `$ARGUMENTS` verbatim.

---

### Step 2: Path Setup

3. Set `DATE` = today in `YYYY-MM-DD`.
4. Set `AI_RESOURCES` = absolute path to the `ai-resources/` directory.
5. Set `REPORT_DIR` = `{AI_RESOURCES}/audits/risk-checks/`. Create if missing (`mkdir -p {REPORT_DIR}`).
6. Extract referenced file paths from `CHANGE_DESCRIPTION`. Strategy: find tokens that look like paths — contain a `/` and end in a recognized extension (`.md`, `.sh`, `.json`, `.yaml`, `.yml`, `.py`, `.ts`, `.js`) — plus bare filenames matching `CLAUDE.md` or `SKILL.md`.
   - For each candidate, resolve against `AI_RESOURCES` (relative) or accept as-is (absolute).
   - For each resolved path, record its existence status: `exists` or `not yet present`.
   - Unresolvable paths do NOT abort the command — `/risk-check` is often invoked pre-creation, so target files may not yet exist. Record them as `not yet present`.
7. Compute `SLUG` from `CHANGE_DESCRIPTION`:
   - Lowercase.
   - Replace runs of non-alphanumeric characters with a single `-`.
   - Strip leading and trailing `-`.
   - Truncate to 60 characters; if the truncation falls mid-word, trim back to the nearest preceding `-`.
   - If the result is empty, fall back to `change-{HHMMSS}` (current time).
8. Set `REPORT_PATH` = `{REPORT_DIR}/{DATE}-{SLUG}.md`.
9. If `REPORT_PATH` already exists from an earlier invocation with the same slug today, append `-2`, `-3`, etc. until unique.
10. Verify the subagent definition exists at `{AI_RESOURCES}/.claude/agents/risk-check-reviewer.md`. Abort if missing.

---

### Step 3: Spawn risk-check-reviewer Subagent

11. Spawn one `risk-check-reviewer` subagent with these inputs:
    - `CHANGE_DESCRIPTION` — verbatim
    - `REFERENCED_FILE_PATHS` — list, each entry `{absolute path} — {exists | not yet present}`
    - `REPORT_PATH` — absolute path where the subagent must write the full report
    - `DATE`
    - `AI_RESOURCES`

12. Subagent returns a ≤20-line summary ending with `REPORT: {absolute path}` as its last line.

13. If the returned summary lacks the `REPORT:` last-line marker, re-invoke the subagent once with the same inputs. If the re-invocation also lacks the marker, abort with an error naming the malformed summary and do NOT proceed to validation.

---

### Step 4: Structural Validation

14. Read `REPORT_PATH` back and parse:
    - `VERDICT` — the token under `## Verdict` (must be exactly one of `GO`, `PROCEED-WITH-CAUTION`, `RECONSIDER`).
    - `NUM_HIGH` — count of `### Dimension N: ...` subsections whose body contains the line `**Risk:** High`.

15. Verify presence rules (structural):
    - `## Verdict` section present with a valid verdict token.
    - `## Dimensions` section present with five `### Dimension N: ...` subsections (1–5, in order).

16. Verify section-by-verdict rules (enforce the agent's Step 8 template OMIT contract so malformed reports cannot ship):

    - **If `VERDICT` = `GO`:**
      - `## Mitigations` must be either absent, OR present with no content bullets (a placeholder line like `_(Not required — verdict is GO.)_` is acceptable and treated as empty).
      - `## Recommended redesign` must be either absent, OR present with no content bullets (placeholder acceptable).

    - **If `VERDICT` = `PROCEED-WITH-CAUTION`:**
      - `## Mitigations` present with at least `max(1, NUM_HIGH)` content bullets. This enforces the agent's generation rule "at least one mitigation per High dimension." If `NUM_HIGH` is 0 (verdict triggered by two-or-more Mediums), at least one bullet total is still required.
      - `## Recommended redesign` must be either absent, OR present with no content bullets (placeholder acceptable).

    - **If `VERDICT` = `RECONSIDER`:**
      - `## Recommended redesign` present with at least one content bullet.
      - `## Mitigations` must be either absent, OR present with no content bullets (placeholder acceptable).

17. On any validation failure, re-invoke the subagent once with explicit instructions naming the specific violation (e.g., "mitigations section has 1 bullet but `NUM_HIGH`=2 — produce at least one per High dimension"; or "verdict is GO but Mitigations section has content — remove or replace with an empty placeholder"). If validation still fails on the re-invocation, abort with an error naming the violation — do NOT present a malformed report to the operator.

---

### Step 5: Present Summary to Operator

18. Display in chat:
    - `Risk check — {DATE}`
    - `Change: {CHANGE_DESCRIPTION first line, truncated to ~100 chars}`
    - `Verdict: {GO | PROCEED-WITH-CAUTION | RECONSIDER}`
    - Per-dimension risk level, one line each, from the subagent summary:
      ```
      - Usage cost:       {Low | Medium | High}
      - Permissions:      {Low | Medium | High}
      - Blast radius:     {Low | Medium | High}
      - Reversibility:    {Low | Medium | High}
      - Hidden coupling:  {Low | Medium | High}
      ```
    - If verdict is `PROCEED-WITH-CAUTION`: list the paired mitigations under `Required mitigations:`.
    - If verdict is `RECONSIDER`: include the recommended-redesign one-liner.
    - `Full report: {REPORT_PATH}`

19. Append guidance based on verdict:
    - `GO` → "Proceed with the change as planned."
    - `PROCEED-WITH-CAUTION` → "Mitigations above are required. Confirm each is applied when you land the change."
    - `RECONSIDER` → "Address the findings before proceeding. Re-invoke /risk-check after redesign."

---

### Step 6: No Commit, No Execution

20. `/risk-check` is a pre-execution gate. It does NOT execute the change. It does NOT commit the report.

21. The report lands in the working tree under `audits/risk-checks/`. The operator (or downstream command such as `/friday-act`) decides the next action based on the verdict. If the operator wants the report preserved in git history, they stage and commit it alongside the change it gated (or as a standalone `audit: risk-check — {slug}` commit).
