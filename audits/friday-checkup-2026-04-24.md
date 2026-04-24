# Friday Checkup — 2026-04-24

## Tier

monthly (operator-override; auto-detected was weekly — today is Friday day-24, outside first-week window)

## Scopes audited

- ai-resources (single scope; operator narrowed from an initial 4-scope selection after runtime estimate)

## Prioritized findings (rolled up)

**HIGH**

1. **[token-audit H1] Rework research-workflow prose-pipeline subagent returns to output-to-disk.** Three HIGH findings in the produce-prose-draft and produce-formatting commands return 60–200+ line findings lists into the main session — one is explicitly preserved across `/compact`. Violates the Subagent Contracts codified in CLAUDE.md. Est. 10,000–30,000 tokens/chapter wasted. (Structural change.)
2. **[token-audit H2] Expand `Read(pattern)` deny coverage in `ai-resources/.claude/settings.json`.** Only `Read(archive/**)` set — `audits/`, `reports/`, `logs/` archives, `inbox/archive/` unprotected. 13 large files in `audits/` (~76k tokens) could be pulled by any broad Glob/Grep. (Quick win, 2-min edit.)
3. **[token-audit H3 + Section 2] Split multi-mode skills.** `ai-resource-builder` (401L, 3 modes) and `answer-spec-generator` (485L, 5 modes) load all modes per invocation. Plus four other skills >300 lines: `research-plan-creator`, `evidence-to-report-writer`, `workflow-evaluator`, `ai-prose-decontamination`.

**MEDIUM**

4. **[token-audit M1] Set `MAX_THINKING_TOKENS=10000`** in ai-resources `.claude/settings.json`. Unchanged carryover from 2026-04-18 audit.
5. **[token-audit M2] Compress verbose orchestrator commands** (`new-project.md` 476L, `deploy-workflow.md` 321L) via protocol-file pattern already used by `/token-audit`.
6. **[token-audit M3] Add `/clear` guidance** between research-workflow produce-* commands.
7. **[token-audit Section 6] `audits/` + `reports/` + `logs/session-notes.md`** are unprotected large-file stores (Section 6 Findings 1–4).

**LOW** — collapsed (see per-scope detail below). Includes orphan `usage/usage-log.md` deletion, CLAUDE.md `## Maintenance Cadence` trim, archive narrow-pattern in settings, repo-dd superseded versions.

No CRITICAL findings.

## Per-scope summary

### ai-resources

- **/audit-repo:** GREEN overall. 0 Critical, 0 Important, 11 Minor. Snapshot: `audits/repo-health-ai-resources-2026-04-24.md`. Canonical report: `reports/repo-health-report.md` (prior archived to `reports/repo-health-report-2026-04-06.md`).
- **/improve:** 0 appended. Both friction-log entries already applied+verified in archive. Log path: `logs/improvement-log.md`.
- **/coach:** ran (35 sessions). First coaching run — baseline established. Dimensions: Iteration Efficiency (Healthy↑), Decision Patterns (Watch→), QC Disposition (Healthy↑), Delegation (Healthy→), Workflow Evolution (Healthy↑↑). **The One Thing:** push a subset of material design decisions from session notes to `decisions.md` — ~40% of session design forks currently live only in session notes. Log entry: `logs/coaching-log.md`.
- **/audit-claude-md (monthly):** skipped — ai-resources scope is covered only when workspace scope is selected (per command spec; workspace not in this run).
- **/token-audit (monthly):** MEDIUM Read(pattern) deny verdict (improved from 2026-04-18 HIGH). 7 HIGH findings (most in research-workflow prose sub-pipeline). 11-section report: `audits/token-audit-2026-04-24-ai-resources.md`. Previous audit: `audits/token-audit-2026-04-18-ai-resources.md`.

## Operator follow-ups

- [ ] `/cleanup-worktree` — working tree dirty (16 modified, 11 untracked). Applies after this Friday checkup run because this session itself introduced new audit files. Safe to run after reviewing the reports.
- [ ] Address HIGH finding H1 (research-workflow subagent-return refactor) — schedule a dedicated session; structural change.
- [ ] Address HIGH finding H2 (expand Read() deny rules) — quick win; can batch with other settings updates.
- [ ] Address HIGH finding H3 (skill splits) + 4 other oversized skills — staged across multiple sessions.
- [ ] Address MEDIUM finding M1 (`MAX_THINKING_TOKENS`) — quick win; 1-line settings.json add.
- [ ] Coach's One Thing — adopt 60-second pre-wrap pass to push material design decisions to `decisions.md`.
- [ ] Optional: delete orphan `usage/usage-log.md` (227L pre-migration artifact, canonical is `logs/usage-log.md`).

## All reports generated

- `audits/repo-health-ai-resources-2026-04-24.md` (cadence snapshot of audit-repo)
- `reports/repo-health-report.md` (canonical; updated by /audit-repo)
- `reports/repo-health-report-2026-04-06.md` (prior, auto-archived by /audit-repo)
- `audits/token-audit-2026-04-24-ai-resources.md` (token-audit report)
- `audits/working/audit-working-notes-preflight.md` (token-audit Section 0)
- `audits/working/audit-working-notes-skills.md` + `audit-summary-skills.md` (Section 2)
- `audits/working/audit-working-notes-file-handling.md` + `audit-summary-file-handling.md` (Section 6)
- `audits/working/audit-working-notes-workflow-research-workflow.md` + `audit-summary-workflow-research-workflow.md` (Section 4)
- `logs/coaching-log.md` (appended first baseline entry)

## Notes

- **Commit behavior:** Per /friday-checkup Step 18, all files land unstaged for operator review at session wrap. Note the conflict with /token-audit's built-in commit step — the orchestrator's no-commit rule takes precedence.
- **Plan QC gap:** Spec says `/audit-claude-md` monthly skips ai-resources scope "covered by workspace scope" — with workspace deselected this run, the ai-resources CLAUDE.md got no direct audit. Consider revising the command spec so ai-resources-only runs still audit ai-resources's own CLAUDE.md. Out of scope for this session to fix.
