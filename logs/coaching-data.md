# Coaching Data

### 2026-04-18 (deep night) — Prevention Session 3: detection + automation (questionnaire items + skill-size hook)
- **Commands used:** /prime, /fewer-permission-prompts, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1 (project allowlist scope: trust boundary for routine Edit/Write paths and Bash mutations)
- **QC cycles:** 2 (post-edit qc-reviewer on questionnaire: PASS-WITH-NITS, 4 nits resolved before commit; post-edit qc-reviewer on hook: PASS-WITH-NITS, all nits cosmetic, no fixes applied)
- **Gates:** 2 (1 changed, 1 confirmed) — plan-approval:confirmed (operator picked Option A without revision), bright-line-review:changed (operator caught /fewer-permission-prompts under-delivery — "I had to approve like 8 permissions" — and directed broader allowlist scope)

### 2026-04-18 (late evening) — Apply token-audit R12 + R2 Phase 1; log three new audit-recurrence prevention entries
- **Commands used:** /prime, /qc-pass, /wrap-session; plan mode entered twice
- **Iterations:** 0 (no drafting — config + agent-file + log-file edits)
- **Decisions logged:** 1 (split-agent-file shape for R2 Phase 1 over caller-side model override)
- **QC cycles:** 1 (plan-level qc-reviewer returned REVISE — caller-side override mechanism unverified; revised to split-agent-file, which the audit had sanctioned)
- **Gates:** 3 (3 changed) — plan-approval:changed (first plan REVISE → revised plan approved), plan-approval:changed (second plan, prevention scope clarified mid-plan via AskUserQuestion → "defer to future session but write brief"), qc-disposition:changed (operator directed "proceed per your recommendation" after QC findings)

### 2026-04-17 — /improve-skill ai-prose-decontamination + produce-prose-draft stop-gap cleanup + /improve-skill prose-compliance-qc
- **Commands used:** /prime, /improve-skill (×2), /wrap-session
- **Iterations:** 0 (no drafting — skill/command edits)
- **Decisions logged:** 1 (combined structure + output-contract decision for ai-prose-decontamination)
- **QC cycles:** 1 (Step 4 evaluator subagent on ai-prose-decontamination: 0 Critical / 0 Major / 9 Minor → six IMPORTANT fixes applied → post-fix regression check passed). Second /improve-skill run (prose-compliance-qc) skipped Step 3 iteration and Step 4 evaluator per operator — scope was too small to benefit from a formal evaluator gate; replaced by mechanical verification of the three known staleness points.
- **Gates:** 5 (5 confirmed) — plan-approval:confirmed (ai-prose-decontamination Step 1 understanding gate), content-review:confirmed (ai-prose-decontamination Step 7 results review), plan-approval:confirmed (mid-session scope extension to produce-prose-draft cleanup), plan-approval:confirmed (prose-compliance-qc streamlined-pipeline proposal), content-review:confirmed (prose-compliance-qc Option B — expand scope to all three staleness points)

### 2026-04-06 — Synced wrap-session command across projects + added drift check
- **Commands used:** /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1 (drift check approach)
- **QC cycles:** 0

### 2026-04-06 — Session rituals doc + subagent isolation for 6 commands
- **Commands used:** /wrap-session
- **Iterations:** 2 (session-rituals.md — initial draft, then added sync-workflow + usage-analysis + repo-dd tiers)
- **Decisions logged:** 0
- **QC cycles:** 0

### 2026-04-06 — Audit remediation: 11 findings from repo-dd-deep
- **Commands used:** /qc-pass, /refinement-pass, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0
- **QC cycles:** 2 (QC pass: REVISE with 3 fixes → applied; refinement pass: REFINE with 5 clarity improvements → applied)

### 2026-04-06 — Full repo due diligence (deep) + strategic workspace review
- **Commands used:** /repo-dd deep, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0 (decisions were triage-level: auto-fix approval, operator item deferral)
- **QC cycles:** 0

### 2026-04-07 — Created /refinement-deep orchestrator command
- **Commands used:** /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0
- **QC cycles:** 0

### 2026-04-09 — Perplexity query improvements from API playbook
- **Commands used:** /qc-pass, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0
- **QC cycles:** 1 (REVISE — 3 findings, all fixed)
- **Gates:** 2 (0 changed) — content-review:confirmed, qc-disposition:confirmed

### 2026-04-11 — Created ai-prose-decontamination skill and Phase 5c integration
- **Commands used:** /qc-pass (x2), /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1
- **QC cycles:** 2 (plan: GO with 4 minor fixes applied; implementation: REVISE with 2 critical + 1 major, all fixed)
- **Gates:** 3 (1 changed) — plan-approval:confirmed, qc-disposition:confirmed, qc-disposition:confirmed

### 2026-04-13 — Added Stop/Notification sound hooks to user settings
- **Commands used:** /qc-pass, /update-config, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0
- **QC cycles:** 1 (GO — no fixes needed)
- **Gates:** 2 (0 changed) — plan-approval:confirmed, qc-disposition:confirmed

### 2026-04-13 — Codex second-opinion auditor viability investigation + inbox brief
- **Commands used:** /prime, /clarify, /wrap-session
- **Iterations:** 1 (codex-second-opinion-brief draft-01 → draft-02 after operator standalone-sufficiency challenge)
- **Decisions logged:** 1
- **QC cycles:** 0
- **Gates:** 2 (1 changed) — plan-approval:confirmed, content-review:changed

### 2026-04-13 — Grant ai-resources filesystem visibility across all projects + /repo-dd detection
- **Commands used:** /prime, /clarify, /qc-pass (x2), /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1
- **QC cycles:** 2 (QC pass #1 on plan: REVISE → 5 fixes applied before ExitPlanMode → approved; QC pass #2 on implementation: REVISE → 1 critical adjudicated as false positive, 1 major fixed via create-manifest + initial-sync + 2 commits → clean)
- **Gates:** 3 (3 changed) — plan-approval:changed, qc-disposition:changed, qc-disposition:changed

### 2026-04-13 — Commit Rules propagation + /deploy-workflow parity + /new-project CLAUDE.md enrichment
- **Commands used:** /prime, /clarify, /qc-pass (x2), /wrap-session
- **Iterations:** 1 (plan v1 → v2 after QC REVISE; 8 commits across 6 repos)
- **Decisions logged:** 1
- **QC cycles:** 2 (plan QC: REVISE → 8 revisions applied before ExitPlanMode → approved; implementation QC: GO with 3 minor follow-ups → all applied)
- **Gates:** 3 (3 changed) — plan-approval:changed, scope-expansion:changed, qc-disposition:changed

### 2026-04-18 — /cleanup-worktree first real invocation — 4-commit sweep of accumulated 2026-04-17 drift

- **Commands used:** /cleanup-worktree, /qc-pass (invoked then skipped), /wrap-session
- **Iterations:** 2 (plan Revision 1 → Revision 2)
- **Decisions logged:** 2
- **QC cycles:** 2 (first: REVISE BLOCKING, 7 findings, all addressed in Revision 1; second: PASS WITH MINOR, 1 off-by-one line count, addressed in Revision 2)
- **Gates:** 1 (1 confirmed) — plan-approval:confirmed (operator approved post-revision; both soft flags G1/G2 resolved to defaults)

### 2026-04-18 — Built /token-audit infrastructure (v1.2 protocol + lean subagent + orchestrator command)
- **Commands used:** /qc-pass (3x), /context (2x), ExitPlanMode, /wrap-session, claude --version
- **Iterations:** 3 (plan Option A → Option E v1 → Option E v2 approved); artifacts built once and passed per-file QC on first try
- **Decisions logged:** 2
- **QC cycles:** 3 (plan cycle 1: REVISE on 11-file Option A with 3 Critical + 6 Major; plan cycle 2: REVISE-AND-RESUBMIT on Option E v1 with 2 new Critical + 4 Major; per-file cycle 3: GO on built artifacts with 5 Minor cosmetic findings, none applied)
- **Gates:** 4 (1 changed, 3 confirmed) — plan-approval:changed (operator pivoted from Option A to Option E after QC cycle 1), qc-disposition:changed (plan QC findings addressed via revision, twice), qc-disposition:confirmed (per-file QC on built artifacts passed clean), commit-approval:confirmed

### 2026-04-18 (pm) — Execute /token-audit ai-resources
- **Commands used:** /prime, /token-audit, /wrap-session
- **Iterations:** 0 (no drafting — diagnostic audit produces a single report artifact)
- **Decisions logged:** 1 (Tier B drop at Section 9 checkpoint)
- **QC cycles:** 0 (diagnostic-only audit; protocol does not include a QC pass on the report itself)
- **Gates:** 2 (1 confirmed, 1 changed) — exit-condition:confirmed (operator selected Option B cleanly at /prime), content-review:changed (operator dropped Tier B at the Section 9 shortlist checkpoint, reducing optimization-plan scope from 12 themes to 7)

### 2026-04-18 (evening) — Execute /token-audit project buy-side-service-plan
- **Commands used:** /token-audit, /wrap-session
- **Iterations:** 0 (no drafting — diagnostic audit produces a single report artifact)
- **Decisions logged:** 1 (symlinked-exclusion extended beyond skills to commands and agents)
- **QC cycles:** 0 (diagnostic-only audit; protocol does not include a QC pass on the report itself)
- **Gates:** 3 (2 confirmed, 1 changed) — scope-resolution:confirmed (operator confirmed `buy-side service plan` → `project buy-side-service-plan`), supplementary-research:changed (operator directed mid-audit to exclude symlinked skills, extended by main agent to all symlinked categories), content-review:confirmed (operator approved symlink-extension decision at wrap-session for formal logging)

### 2026-04-18 (late evening) — Token-audit quick-win fixes + five durable workspace rules
- **Commands used:** /prime, /qc-pass (×3), /improve (attempted, aborted — friction log not started), /wrap-session
- **Iterations:** 0 draft iterations; 2 plan iterations (v1 REVISE → v2 approved); 1 session-wide deny-list iteration (buy-side → narrowed → mirrored to ai-resources)
- **Decisions logged:** 5 (audit-recs bright-line rule, plan-mode discipline rule, commit-boundary rule, CLAUDE.md scoping rule, model-tier rule)
- **QC cycles:** 3 (plan-v1 REVISE → addressed in v2 → approved; R13 migration post-edit QC 2 IMPORTANTs dismissed scope-out-of-pipeline; landed-commits QC REVISE 4 findings → 3 applied, 1 false alarm)
- **Gates:** 6 (2 changed, 4 confirmed) — plan-approval:changed (v1 QC flagged 9 revisions, integrated 10 of 12 into v2 — v2 approved), qc-disposition:changed (post-implementation QC drove buy-side + ai-res deny narrowing), editorial-disagreement:changed (operator interrupted over-planning "Stop, what's taking so long" — motivated the Plan Mode Discipline rule), autonomy-directive:changed (operator granted in-execution autonomy mid-session "I give you autonomy don't ask me for permissions unless its really important" — saved to memory), content-review:confirmed (3-rule recommendation approved), content-review:confirmed (4-rule recommendation approved "do 3,4 now")

### 2026-04-18 — Prevention Session 1: agent-tier rule + subagent contracts + telemetry discipline
- **Commands used:** /prime, /fewer-permission-prompts, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1 (Agent Tier Table includes untracked agents from concurrent session)
- **QC cycles:** 1 (post-edit qc-reviewer: REVISE → 2 Important findings → both applied → accepted)
- **Gates:** 2 (0 changed, 2 confirmed) — plan-approval:confirmed (operator picked the 3-edit governance scope "C: Session 1", no revisions), content-review:confirmed (QC findings applied without dispute, operator said "proceed")

### 2026-04-18 — Prevention Session 2: canonical project settings + CLAUDE.md templates
- **Commands used:** /prime, /qc-pass, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1 (canonical templates: archival-only deny set + model at top-level settings.json + 2026-04-13 short-form mirror preserved — three sub-decisions bundled)
- **QC cycles:** 2 (post-edit qc-reviewer: GO, 2 pre-existing minors flagged; independent /qc-pass: GO, 3 minors, no fixes applied)
- **Gates:** 1 (0 changed, 1 confirmed) — plan-approval:confirmed (operator picked Option A full end-to-end without revision)


### 2026-04-18 — Execute 4 next-steps from Prevention Session 3 wrap

- **Commands used:** /prime, /qc-pass, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1 (defer Sonnet model default until per-project opus-frontmatter coverage is audited)
- **QC cycles:** 1 (qc-reviewer subagent: GO, 3 minors flagged, no fixes applied)
- **Gates:** 5 (0 changed, 5 confirmed) — plan-approval:confirmed (next-step ordering), plan-approval:confirmed (inbox triage approach), plan-approval:confirmed (denies-only retrofit + commit-per-project), plan-approval:confirmed (heredoc fix approach), qc-disposition:confirmed (GO with no fixes required)

### 2026-04-18 — Post-prevention cleanup 2 (items 1–6 from prior wrap)
- **Commands used:** /prime, /friction-log, /qc-pass, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 2 (defer repo-review brief pending /audit-repo coverage; majority-match normalization of nordic deny patterns)
- **QC cycles:** 1 (qc-reviewer subagent: REVISE-light → findings captured in session notes → GO accepted)
- **Gates:** 4 (0 changed, 4 confirmed) — plan-approval:confirmed (exit-condition Option A), plan-approval:confirmed (repo-review brief defer), qc-disposition:confirmed (GO-A accepted), push-approval:confirmed (push executed across 3 repos)

### 2026-04-18 — Agent tier retrofit (Option B) + R13 skill-chain migration (Option C)
- **Commands used:** /prime, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 1 (R13 closeout — move skill-chain to research-workflow/CLAUDE.md to sidestep audit-vs-pipeline-rule conflict)
- **QC cycles:** 2 (qc-reviewer on tier retrofit: GO; qc-reviewer on R13 migration: GO)
- **Gates:** 6 (1 changed, 5 confirmed) — plan-approval:confirmed (exit-condition Option B), plan-approval:changed (mid-session [SCOPE] extension → Option C on R8/R13), plan-approval:confirmed (R13 closeout Option C), qc-disposition:confirmed (tier retrofit GO), qc-disposition:confirmed (R13 GO), push-approval:confirmed (push executed).


### 2026-04-18 — Token-cost residual audit: map prior post-mortems to applied fixes; raise MAX_THINKING_TOKENS
- **Commands used:** /prime, /update-config, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0 (operational tuning, not analytical/scoping)
- **QC cycles:** 0 (diagnostic plan + single-line config edit)
- **Gates:** 3 (0 changed, 3 confirmed) — plan-approval:confirmed (diagnostic plan approved as-is), qc-disposition:confirmed (recommendation "close C5 only" accepted without modification), bright-line-review:confirmed (operator accepted C5 bump from 10k→20k without pushback)


### 2026-04-18 — /cleanup-worktree bundle (R3+R4+R5+R11) + /usage-analysis pointer fix
- **Commands used:** /prime, /improve-skill, /wrap-session
- **Iterations:** 0 (no draft cycles — direct edit-review-commit flow)
- **Decisions logged:** 1 (3 judgment calls bundled: R11 calibration, R5 scope extension, pointer-vs-move)
- **QC cycles:** 1 (fresh-context evaluation subagent — 0 Critical, 0 Major, 5 Minor; all swept; 3 self-caught regressions from Step 2 also fixed)
- **Gates:** 4 (1 changed, 3 confirmed) — plan-approval:confirmed (exit condition Option A accepted without changes), qc-disposition:changed (operator approved "both recommendations + sweep 3 minors + bundled commit" after asking "what do you recommend"), bright-line-review:confirmed (R11 dual-condition calibration approved without changes), editorial-disagreement:confirmed (sweep-3-minors approach approved without changes)

### 2026-04-18 — /repo-dd on ai-resources (standard depth) — 5 triaged fixes applied
- **Commands used:** /repo-dd, /triage, /wrap-session
- **Iterations:** 0 (no drafting — audit + triage + fixes)
- **Decisions logged:** 0
- **QC cycles:** 1 (independent triage-reviewer subagent on 12 findings; produced Do/Park table; all 5 Do items accepted without modification)
- **Gates:** 3 (3 confirmed) — plan-approval:confirmed (scope = ai-resources standard, accepted without changes), qc-disposition:confirmed (Do/Park table accepted via "proceed per your recommendation"), triage-disposition:confirmed (triage-reviewer output passed through unmodified)

### 2026-04-18 — /improve applied two Prime command fixes
- **Commands used:** /improve, /wrap-session
- **Iterations:** 0
- **Decisions logged:** 0
- **QC cycles:** 0
- **Gates:** 1 (1 changed) — plan-approval:changed (operator said "fix" — applied both findings; one proposal adapted because Prime's Step 5 output didn't have the line the analyst proposed prefixing)

### 2026-04-18 — Tier 3 token-audit hardening: [HEAVY] PreToolUse hook + Stop-hook telemetry
- **Commands used:** /qc-pass, /wrap-session
- **Iterations:** 1 (plan v1 → REVISE → plan v2 approved)
- **Decisions logged:** 2
- **QC cycles:** 1 (REVISE → revised per recommendation → applied; no second QC after revision since changes were per the reviewer's prescriptive list)
- **Gates:** 4 (2 confirmed, 2 changed) — plan-approval:changed (v1 plan revised after QC, v2 approved via "proceed per your recommendation"), qc-disposition:changed (REVISE list applied including dropping Fix 3 and switching Fix 2 hook event), scope-selection:confirmed (operator selected 3 fixes via AskUserQuestion, accepted as scope), commit-approval:confirmed (two commits + push approved with single "push" command)
