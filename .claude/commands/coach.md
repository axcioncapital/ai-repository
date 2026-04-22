---
model: opus
---

Run the collaboration coach to analyze operator-AI collaboration patterns across sessions.

## Instructions

1. **Check for sufficient data.** Read `/logs/session-notes.md` and count session entries (lines starting with `## 20`). If fewer than 5 entries exist, tell the user:
   > Not enough session data for meaningful coaching analysis. Need at least 5 wrapped sessions. Currently have {N}.
   
   Stop here.

2. **Check for prior coaching runs.** Check if `/logs/coaching-log.md` exists. If it does, note the most recent entry date for progression tracking.

3. **Parse focus area.** If `$ARGUMENTS` is non-empty, pass it as the focus area to the agent (e.g., `/coach decision-making` → focus on decision patterns).

4. **Launch the collaboration-coach agent.** Pass it:
   - Focus area (from arguments, or "none — analyze all dimensions equally")
   - Whether coaching-log.md exists (for progression tracking)
   
   The agent reads all log files directly. Do not load or pass log contents from this session.

5. **Present findings to the operator.** Show the full coaching analysis output from the agent.

6. **Persist results.** Append a compact entry to `/logs/coaching-log.md`:

   ```markdown
   ### {YYYY-MM-DD}
   **Coverage:** {N} sessions ({date range})

   | Dimension | Rating | Trend |
   |-----------|--------|-------|
   | Iteration Efficiency | {rating} | {arrow} |
   | Decision Patterns | {rating} | {arrow} |
   | QC Disposition | {rating} | {arrow} |
   | Delegation Effectiveness | {rating} | {arrow} |
   | Workflow Evolution | {rating} | {arrow} |

   **The One Thing:** {recommendation}
   **Prior recommendation status:** {acted on / not acted on / N/A}
   ```

   If the file doesn't exist, create it with `# Coaching Log` as the first line before appending.

7. **Archive maintenance.** If coaching-log.md has 15+ entries, archive older entries to `logs/coaching-log-archive.md` and produce a one-paragraph trend summary at the top of the archive.

$ARGUMENTS