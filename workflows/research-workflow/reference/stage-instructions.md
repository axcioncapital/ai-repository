# Stage Instructions — {{PROJECT_TITLE}}

> **When to read this file:** At the start of any stage, or when a slash command triggers a stage transition. Not needed for every turn.

## Sequence Constraints

{{SECTION_SEQUENCE}}

<!-- Replace with your project's section ordering and co-dependency rules. Example:
1. Working Hypotheses before any Part 1 research
2. Part 1 sections in order: 1.1 → 1.2 → 1.3 → 1.4
3. Part 1 complete before Part 2 begins
-->

## Stage 1: Preparation

- Read task plan draft (loaded via @ reference)
- Apply `task-plan-creator` logic to produce `/preparation/task-plans/{section}-task-plan-v1.md`
- GATE: Operator reviews Task Plan.
- After Task Plan approval: update the Project Context section of CLAUDE.md with the approved Task Plan's objective, scope, constraints, and audience.
- Apply `research-plan-creator` logic to produce research plan in `/preparation/research-plans/`
- GATE: Operator reviews Research Plan before proceeding to answer specs.
- Apply `answer-spec-generator` logic to produce answer specs in `/preparation/answer-specs/{section}/`
- Run `answer-spec-qc` logic. Write verdicts to `/preparation/answer-specs/{section}/answer-specs-qc.md`
- GATE: Do not proceed to Stage 2 until operator confirms answer specs are approved.

## Stage 2: Execution

- **Step 2.0 — Create Execution Manifest [Claude Project]:** Read approved Research Plan and Answer Specs. Apply `execution-manifest-creator` to route each question to an execution tool (Research Execution GPT or Perplexity), design session groupings, and plan execution waves. Write to `/execution/manifest/{section}/{section}-execution-manifest.md`. GATE: Operator reviews session architecture before proceeding.
- **Step 2.1 — Create Execution Prompts [Claude Project]:** Read approved Execution Manifest, Research Plan, and Answer Specs. Apply `research-prompt-creator` to create session prompts for all routed questions, following the manifest's session groupings. Research Execution GPT: target 2 questions per session (1 or 3 acceptable with justification), no hard session cap. Write each session prompt to its own file under `/execution/research-prompts/{section}/`.
- **Step 2.1b — QC Execution Prompts [delegate-qc]:** Run `research-prompt-qc` as subagent against the prompts, answer specs, and research plan. Write verdict to `/execution/checkpoints/{section}/{section}-step-2.1b-prompt-qc.md`. If APPROVED, proceed automatically. If REVISE with only Moderate findings, apply fixes and re-run once. If Critical findings or second pass still flags, pause for operator.
- **Transition to Step 2.2:** When Step 2.1b passes, write the execution mapping to the session notes entry (Next Steps section). Include: session table (session, questions, topic, prompt file path), wave structure with dependency notes, and per-session execution instructions. This ensures the next session can brief the operator on Step 2.2 without re-deriving the plan from the manifest and session files.
- **Step 2.2 — Execute Research Sessions [Operator]:** Operator runs Research Execution GPT and Perplexity sessions. Sessions without cross-dependencies can run simultaneously. Write raw reports to `/execution/raw-reports/{section}/{section}-session-[letter]-raw-report.md`.
- **Step 2.3 — Create Research Extracts [Claude Project]:** For each raw report, apply `research-extract-creator` with the report and corresponding Answer Specs. One extract per question. Write to `/execution/research-extracts/{section}/{section}-Q[N]-extract.md`.
- **Step 2.4 — Review Research Extracts [delegate-qc]:** Apply `research-extract-verifier` against raw reports, extracts, and Answer Specs. Write verification to `/execution/extract-verification/{section}/{section}-extract-verification-[session-letter].md`. Verdicts: APPROVED or FLAG — RE-EXTRACT. Flagged extracts route back to Step 2.3.
- After 2 re-extraction passes, remaining failures → confirmed evidence scarcity → `/execution/scarcity-register/{section}/{section}-scarcity-register.md`
- GATE: Do not proceed to Stage 3 until all Research Extracts are APPROVED.

### Subworkflow 2.S — Supplementary Research (Optional)

> **Trigger:** After all extracts are APPROVED (Step 2.4 gate passed), operator reviews coverage verdicts across extracts and judges that THIN or MISSING components warrant supplementary research before entering Stage 3. Skip this subworkflow if coverage is acceptable.

- **Step 2.S0 — Extract Failed Components [Claude Project]:** Parse all approved Research Extracts and extract every component with THIN or MISSING coverage verdict. Output structured list grouped by Question ID to `/execution/supplementary/{section}/{section}-failed-components.md`. Extraction only — no query drafting.
- **Step 2.S1 — Draft Supplementary Query Brief [Claude Project]:** Apply `supplementary-query-brief-drafter` with failed components, Research Extracts, and Answer Specs as inputs. Produces grouped Perplexity queries (max 12) with Section A (analysis) and Section B (paste-ready execution sheet). Write to `/execution/supplementary/{section}/{section}-query-brief-pass-[1/2].md`. GATE: Operator reviews query brief before execution.
- **Step 2.S2 — Execute Queries in Perplexity [Operator]:** Operator runs each query in Perplexity Pro Search using the Execution Sheet verbatim. Prefix each query with: `I'm researching Nordic mid-market private equity for a professional advisory report.` Save raw output to `/execution/supplementary/{section}/{section}-perplexity-raw-pass-[1/2].md`.
- **Step 2.S3 — QC Perplexity Results [Claude Project]:** Apply `supplementary-research-qc` against raw Perplexity output, Research Extracts, and Query Brief Section A. Per-query verdicts: MERGE / SKIP / PARTIAL. Write to `/execution/supplementary/{section}/{section}-supplementary-qc-pass-[1/2].md`. GATE: Operator confirms merge summary before proceeding.
- **Step 2.S4 — Merge Supplementary Evidence [Claude Project]:** Apply `supplementary-evidence-merger` to integrate QC-approved results into Research Extracts. Recalculate coverage verdicts, update syntheses, tag supplementary claims with `[SUPPLEMENTARY]`. Updated extracts replace originals in `/execution/research-extracts/{section}/`.
- **Loop ceiling:** Max 2 passes per question. Pass 2 uses the pass-2 variant of Step 2.S1, which diagnoses why pass 1 didn't close gaps and uses different search strategies. Persistent gaps after 2 passes → confirmed evidence scarcity → `/execution/scarcity-register/{section}/{section}-scarcity-register.md`.
- Components classified as **confirmed scarcity** in pass 2 are documented in the extract's Gaps section and the scarcity register.

## Stage 3: Analysis & Gap Resolution

> Stage 3 has 10 steps due to its conditional branching (gap resolution paths). Split across three commands: `/run-cluster` (per-cluster analysis), `/run-analysis` (gap resolution + directives + review + recommendations + QC), `/run-synthesis` (chapter drafting in fresh session). Each execution unit stays within the 3–6 step guideline.

- **Step 3.1** — Read all research extracts from `/execution/research-extracts/{section}/` and scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if exists).
- **Step 3.2** — Apply `cluster-analysis-pass` logic per cluster, write to `/analysis/cluster-memos/{section}/`. Run `/compact` between clusters to prevent context bleed.
- **Step 3.3** — Apply `cluster-memo-refiner` for six-check refinement pass. GATE: Operator reviews each refined cluster memo before proceeding.
- **Step 3.4** — Run `gap-assessment-gate` with scarcity register as input. Write report to `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`.
- **Path classification:** Path A = gap requires new primary research (missing evidence categories, unasked questions, or fundamentally insufficient source material). Path B = gap can be closed with targeted factual retrieval (specific data points, statistics, or confirmatory evidence for existing analysis).
- If Path B gaps: execute Subworkflow 3.S (lightweight Perplexity research). After 3.S completes: re-run `gap-assessment-gate` on affected clusters only before proceeding to Step 3.5.
- If Path A gaps: loop back to Stage 2 for affected questions only. Re-entry trigger: new APPROVED research extracts for the affected questions appear in `/execution/research-extracts/{section}/`. Resume Stage 3 from Step 3.2 for the affected clusters only. Unaffected clusters hold at their current completed state — do not re-run them. Termination: all affected questions either resolve or exhaust 2 supplementary passes and classify as scarcity.
- **Reconvergence (Path A):** Write a loop-state entry per affected question to `/analysis/checkpoints/{section}/{section}-gap-loop-state.md`, tracking: question ID, current pass count, status (looping / resolved / scarcity). Stage 3 resumes at Step 3.5 only when every entry shows resolved or scarcity. Operator confirms loop completion at the gap assessment gate below.
- GATE: Operator reviews gap assessment routing decisions.

### Subworkflow 3.S — Lightweight Gap Research (Path B)

> **Trigger:** Step 3.4 routes gaps to Path B — analytical gaps that can be closed with targeted factual retrieval via Perplexity, without requiring full Stage 2 research sessions.

- **Step 3.S1 — Draft Gap Queries [Claude Code]:** Read gap assessment, affected cluster memos, and Research Extracts for affected questions. For each query group, document: (a) **What Stage 2 already searched** — source types, institutions, and search angles tried in the original Research Execution GPT sessions and any Stage 2 supplementary passes, including searches that returned nothing useful (derive from extract source lists, gap notes, and scarcity register entries); (b) **What Perplexity should find that's different** — the specific source types, data categories, or entry points that Stage 2 did not target, and why these are reachable via Perplexity but were outside the GPT's retrieval scope. Each query must target source types absent from the "already searched" list. Draft targeted Perplexity queries (max 8 per pass) to fill identified gaps. Write to `/analysis/gap-supplementary/{section}-gap-queries-pass-[1/2].md`. GATE: Operator reviews queries before execution.
- **Step 3.S2 — Execute Queries [Operator]:** Operator runs each query in Perplexity Pro Search. Prefix each query with: `I'm researching Nordic mid-market private equity for a professional advisory report.` Save raw output to `/analysis/gap-supplementary/{section}-perplexity-raw-pass-[1/2].md`.
- **Step 3.S3 — QC and Merge Results [Claude Code]:** Review Perplexity results against the gaps they target. Per-query verdicts: MERGE (closes gap) / SKIP (irrelevant or low quality) / PARTIAL (useful but gap not fully closed). For MERGE and PARTIAL results: (1) write a lightweight supplementary extract file to `/analysis/gap-supplementary/{section}-gap-extract-pass-[1/2].md` containing individual claims with Claim IDs (format: `GF[cluster]-C[##]`, e.g., GF3-C01), source attribution, and strength ratings — this ensures every gap-fill assertion has a citable identifier before it enters downstream artifacts; (2) integrate the ID-bearing claims into affected cluster memos, tag with `[GAP-FILL]`. Write QC report to `/analysis/gap-supplementary/{section}-gap-qc-pass-[1/2].md`.
- **Loop ceiling:** Max 2 passes. Pass 2 must update the "already searched" inventory to include pass 1 queries and outcomes, then use different search strategies targeting source types not yet tried. Persistent gaps after 2 passes → confirmed evidence scarcity → `/execution/scarcity-register/{section}/{section}-scarcity-register.md`.
- After 3.S completes: return to Step 3.4 for re-assessment of affected clusters only.
- **Step 3.5** — Apply `section-directive-drafter` per cluster. MUST include scarcity register items as required input.
- **Step 3.6** — Apply `analysis-pass-memo-review` for editorial decision surfacing. Write to `/analysis/editorial-review/{section}/{section}-memo-review.md`.
- **Step 3.6b** — Apply `editorial-recommendations-generator` to produce recommended answers for all editorial decisions. Write to `/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`. [delegate]
- **Step 3.6c** — Apply `editorial-recommendations-qc` as independent QC of recommendations. Write to `/analysis/editorial-review/{section}/{section}-qc-editorial-decisions.md`. [delegate-qc]
- **Step 3.6d** — Auto-approve editorial decisions based on QC results. [auto-delegate] Decision logic: QC AGREE → accept as-is; QC NUANCE → accept with QC adjustment applied; QC DISAGREE → PAUSE for operator. Write to `/analysis/editorial-review/{section}/{section}-editorial-decisions-approved.md`. Log to `/logs/qc-log.md`. Only pauses if QC contains DISAGREE items. Session boundary — start new session for Step 3.7.
- **Step 3.7** — Apply `cluster-synthesis-drafter` per cluster, write to `/analysis/chapters/{section}/`. Runs via `/run-synthesis` in a fresh session.

## Stage 4: Report Production

- **Step 4.1** — Read all chapter drafts from `/analysis/chapters/{section}/` and scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md`. Apply `research-structure-creator` to produce `/report/architecture/{section}/{section}-architecture.md`.
- For each chapter:
  - **Step 4.2** — Apply `evidence-to-report-writer`. Scarcity register is a required input — writer MUST implement editorial instructions for scarcity items. Write to `/report/chapters/{section}/`.
  - **Step 4.3** — Apply `chapter-prose-reviewer`. Write review to `/report/checkpoints/{section}/`.
  - **Step 4.4** — Apply fixes from prose review per bright-line rule. After first chapter: lock style reference to `/report/style-reference/{section}/{section}-style-reference.md`.
  - **Step 4.5** — Add H3 titles.
  - **Step 4.6** — Apply `citation-converter`, write cited version and Citation Traceability Layer.
- GATE: Operator reviews each chapter before proceeding.

## Stage 5: Final Production

- **Step 5.1** — Run `document-integration-qc` per module, write QC report.
- **Step 5.2** — Apply fixes per bright-line rule.
- **Step 5.3** — Apply formatting.
- **Step 5.4** — QC formatting against style reference.
- GATE: Operator reviews v1.4 drafts (Step 5.4).
- **Step 5.5** — Implement fixes in three phases: (1) identify all flagged items from QC reports, (2) classify each per bright-line rule (auto-fix vs. operator approval), (3) apply approved fixes and write v2.0. Bright-line rule applies to every fix.
- **Step 5.6** — Run `citation-converter` in reconciliation mode for bibliography.
- **Step 5.7** — Merge and compile full document.
- **Step 5.8** — Compile glossary, add front matter.
- GATE: Final operator review.

## Context Management

Pipeline commands consume large amounts of context. Three strategies keep usage sustainable:

### Strategy 1: Step Checkpoints
After each major step, write a checkpoint file capturing what was produced, key decisions, and anything the next step needs. Subsequent steps read the checkpoint instead of re-reading all source material.

- Path: `{stage-dir}/checkpoints/{section}-step-{id}-checkpoint.md`
- Content: structured summary — file paths produced, counts/inventory, decisions, flags for next step. Target: under 500 tokens.

### Strategy 2: Compact Directives
Commands include explicit `▸ /compact` markers at natural boundaries — typically after a step that loaded a skill file and wrote its output.

### Strategy 3: Sub-Agent Delegation for Heavy Steps
Self-contained steps run as sub-agents via the Agent tool. The main session never loads the skill file — it reads the inputs, passes them to the sub-agent along with the skill content, and receives a structured summary back.

Pattern for delegated steps:
1. Main agent reads the input files needed for the step.
2. Main agent reads the skill file.
3. Main agent launches sub-agent, passing: skill content, input content, output path, and task description.
4. Sub-agent executes, writes output, returns summary.
5. Main agent writes step checkpoint from summary.
6. Main agent compacts.

When a step is marked **[delegate]**, follow this pattern. When marked **[delegate-qc]**, use the qc-gate sub-agent type.
