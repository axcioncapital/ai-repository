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

3b. **Identify and surface stale-pending entries.** From the Pending set, flag any entry whose `### YYYY-MM-DD` header date is > 6 weeks ago (42 days; configurable by operator instruction at invocation). Compute age: extract the date from the `### ` header line, then `python3 -c "from datetime import date; print((date.today() - date.fromisoformat('ENTRY_DATE')).days)"`. Call this set `STALE_PENDING`.

   - Skip age-checking for entries with no parseable `### YYYY-MM-DD` header; count them as Pending only.
   - Entries with a `**Review-cycle:**` line are still flagged if the header date is > 42 days — include the Review-cycle value in the display so the operator sees the prior disposition.

   If `STALE_PENDING` is empty, proceed silently to step 4.

   If non-empty, display:
   ```
   {N} stale-pending entries (>42 days without resolution):
     1. {date} — {title} — {age} days{  ·  last review: {Review-cycle value} if present}
     2. …

   Disposition each (one letter per item, in order):
     (r)eview-cycle — update Review-cycle field with new text (prompts for text)
     (e)scalate     — mark active; sets Status: pending (escalated YYYY-MM-DD)
     (c)lose        — mark closed; sets Status: closed YYYY-MM-DD (stays in active log)
     (k)eep         — no change
   ```

   Wait for the operator's per-item disposition string (characters `{r,e,c,k}`). Re-prompt on mismatch.

   Apply dispositions via `Edit` against the active improvement-log before proceeding to step 4:
   - `r` → prompt `New Review-cycle text for "{title}" (e.g., "reviewed 2026-04-25, defer to Q3"):` and set/update the `**Review-cycle:**` line in the entry.
   - `e` → set `**Status:** pending (escalated {TODAY})`.
   - `c` → set `**Status:** closed {TODAY}`.
   - `k` → no edit.

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
   Stale-pending surfaced: {S} entries ({D} dispositioned, {K} kept as-is). [Omit line if STALE_PENDING was empty.]
   [If orphaned content: Skipped K orphaned lines (no `### ` header) — left in place.]
   ```

$ARGUMENTS
