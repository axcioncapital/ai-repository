---
model: sonnet
---

Log a friction event or start a new friction log session.

## Usage
- `/friction-log start` — Initialize a new session block in the friction log
- `/friction-log [description]` — Append a friction entry to the current session block

## Instructions

1. Parse $ARGUMENTS:
   - If the first word is "start", go to step 2 (start a session block)
   - If $ARGUMENTS is empty, show the usage lines above and stop
   - Otherwise, go to step 3 (append a friction entry)

2. **Start a session block:**
   - Read `/logs/friction-log.md` (last 5 lines to find the append point). If the file doesn't exist, create it with `# Friction Log` as the first line.
   - Append a new session block:
     ```
     ## Session — {YYYY-MM-DD HH:MM}

     ### Friction Events

     #### Write Activity
     ```
   - Confirm: "Friction log session started."
   - Stop.

3. **Append a friction entry:**
   - Read `/logs/friction-log.md` (last 30 lines to find the current session's Friction Events section).
   - If no `### Friction Events` section exists, run step 2 first to create a session block, then continue.
   - Append under the most recent `### Friction Events` heading (before `#### Write Activity`):
     ```
     - **{HH:MM}** — {description from $ARGUMENTS}
     ```
   - Confirm with a one-line acknowledgment. Do NOT ask clarifying questions — log exactly what the user typed.

$ARGUMENTS