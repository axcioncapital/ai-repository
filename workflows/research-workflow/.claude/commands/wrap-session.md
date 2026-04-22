Wrap the current session. The operator's wrap-up context follows this prompt: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context. Auto-commits track file changes separately. Maintenance scripts invoked by named steps below (e.g., step 7 log-archive check) are permitted.

0. As your first action, run `touch /tmp/claude-wrap-session-done` via Bash. This suppresses the session-end hook's "Session ended without /wrap-session" auto-append while this command runs, preventing a file-modification race on `logs/session-notes.md`. The hook deletes the lockfile after reading it, so no cleanup is needed.
1. Read `/logs/session-notes.md` (last 5 lines only — to find the append point). If the file doesn't exist, create it with `# Session Notes` as the header. **Format guard:** If the file exists but has no `# Session Notes` header, prepend it. If the last non-empty line is a partial block (unclosed heading, unterminated list), append a blank line before the new entry.
2. Read `/logs/decisions.md` (last 5 lines only — to find the append point).
3. Using conversation context and the operator's summary, append a session note to `/logs/session-notes.md` with:
   - `## {date} — {one-line title}` (e.g., "Stage 1 Preparation complete for Section 1.3")
   - `### Summary` — 2-4 sentences: what was accomplished, what stage/step, what state the pipeline is in
   - `### Files Created` — list from conversation context (path + short description)
   - `### Files Modified` — list from conversation context
   - `### Decisions Made` — operator-directed decisions grouped by artifact; QC fixes listed separately
   - `### Next Steps` — what command to run next, any recommended groupings or sequencing
   - `### Open Questions` — blockers or unresolved items; write "None" if clean
4. If operator decisions with analytical or scoping judgment were made, append to `/logs/decisions.md` with: date, context, decision, rationale, alternatives considered. Skip this if all decisions were routine (operator-directed text edits, QC auto-fixes).
5. If the operator didn't mention decisions but significant ones occurred in the session, list them and ask: "Should I log any of these to the decision journal?"
6. **Innovation triage.** Read `/logs/innovation-registry.md`. For any entries with status `detected`:
   - Present the list: "Innovations detected this session: [list with type and filename]"
   - For each, recommend: `graduate` (useful beyond this project) or `project-specific` (stays local). One line per item.
   - Ask the operator to confirm or override. Accept "looks good" as blanket confirmation.
   - For items marked `graduate`: update registry status to `triaged:graduate` and remind: "Run `/graduate-resource {name}` to move it to ai-resources."
   - For items marked project-specific: update registry status to `triaged:project-specific`.
   - If no `detected` entries exist, skip silently.
   - Also surface any new CLAUDE.md rules added this session (from conversation context) and ask if they should graduate to root CLAUDE.md.
7. **Log size check.** Run `bash "$CLAUDE_PROJECT_DIR/logs/scripts/check-archive.sh"`.
   If it prints any lines, report each to the operator: "Auto-archived [file] → [archive path] (kept N entries)."
   If output is empty, proceed silently.
