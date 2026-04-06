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

6. Do NOT execute any command or start any work. Wait for operator direction.
