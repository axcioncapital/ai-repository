# Section 6 File Handling Patterns — Working Notes

**Date:** 2026-04-18
**AUDIT_ROOT:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
**Protocol:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-protocol.md (Section 6)

## Step 6.2 — Read(pattern) deny-rule status (re-used from Step 0.3)

**Verdict: HIGH** — No `Read(...)` deny rules exist anywhere under AUDIT_ROOT.

- Covered directories: NONE
- Missing expected coverage (all): `audits/`, `logs/`, `reports/`, `inbox/`, `archive/` (directory not present), `output/` (not present), `drafts/` (not present)
- Source: `audit-working-notes-preflight.md` lines 22–46

**Consequence for Section 6:** Every file flagged below sits in a directory NOT covered by a `Read(...)` deny. This is universal, not per-file.

## Step 6.1 — Large-file scan (merged by word count and line count)

Scan spec: `find AUDIT_ROOT -not -path "./.git/*" -not -path "*/node_modules/*" \( -name "*.md" -o -name "*.json" -o -name "*.txt" -o -name "*.csv" -o -name "*.yaml" -o -name "*.yml" \)`.

Inclusion threshold per protocol: ">200 lines" for the unignored-large-file assessment. All files below meet that threshold on line count or are in the top 20 by word count. Merged and deduplicated.

### Full merged list (files >200 lines, sorted by lines descending)

| # | File (relative to AUDIT_ROOT) | Lines | Words | Category | Should Claude read? | In dir covered by Read() deny? |
|---|-------------------------------|------:|------:|----------|---------------------|-------------------------------|
| 1 | audits/repo-due-diligence-2026-04-11.md | 857 | 6326 | Prior audit report | No | No |
| 2 | audits/repo-due-diligence-2026-04-12.md | 824 | 6883 | Prior audit report | No | No |
| 3 | logs/session-notes.md | 800 | 9304 | Session history log | No | No |
| 4 | audits/repo-due-diligence-2026-04-06.md | 691 | 4699 | Prior audit report | No | No |
| 5 | audits/token-audit-protocol.md | 632 | 5817 | Active protocol (this audit) | Yes | No |
| 6 | skills/answer-spec-generator/SKILL.md | 485 | 3687 | Active skill | Yes | No |
| 7 | skills/ai-prose-decontamination/SKILL.md | 484 | 6417 | Active skill | Yes | No |
| 8 | skills/research-plan-creator/SKILL.md | 464 | 3504 | Active skill | Yes | No |
| 9 | skills/ai-resource-builder/SKILL.md | 463 | 3295 | Active skill | Yes | No |
| 10 | skills/research-prompt-creator/references/prompt-construction-guide.md | 385 | 3195 | Active skill reference | Yes | No |
| 11 | audits/workflow-analysis-research-workflow-2026-04-07.md | 360 | 4283 | Prior audit report | No | No |
| 12 | .claude/commands/new-project.md | 351 | 3552 | Active command | Yes | No |
| 13 | skills/evidence-to-report-writer/SKILL.md | 332 | 3424 | Active skill | Yes | No |
| 14 | skills/prose-compliance-qc/SKILL.md | 330 | 2420 | Active skill | Yes | No |
| 15 | audits/workflow-analysis-global-macro-analysis-2026-04-11.md | 330 | 2659 | Prior audit report | No | No |
| 16 | skills/session-guide-generator/SKILL.md | 320 | 2116 | Active skill | Yes | No |
| 17 | .claude/commands/deploy-workflow.md | 317 | 1770 | Active command | Yes | No |
| 18 | skills/workflow-evaluator/SKILL.md | 316 | 2509 | Active skill | Yes | No |
| 19 | skills/worktree-cleanup-investigator/references/execution-protocol.md | 310 | 3766 | Active skill reference | Yes | No |
| 20 | skills/ai-resource-builder/references/evaluation-framework.md | 307 | 2133 | Active skill reference | Yes | No |
| 21 | .claude/commands/repo-dd.md | 301 | 2626 | Active command | Yes | No |
| 22 | skills/workflow-system-critic/SKILL.md | 300 | 2357 | Active skill | Yes | No |
| 23 | skills/implementation-spec-writer/SKILL.md | 294 | 1699 | Active skill | Yes | No |
| 24 | skills/decision-to-prose-writer/SKILL.md | 290 | 2348 | Active skill | Yes | No |
| 25 | skills/prose-formatter/SKILL.md | 287 | 3194 | Active skill | Yes | No |
| 26 | audits/working/audit-working-notes-skills.md | 287 | 2741 | Generated audit working notes (this session) | No | No |
| 27 | skills/workflow-system-analyzer/SKILL.md | 274 | 1851 | Active skill | Yes | No |
| 28 | skills/fund-triage-scanner/SKILL.md | 263 | 1658 | Active skill | Yes | No |
| 29 | skills/section-directive-drafter/SKILL.md | 259 | 2293 | Active skill | Yes | No |
| 30 | skills/task-plan-creator/SKILL.md | 245 | 1465 | Active skill | Yes | No |
| 31 | skills/citation-converter/SKILL.md | 245 | 2140 | Active skill | Yes | No |
| 32 | audits/repo-dd-deep-2026-04-06.md | 245 | 2674 | Prior audit report | No | No |
| 33 | skills/spec-writer/SKILL.md | 242 | 2107 | Active skill | Yes | No |
| 34 | skills/worktree-cleanup-investigator/SKILL.md | 241 | 3133 | Active skill | Yes | No |
| 35 | skills/supplementary-query-brief-drafter/SKILL.md | 241 | 2668 | Active skill | Yes | No |
| 36 | skills/architecture-designer/SKILL.md | 239 | 2087 | Active skill | Yes | No |
| 37 | skills/context-pack-builder/SKILL.md | 231 | 1420 | Active skill | Yes | No |
| 38 | skills/worktree-cleanup-investigator/references/decision-taxonomy.md | 230 | 2027 | Active skill reference | Yes | No |
| 39 | skills/research-prompt-creator/SKILL.md | 220 | 3415 | Active skill | Yes | No |
| 40 | skills/project-tester/SKILL.md | 220 | 1354 | Active skill | Yes | No |
| 41 | skills/curiosity-hub-article-writer/SKILL.md | 216 | 2005 | Active skill | Yes | No |
| 42 | skills/editorial-recommendations-generator/SKILL.md | 215 | 1390 | Active skill | Yes | No |
| 43 | .claude/agents/collaboration-coach.md | 209 | 1764 | Active agent def | Yes | No |
| 44 | workflows/research-workflow/.claude/commands/produce-prose-draft.md | 207 | 3313 | Active command | Yes | No |
| 45 | skills/implementation-project-planner/SKILL.md | 207 | 1437 | Active skill | Yes | No |
| 46 | skills/research-structure-creator/SKILL.md | 205 | 2468 | Active skill | Yes | No |
| 47 | skills/answer-spec-qc/SKILL.md | 205 | 1957 | Active skill | Yes | No |
| 48 | skills/chapter-review/SKILL.md | 201 | 1895 | Active skill | Yes | No |

### Additional dense files (under 200 lines but in top 20 by word count)

| File | Lines | Words | Category | Should Claude read? | Covered? |
|------|------:|------:|----------|---------------------|----------|
| logs/decisions.md | 124 | 5461 | Decision log (historical) | No | No |
| inbox/codex-second-opinion-brief.md | 182 | 2259 | Prior brief (archival inbox item) | No | No |
| inbox/worktree-cleanup-brief.md | 97 | 1511 | Prior inbox brief | No | No |
| workflows/research-workflow/reference/stage-instructions.md | 129 | 2208 | Active workflow reference | Yes | No |
| audits/questionnaire.md | 137 | 1328 | Audit artifact | No | No |
| reports/repo-health-report.md | 137 | 1340 | Generated report | No | No |
| audits/workflow-critique-research-workflow-2026-04-07.md | ~135 | 1852 | Prior audit report | No | No |
| audits/workflow-critique-global-macro-analysis-2026-04-11.md | ~115 | 1431 | Prior audit report | No | No |
| audits/token-audit-2026-04-18-ai-resources.md | ~150 | 1658 | Active audit output (in progress) | Mixed (active during this session, archival after) | No |

## Step 6.3 — Assessment

### Assessment 1: Unignored large files in directories that should not be read

Every file marked "No" in the "Should Claude read this?" column sits in a directory with zero `Read(...)` deny coverage. Findings grouped by directory:

**Directory `audits/`** — contains 9 archival/historical files totaling roughly 3,730 lines / 36,650 words. Prior due-diligence reports (repo-due-diligence-2026-04-06/11/12.md) alone total 2,372 lines / 17,908 words. Plus prior workflow-analysis files and the audit questionnaire. All are archival — none are active instructions that a routine session needs. Parent dir NOT covered by any Read() deny.

**Directory `logs/`** — contains `session-notes.md` (800 lines / 9,304 words), `decisions.md` (124 lines / 5,461 words), `coaching-data.md` (95 lines / 865 words), `innovation-registry.md` (41 lines / 465 words). `session-notes.md` alone is the largest single file in the entire repo by word count. All are historical logs that should not load during routine skill/command work. Parent dir NOT covered.

**Directory `inbox/`** — contains 3 briefs totaling 342 lines / 4,320 words plus `.gitkeep`. Briefs are consumed once by `/create-skill`; once processed they are archival. Parent dir NOT covered.

**Directory `reports/`** — contains `repo-health-report.md` (137 lines / 1,340 words). Generated output from a prior run. Parent dir NOT covered.

**Directory `audits/working/`** — contains this audit's own in-progress working notes and summaries (audit-working-notes-preflight.md, audit-working-notes-skills.md at 287 lines / 2,741 words, audit-summary-skills.md). Active only during this audit session; archival afterwards. Parent dir NOT covered.

### Assessment 2: Output files from previous sessions

Per protocol, "Are outputs from previous sessions (reports, analyses, context packs, audit artifacts) sitting in the repo where Claude Code might read them unnecessarily?"

Identified output artifacts that sit at paths a future session might read during exploration:

- `audits/repo-due-diligence-2026-04-06.md` (691 lines / 4,699 words) — prior DD report
- `audits/repo-due-diligence-2026-04-11.md` (857 lines / 6,326 words) — prior DD report
- `audits/repo-due-diligence-2026-04-12.md` (824 lines / 6,883 words) — prior DD report
- `audits/repo-dd-deep-2026-04-06.md` (245 lines / 2,674 words) — prior DD deep-dive
- `audits/workflow-analysis-research-workflow-2026-04-07.md` (360 lines / 4,283 words) — prior workflow analysis
- `audits/workflow-analysis-global-macro-analysis-2026-04-11.md` (330 lines / 2,659 words) — prior workflow analysis
- `audits/workflow-critique-research-workflow-2026-04-07.md` (~135 lines / 1,852 words) — prior critique
- `audits/workflow-critique-global-macro-analysis-2026-04-11.md` (~115 lines / 1,431 words) — prior critique
- `audits/questionnaire.md` (137 lines / 1,328 words) — audit questionnaire
- `reports/repo-health-report.md` (137 lines / 1,340 words) — prior health report
- `logs/session-notes.md` (800 lines / 9,304 words) — cumulative session history
- `logs/decisions.md` (124 lines / 5,461 words) — cumulative decision log
- `logs/coaching-data.md` (95 lines / 865 words) — coaching capture
- `logs/innovation-registry.md` (41 lines / 465 words) — innovation log
- `inbox/codex-second-opinion-brief.md` (182 lines / 2,259 words) — prior brief
- `inbox/repo-review-brief.md` (63 lines / 550 words) — prior brief
- `inbox/worktree-cleanup-brief.md` (97 lines / 1,511 words) — prior brief
- `audits/working/audit-working-notes-preflight.md` (46 lines / 272 words) — this audit's working notes
- `audits/working/audit-working-notes-skills.md` (287 lines / 2,741 words) — this audit's working notes
- `audits/working/audit-summary-skills.md` (28 lines / 243 words) — this audit's working summary
- `audits/token-audit-2026-04-18-ai-resources.md` (~150 lines / 1,658 words) — this audit's report (in progress)

All 21 output/archival files have parent directories NOT covered by any `Read(...)` deny rule.

### Assessment 3: Workspace hygiene — deprecated/temporary/drafted files

Marker scan run: filename contains `draft`, `tmp`, `old`, `deprecated`, `archive`, or dated variants (`v1`, `2024-`); folder named `archive`, `deprecated`, or `old`.

**Results:**

- No `archive/`, `deprecated/`, `old/`, `drafts/`, `tmp/` directories exist under AUDIT_ROOT.
- Filename-marker matches: `./workflows/research-workflow/.claude/commands/produce-prose-draft.md` — matches `draft` marker, but name describes its function (drafts prose), not a draft/temporary status. Inspected: active command file, not stale.
- No files with `v1`, `v2`, `old`, `deprecated`, `tmp`, or `archive` markers in AUDIT_ROOT filenames.
- Dated variants: all dated files (`repo-due-diligence-2026-04-06/11/12.md`, `workflow-analysis-*-2026-04-07.md`, `repo-dd-deep-2026-04-06.md`, `workflow-critique-*-2026-04-07/11.md`, `token-audit-2026-04-18-*.md`) are the canonical naming convention for archival audit outputs, not drafts — they are listed under Assessment 2 as output clutter, not under deprecated/draft hygiene.
- Superseded versions: three repo-due-diligence files (04-06, 04-11, 04-12) suggest 04-06 and 04-11 are superseded by 04-12 (same report type, later date). No explicit deprecation markers, but naming implies succession.

No explicitly-labeled deprecated/draft/tmp files found. LOW-severity workspace-hygiene finding is limited to the implicit supersession in `audits/`.

## Findings (severity per Section 6 classification)

Severity rules (from protocol §6):
- No `Read(...)` deny rules at all (from Step 0.3) → HIGH
- Missing `Read(...)` deny coverage for >2 expected directories → MEDIUM (subsumed by HIGH)
- Large data/output files in directories not covered by a `Read(...)` deny → MEDIUM per directory
- Deprecated/temporary files cluttering the repo → LOW

| # | Finding | Severity | Evidence | Scope |
|---|---------|----------|----------|-------|
| 1 | No `Read(...)` deny rules exist at all in AUDIT_ROOT settings. Claude Code may freely Glob/Grep/Read any file including archival reports, logs, inbox briefs, and working audit notes. | HIGH | Pre-flight 0.3 verdict (HIGH); 2 settings files examined (`ai-resources/.claude/settings.json`, `workflows/research-workflow/.claude/settings.json`); neither contains any `Read(...)` entry in `permissions.deny`. | Repo-wide |
| 2 | `audits/` directory contains large archival output files not covered by any Read() deny. 9 archival files ≈ 3,730 lines / 36,650 words, including 3 DD reports totaling 2,372 lines / 17,908 words. | MEDIUM | `audits/repo-due-diligence-2026-04-06.md` (691 L / 4,699 W), `...-04-11.md` (857 L / 6,326 W), `...-04-12.md` (824 L / 6,883 W), `repo-dd-deep-2026-04-06.md` (245 L / 2,674 W), `workflow-analysis-research-workflow-2026-04-07.md` (360 L / 4,283 W), `workflow-analysis-global-macro-analysis-2026-04-11.md` (330 L / 2,659 W), `workflow-critique-research-workflow-2026-04-07.md` (~135 L / 1,852 W), `workflow-critique-global-macro-analysis-2026-04-11.md` (~115 L / 1,431 W), `questionnaire.md` (137 L / 1,328 W). | `audits/` |
| 3 | `logs/` directory contains large historical session logs not covered by any Read() deny. 4 files ≈ 1,060 lines / 16,095 words. `session-notes.md` is the largest single file in the repo by word count (9,304 W). | MEDIUM | `logs/session-notes.md` (800 L / 9,304 W), `logs/decisions.md` (124 L / 5,461 W), `logs/coaching-data.md` (95 L / 865 W), `logs/innovation-registry.md` (41 L / 465 W). | `logs/` |
| 4 | `inbox/` directory contains prior skill-request briefs not covered by any Read() deny. 3 briefs ≈ 342 lines / 4,320 words. | MEDIUM | `inbox/codex-second-opinion-brief.md` (182 L / 2,259 W), `inbox/worktree-cleanup-brief.md` (97 L / 1,511 W), `inbox/repo-review-brief.md` (63 L / 550 W). | `inbox/` |
| 5 | `reports/` directory contains generated output not covered by any Read() deny. | MEDIUM | `reports/repo-health-report.md` (137 L / 1,340 W). | `reports/` |
| 6 | `audits/working/` directory contains in-progress audit working notes not covered by any Read() deny. Will become archival clutter once this session ends. | MEDIUM | `audits/working/audit-working-notes-preflight.md` (46 L / 272 W), `audit-working-notes-skills.md` (287 L / 2,741 W), `audit-summary-skills.md` (28 L / 243 W); post-session, audit report `audits/token-audit-2026-04-18-ai-resources.md` (~150 L / 1,658 W). | `audits/` and `audits/working/` |
| 7 | Three prior repo-due-diligence reports (04-06, 04-11, 04-12) coexist; the two earlier files appear implicitly superseded by the 04-12 version by date-succession naming, but no explicit deprecation marker exists. | LOW | `audits/repo-due-diligence-2026-04-06.md` (691 L), `...-04-11.md` (857 L), `...-04-12.md` (824 L). | `audits/` |

## Protocol gaps

- Protocol §6 does not specify how to classify active in-session audit outputs (e.g., `audits/working/audit-working-notes-*.md`, `audits/token-audit-2026-04-18-*.md`) that are "active" during this session but become archival afterward. Classified them as "No — Claude should not read during future sessions" with a note that they are active-now. Marked under Findings #6.
- Protocol §6 says "large files (>200 lines)" for assessment #1 but §6.1 scan produces top-20 lists. I applied the 200-line threshold to the merged list and additionally included dense low-line / high-word files (e.g., `logs/decisions.md`: 124 L / 5,461 W). Documented both sets above.
- Ambiguity: `audits/token-audit-protocol.md` (632 L / 5,817 W) is at the border — it's the active protocol for this audit (read by the auditor subagents), but sits in `audits/` which is otherwise archival. Classified as "Yes" to read during token-audit sessions, but its parent dir should still be Read()-denied for non-audit sessions. No per-file exemption mechanism required — file-scope Read() rules are supported.

## Threshold-boundary findings (±15% of severity threshold)

None. The HIGH severity for Finding #1 is categorical ("no rules at all"), not threshold-proximate. MEDIUM severities for Findings #2–6 are per-directory findings triggered by presence of large output files, not by a numeric threshold. LOW severity for Finding #7 is categorical (supersession by implication).

The 200-line threshold used in Assessment #1 is not a severity threshold under §6 (severities are defined per-directory, not per-file-size), so boundary tagging does not apply to the per-file line counts.
