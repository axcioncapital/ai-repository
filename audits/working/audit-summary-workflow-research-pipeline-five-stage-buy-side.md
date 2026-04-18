# Summary — Workflow Audit: research-pipeline-five-stage (buy-side-service-plan)

**Total findings:** 23 (20 severity-bearing + 3 PASS)
**By severity:** HIGH 5 (1 boundary) | MEDIUM 9 | LOW 6 (1 boundary) | PASS 3

**Workflow start context:** ~2,300 tokens auto-loaded (CLAUDE.md 167 lines + SessionStart hook). No `@`-imports — reference files load on-demand only. Acceptable.

**Stepwise pattern:** Preserved across `run-preparation`, `run-execution`, `run-analysis`, `run-cluster`, `run-synthesis` — `/compact` markers dense at 22 total across these five commands. Subagent returns are file-path-plus-summary (PASS). Stage 3→synthesis fresh-session boundary explicit.

**Top 3 findings:**
1. **HIGH — No `Read(...)` deny rules** in `.claude/settings.json` (only 3 Bash denies). Combined with `additionalDirectories` granting parent-workspace read, Claude Code can explore `/logs/`, `/output/` (164KB+ modules), `/final/`, `/parts/*/drafts/`, old checkpoints during any Glob/Grep.
2. **HIGH — `produce-knowledge-file.md` does not delegate production step.** Step 2 reads all cited chapter files in main session; Step 3 applies the skill inline. Knowledge file produced in main context with full chapter prose materialized. Only the QC step is delegated.
3. **HIGH — `review.md` Step 1 reads 6–7 large files in main session** (chapter prose + architecture spec + style reference + section directive + scarcity register + cluster memo + synthesis brief) BEFORE delegating to qc-gate. Protocol explicitly says ">3–4 large files → delegate." Plausibly 1,000–2,000 lines materialized pre-delegation.

Also HIGH: `run-cluster.md` Step 1 main-session read of cluster extracts (some >250 lines) pre-delegation; `run-analysis.md` Step 1 main-session read of all refined cluster memos pre-delegation (boundary). Refinement multiplier: ~14–16 delegated calls + up to 4 re-entry loops per section (MEDIUM).

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-research-pipeline-five-stage-buy-side.md`. Main session should read the full notes only if a specific finding needs deeper review.
