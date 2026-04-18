# DD Extract — 2026-04-18
Source: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/repo-due-diligence-2026-04-18-ai-resources.md
Depth: standard

## Findings

- **[FINDING-1]** Contradiction — CLAUDE.md "Git Rules" (line 56) states "Always show me the diff before committing" but "Commit Rules" (line 66) states "Commit directly. Do not ask for permission." Direct conflict on whether pre-commit review is required. Source: §2.3. Severity hint: high.

- **[FINDING-2]** Missing item — CATALOG.md out of date: 7 skills created after 2026-04-06 are not listed (ai-prose-decontamination, formatting-qc, fund-triage-scanner, intake-processor, workflow-system-analyzer, workflow-system-critic, worktree-cleanup-investigator). Source: §2.4. Severity hint: medium.

- **[FINDING-3]** Violation — `skills/repo-health-analyzer/` contains `command.md` and `agents/` subdirectory, non-standard skill directory structure (only skill with bundled command and agent definitions inside skill directory). Source: §2.4. Severity hint: medium.

- **[FINDING-4]** Missing item — `logs/workflow-observations.md` does not exist but is referenced by `/note` command and `repo-dd` log sweep. Source: §2.5. Severity hint: medium.

- **[FINDING-5]** Missing item — `logs/coaching-log.md` does not exist but is referenced by `/coach` command and `repo-dd` log sweep. Source: §2.5. Severity hint: medium.

- **[FINDING-6]** Discrepancy — `audit-repo` command references `reference/skills/repo-health-analyzer/agents/` which resolves in deployed projects but does not exist in ai-resources itself. Source: §3.1, §4.6. Severity hint: medium.

- **[FINDING-7]** Discrepancy — 40 skills predate 2026-04-06 template update; conformance to "Failure Behavior" section is non-uniform (e.g., cluster-synthesis-drafter and gap-assessment-gate have 0 mentions, evidence-spec-verifier has 4). Source: §4.1, §4.3. Severity hint: low.

- **[FINDING-8]** Violation — 8 skills exceed 300-line convention: answer-spec-generator (485 lines), ai-prose-decontamination (484), research-plan-creator (464), ai-resource-builder (463), evidence-to-report-writer (332), prose-compliance-qc (330), session-guide-generator (320), workflow-evaluator (316). Source: §4.1. Severity hint: low.

- **[FINDING-9]** Discrepancy — Commands use varied opening patterns (YAML frontmatter, prose, h1 heading, usage line) with no enforced format standard. Source: §4.2. Severity hint: low.

- **[FINDING-10]** Violation — `skills/CATALOG.md` is a flat file at `skills/` root instead of within a skill subdirectory, violating the convention that all files under `skills/` live in per-skill subdirectories. Source: §4.4. Severity hint: low.

- **[FINDING-11]** Violation — `usage/` directory exists and is referenced by commands and CLAUDE.md but is not listed in CLAUDE.md "What This Repo Contains" section. Source: §4.5. Severity hint: low.

- **[FINDING-12]** Discrepancy — Three CLAUDE.md sections (What This Repo Contains, How I Work, General Session Rules) are not referenced by any command or hook yet load on every turn as context overhead. Source: §5.2. Severity hint: low.

## Section 1.2 — Hooks Inventory
Skipped — depth=standard, deep-tier sections not requested.

## Section 2 — CLAUDE.md Health
Skipped — depth=standard, deep-tier sections not requested.

## Section 3.4 — Downstream Reference Ranking (Top 10)
Skipped — depth=standard, deep-tier sections not requested.

## Section 5.1 — Context Load Per Entry Point
Skipped — depth=standard, deep-tier sections not requested.

## Section 5.2 — Unreferenced CLAUDE.md Sections
Skipped — depth=standard, deep-tier sections not requested.

## Section 1.7 — Symlinks
Skipped — depth=standard, deep-tier sections not requested.
