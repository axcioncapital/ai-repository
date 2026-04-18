# Summary — Service Development Workflow Token Audit (buy-side-service-plan)

**Workflow:** Parts 2–3 and Working Hypotheses drafting lifecycle
**Scope:** local `.claude/commands/` + `.claude/agents/` + `/context/`
**Total findings:** 10

**By severity:**
- HIGH: 3 (1 tagged boundary)
- MEDIUM: 5
- LOW: 2

**Top 3 findings:**
1. [HIGH] Three QC commands (`/review`, `/challenge`, `/service-design-review`) return full findings (3,000–8,000 tokens each) to main session instead of writing reports to disk — ~10,500–19,000 tokens per draft iteration accumulating across three layers.
2. [HIGH] Main session re-reads full draft file (up to 640 lines / ~18,800 tokens) after every `/draft-section` Phase 3 completion; subagent's Step 7 return summary already contains what the main session needs.
3. [MEDIUM] `/draft-section` has no `/compact` breakpoints; with 9 iterations on section 2.8, cumulative token load in main session can exceed ~200,000 tokens without compaction.

**Context sizing highlights:**
- `context/prose-quality-standards.md`: 753 lines / ~10,215 tokens (boundary on load-path attribution)
- `context/doc-2-production-plan.md`: 340 lines / ~4,853 tokens
- `parts/part-2-service/drafts/2.8-draft-04.md`: 641 lines / ~18,858 tokens
- `/context/` total: 1,797 lines / ~25,420 tokens

**Subagent read pattern:** Good — section-drafter, strategic-critic, service-designer, qc-reviewer all read source files directly via Read/Glob/Grep tools; no main-session content transfer for context files.

**CLAUDE.md↔implementation mismatch:** Part 1 references documented at `/report/chapters/` + `/final/modules/` but subagent maps to `/output/knowledge-files/`; `/final/modules/` is empty.

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-service-development-buy-side.md`. Main session should read the full notes only if a specific finding needs deeper review.
