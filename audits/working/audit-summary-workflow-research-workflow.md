# Section 4 Summary — research-workflow (prose sub-pipeline)

**Scope:** produce-architecture, produce-prose-draft, produce-formatting (April 2026 three-command split).
**Telemetry:** Structural inferences from command text; no session telemetry.

**Total findings:** 18 (HIGH 7 | MEDIUM 8 | LOW 3). Boundary-tagged: 4.

**Top 3:**
1. HIGH — produce-prose-draft Phase 3 subagent returns unified findings list (chapter-prose-reviewer + prose-compliance-qc 4 scans + 13 prose-quality checks + expanded detection tests) to main session, explicitly preserved across /compact (line 113). Est. 60–200+ lines.
2. HIGH — Ten SKILL.md files (~29,400 tok total) loaded in main session across the three commands before being passed to subagents. Pattern used for `style-reference.md` and `prose-quality-standards.md` (subagent reads by path) is not applied to skill files.
3. HIGH — produce-formatting Phase 2 subagent returns full H3 decisions table + formatting change log + MTC pre-scan + SPLIT verdicts. Required by design for Phase 4 operator surfacing; 10–20 headings = 50–200+ lines.

**Other HIGH findings (brief):** produce-formatting Phase 3 two-stage QC return (60–200+ lines); source document re-read 3× in prose-draft main session; prose-draft Phase 4 reads all completed prose sections in main session (6–18k tok); architecture Phase 3 re-reads all section drafts in main session.

**MEDIUM themes:** command-file size (produce-prose-draft 203 lines / 4,532 tok); inline Tier 1/2/3 + Standards 10–13 detection tests duplicating prose-quality-standards.md; no /clear between commands; @ reference always-load of stage-instructions; findings-list preservation across /compact; 7–9 subagent launches per section end-to-end.

**LOW:** architecture.md small re-reads; out-of-scope note on run-execution.md size.

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-research-workflow.md`. Main session should read the full notes only if a specific finding needs deeper review.
