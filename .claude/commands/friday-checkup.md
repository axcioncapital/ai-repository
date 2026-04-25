# /friday-checkup — Weekly Maintenance Cadence

Run a tiered Friday maintenance cadence against `ai-resources/`, the workspace root, and operator-selected active projects. Produces a single consolidated review-only report under `ai-resources/audits/`. No auto-fix; findings direct next week's work.

Input: `$ARGUMENTS` (optional) — `weekly` | `monthly` | `quarterly` to override auto-detected tier.

---

### Step 1: Detect Tier

1. Compute date fields with Bash:
   ```bash
   TODAY=$(date +%Y-%m-%d)
   DOW=$(date +%u)        # 5 = Friday
   DAY=$(date +%d)
   MONTH=$(date +%m)
   ```
2. Determine the auto-detected tier:
   - **quarterly** = `DOW=5` AND `DAY ≤ 7` AND `MONTH ∈ {01,04,07,10}`
   - **monthly** = `DOW=5` AND `DAY ≤ 7`
   - **weekly** = `DOW=5`
   - **off-schedule** = any other day
3. If `$ARGUMENTS` is `weekly`, `monthly`, or `quarterly`, set `TIER` to that override. Otherwise use the auto-detected tier.
4. If off-schedule and no override, ask the operator: "Today is not a Friday. Run `/friday-checkup` anyway? (y/n, or specify `weekly`|`monthly`|`quarterly`)". Wait for response before proceeding.

---

### Step 2: Confirm Tier and Checks

5. Display the tier plus the auto-run checks that tier will perform:
   ```
   Tier: {TIER}  ({auto-detected | operator-override})

   Auto-run checks:
     Weekly:  /audit-repo, /improve, /coach (if ≥5 sessions), /permission-sweep --dry-run
     Monthly: + /audit-claude-md, /token-audit
     Quarterly: (same auto-run as monthly)

   {If TIER=quarterly:}
   Follow-up checklist (surfaced in report, NOT auto-run):
     /repo-dd deep per scope
     /analyze-workflow per workflow under workflows/
   ```
6. Ask: "Proceed with this tier? (y / n / `weekly` / `monthly` / `quarterly`)". Wait for reply. Treat `y` as confirm; a tier name re-sets `TIER`.

---

### Step 3: Scope Selection

7. Enumerate project directories under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/`:
   ```bash
   ls -1d /Users/patrik.lindeberg/Claude\ Code/Axcion\ AI\ Repo/projects/*/ 2>/dev/null
   ```
   Store as ordered list.
8. Present numbered menu:
   ```
   Scopes:
     1. ai-resources           (always — cannot be deselected)
     2. workspace root         (workspace CLAUDE.md audit only)
     3a. {project-name-1}
     3b. {project-name-2}
     ...
   ```
9. Ask: "Select active projects (comma-separated letters like `3a,3c`, or `none`, or `all`):". Parse the reply into `ACTIVE_PROJECTS`.
10. Build `ACTIVE_SCOPES` as a list of `(scope_label, scope_slug, scope_path, is_project)` tuples:
    - `("ai-resources", "ai-resources", "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources", false)`
    - `("workspace", "workspace", "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo", false)`
    - For each selected project: `("project {name}", "project-{name}", "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/{name}", true)`

---

### Step 4: Runtime Estimate

11. Compute rough runtime estimate using these per-check ceilings:
    - `/audit-repo` = 1 min per scope (ai-resources + active projects; skip workspace)
    - `/improve` = 5 min per scope
    - `/coach` = 15 min per scope (skipped ones count 0)
    - `/permission-sweep --dry-run` = 2 min per scope (ai-resources + workspace + active projects)
    - `/audit-claude-md` = 10 min per scope (workspace + active projects)
    - `/token-audit` = 30 min per scope (ai-resources + workspace + active projects)
12. Display the estimate: `"Estimated runtime: ~{N} min"`.
13. If estimate > 45 min, require the operator to type the exact phrase `proceed with long run` before continuing. Any other response aborts.

---

### Step 5: Run Auto-Run Checks

Run the checks below in sequence (not in parallel — avoid context contention). For each sub-command invocation: use the Skill tool with the slash-command name and the argument shown. Between scopes, `cd` to the scope's path first. After each check, record the produced report path(s) in a running `RESULTS` list.

Skip any scope that cannot support a check (e.g. `/audit-repo` on workspace root — no repo-health-analyzer skill deployed there). Note the skip with reason in `RESULTS`.

**A. `/audit-repo` — all tiers, per scope (skip workspace)**

For each scope where `is_project=true` OR `scope_label="ai-resources"`:
1. `cd "{scope_path}"`
2. Verify `reference/skills/repo-health-analyzer/agents/` OR `skills/repo-health-analyzer/agents/` exists. If neither, record `skipped: repo-health-analyzer not deployed` and continue.
3. Invoke `/audit-repo`.
4. After completion, copy the per-scope report to a dated cadence snapshot:
   ```bash
   cp "{scope_path}/reports/repo-health-report.md" "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/repo-health-{scope_slug}-{TODAY}.md"
   ```
5. Record both paths in `RESULTS`.

**B. `/improve` — all tiers, per scope**

For each scope:
1. `cd "{scope_path}"`
2. If `logs/improvement-log.md` does not exist, record `skipped: no improvement-log.md` and continue.
3. Invoke `/improve`. The command reads `logs/friction-log.md`, appends new entries to `logs/improvement-log.md`. Entries land in the scope's own logs, not `ai-resources/logs/`.
4. Record the appended count (best-effort, from `/improve`'s own output) and the log path in `RESULTS`.

**C. `/coach` — all tiers, per scope (skip if thin)**

For each scope:
1. `cd "{scope_path}"`
2. If `logs/session-notes.md` does not exist, record `skipped: no session-notes.md` and continue.
3. Count wrapped sessions with Bash: `grep -c "^## " "{scope_path}/logs/session-notes.md"`. If count < 5, record `skipped: insufficient session volume ({N}/5)` and continue.
4. Invoke `/coach`.
5. Record the produced coaching-log append in `RESULTS`.

**D. `/audit-claude-md` — monthly and quarterly only**

Skip entirely if `TIER=weekly`.

For each scope:
1. ai-resources → not applicable (no standalone ai-resources CLAUDE.md audit; `workspace` arg covers the workspace CLAUDE.md, and ai-resources' own CLAUDE.md is audited there). Record `skipped: covered by workspace scope` and continue.
2. workspace → invoke `/audit-claude-md workspace`.
3. project {name} → invoke `/audit-claude-md project {name}`.

Record the produced audit report path in `RESULTS`.

**E. `/token-audit` — monthly and quarterly only**

Skip entirely if `TIER=weekly`.

For each scope:
1. ai-resources → invoke `/token-audit ai-resources`.
2. workspace → invoke `/token-audit workspace`.
3. project {name} → invoke `/token-audit project {name}`.

Record the produced audit report path in `RESULTS`.

**F. `/permission-sweep --dry-run` — all tiers, once per checkup run**

Permission-sweep scans every settings file in the workspace in one pass — it is **not** per-scope. Invoke it exactly once regardless of how many scopes are selected.

1. `cd "{WORKSPACE_ROOT}"` (the workspace root, not a scope path).
2. Verify `ai-resources/.claude/agents/permission-sweep-auditor.md` exists. If missing, record `skipped: permission-sweep-auditor not deployed` and continue.
3. Invoke `/permission-sweep --dry-run`.
4. The command writes the consolidated dry-run report to `ai-resources/audits/permission-sweep-{TODAY}.md` (same dated path regardless of scope).
5. Record the report path in `RESULTS` under a synthetic scope label `permission-sweep (workspace-wide)`.

---

### Step 6: Compile Follow-Ups

14. Check follow-up triggers and assemble three tier-differentiated sections.

    **Tactical follow-ups (all tiers).** Per-item shape: `[ ] {item} — risk: {low | med | high}`. Risk derivation:
    - Sub-report severity `CRITICAL` → `high`
    - Sub-report severity `HIGH` → `high`
    - Sub-report severity `MEDIUM` → `med`
    - Anything else (advisory, info) → `low`
    - Hand-coded items below: `med` unless an upstream signal raises them.

    Standard tactical items:
    - **Resolve-improvements:** in `ai-resources/logs/improvement-log.md`, count entries that have both `**Status:** applied` and `**Verified:**` lines. If count ≥ 5, add `` `/resolve-improvements` — {N} resolved entries pending archive `` (risk: `low`).
    - **Cleanup-worktree:** run `git status --short` in `ai-resources/`. If non-empty, count modified vs untracked lines and add `` `/cleanup-worktree` — working tree dirty (M modified, U untracked) `` (risk: `med`).
    - **Quarterly follow-ups:** if `TIER=quarterly`, add one item per scope for `/repo-dd deep` (risk: `low`), and one item per directory under `workflows/` for `/analyze-workflow` (risk: `low`).

    **Policy-level observations (monthly + quarterly).** Skip if `TIER=weekly`. Sources:
    - `/audit-claude-md` reports: any finding tagged as a rule-level recommendation (suggests adding/removing/rewording a CLAUDE.md rule rather than a single file fix).
    - `/token-audit` reports: any finding that recommends a workspace- or project-wide policy change (default-model tier, frontmatter convention, hook-firing pattern, agent-tier table revision).
    - Recurrence signals: if any tactical item appears in both this checkup AND the prior `audits/friday-checkup-*.md` (search backward by filename date, comparing item text), flag as `[recurring]` — recurrence is the canonical trigger for policy-level review.

    Surface up to 5 observations. If none qualify, write `(none flagged this cycle)`.

    **Architectural retrospective (quarterly only).** Skip if `TIER ∈ {weekly, monthly}`. Populate with:
    - Standard substrate questions (always present): "What's the repo drifting toward?" / "What's accumulating without a forcing function to remove it?" / "Which boundary felt fuzziest this quarter?"
    - Quarterly follow-up references already added to Tactical (`/repo-dd deep`, `/analyze-workflow`) — repeat their paths here so the retrospective section is self-contained for `/friday-act`'s quarterly review.
    - Auto-detect substrate-drift signals: count of `audits/risk-checks/*.md` files this quarter; count of new `.claude/commands/*.md` files this quarter (`git log --since="3 months ago" --name-only -- ai-resources/.claude/commands/`). Surface counts as one-liners; the operator interprets in `/friday-act`.

---

### Step 7: Write Consolidated Report

15. Write the consolidated report to `ai-resources/audits/friday-checkup-{TODAY}.md`. Structure:

    ```
    # Friday Checkup — {TODAY}

    ## Tier
    {TIER} ({auto-detected | operator-override})

    ## Scopes audited
    - {scope_label for each ACTIVE_SCOPES entry}

    ## Prioritized findings (rolled up across all scopes)
    1. [CRITICAL] …
    2. [HIGH] …
    3. [MEDIUM] …
    (Extract HIGH/CRITICAL findings from each sub-report read in Step 5.
     If a sub-report has no findings, note "clean" for that check.)

    ## Per-scope summary
    ### {scope_label}
    - /audit-repo: {summary} → {snapshot path OR skipped reason}
    - /improve: {N appended | skipped} → {log path}
    - /coach: {ran ({N} sessions) | skipped: insufficient session volume ({N}/5) | skipped: no session-notes.md}
    - /audit-claude-md (monthly): {summary} → {path OR skipped reason}
    - /token-audit (monthly): {summary} → {path}

    ## Tactical follow-ups
    - [ ] {item} — risk: {low | med | high}
    (One bullet per Step 6 tactical item. Always present.)

    ## Policy-level observations
    - {observation} — {source: /audit-claude-md | /token-audit | recurring | …}
    (Monthly and quarterly only. Omit the heading if TIER=weekly. If TIER ∈ {monthly, quarterly} but no observations qualify, write the heading followed by "(none flagged this cycle)".)

    ## Architectural retrospective
    - Substrate questions:
      - What's the repo drifting toward?
      - What's accumulating without a forcing function to remove it?
      - Which boundary felt fuzziest this quarter?
    - Quarter-over-quarter signals:
      - /risk-check reports filed this quarter: {N}
      - New commands added this quarter: {N}
    - Quarterly follow-ups (also listed under Tactical):
      - /repo-dd deep — {scope_label}
      - /analyze-workflow — {workflow_path}
    (Quarterly only. Omit the heading entirely if TIER ∈ {weekly, monthly}.)

    ## All reports generated
    - {every path recorded in RESULTS}
    ```

    **Section presence by tier (data contract for `/friday-act`):**
    - `weekly` → Tactical follow-ups only (Policy-level and Architectural retrospective omitted).
    - `monthly` → Tactical + Policy-level (Architectural retrospective omitted).
    - `quarterly` → Tactical + Policy-level + Architectural retrospective.

    `/friday-act` parses these section headings verbatim. Do not rename them.

16. To extract findings: Read each sub-report produced in Step 5 (the snapshot audit-repo files, the audit-claude-md reports, the token-audit reports, the permission-sweep report). For each, look for sections titled `HIGH`, `CRITICAL`, `Top findings`, or the report's executive summary. Pull headline items; do not re-evaluate severity. If a report uses numeric scoring (e.g. repo-health RED/YELLOW/GREEN), surface RED findings only. For the permission-sweep dry-run, surface all CRITICAL findings (the primary signal of live permission-prompt issues) and HIGH findings in aggregate (e.g., "5 HIGH gaps across 3 projects — see report").

---

### Step 8: Summary and Exit

17. Print to operator:
    ```
    Friday checkup complete.

    Tier: {TIER}
    Scopes: {scope_labels joined by comma}
    Auto-run checks: {completed count} / {attempted count}  ({N} skipped: reasons listed in report)
    Follow-ups flagged: {count}

    Consolidated report:
      ai-resources/audits/friday-checkup-{TODAY}.md

    Review the report and commit at session wrap (`/wrap-session`).
    ```

18. **Do NOT commit.** All files land unstaged. Operator reviews and commits at session wrap per workspace `Commit behavior` rules (handles concurrent-session staging enumeration correctly).

---

### Notes

- **Scope-slug convention:** `ai-resources`, `workspace`, `project-{name}`. Matches existing audit filename convention (see `repo-due-diligence-*.md` and `token-audit-*.md` under `ai-resources/audits/`).
- **No subagent orchestration here.** Each sub-command manages its own subagents; this command only sequences them and consolidates outputs.
- **Interactive sub-commands to avoid:** `/resolve-improvements` and `/cleanup-worktree` both prompt for confirmation mid-run. They are listed only in the follow-ups section, never auto-invoked. `/repo-dd deep` and `/analyze-workflow` are deferred to quarterly follow-ups for the same reason plus runtime.
- **Failure handling:** if a sub-command errors, record the error as the per-scope result and continue to the next check. Do not abort the whole run.
