Provide a project status report for {{PROJECT_NAME}}.

1. Scan key project directories for current state:

   {{STATUS_SCAN_DIRS}}

2. Read the last 5 entries from `/logs/qc-log.md` (if it exists).

3. Read the last entry from `/logs/session-notes.md` (if it exists).

4. Determine the current project state based on which directories have content and which milestones have been reached.

5. Present as a compact summary — no more than 20 lines total:
   - Current state
   - Recent activity
   - Next pending step
   - Any open issues or decisions needed
