Start a new work session for {{PROJECT_NAME}}.

1. Read `/logs/session-notes.md` for where we left off last session.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

2. Scan the project to check current state:

   {{STATUS_SCAN_DIRS}}

3. Read `/logs/decisions.md` and note the 3 most recent decisions.
   If the file doesn't exist or is empty, note "No decisions logged yet" and continue.

4. Present a brief status summary:
   - Where we left off (or "First session" if no session notes exist)
   {{STATUS_SUMMARY_BULLETS}}
   - Recent decisions that may affect today's work

5. Ask what {{OPERATOR_NAME}} wants to work on today.

Do NOT start any content work until {{OPERATOR_NAME}} gives direction.
