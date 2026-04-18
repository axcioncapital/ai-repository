# Coaching Data

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
