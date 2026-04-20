Orient the session. Read state, brief the operator, wait for direction.

1. Read the last entry from `/logs/session-notes.md`. Extract: date, summary, next steps, open questions.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

2. Read `/logs/innovation-registry.md`. The registry is a pipe-delimited markdown table with columns
   `| Date | Type | File | Status | Graduated To |`. Count data rows whose Status column equals
   exactly `detected` (do NOT count `triaged:*`, `graduated`, or other statuses). Use pattern
   `^\|[^|]*\|[^|]*\|[^|]*\| detected \|` or parse the Status column directly. Do not grep for
   list-item / YAML / JSON patterns — they do not match this table format.
   If the file doesn't exist, report 0.

3. Check `/inbox/` for pending skill request briefs. Count files excluding `.gitkeep`.
   If the directory is empty or doesn't exist, report 0.

4. Read `/logs/decisions.md`. Extract the 3 most recent entries.
   If the file doesn't exist or is empty, note "No decisions logged yet" and continue.

4a. If the environment's git-status snapshot is non-empty (shows modified or untracked files), run
    `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env
    snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files
    already committed in the prior session). Use the live result, not the snapshot, when reporting
    working-tree state or next steps. This is a Prime-time orientation check, distinct from the
    commit-time "no pre-commit git status" rule.

5. Output this and nothing else:

```
## Prime — {date}

**Last session:** {date} — {one-line summary}

**Inbox:** {N} skill request(s) pending
**Innovations:** {N} detected, pending triage
**Recent decisions:** {list or "None"}
**Working tree:** {clean | list of live-verified changes from step 4a}

**Next steps (from last session):**
{bulleted list from session notes}

**Open questions:** {list or "None"}
```

6. After the status block, ask **"What are we working on?"** and wait for the operator's answer.

7. Once the operator has named the work, log a new session entry header to `/logs/session-notes.md` containing the date and the work description. If the operator states a scope boundary inline (e.g., "just the refactor, not the follow-up PRs"), capture it in the header too; otherwise omit.

8. Begin execution immediately under full autonomy (per workspace CLAUDE.md Autonomy Rules). No second "go/proceed" confirmation required.
