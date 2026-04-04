# Project Setup Checklist

Use this checklist to initialize a new research project from this template.

**Estimated time:** 15–20 minutes.

---

## 1. Copy the template

```bash
cp -r workflows/active/research-workflow/project-template/ projects/[project-name]/
cd projects/[project-name]/
```

Replace `[project-name]` with a kebab-case identifier (e.g., `market-entry-analysis`).

## 2. Initialize git

```bash
git init
```

## 3. Fill CLAUDE.md placeholders

Open `CLAUDE.md` and replace all `{{PLACEHOLDER}}` values:

| Placeholder | What to fill in | Example |
|------------|----------------|---------|
| `{{PROJECT_TITLE}}` | Human-readable project title (used in headings) | `Axcíon Research Workflow — Market Entry Analysis` |
| `{{PROJECT_DESCRIPTION}}` | 2-3 sentences: what the project produces, for whom | `A market entry feasibility study for...` |
| `{{ANALYTICAL_LENS}}` | The analytical framework anchoring the research | `Porter's Five Forces adapted to...` |
| `{{CURRENT_SECTION}}` | Initial section identifier | `1.1 — Market Overview` |
| `{{DOCUMENT_ARCHITECTURE}}` | Document structure (parts, sections, sequence) | `Part 1 (Research, 1.1–1.3) → Part 2 (Strategy, 2.1–2.4)` |
| `{{EVIDENCE_CALIBRATION}}` | Evidence availability and calibration note | `No primary research available. Each section must...` |
| `{{OPERATOR_NAME}}` | Operator's name | `Patrik` |

## 4. Fill stage-instructions.md sequence constraints

Open `reference/stage-instructions.md` and replace `{{PROJECT_TITLE}}` in the title and `{{SECTION_SEQUENCE}}` with your project's section ordering rules. See the HTML comment in that section for an example.

## 5. Fill file-conventions.md title

Open `reference/file-conventions.md` and replace `{{PROJECT_TITLE}}` in the title.

## 5b. Fill quality-standards.md title

Open `reference/quality-standards.md` and replace `{{PROJECT_TITLE}}` in the title.

## 5c. Customize style-guide.md

Open `reference/style-guide.md` and replace `{{PROJECT_TITLE}}` in the title. Review the default document specification and voice notes — customize for your project after the first content draft establishes the voice.

## 6. Create skill symlinks

Symlink all skills from the skill library. From your project root:

```bash
SKILLS_DIR="../../ai-resources/skills"  # adjust relative path if project is not in projects/

for skill in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill")
  # Skip if a local copy already exists (knowledge-file-producer, report-compliance-qc)
  [ -d "reference/skills/$skill_name" ] && continue
  ln -s "$skill" "reference/skills/$skill_name"
done
```

**Verify:** `ls -la reference/skills/` should show symlinks pointing to `ai-resources/skills/`. Local skills (`knowledge-file-producer`, `report-compliance-qc`) remain as real directories.

**Required skills (minimum set for the research workflow):**
- analysis-pass-memo-review
- answer-spec-generator
- answer-spec-qc
- chapter-prose-reviewer
- citation-converter
- cluster-analysis-pass
- cluster-memo-refiner
- cluster-synthesis-drafter
- context-pack-builder
- document-integration-qc
- evidence-prose-fixer
- evidence-spec-verifier
- evidence-to-report-writer
- gap-assessment-gate
- research-plan-creator
- research-question-batcher
- repo-health-analyzer
- research-structure-creator
- section-directive-drafter
- task-plan-creator

Additional skills in the library are symlinked automatically by the loop above. Unused skills have zero cost; missing skills interrupt execution.

## 7. Optional: Create context folder

If the project needs domain-specific reference documents beyond the standard `reference/` files:

```bash
mkdir context/
```

Use this for project briefs, domain knowledge files, content architecture docs, etc.

## 8. Optional: Customize SOPs

Review and adjust `reference/sops/` if the project uses different API configurations or system prompts for Research Execution GPT or Perplexity.

## 9. Write initial task plan draft

Create the first task plan draft:

```bash
touch preparation/task-plans/[section]-task-plan-draft.md
```

Fill it with the section's objective, scope, constraints, and audience. This is the input for `/run-preparation`.

## 10. Initial commit

```bash
git add -A
git commit -m "init: [project-name] workspace from research template"
```

## 11. Validate

Start Claude Code in the project directory, then:

1. Run `/status` — confirm it returns a coherent project summary
2. Run `/run-preparation` — confirm it picks up the task plan draft and begins Stage 1

If either fails, check:
- Skill symlinks resolve correctly (`ls -la reference/skills/`)
- CLAUDE.md has no remaining `{{PLACEHOLDER}}` markers
- settings.json is valid JSON

---

## Placeholder Reference

All placeholders used in template files:

| Placeholder | Files | Purpose |
|------------|-------|---------|
| `{{PROJECT_TITLE}}` | CLAUDE.md, reference/stage-instructions.md, reference/file-conventions.md, reference/quality-standards.md, reference/style-guide.md | Project name in headings |
| `{{PROJECT_DESCRIPTION}}` | CLAUDE.md | Project scope description |
| `{{ANALYTICAL_LENS}}` | CLAUDE.md | Analytical framework |
| `{{CURRENT_SECTION}}` | CLAUDE.md | Starting section |
| `{{DOCUMENT_ARCHITECTURE}}` | CLAUDE.md | Document structure |
| `{{EVIDENCE_CALIBRATION}}` | CLAUDE.md | Evidence availability note |
| `{{OPERATOR_NAME}}` | CLAUDE.md | Operator's name |
| `{{SECTION_SEQUENCE}}` | reference/stage-instructions.md | Section ordering constraints |
