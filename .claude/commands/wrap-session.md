Wrap the current session. The operator's wrap-up context follows this prompt: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context. Auto-commits track file changes separately.

0. As your first action, run `touch /tmp/claude-wrap-session-done` via Bash. This suppresses the session-end hook's "Session ended without /wrap-session" auto-append while this command runs, preventing a file-modification race on `logs/session-notes.md`. The hook deletes the lockfile after reading it, so no cleanup is needed.

**Preflight — operator preferences.** Before doing anything else, ask the operator in a single prompt and **wait for the answer**:

> Wrap-session preflight — run these optional passes?
> 1. Session telemetry (usage-analysis) — y/n
> 2. Coaching data capture — y/n

Accept shorthand: "yy" / "yes both" / "both" = both yes; "nn" / "skip both" = both no; "y/n" or "1y 2n" = per-item. Record the two answers and use them to gate Step 6 (coaching) and Step 13 (telemetry). Do not assume defaults — if the operator's reply is ambiguous, re-ask before proceeding. Note skipped passes in chat as "Skipped per preflight" when you reach the corresponding step.

1. Read `/logs/session-notes.md` (last 5 lines only — to find the append point). If the file doesn't exist, create it with `# Session Notes` as the header. **Format guard:** If the file exists but has no `# Session Notes` header, prepend it. If the last non-empty line is a partial block (unclosed heading, unterminated list), append a blank line before the new entry.
2. Read `/logs/decisions.md` (last 5 lines only — to find the append point). If the file doesn't exist, create it with `# Decision Journal` as the header.
3. Using conversation context and the operator's summary, append a session note to `/logs/session-notes.md` with:
   - `## {date} — {one-line title}` (e.g., "Created supplementary-query-brief-drafter skill")
   - `### Summary` — 2-4 sentences: what was accomplished, what was the focus
   - `### Files Created` — list from conversation context (path + short description)
   - `### Files Modified` — list from conversation context
   - `### Decisions Made` — operator-directed decisions grouped by artifact; QC fixes listed separately
   - `### Next Steps` — what command to run next, any recommended groupings or sequencing
   - `### Open Questions` — blockers or unresolved items; write "None" if clean
4. If operator decisions with analytical or scoping judgment were made, append to `/logs/decisions.md` with: date, context, decision, rationale, alternatives considered. Skip this if all decisions were routine (operator-directed text edits, QC auto-fixes).
5. If the operator didn't mention decisions but significant ones occurred in the session, list them and ask: "Should I log any of these to the decision journal?"
6. **Coaching data capture.** If the operator declined coaching in the preflight, skip this step and note "Coaching capture skipped per preflight" in chat. Otherwise, after writing the session note, auto-append a session profile entry to `/logs/coaching-data.md`. Derive all fields from the session note you just wrote — no extra operator input needed:
   ```
   ### {YYYY-MM-DD} — {session title}
   - **Commands used:** {slash commands triggered this session, from conversation context}
   - **Iterations:** {draft iteration count and section, e.g., "3 (skill-name draft-01 → draft-03)", or "0" if no drafting}
   - **Decisions logged:** {count of decisions appended to decisions.md this session}
   - **QC cycles:** {count and outcome, e.g., "1 (conditional pass → fixes → approved)", or "0"}
   - **Gates:** {count of operator approval/review points this session} ({N} changed) — {comma-separated type:outcome pairs}. Types: plan-approval, content-review, qc-disposition, challenge-disposition, service-design-disposition, bright-line-review, editorial-disagreement, supplementary-research. Outcomes: confirmed (operator approved without changes) or changed (operator directed modification). Derive from conversation: "looks good"/"approved" with no changes = confirmed; operator gave feedback or directed revisions = changed. Omit this line entirely for 0-gate sessions (infrastructure work).
   - **Reflection:** {operator's reflection if provided, otherwise omit this line}
   ```
7. **Innovation triage.** Read `/logs/innovation-registry.md`. For any entries with status `detected`:
   - Present the list: "Innovations detected this session: [list with type and filename]"
   - For each, recommend: `graduate` (useful beyond this project) or `project-specific` (stays local). One line per item.
   - Ask the operator to confirm or override. Accept "looks good" as blanket confirmation.
   - For items marked `graduate`: update registry status to `triaged:graduate` and remind: "Run `/graduate-resource {name}` to move it to ai-resources."
   - For items marked project-specific: update registry status to `triaged:project-specific`.
   - If no `detected` entries exist, skip silently.
   - Also surface any new CLAUDE.md rules added this session (from conversation context) and ask if they should graduate to root CLAUDE.md.
8. **Shared command drift check.** If any `.claude/commands/` files were modified this session, ask: "These shared commands were modified: [list]. Should any changes be synced back to ai-resources or to other projects?" If yes, note the sync action in Next Steps.
9. **Optional reflection.** Before the git commit step, ask: "Session reflection (optional, one line — what felt hard, easy, or surprising):" If Patrik provides one, add it as the `Reflection:` line in the coaching-data entry. If skipped, proceed without it.
10. **Improvement verification and resolved-count check.** Read `/logs/improvement-log.md` (if it exists). Find entries with status "applied" that have no "Verified:" line. If any exist, present: "Unverified improvements: [list with date and title]." Ask: "Verify any, or skip?" If confirmed, append `- **Verified:** {date} — confirmed by operator` to each entry. If skipped, proceed.

    **After verification**, count entries that now have both `**Status:** applied` AND `**Verified:**` lines. If count ≥ 5, append to the wrap summary: "N resolved entries in improvement-log — consider running `/resolve-improvements` to archive them." Below 5: do not mention.
11. **Remind about /improve.** If the session had friction events logged (check `/logs/friction-log.md` for today's entries), suggest: "Friction events were logged this session. Consider running `/improve` to analyze them."
12. **Log archive check.** Run `bash logs/scripts/check-archive.sh`. The script iterates append-only logs (session-notes.md, decisions.md) and archives any file exceeding its threshold by invoking `logs/scripts/split-log.sh` internally. Behavior:
    - Below threshold: silent exit, nothing to do.
    - Archive triggered: script prints `Auto-archived <file> → <archive-file> (archived N entries, kept M)`. Read the printed archive filename and add it to the session note's `### Files Modified` list so it gets staged explicitly in the commit step below.
    - Failure: script prints `ARCHIVE FAILED for <file>` and exits non-zero. Surface the failure to the operator, do NOT attempt to rerun, proceed with the rest of the wrap.

13. **Session telemetry.** If the operator declined telemetry in the preflight, skip this step with a one-line note in chat ("Telemetry skipped per preflight") and proceed to the commit step. Otherwise, run the usage analysis inline before committing. Execute the full `/usage-analysis` flow (build session summary, read existing `logs/usage-log.md` if it exists, delegate to the `session-usage-analyzer` subagent per `ai-resources/skills/session-usage-analyzer/SKILL.md`, write the returned entry to the log). For trivial sessions (single-file edit, one-question read, aborted session), skip with a one-line note in chat ("Telemetry skipped — trivial session") and proceed. Rationale: R14 telemetry baseline depends on consistent capture; inlining the analysis prevents the common failure mode where the operator forgets to invoke it post-wrap and the session drops out of the record.

13a. **Working-tree dirt check.** Run `git status --porcelain` in the current working tree. If empty, skip this step. Otherwise, compare each dirty path against the session note's `Files Created` and `Files Modified` lists. For any dirty path NOT in those lists, capture its mtime (`stat -f "%Sm" -t "%Y-%m-%d" <path>` on macOS) and present once:

    > Working tree has dirty paths not produced this session:
    > - {path} ({modified|untracked}, mtime: {YYYY-MM-DD})
    > - ...
    >
    > Disposition each (one letter per path, in order): (c)ommit with this session, (d)efer as WIP, (i)gnore?

    Apply per-path decisions:
    - **c (commit)** — stage the path explicitly so it lands in the wrap commit; add the path to the session note's `### Files Modified` list (Edit on the note file).
    - **d (defer as WIP)** — leave the path dirty; append `- WIP: {path} (deferred {YYYY-MM-DD})` to the session note's `### Open Questions` section so it surfaces next session.
    - **i (ignore)** — leave the path dirty; do not modify the note. Count these for the end-of-turn summary.

    If any paths were ignored, include in your end-of-turn wrap summary: "{N} dirty path(s) deferred without disposition. Consider `/cleanup-worktree` next session." Skip silently if zero ignored.

    Rationale: catches uncommitted edits and unstaged finished files that survive across sessions — the failure class observed on 2026-04-24 (telemetry-path migration sat in working tree for weeks; improvement-log-archive.md and setup-improvement-scan-2026-04-21.md sat untracked).

After updating logs, writing the telemetry entry, and processing the dirt check, stage and commit changes. **Stage by explicit file paths**, not directory wildcards — directory-level `git add` silently sweeps uncommitted files from concurrent sessions. Enumerate from the Files Created / Files Modified sections just written to the session note, plus always-present wrap-touched files:
- Always-staged (if modified this session): `logs/session-notes.md`, `logs/decisions.md`, `logs/coaching-data.md`, `logs/improvement-log.md`, `logs/improvement-log-archive.md`, `logs/innovation-registry.md`, `logs/usage-log.md`
- Session-specific: every path listed in Files Created / Files Modified for this session, staged by explicit name

Run as two separate commands, not chained:
- `git add <explicit paths>` (enumerate; no trailing `/` wildcards)
- `git commit -m "session: [brief description of session work]"`
