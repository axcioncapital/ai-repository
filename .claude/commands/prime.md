Orient the session. Read state, brief the operator, wait for direction.

1. Read the last entry from `/logs/session-notes.md`. Extract: date, summary, next steps, open questions.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

2. Read `/logs/innovation-registry.md`. Count items with `detected` status (pending triage).
   If the file doesn't exist, report 0.

3. Check `/inbox/` for pending skill request briefs. Count files excluding `.gitkeep`.
   If the directory is empty or doesn't exist, report 0.

4. Read `/logs/decisions.md`. Extract the 3 most recent entries.
   If the file doesn't exist or is empty, note "No decisions logged yet" and continue.

5. Output this and nothing else:

```
## Prime — {date}

**Last session:** {date} — {one-line summary}

**Inbox:** {N} skill request(s) pending
**Innovations:** {N} detected, pending triage
**Recent decisions:** {list or "None"}

**Next steps (from last session):**
{bulleted list from session notes}

**Open questions:** {list or "None"}
```

6. After the status block, ask **"What are we working on?"** and wait for the operator's answer.

7. Once the operator has named the work, generate an **exit-condition question with three options (A/B/C)** calibrated to the actual scope of that work. This is unconditional — always ask, even for small tasks. The floor cost is one line ("A, go"); the ceiling cost of skipping is a drifting session.

   Rules for generating the options:
   - Read the scope implied by the operator's answer and the status block (stage, section, remaining work if resumed mid-stage).
   - Estimate realistic effort — word counts, number of artifacts, QC layers involved.
   - Produce three options that represent **genuinely different stopping points**, not three flavors of the same plan. A typical shape:
     - **A** — Full end-to-end in one shot, high autonomy (fastest, highest risk of drift)
     - **B** — Through a natural checkpoint (e.g., all drafts complete, pre-integration), pause for review
     - **C** — Smaller calibration slice first (plan + first 1–2 units), then continue after feedback
   - Adjust the shape if the work doesn't fit this mold — the point is three distinct exit points, not a fixed template.
   - Name the trade-off for each option in one line (e.g., "ambitious, ~Xk words, highest drift risk").
   - If the session is resumed mid-stage, scope the options to **remaining** work, not the full stage.

   Format:
   > **One genuine question: Exit condition.** {one-sentence framing of why the scope matters}
   >
   > **A:** {option} — {trade-off}
   > **B:** {option} — {trade-off}
   > **C:** {option} — {trade-off}

8. When the operator picks an option, log the choice to `/logs/session-notes.md` as a new session entry header (date, work description, chosen exit condition, autonomy implied). Hold to it throughout the session. If scope shifts mid-session, flag that the exit condition may need updating.

9. Do NOT execute any command or start any work. Wait for operator direction after the exit condition is set.
