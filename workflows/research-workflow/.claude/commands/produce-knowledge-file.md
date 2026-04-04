Produce a Chat knowledge file for: $ARGUMENTS

$ARGUMENTS should specify the section (e.g., "1.1", "1.2") or "all" to produce knowledge files for every completed section.

---

### Step 1: Locate Approved Content

Find the cited chapter files for the specified section in `report/chapters/`.

- Cited chapters follow the naming pattern: `{section}-chapter-NN-cited.md`
- Each section produces multiple chapters (e.g., section 1.1 produces chapters 01–04)
- Use `report/{section}-architecture.md` to determine which chapters belong to the requested section

If `all` is specified, identify every section that has a complete set of cited chapters and process each one.

If no cited chapters exist for the specified section, abort and report what was found (or not found) in `report/chapters/`.

---

### Step 2: Read Approved Content

Read all cited chapter files for the section. These are the inputs for the skill.

The knowledge file combines all chapters for a section into a single file — one knowledge file per section, not per chapter.

---

### Step 3: Apply Skill

Read the knowledge-file-producer skill from `/reference/skills/knowledge-file-producer/SKILL.md`.

Apply the skill's logic to produce the knowledge file from the approved content. Follow the skill's heuristics for what to preserve vs. condense, and use the output format specified in the skill.

---

### Step 4: Write Knowledge File

Create the `output/knowledge-files/` directory if it doesn't exist.

Write the knowledge file to: `output/knowledge-files/[section-number]-knowledge-file.md`
(e.g., `output/knowledge-files/1.1-knowledge-file.md`)

If a previous version exists for this section, name the new file with a version suffix: `[section-number]-knowledge-file-v2.md`, v3, etc.

---

### Step 5: QC Knowledge File [delegate-qc]

Run QC as a subagent against the produced knowledge file using the skill's quality criteria. Pass the subagent:
- The knowledge file content
- The cited chapter files (source content)
- The skill file content (for evaluation criteria)

Evaluate against:
1. **Word count** — within 1,500–2,500 target range
2. **Structural artifact preservation** — tables, matrices, lists preserved intact (not summarized to uselessness)
3. **Evidence calibration** — markers preserved from source content
4. **No editorializing** — conclusions match source; no added interpretation beyond downstream implications
5. **Output format compliance** — follows the skill's specified structure and required fields
6. **Downstream implications** — present and actionable for Part 2 consumption
7. **Claim IDs / citation markup stripped** — Code-internal references removed per skill rules

Verdicts: APPROVED or REVISE with findings. If REVISE, apply fixes and re-run QC once. If second pass still flags, pause for operator.

---

### Step 6: Present for Review

Present the knowledge file to the operator for review before finalizing. Note:
- This command does NOT transfer files to Chat
- The knowledge file will be manually downloaded and uploaded to the Chat project
- The output directory is `output/knowledge-files/` — these are cross-cutting artifacts, not part-specific deliverables
