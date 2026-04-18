# Section 4 Summary — research-workflow

**Workflow:** research-workflow (5-stage template: Preparation → Execution → Analysis → Report Production → Final Production)
**Telemetry label:** Structural inferences only (no session telemetry available).

**Total findings:** 20 — HIGH: 10, MEDIUM: 7, LOW: 3

**Context-loading chain at workflow start (main-session per-turn cost):**
- CLAUDE.md chain (workspace + ai-resources + workflow): 345 lines / ~5,396 tokens
- If `@`-referenced stage-instructions/file-conventions/quality-standards/style-guide auto-load: ~11,017 tokens
- Per-invocation command overhead: 264–4,307 tokens (largest: `produce-prose-draft.md` at 207 lines / 3,313 words)
- 34 skills loaded into main session across the pipeline (largest: `ai-prose-decontamination` 484 lines / ~8,342 tokens; 4 skills >300 lines)
- Subagent count per section run: 40+ launches (preparation 6 + execution 7–15 + 3a 12 per 6 clusters + 3b 8+ + synthesis 6 + report 24 for 6 chapters)

**Top 3 findings:**
1. `run-report.md` Step 4.0 loads 6 file categories (all chapter drafts, scarcity register, all section directives, all refined cluster memos, all research extracts, editorial recommendations) into main session before any delegation — 30+ files for a 6-cluster project. [HIGH]
2. Workflow's context-isolation rule ("sub-agents receive content, not file paths" — CLAUDE.md line 53) forces every delegated step to read all inputs into main session first. Systemic driver of Stage 3b/4 token cost. [HIGH]
3. Subworkflow 3.S (gap-supplementary) and 2.S (supplementary research) steps S.0/S.1/S.3/S.4 run inline in main session and each read 3–5 files — violates protocol "3–4 files → subagent" rule. [HIGH]

Also notable: (a) `run-report.md` Step 4.2a return includes "chapter draft content" → full prose (~1,000–3,000 tokens) returns to main [HIGH]; (b) no custom `/compact` preservation instructions in workflow CLAUDE.md [MEDIUM]; (c) refinement multiplier 12–20+ passes per section [MEDIUM].

Full evidence in /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-research-workflow.md. Main session should read the full notes only if a specific finding needs deeper review.
