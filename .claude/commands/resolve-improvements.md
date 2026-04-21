---
model: sonnet
---

Archive resolved entries from `ai-resources/logs/improvement-log.md` so stale items stop re-entering context on every log read.

**Confirmation is load-bearing.** The `[y/n/select]` prompt at step 4 is required and must not be stripped by future autonomy optimizations — removing entries from an operator-facing log is a destructive edit to durable content.

## Instructions

1. **Read `ai-resources/logs/improvement-log.md`.** If the file doesn't exist, tell the operator: "No improvement log at `ai-resources/logs/improvement-log.md`. Nothing to do." Stop.

2. **Parse entries.** Entries are header-bounded `### ` blocks. Each block runs from one `### ` line up to (but not including) the next `### ` line or end-of-file.

   **Malformed-entry handling:** Content preceding the first `### ` header, or orphaned content between blocks that does not belong to a preceding block, is left untouched. Do not error, discard, or attempt to re-anchor. If orphaned content exists, count the lines and mention it in the final summary ("Skipped N orphaned lines, no header").

3. **Classify each entry:**
   - **Resolved** — the entry contains both a line starting `**Status:** applied` AND a line starting `**Verified:**`.
   - **Pending** — anything else (missing Status, Status is "logged"/"proposed"/"pending", or "applied" without a Verified line).

4. **Present resolved entries.** If zero resolved entries exist, tell the operator "No resolved entries to archive. Active log has N pending entries." and stop.

   Otherwise, show a numbered list: date and one-line title only, one entry per line. Then ask exactly:

   > Move these N resolved entries to `improvement-log-archive.md`? **[y/n/select]**
   >
   > - `y` — archive all N
   > - `n` — no changes
   > - `select` — I'll list them again; reply with numbers to archive (e.g., "1 3 5")

5. **Wait for the operator's reply.** Do not proceed without explicit input.

6. **Execute based on reply:**

   **On `y`:** Archive all resolved entries (step 7).

   **On `n`:** Report "No changes." Stop.

   **On `select`:** Re-display the numbered list. Ask: "Which to archive? Reply with numbers (e.g., `1 3 5`), or `all` / `none`." Parse the reply. Archive only the selected subset (step 7).

7. **Archive procedure:**

   a. **Open or create** `ai-resources/logs/improvement-log-archive.md`. If missing, create with exactly these first two lines:
      ```
      # Improvement Log — Archive

      ```

   b. **Append** each selected entry verbatim (full content, preserving all markdown) to the archive file, in chronological order (oldest first). If the archive already has entries, insert new ones in chronological position — do not just append if it breaks ordering. Simpler implementation: read archive entries, merge with new ones, sort by the date in the `### YYYY-MM-DD — ...` header, rewrite archive file.

   c. **Remove** the selected entries from active `improvement-log.md`. Use `Edit` with the exact entry text (from start of `### ` line through the line before the next `### ` or EOF). Verify by reading the modified file — the removed entries must no longer appear and no formatting fragments should remain.

   d. **Do not commit.** Staging and commit happen at the operator's next `/wrap-session`. This preserves commit-boundary discipline.

8. **Summarize:**
   ```
   Moved N entries to improvement-log-archive.md.
   Active improvement-log: M pending entries remaining.
   [If orphaned content: Skipped K orphaned lines (no `### ` header) — left in place.]
   ```

$ARGUMENTS
