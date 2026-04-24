---
model: sonnet
---

Diagnose structural Claude Code permission-prompt failure modes across every settings file in the workspace, then (with explicit operator approval) apply remediations. Pairs with `/fewer-permission-prompts` — this command fixes structural causes (defaultMode, glob shape, layer consistency); that command fixes empirical causes discovered in transcripts.

**Scope:** user-level `~/.claude/settings.json`, workspace root, `ai-resources/`, every project under `projects/`, plus workflow-dev settings files. Both `settings.json` and `settings.local.json` at each level.

**Per Autonomy Rules pause-trigger #8:** harness-level permission changes require explicit operator approval. This command never auto-applies — it diagnoses, presents a fix plan, waits for approval, then applies.

Input: `$ARGUMENTS` (optional).

Flags (anywhere in `$ARGUMENTS`):
- `--dry-run` — run diagnosis only; report findings and exit. Used by `/friday-checkup` weekly rotation.
- `--fix-narrow` — include INTENTIONAL-NARROW files in remediation. Default: skip them (they are locked on purpose, e.g., `obsidian-pe-kb/vault`).
- `--skip-user-level` — do not audit `~/.claude/settings.json`. Default: include it.

Examples:
- `/permission-sweep` — diagnose and prompt for remediation.
- `/permission-sweep --dry-run` — diagnose only, no remediation prompt.

---

### Step 1: Path setup

1. Set `WORKSPACE` = Axcíon AI workspace root (ancestor containing `ai-resources/`).
   ```bash
   d="$(pwd)"
   WORKSPACE=""
   while [ "$d" != "/" ]; do
     if [ -d "$d/ai-resources/.claude" ]; then WORKSPACE="$d"; break; fi
     d=$(dirname "$d")
   done
   [ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources/ not found in any ancestor of $(pwd)"; exit 1; }
   ```
2. Set `AI_RESOURCES` = `{WORKSPACE}/ai-resources`.
3. Set `AUDIT_DIR` = `{AI_RESOURCES}/audits`.
4. Set `WORKING_DIR` = `{AUDIT_DIR}/working`. Create if missing (`mkdir -p`).
5. Set `DATE` = today in `YYYY-MM-DD` (`date +%Y-%m-%d`).
6. Set `NOTES_FILENAME` = `permission-sweep-{DATE}.md`.
7. Set `FULL_NOTES_PATH` = `{WORKING_DIR}/{NOTES_FILENAME}`.
8. Set `SUMMARY_PATH` = `{WORKING_DIR}/{NOTES_FILENAME}.summary.md`.
9. Set `FINAL_REPORT_PATH` = `{AUDIT_DIR}/permission-sweep-{DATE}.md`.
10. Set `TEMPLATE_PATH` = `{AI_RESOURCES}/docs/permission-template.md`.
11. Verify `{AI_RESOURCES}/.claude/agents/permission-sweep-auditor.md` exists. Abort if missing.
12. Verify `TEMPLATE_PATH` exists. Abort if missing — the subagent reads it as source of truth.
13. Verify `jq` is on PATH (`command -v jq`). Abort if missing — remediation requires jq.

---

### Step 2: Parse flags

14. From `$ARGUMENTS`, set:
    - `DRY_RUN` = true if `--dry-run` present
    - `FIX_NARROW` = true if `--fix-narrow` present
    - `SKIP_USER_LEVEL` = true if `--skip-user-level` present
    - `INCLUDE_USER_LEVEL` = `!SKIP_USER_LEVEL` (default true)

---

### Step 3: Spawn the auditor subagent

15. Emit `[HEAVY]` one-line note: "spawning permission-sweep-auditor to scan settings files across workspace."

16. Spawn one `permission-sweep-auditor` subagent. Pass these inputs:
    - `WORKSPACE_ROOT` = `{WORKSPACE}`
    - `INCLUDE_USER_LEVEL` = `{INCLUDE_USER_LEVEL}` (`"true"` or `"false"`)
    - `WORKING_DIR` = `{WORKING_DIR}`
    - `NOTES_FILENAME` = `{NOTES_FILENAME}`
    - `TEMPLATE_PATH` = `{TEMPLATE_PATH}`

17. Wait for the subagent's return message. Expected shape:
    ```
    Permission sweep complete. Scanned N files.
    Findings: X critical, Y high, Z medium, W advisory, K intentional-narrow.
    Summary: {absolute path}
    Full notes: {absolute path}
    ```

18. If the return message does not contain both `Summary:` and `Full notes:` paths, re-invoke the subagent once with the same inputs. If it still fails, abort with a loud error naming the malformed return.

---

### Step 4: Read the summary (not the full notes)

19. Read `{SUMMARY_PATH}` into main session. The summary is capped at 30 lines per Subagent Contract. Do NOT read the full notes unless a specific finding needs deeper review during presentation.

---

### Step 5: Build the plain-language report

20. From the summary, extract per-severity counts and the top-3 critical findings. From the full-notes file, extract the full list of CRITICAL and HIGH findings (needed for the fix plan). Read the full notes ONCE here — do not re-read throughout the command.

21. Group findings by file. For each file with ≥1 finding, translate the raw findings into a plain-language entry:

    - **File:** show path relative to workspace root (not absolute).
    - **Plain-language cause:** one sentence per rule triggered. Use the template's canonical-value column to phrase the fix.
    - **Proposed change:** summarize as "add X" / "remove Y" / "change Z from {old} to {new}". Do NOT show JSON yet — keep the main report human-readable.

    Mapping of rules to plain-language phrasing (use these canonical phrasings):

    | Rule | Plain-language cause |
    |------|----------------------|
    | 1 | "Local-override file is missing the 'skip permission prompts' setting, which disables it globally for this project." |
    | 2 | "This project's settings file does not say 'skip permission prompts'. Claude falls back to asking by default." |
    | 3 | "Broad allow rule does not cover nested `.claude/` folders (glob quirk). Edits inside nested `.claude/` still prompt." |
    | 4 | "Scoped allow patterns without a bare `Edit`/`Write` fallback. Some absolute-path edits still prompt." |
    | 5 | "Narrow bash allowlist (only specific commands). Any new bash command will prompt." |
    | 6 | "No allow for narrow `rm`. Delete/Remove operations prompt." |
    | 7 | "A deny rule overlaps with an allow rule — may be intentional, flagging for your review." |
    | 8 | "Missing or stale `additionalDirectories`. ai-resources symlinks may not resolve." |
    | 9 | "Absolute-path allow entry points to a path that no longer exists." |
    | 10 | "MCP tools (e.g., Google Drive) are not in any allowlist." |
    | 11 | "User-level settings differ from workspace settings on a critical rule." |
    | 12 | "`settings.local.json` is tracked in git — it should be gitignored." |
    | 13 | "Typo / duplicate entry / inconsistent syntax form." |

22. Render the chat report:

    ```
    /permission-sweep — report

    Scanned {N} settings files across your workspace.

    Findings:
      {X} CRITICAL — these are why Claude keeps asking for permission
      {Y} HIGH     — gaps that will cause future prompts
      {Z} MEDIUM   — coverage improvements
      {W} ADVISORY — hygiene
      {K} INTENTIONAL — narrow permissions set on purpose (leaving alone unless --fix-narrow)

    What's causing the Edit/Delete prompts right now:

    {Numbered list of CRITICAL findings, grouped by file:}

     1. {relative path}
        — {plain-language cause}
        Fix: {plain-language proposed change}

     2. ...

    Other gaps (won't cause prompts today, but will eventually):
    {HIGH findings, grouped by file, one line each}

    Coverage improvements:
    {MEDIUM findings, one line each}

    Intentionally narrow — not touching:
    {INTENTIONAL-NARROW files, one line each}

    Next step:
      Type 'apply all' to fix everything,
      'apply {numbers}' to fix specific critical findings (e.g., 'apply 1,2'),
      'show details' to see the exact JSON changes,
      or 'skip' to exit without applying.

    Full notes: {FULL_NOTES_PATH}
    ```

---

### Step 6: Dry-run exit

23. If `DRY_RUN` is true:
    - Copy the in-memory report to `{FINAL_REPORT_PATH}` (so `/friday-checkup` can read it).
    - Print the report to chat.
    - Print: "Dry-run complete. Run `/permission-sweep` without `--dry-run` to remediate."
    - Exit. Do not proceed to Step 7.

---

### Step 7: Approval gate (pause-trigger #8)

24. Print the report to chat. Wait for operator response.

25. Parse operator response:
    - `apply all` → set `APPROVED_FINDINGS` = all CRITICAL + HIGH findings (exclude INTENTIONAL-NARROW unless `FIX_NARROW` is true; exclude MEDIUM/ADVISORY by default).
    - `apply N` or `apply N,M,P` → set `APPROVED_FINDINGS` = only the CRITICAL findings with those numbers.
    - `apply all including medium` → include MEDIUM. Advisory still excluded.
    - `show details` → print the exact JSON diff for each finding (use `jq` to render before/after snippets). Return to Step 7 approval prompt.
    - `skip` → exit without changes. Print "No changes applied."
    - Anything else → treat as ambiguous. Ask: "Not sure what you meant. Type 'apply all', 'apply N,M', 'show details', or 'skip'." Return to Step 7.

26. If `FIX_NARROW` is false AND `APPROVED_FINDINGS` contains any INTENTIONAL-NARROW entry, strip it from the list and emit: "Skipped {N} INTENTIONAL-NARROW findings. Re-run with `--fix-narrow` if you want to include them."

---

### Step 8: Apply approved fixes via jq

27. For each file in `APPROVED_FINDINGS`, group findings by file (so each file is edited once, not N times).

28. For each file, construct a jq merge that applies all approved findings for that file. Use idempotent patterns — every merge should be safe to re-run.

    **Common merge idioms** (compose as needed per finding):

    **Add `defaultMode`** (rules 1, 2):
    ```bash
    jq '.permissions.defaultMode = "bypassPermissions"' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    ```

    **Add allow entries** (rules 3, 4, 5, 6, 10) — idempotent via `unique`:
    ```bash
    jq --argjson adds '["Edit(**/.claude/**)","Write(**/.claude/**)","Bash(*)","Bash(rm *)"]' '
      .permissions.allow = ((.permissions.allow // []) + $adds | unique)
    ' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    ```
    Pass only the entries the rules actually fired on — don't blanket-add.

    **Add `additionalDirectories`** (rule 8):
    ```bash
    jq --arg dir "$WORKSPACE" '
      .permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + [$dir] | unique)
    ' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    ```

    **Strip permissions from `settings.local.json`** (rule 1 alternative) — only if operator approved the "omit" remediation path specifically:
    ```bash
    jq 'del(.permissions)' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    ```
    Default remediation for rule 1 is to ADD `defaultMode`, not strip — preserves any other permissions keys the operator has set.

    **Remove stale absolute-path entries** (rule 9):
    ```bash
    jq --arg stale "$STALE_PATH" '
      .permissions.allow = (.permissions.allow // [] | map(select(contains($stale) | not)))
    ' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    ```

    **Remove duplicate/typo entries** (rule 13):
    ```bash
    jq '.permissions.allow = (.permissions.allow // [] | unique)' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    ```

29. Before writing, validate the final JSON parses:
    ```bash
    jq '.' "$FILE.tmp" > /dev/null || { echo "ERROR: merge produced invalid JSON for $FILE"; rm "$FILE.tmp"; continue; }
    ```

30. After each file, Read the file back and verify that the expected keys now match the canonical template. Record the before/after line count in a running `APPLIED_LIST`.

---

### Step 9: Present confirmation

31. Print in chat:
    ```
    Applied:
    {For each file in APPLIED_LIST:}
      ✓ {relative path}  ({+N lines / -M lines})

    Skipped:
    {Any INTENTIONAL-NARROW stripped or ambiguous findings, one per line}

    Done. Start a new Claude session to pick up the changes.
    (Settings load at session start, not per-turn — your current session still
    has the old permissions cached.)

    Final report: {FINAL_REPORT_PATH}
    ```

32. "Start a new Claude session" is load-bearing — the current session still operates under the cached permissions. Do not omit this line.

---

### Step 10: Write the final report

33. Write `{FINAL_REPORT_PATH}` with this structure:

    ```markdown
    # Permission Sweep Report — {DATE}

    ## Summary

    - Scanned {N} settings files.
    - Findings: {X} CRITICAL, {Y} HIGH, {Z} MEDIUM, {W} ADVISORY, {K} INTENTIONAL-NARROW.
    - Applied: {count}. Deferred: {count}. Skipped INTENTIONAL-NARROW: {count}.

    ## Findings applied

    | # | File | Rule | Severity | Change |
    |---|------|------|----------|--------|
    | 1 | {path} | {rule N} | CRITICAL | {one-line change summary} |
    | ... | | | | |

    ## Findings deferred (not approved this run)

    | File | Rule | Severity | Reason |
    |------|------|----------|--------|
    | ... | ... | ... | not in approval list |

    ## Intentional-narrow files (excluded)

    - {path}

    ## Full diagnostic notes

    {FULL_NOTES_PATH}

    ## Prevention

    - SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start.
    - `/new-project` pipeline emits the canonical template for every new project.
    - `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
    ```

---

### Step 11: Do not commit

34. **Do NOT commit.** All changes land unstaged. The operator reviews and commits at session wrap per workspace `Commit behavior` rules (handles concurrent-session staging enumeration correctly).

35. Remind the operator at the end of the chat output:
    > "Review the changes and commit at session wrap (`/wrap-session`). Start a new Claude session to pick up the new permissions."

---

### Notes

- **This command does not invoke `/update-config`.** Nested permission-prompt loops defeat the purpose. The jq merge idioms above mirror `/update-config`'s discipline but run in-command.
- **This command does not duplicate `/fewer-permission-prompts`.** That skill scans transcripts for empirical denials. Run it after `/permission-sweep` if specific tool calls still prompt.
- **Failure handling:** if any jq merge fails for a file, record it in APPLIED_LIST with `✗ {path} — {error}` and continue to the next file. Do not abort the whole run.
- **Idempotence:** every merge uses `unique` or set-style operations. Re-running the command immediately after applying should report 0 new findings on the fixed files.
- **Subagent contract compliance:** the auditor writes full notes to disk and returns a ≤30-line summary. Main session reads the summary; the full notes are only read once during Step 5 fix-plan construction.
