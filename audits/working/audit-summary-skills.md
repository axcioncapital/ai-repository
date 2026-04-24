---
section: 2
audit_date: 2026-04-24
protocol_version: 1.2
---

# Section 2 Summary: Skill Census

**Total skills:** 69 (67 canonical + 2 workflow-reference copies)
**Total lines:** 14,334 | **Total words:** 126,050 | **Est. tokens:** ~164,000

## Findings Count

- **HIGH:** 6 (skills >300 lines)
- **MEDIUM:** 1 (multi-mode bloat + high word density)
- **LOW:** 2 (vague descriptions, file duplicates)
- **Boundary findings:** 4 (within ±15% of 300-line threshold)

## Top 3 Findings

1. **Six oversized skills (HIGH):** `answer-spec-generator` (485L), `research-plan-creator` (464L), `ai-resource-builder` (401L), `evidence-to-report-writer` (332L), `workflow-evaluator` (316L), `ai-prose-decontamination` (314L). Combined ~19,000 estimated tokens.

2. **Multi-mode skills load unused content (MEDIUM):** `ai-resource-builder` (3 modes) and `answer-spec-generator` (5 modes) combine independent workflows into single files. Splitting would save 1,500–2,000 tokens/session.

3. **Workflow reference copies duplicate canonical skills (LOW):** `knowledge-file-producer` and `report-compliance-qc` exist in both `skills/` and `workflows/research-workflow/reference/skills/`. Intentional (workflow self-containment) but creates maintenance risk.

## Quality Metrics

- Frontmatter complete: 100% (all 69 skills)
- Descriptions trigger-rich: 97% (67 of 69)
- Dead skills: 0
- Semantic redundancy: 0
- Size distribution: 0% (<50L) | 35% (50–150L) | 57% (150–300L) | 9% (>300L)

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-skills.md`.
