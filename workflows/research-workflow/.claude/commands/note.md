The user wants to log a workflow observation. Their note follows this prompt.

## Routing

Parse $ARGUMENTS for a prefix:
- If $ARGUMENTS starts with "friction:" (case-insensitive), strip the prefix and route to the friction log (see Step A below).
- Otherwise, route to the workflow observations log (see Step B below).

## Step A: Friction routing

1. Read `/logs/friction-log.md` (last 30 lines). If the file doesn't exist, create it with:
   ```
   # Friction Log
   
   ### Session: {YYYY-MM-DD HH:MM} — Manual entry
   #### Friction Events
   ```
2. If no `#### Friction Events` section exists in the last 30 lines, append a new session block with the header above.
3. Append the friction entry under the most recent `#### Friction Events` heading:
   ```
   - **{HH:MM}** — {text after "friction:" prefix}
   ```
4. Confirm: "Friction event logged."

## Step B: Workflow observation routing

1. Append the note to /logs/workflow-observations.md
2. Add a timestamp and the current session context (which phase, which section)
3. If the file doesn't exist, create it with a header: "# Workflow Observations"
4. Confirm the note was added with a one-line summary

$ARGUMENTS
