# Axcion AI Resource Repository

## Ecosystem Context

This repository contains AI resources (skills, prompts, workflows, project instructions) used across a multi-tool ecosystem:

- **Claude (Chat + Code):** Skill development, document production, synthesis
- **GPT-5 (via API/CustomGPT):** Analytical research execution using embedded SOPs
- **Perplexity (via API):** Factual retrieval and verification research
- **Notion:** Documentation and knowledge management
- **NotebookLM:** Source analysis and synthesis

Skills in this repository are primarily consumed in Claude Chat projects. Do not design skills that assume a single-tool environment.

## Skill File Conventions

All skills live under `skills/` in a flat structure:
```
skills/{skill-name}/
├── SKILL.md          (required)
└── bundled resources  (optional)
    ├── scripts/
    ├── references/
    └── assets/
```

### SKILL.md Structure

Every SKILL.md requires:

- **YAML frontmatter** with `name` and `description` only. The description is the primary trigger mechanism — include what the skill does and when to use it.
- **Markdown body** with procedural instructions. Keep under 500 lines.

Follow progressive disclosure: metadata (~100 words) is always loaded, body loads on trigger, bundled resources load on demand.

### What NOT to Include

Do not create README.md, CHANGELOG.md, INSTALLATION_GUIDE.md, or other auxiliary files. A skill contains only what an AI agent needs to do the job.

## Working Protocol

**New skills or resources:** Propose an outline (purpose, sections, key decisions) and wait for approval before writing the full file.

**Edits to existing files:** Proceed directly with targeted changes.

## Cross-References

Research workflow skills form a pipeline. When modifying any skill in this chain, check downstream skills for impact:
```
research-plan-creator → answer-spec-generator → [external: GPT-5 execution]
→ cluster-analysis-pass → evidence-to-report-writer
```

## Quality Standards

A skill is "done" when:

- Frontmatter description clearly communicates triggers and scope
- Body contains only what Claude needs — no redundant explanation of things Claude already knows
- No extraneous files (README, CHANGELOG, etc.)
- Progressive disclosure is applied: core workflow in SKILL.md, variant details in references/
- At least one test case exists in `tests/{skill-name}/`

## Commit Conventions

- New skills: `new: {skill-name} — {one-line purpose}`
- Edits: `update: {skill-name} — {what changed}`
- Multi-file changes: `batch: {description}`

## Naming

Lowercase, hyphenated: `evidence-pack-validator`, not `EvidencePackValidator`.
