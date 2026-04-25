# Improvement Log

## Schema

Each entry is a `### YYYY-MM-DD — {title}` block. Fields:

- **Status:** `logged` | `proposed` | `pending` | `applied YYYY-MM-DD`
- **Verified:** present when Status is `applied` and the operator has confirmed the fix is live. Both `Status: applied` AND `Verified:` are required for `/resolve-improvements` to classify an entry as resolved.
- **Age:** auto-computed from the header date by `/resolve-improvements`; surfaced when > 6 weeks without resolution.
- **Review-cycle:** for items not yet resolved — records the last review date and disposition (e.g., `reviewed 2026-04-24, deferred to next quarterly`).
- **Category:** broad classification (e.g., `Audit-recurrence prevention`, `command/skill`).
- **Proposal:** the proposed change.
- **Target files:** files to be edited when executed.

Resolved entries (Status: applied + Verified) are archived to `improvement-log-archive.md` via `/resolve-improvements`.

---

- **Status:** applied 2026-04-18 (Prevention Session 2)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R1 (both audits) and R4 (buy-side). Every new project ships without `Read(...)` denies and without a Sonnet default. The audit catches these findings on every project; preventing them at project-creation time would eliminate the recurrence.
- **Proposal:**
  - Update `/new-project` pipeline's post-enrichment stage to write `.claude/settings.json` with a sensible `permissions.deny` block. Minimum: `Read(archive/**)`. Research-workflow-derived projects should also get `Read(output/**)`, `Read(parts/**/drafts/**)`, `Read(usage/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.
  - Update the same stage to write `.claude/settings.local.json` with `{"model": "sonnet"}` as default.
  - Update the research-workflow template's `.claude/settings.json` at `ai-resources/workflows/research-workflow/.claude/settings.json` so `/deploy-workflow` propagates the canonical state.
  - Apply the "Applying Audit Recommendations" rule (workspace CLAUDE.md) when finalizing the deny list — list the top-3 commands each path affects and confirm no regression before committing the template.
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` (pipeline orchestrator)
  - `ai-resources/workflows/research-workflow/.claude/settings.json` (template)
  - Any pipeline-stage-N agent that writes project `.claude/settings.json`

### Sequencing note (five entries combined)

Suggested three-session sequence:

- **Session 1 (rules, ~45 min):** Entry "Extend Model Tier rule to agents" + Entry "Codify subagent-summary cap + /usage-analysis discipline". Purely CLAUDE.md + one `/wrap-session` edit. Lowest risk, highest per-turn leverage.
- **Session 2 (templates, ~1–2 hrs):** Existing entries — canonical project settings template + canonical project CLAUDE.md template. Touches `/new-project` pipeline + research-workflow templates. Before implementing, re-read the 2026-04-13 decision ("Commit Rules propagate by explicit copy") to confirm whether the inheritance workaround is still needed.
- **Session 3 (detection + automation, ~45 min):** Entry "Add three questionnaire items to /repo-dd" + Entry "Pre-commit skill-size warning hook". Depends on Session 1 (Agent Tier Table) and Session 2 (canonical templates) landing first so the new questionnaire items have stable references.

### 2026-04-22 — Hook inventory + validation (SC-02 reframe)

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** `ai-resources/reports/setup-improvement-scan-2026-04-21.md:50–58` (SC-02). Original scan framing was "6 hooks deployed 2026-03-28 remain unvalidated"; the 2026-04-22 setup-scan fix session could not verify that 6-hook baseline in git history and deferred the item.
- **Reframe:** broader and more actionable — inventory every currently deployed hook across the workspace and verify each fires correctly in a test session. Phase 1 exploration on 2026-04-22 counted 29 hook files:
  - 6 under `ai-resources/.claude/hooks/`
  - 6 under workspace-root `.claude/hooks/`
  - 13 across `projects/*/.claude/hooks/` (buy-side-service-plan, nordic-pe-landscape-mapping-4-26, project-planning)
  - 4 in the research-workflow template at `ai-resources/workflows/research-workflow/.claude/hooks/`
- **Proposed change:** one-off inventory session, or a new `/validate-hooks` command (or `hook-validator` skill) that: (a) enumerates each hook by path and declared trigger (SessionStart / PreToolUse / PostToolUse / Stop / pre-commit); (b) checks whether it is actually wired via the nearest `settings.json`; (c) in a test session, triggers each hook type and confirms it fires. Priority order: high-value hooks first — SessionStart context loader, `auto-sync-shared.sh`, `check-heavy-tool.sh`, pre-commit `skill-size`.
- **Deferred reason:** scope estimated ~1 hour; no active friction driving urgency. Better handled as a dedicated maintenance session than bundled into a scan-fix session.
- **Target files (when executed):** potentially new — `ai-resources/.claude/commands/validate-hooks.md` or `ai-resources/skills/hook-validator/SKILL.md`.

### 2026-04-25 — Make /wrap-session leaner

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** Mid-wrap conversation 2026-04-25 — operator asked why /wrap-session was taking so long. Audit of the wrap's actual tool-call count surfaced ~3-4 round-trips of avoidable cost.
- **Friction observation:** A typical /wrap-session reads 3 full log files (innovation-registry, improvement-log, friction-log) when single greps would do, and runs the archive AFTER appending today's entry, which forces a freshness-failure re-read of session-notes.md when the archive trims it.
- **Proposal:**
  1. **Replace full-file Reads with greps in steps 7, 9, 10.** Step 7 (innovation triage): grep for `| detected |` in `logs/innovation-registry.md`. Step 9 (improvement verification): scan for entries with `Status: applied` missing a `Verified:` line via awk/grep. Step 10 (friction reminder): grep for today's date (`$(date +%Y-%m-%d)`) in `logs/friction-log.md`. Saves ~150 lines of content streaming through context per wrap.
  2. **Reorder Step 11 (archive) BEFORE Step 3 (append session note).** Archive script rewrites session-notes.md when threshold exceeded; appending FIRST then archiving causes Edit-after-archive freshness invalidation, forcing a re-read of ~60 lines of the just-written note. Archive operates only on existing entries — running it before today's note is written is safe and avoids the re-read entirely.
  3. **Drop the wc -l + Read pattern in steps 1-2.** Spec says "last 5 lines only" but a `wc -l` probe before tail-reading is redundant. Tail-read directly with a known offset.
  4. **Drop the file-existence inventory before content reads.** Six `if -f` checks pre-empting reads in the current flow — let Read error on the rare missing case rather than pre-checking each.
  5. **Auto-pass dirt check when all dirty paths match Files Created/Files Modified verbatim.** Step 12a currently only short-circuits on empty git-status. Extending the silent-skip rule to "all matched" would skip the operator prompt for clean wraps where every dirty path was produced this session and is already enumerated.
- **Target files (when executed):**
  - `ai-resources/.claude/commands/wrap-session.md`
