Wrap the current session. The operator's wrap-up context follows this prompt: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context. Auto-commits track file changes separately.

1. Read `/logs/session-notes.md` (last 5 lines only — to find the append point).
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
