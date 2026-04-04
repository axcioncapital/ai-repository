---
friction-log: true
---
Execute the cross-cluster Stage 3 pipeline.

Prerequisite check: Verify refined cluster memos exist in `/analysis/cluster-memos/` for all clusters. Verify all have been reviewed (check QC log).

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 1: Load Inputs

1. Read all refined cluster memos from `/analysis/cluster-memos/{section}/`.

---

### Step 2: Gap Assessment [delegate]

1. Read `/ai-resources/skills/gap-assessment-gate/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, all refined cluster memo content, and the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists). Task: execute the gap assessment across all memos, accounting for items already classified as scarcity. Write to `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`. Return: output file path, gap inventory (gap ID, cluster, path classification, severity).
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-2-gap-assessment-checkpoint.md` from the sub-agent's returned summary. Include: gap count, per-gap path classification (A/B), affected clusters.
4. ▸ /compact — skill content and memo content no longer needed; checkpoint carries forward.
5. PAUSE — Present gap assessment to the operator. For each gap:
   - Path B (non-blocking): propose lightweight Perplexity queries
   - Path A (blocking): flag for full Stage 2 re-execution on affected questions
   - The operator approves routing.

---

### Step 3: Supplementary Research (if needed)

1. If Path B gaps approved, execute Subworkflow 3.S (see below).
2. After Subworkflow 3.S completes, re-run gap assessment on affected clusters only: repeat Step 2 scoped to the clusters that received supplementary research. If all gaps are now resolved or classified as scarcity, proceed. If new Path A gaps surface, PAUSE for operator routing.

---

### Step 4: Section Directives [delegate]

1. Read `/ai-resources/skills/section-directive-drafter/SKILL.md`.
2. For each cluster, launch a general-purpose sub-agent. Pass it: the skill content, the cluster's refined memo, and the scarcity register (`/execution/scarcity-register/{section}/{section}-scarcity-register.md`) as a required input. Task: execute the skill logic for this cluster. Each directive must reference any scarcity items for its cluster and specify the editorial instruction (HEDGE / SCOPE CAVEAT / PROXY FRAMING). Write to `/analysis/section-directives/{section}/{section}-cluster-NN-directive.md`. Return: output file path, scarcity items referenced, key editorial decisions.
   - Launch sub-agents in parallel for independent clusters.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-4-directives-checkpoint.md`. Include: directive file inventory (cluster → file path), scarcity items referenced per directive.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5: Memo Review [delegate]

1. Read `/ai-resources/skills/analysis-pass-memo-review/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, all refined cluster memos, and all section directives. Task: execute the editorial decision surfacing review. Write to `/analysis/editorial-review/{section}/{section}-memo-review.md`. Return: output file path, editorial decisions surfaced, flags for operator attention.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5-memo-review-checkpoint.md`. Include: output file path, count of editorial decisions surfaced, severity flags.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5b: Generate Editorial Recommendations [delegate]

1. Read `/ai-resources/skills/editorial-recommendations-generator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, `/analysis/editorial-review/{section}/{section}-memo-review.md`, all refined cluster memos, the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md`, and all section directives. Task: generate recommended answers for all editorial decisions. Write to `/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`. Return: output file path, recommendation count, any confidence flags.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5b-recommendations-checkpoint.md`. Include: output file path, recommendation count, confidence flags, scarcity editorial instructions recommended.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5c: QC Editorial Recommendations [delegate-qc]

1. Read `/ai-resources/skills/editorial-recommendations-qc/SKILL.md`.
2. Launch a sub-agent (qc-gate type for independence). Pass it: the skill content, `/analysis/editorial-review/{section}/{section}-memo-review.md`, `/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`, all refined cluster memos, the scarcity register, and all section directives. Task: independently derive recommendations from the evidence, then compare against the originals and score each. Write to `/analysis/editorial-review/{section}/{section}-qc-editorial-decisions.md`. Return: output file path, verdict distribution (AGREE/DISAGREE/NUANCE counts), flagged disagreements.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5c-qc-checkpoint.md`. Include: output file path, verdict distribution, list of DISAGREE items.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5d: Approve Editorial Decisions [auto-delegate]

Launch a general-purpose sub-agent to make editorial calls based on the QC results. This step runs automatically — no operator pause.

1. Launch a general-purpose sub-agent. Pass it: the memo review (`{section}-memo-review.md`), recommendations (`{section}-memo-review-recommendations.md`), and QC report (`{section}-qc-editorial-decisions.md`). Task: apply the following decision logic and write approved decisions.

   **Decision logic:**
   - QC AGREE → Accept recommendation as-is
   - QC NUANCE → Accept recommendation with the QC's proposed adjustment applied
   - QC DISAGREE → **PAUSE for operator** — do not auto-approve. Present the disagreement with both positions and evidence for operator decision.

   **Confidence flag handling:**
   - LOW CONFIDENCE: Accept recommendation but preserve the alternative framing as a noted option for operator review at synthesis stage
   - ASSUMPTION-DEPENDENT: Accept, noting the assumption (PE fund audience)
   - DEPENDENCY flags: Verify consistency across all linked decisions before approving

   **Write to:** `/analysis/editorial-review/{section}/{section}-editorial-decisions-approved.md`

   **Output format:**
   ```
   # Approved Editorial Decisions — Section {section}
   **Date:** [date]
   **Approved by:** Editorial Decision Agent (operator-delegated)
   **Basis:** Recommendations + QC ([n] AGREE, [n] NUANCE adjusted, [n] DISAGREE)

   ## Scarcity Register Instructions (Approved)
   [Table: item, instruction, rationale]

   ## Approved Decisions
   [Per decision: ID, decision, rationale (1 line), QC status]

   ## Nuance Adjustments Applied
   [Items showing what was adjusted per QC]

   ## Noted Alternatives (LOW CONFIDENCE items)
   [Alternative framings preserved for operator review at synthesis]

   ## Dependency Consistency Check
   [Verification that linked decisions are aligned]
   ```

2. If any QC DISAGREE items exist, PAUSE and present them to the operator with both positions. Resume only after operator resolves each disagreement.
3. Append QC log entry to `/logs/qc-log.md`:
   ```
   ## [date] — Section {section}, Step 3.6 Gate
   - **Artifact:** Editorial decisions ([n] decisions + [n] scarcity items)
   - **Verdict:** APPROVED (agent-delegated) / APPROVED (operator-resolved [n] disagreements)
   - **Basis:** Recommendations QC: [n] AGREE, [n] NUANCE (adjusted), [n] DISAGREE
   - **Files:** `analysis/editorial-review/{section}/{section}-editorial-decisions-approved.md`
   ```
4. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5d-approved-checkpoint.md`.
5. ▸ /compact

---

### Step 6: Hand Off to Synthesis

After editorial decisions are approved, log and hand off.

1. Present: "Memos, directives, and editorial decisions approved. Start a new session and run `/run-synthesis` for chapter drafting with fresh context."

---

### Subworkflow 3.S: Lightweight Supplementary Research

**Trigger:** Gap assessment identifies Path B (non-blocking) gaps, and operator approves routing.

**Prompt files:** All prompts live in `/ai-resources/prompts/supplementary-research/`. Claude Code reads each prompt file, substitutes project inputs into the placeholders, and executes. The operator's only manual step is S.2 (Perplexity queries).

**Inputs:**
- Path B gap items from `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`
- Relevant cluster memos from `/analysis/cluster-memos/{section}/`
- Research extracts for context

**S.0 — Extract Failed Components [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S0-extract-failed-components.md`. Execute against the gap assessment report from `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`, scoped to Path B items only. Write output to `/analysis/gap-supplementary/cluster-NN-failed-components.md`.

**S.1 — Draft Query Brief [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S1-query-brief-pass1.md` (or `S1-query-brief-pass2.md` for pass 2). Execute using: the failed components extraction, relevant Research Extracts from `/execution/research-extracts/{section}/`, and cluster memos. For pass 2, also include: the pass 1 Query Brief and pass 1 raw Perplexity output. Write output to `/analysis/gap-supplementary/cluster-NN-query-brief-pass-N.md`.

**PAUSE — S.2 — Execute in Perplexity [Operator]**
Present the query brief's Section B (Execution Sheet) to the operator. He runs queries manually in Perplexity Pro Search (no API). The operator pastes raw Perplexity output back into Claude Code. Write raw output to `/analysis/gap-supplementary/cluster-NN-perplexity-raw-pass-N.md`.

**S.3 — QC Results [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S3-qc-supplementary-results.md`. Execute against: the raw Perplexity output, Research Extracts, and Query Brief Section A. Write QC report to `/analysis/gap-supplementary/cluster-NN-qc-pass-N.md`. PAUSE for operator to confirm merge/skip verdicts.

**S.4 — Integrate into cluster memos [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S4-merge-instructions.md`. For each MERGE-approved finding:
   - Add to the relevant cluster memo's evidence base
   - Tag supplementary sources with `[SUPPLEMENTARY-PASS-N]`
   - Include **Route Out editorial instructions** where gaps could not be fully resolved: specify hedging language, scope caveats, or proxy framing that the cluster memo should carry forward to section directives and report prose.

**S.5 — Checkpoint and compact**
Write checkpoint to `/analysis/checkpoints/{section}/{section}-3S-pass-N-checkpoint.md`. Include: queries executed, findings per gap, memos updated, gaps resolved vs remaining, scarcity candidates. ▸ /compact — supplementary pass context no longer needed.

If still insufficient after pass 1: repeat S.0–S.5 as pass 2.

**Two-pass maximum (hard constraint):** Track pass count via file naming (`cluster-NN-query-brief-pass-1.md`, `cluster-NN-query-brief-pass-2.md`). Maximum 2 passes per question. After 2 passes, remaining gaps are classified as confirmed evidence scarcity.

**Scarcity handling:** Update `/execution/scarcity-register/{section}/{section}-scarcity-register.md` with any newly confirmed scarcity items from Stage 3. These follow the same format and operator-selected editorial instructions as Stage 2 scarcity items.

**After Subworkflow 3.S completes:** Re-run gap assessment on affected clusters only (handled by Step 3.2 above). If all gaps resolved or classified as scarcity, proceed to Step 4 (Section Directives).

**Outputs:**
- `/analysis/gap-supplementary/cluster-NN-*.md` (per-step supplementary artifacts)
- Updated cluster memos with integrated findings and Route Out instructions
- Updated `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if new scarcity items confirmed)
