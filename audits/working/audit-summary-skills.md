# Section 2 — Skill Census Summary

**Total skills (SKILL.md files):** 69 (67 unique; 2 duplicated in workflows/research-workflow/reference/skills/)
**Total lines:** 14,171 · **Total words:** 120,956 · **Est. tokens:** ~157,243

## Findings by severity
- HIGH: 8 (skills over 300 lines)
- MEDIUM: 36 (skills 150–300 lines; 7 are boundary cases ±15% of 300 threshold)
- LOW: 1 (duplicate skill files — D1)
- Missing frontmatter: 0
- Vague descriptions: 0
- Dead skills (per protocol): 0

## Size distribution
- <50 lines: 0 · 50–150 lines: 25 · 150–300 lines: 35 · >300 lines: 9 (includes 1 boundary at exactly 300)

## Top 3 findings
1. HIGH — 8 skills exceed 300 lines (largest: ai-prose-decontamination.md 484L/6,417 words ≈ 8,342 tokens; answer-spec-generator 485L; research-plan-creator 464L; ai-resource-builder 463L)
2. MEDIUM — 36 skills in the 150–300 line MEDIUM band; 7 within ±15% of the HIGH threshold (boundary findings)
3. LOW — 2 pairs of duplicate SKILL.md files at `/skills/` and `/workflows/research-workflow/reference/skills/` (knowledge-file-producer, report-compliance-qc)

## Notable non-findings
- All 69 files have valid frontmatter (name + description)
- All descriptions include activation triggers and "Do NOT use for" exclusions — no vague descriptions
- No skills carry folder-level deprecation markers; 15 skills have 0 inbound references but none qualifies as "dead" per protocol
- All adjacent-skill pairs (e.g., workflow-creator/documenter/consultant; prose-compliance-qc/report-compliance-qc) are already explicitly demarcated

Full evidence in /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-skills.md. Main session should read the full notes only if a specific finding needs deeper review.
