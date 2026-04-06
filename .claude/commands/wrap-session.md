Wrap the current session. The operator's wrap-up context follows this prompt: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context.

1. Read `/logs/session-notes.md` (last 5 lines only — to find the append point). If the file doesn't exist, create it with `# Session Notes` as the header.
2. Read `/logs/decisions.md` (last 5 lines only — to find the append point). If the file doesn't exist, create it with `# Decision Journal` as the header.
3. Using conversation context and the operator's summary, append a session note to `/logs/session-notes.md` with:
   - `## {date} — {one-line title}` (e.g., "Created supplementary-query-brief-drafter skill")
   - `### Summary` — 2-4 sentences: what was accomplished, what was the focus
   - `### Files Created` — list from conversation context (path + short description)
   - `### Files Modified` — list from conversation context
   - `### Decisions Made` — operator-directed decisions; QC fixes listed separately
   - `### Next Steps` — what to work on next, any pending items
   - `### Open Questions` — blockers or unresolved items; write "None" if clean
4. If operator decisions with analytical or scoping judgment were made, append to `/logs/decisions.md` with: date, context, decision, rationale, alternatives considered. Skip this if all decisions were routine (operator-directed text edits, QC auto-fixes).
5. If the operator didn't mention decisions but significant ones occurred in the session, list them and ask: "Should I log any of these to the decision journal?"
6. **Innovation triage.** Read `/logs/innovation-registry.md`. For any entries with status `detected`:
   - Present the list: "Innovations detected this session: [list with type and filename]"
   - For each, recommend: `graduate` (useful beyond this project — route to `/graduate-resource`) or `project-specific` (stays local). Keep recommendations brief — one line per item.
   - Ask the operator to confirm or override. Accept "looks good" as blanket confirmation.
   - For items marked `graduate`: update the registry entry status to `triaged:graduate`. Note: actual graduation happens via `/graduate-resource` in a separate step.
   - For items marked `project-specific`: update the registry entry status to `triaged:project-specific`.
   - If no `detected` entries exist, skip silently.
7. **CLAUDE.md rule check.** Surface any new CLAUDE.md rules added this session (from conversation context) and ask if they should graduate to root CLAUDE.md.
8. **Remind about /improve.** If the session had friction events logged (check `/logs/friction-log.md` for today's entries), suggest: "Friction events were logged this session. Consider running `/improve` to analyze them."
