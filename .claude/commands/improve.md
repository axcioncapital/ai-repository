Run the improvement analyst to review this session's friction and suggest workflow improvements.

## Instructions

1. **Check for friction data.** Read `/logs/friction-log.md`. If the file doesn't exist or contains no `### Friction Events` entries, tell the user:
   > No friction log found. Use `/friction-log start` at the beginning of a session, then `/friction-log [description]` to log friction events during the session. Run `/improve` at session end.
   
   Stop here.

2. **Launch the `improvement-analyst` subagent.** Pass it only:
   - The path to `/logs/friction-log.md`
   - The path to `/logs/improvement-log.md` (or note that it doesn't exist)
   - The project root path
   
   The agent reads log contents, CLAUDE.md, settings.json, commands, and hooks independently. Do NOT pass log contents inline or conversation history — the agent gathers its own context for independent analysis.

3. **Present findings to the operator.** Show the ranked findings from the analyst. For each finding, offer three actions:
   - **Apply** — implement the proposed change now
   - **Log** — save the suggestion to the improvement log for future implementation
   - **Dismiss** — acknowledge and skip

4. **Wait for direction.** The operator will respond with actions per finding, e.g.:
   - "apply 1, 3" or "apply all"
   - "log 2"
   - "dismiss 4, 5" or "dismiss the rest"

5. **Execute actions:**

   **For each "apply" item:**
   - Show the exact change that will be made (file path + content)
   - Wait for operator confirmation before making the change
   - Execute the change (create file, modify config, add rule)
   - Append to `/logs/improvement-log.md`:
     ```
     ### {YYYY-MM-DD} — {finding title}
     - **Status:** applied
     - **Category:** {category}
     - **Friction source:** {which friction entry triggered this}
     - **What changed:** {description of what was created or modified}
     ```

   **For each "log" item:**
   - Append to `/logs/improvement-log.md`:
     ```
     ### {YYYY-MM-DD} — {finding title}
     - **Status:** logged (pending)
     - **Category:** {category}
     - **Friction source:** {which friction entry triggered this}
     - **Proposal:** {the full proposal text from the analyst}
     ```

   **For dismissed items:** no action.

6. **Create improvement log if needed.** If `/logs/improvement-log.md` doesn't exist and any items are being applied or logged, create it with `# Improvement Log` as the first line before appending entries.

7. **Summarize.** One-line summary of what was applied, logged, and dismissed.

$ARGUMENTS