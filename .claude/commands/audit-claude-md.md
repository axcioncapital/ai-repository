Audit the always-loaded CLAUDE.md files for token cost, redundancy, contradiction, staleness, misplacement, and clarity. Produces a findings report saved to `ai-resources/audits/`. Diagnostic-only — the command does not edit CLAUDE.md. Edits happen in a separate operator-directed turn after review.

Input: $ARGUMENTS (optional) — scope selector:
- empty → audit both the workspace CLAUDE.md and the current working directory's project CLAUDE.md
- `workspace` → audit the workspace CLAUDE.md only
- `project <name>` → audit the workspace CLAUDE.md plus `{WORKSPACE}/projects/<name>/CLAUDE.md`

Priority ordering (operator-set, do not vary):
1. Token cost per turn
2. Cross-file redundancy
3. Contradictions
4. Staleness
5. Misplacement
6. Clarity

---

### Step 1: Scope Resolution

1. Set `WORKSPACE` to the Axcíon AI workspace root (parent of `ai-resources/`).
2. Set `WORKSPACE_CLAUDE_MD` = `{WORKSPACE}/CLAUDE.md`. Verify it exists; abort if missing: "Workspace CLAUDE.md not found at {path}. Aborting."
3. Parse $ARGUMENTS:
   - empty → derive project root by walking up from the current working directory until a `CLAUDE.md` is found inside a `projects/<name>/` path. Set `PROJECT_CLAUDE_MD` to that path. If not found, set `PROJECT_CLAUDE_MD` = "none", **emit a chat message: "Project CLAUDE.md not detected from cwd — auditing workspace only. Use `project <name>` to target a specific project."**, and continue with workspace-only scope. Set `SCOPE_SLUG` from the project name (e.g., `project-buy-side-service-plan`) or `workspace-only` if no project. Set `SCOPE_LABEL` = "workspace + {project-name}" or "workspace only".
   - `workspace` → `PROJECT_CLAUDE_MD` = "none". `SCOPE_SLUG` = `workspace-only`. `SCOPE_LABEL` = "workspace CLAUDE.md only".
   - `project <name>` → `PROJECT_CLAUDE_MD` = `{WORKSPACE}/projects/<name>/CLAUDE.md`. Verify it exists; abort if missing. `SCOPE_SLUG` = `project-<name>`. `SCOPE_LABEL` = "workspace + projects/<name>".

---

### Step 2: Path Setup

4. Set `AUDIT_DIR` = `{WORKSPACE}/ai-resources/audits/`.
5. Set `WORKING_DIR` = `{AUDIT_DIR}/working/`. Create it if missing (`mkdir -p`).
6. Set `REPORT_PATH` = `{AUDIT_DIR}/claude-md-audit-YYYY-MM-DD-{SCOPE_SLUG}.md` (or without the scope suffix if `SCOPE_SLUG` is empty).
7. Set `GUIDANCE_PATH` = `{WORKING_DIR}/audit-claude-md-external-guidance-YYYY-MM-DD.md`.
8. Set `NOTES_PATH` = `{WORKING_DIR}/audit-claude-md-working-notes-YYYY-MM-DD.md`.
9. Verify the subagent file exists: `{WORKSPACE}/ai-resources/.claude/agents/claude-md-auditor.md`. Abort if missing.

---

### Step 3: Fetch Fresh External Guidance

10. Run WebSearch queries to collect current guidance on CLAUDE.md anti-patterns and best practices. Cap at **6 searches**; stop earlier if results converge. Seed queries (adapt as needed):
    - `CLAUDE.md best practices Claude Code`
    - `CLAUDE.md anti-patterns token cost`
    - `Claude Code memory file guidance 2026`
    - `Claude Opus 4.7 CLAUDE.md context loading`
    - `Claude Code CLAUDE.md too long redundant`
    - `Anthropic Claude Code memory system file`
11. For each search result that looks authoritative (Anthropic docs, Claude Code repo, engineering-org posts), consider fetching the full page via WebFetch. Cap at **3 fetches** total to keep the synthesis bounded.
12. Write a short synthesis to `GUIDANCE_PATH` with this structure:
    - `## Sources consulted` (bullet list: title, URL, date if visible)
    - `## Identified anti-patterns` (bullet list: pattern, why it costs, severity hint)
    - `## Identified best practices` (bullet list: practice, rationale)
    - `## Notes specific to Opus 4.7 / long-context models` (if any)
    Target: 40–80 lines. Do not copy-paste large passages; synthesize.
13. **If WebSearch is unavailable or all queries fail**, write a one-line note in `GUIDANCE_PATH`: "External guidance fetch failed — audit proceeds on priors only. Guidance-derived citations are OMITTED from the findings report." Do not abort.

---

### Step 4: Measure Both Files

14. For each of `WORKSPACE_CLAUDE_MD` and `PROJECT_CLAUDE_MD` (skip the latter if "none"):
    - Line count: `wc -l`
    - Word count: `wc -w`
    - Approx token count: word count × 1.3 (note the ±30% drift caveat in the report)
    - H2 section count: `grep -c "^## "`
    - H3 section count: `grep -c "^### "`
    - `@`-reference count: `grep -cE "@[A-Za-z0-9/._-]+\.md"`
15. Record measurements, the list of `@`-referenced files, and both files' H2 headings into `NOTES_PATH` under headings `## Workspace CLAUDE.md measurements` and `## Project CLAUDE.md measurements` (omit the project section if scope is workspace-only).

---

### Step 5: Delegate Deep Audit to `claude-md-auditor` Subagent

16. Read the full content of `WORKSPACE_CLAUDE_MD` and, if scope includes it, `PROJECT_CLAUDE_MD` into main-session context.
17. Launch the `claude-md-auditor` subagent with:
    - `WORKSPACE_CLAUDE_MD_CONTENT` — the full text of the workspace CLAUDE.md (passed as content, not path, per Context Isolation Rule)
    - `PROJECT_CLAUDE_MD_CONTENT` — the full text of the project CLAUDE.md, or "none" if scope is workspace-only
    - `WORKSPACE_CLAUDE_MD_PATH` — the absolute path (for citation in the report only)
    - `PROJECT_CLAUDE_MD_PATH` — the absolute path or "none"
    - `GUIDANCE_PATH` — path to the external-guidance synthesis (the subagent may read this file)
    - `NOTES_PATH` — path to the measurements file (the subagent may read this)
    - `PRIORITY_ORDER` — the verbatim 6-tier priority list from the command header
    - `REPORT_PATH` — the output path for the findings report
18. The subagent writes `REPORT_PATH` directly and returns only a short confirmation string plus the report path.

---

### Step 6: Verify Report

19. Read `REPORT_PATH` back and confirm:
    - Executive summary section present
    - Per-file inventory section present for each in-scope file
    - All six priority tiers present as headings (Tier 1 through Tier 6)
    - A per-block verdict table is present with columns: block · file · est. tokens · verdict · rationale · move-target · source
    - **The table row count is ≥ the total rule-block count recorded in the per-file inventory** (confirms every block is listed, not just a sampled subset)
    - Estimated-savings section present (per-turn and per-session projection)
    - Every HIGH-severity finding cites a specific rule block by its heading text
20. If verification fails on any item, flag the failure in chat and leave the report for manual inspection. Do not retry silently.

---

### Step 7: Commit

21. Stage **only** `REPORT_PATH`. Do NOT run `git add {WORKING_DIR}` or any directory wildcard — the `working/` synthesis and notes files are transient and must not be committed.
22. Count total findings in the report (HIGH + MEDIUM + LOW across all tiers).
23. Commit with message:
    - `audit: claude-md-audit — YYYY-MM-DD [{SCOPE_LABEL}, N findings, ~T tokens/turn savings]`
    - Example: `audit: claude-md-audit — 2026-04-20 [workspace + buy-side-service-plan, 18 findings, ~1200 tokens/turn savings]`
24. Do NOT push. Pushing remains a manual operator step.

---

### Step 8: Present Summary to Operator

25. Display:
    - Path to the report
    - `SCOPE_LABEL`
    - Finding count by severity (HIGH / MEDIUM / LOW)
    - Top 10 findings — one line each, grouped by tier, showing: rule-block name · file (workspace/project) · verdict · one-phrase rationale
    - Total projected token savings per turn (and a rough per-session figure at 30 and 50 turns)
    - Reminder: "Edits happen in a separate turn. To apply, say which blocks to Keep/Trim/Move/Delete and the Bright-Line Rule governs each change."
26. Remind the operator to push the commit and to run `/wrap-session` when the work is complete.
