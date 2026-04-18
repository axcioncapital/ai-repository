# Section 4 — Workflow Token Efficiency Audit: research-workflow

**Workflow audited:** `ai-resources/workflows/research-workflow/` (template, 5-stage pipeline)
**Protocol:** token-audit-protocol v1.2, Section 4, Steps 4.1–4.2
**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Telemetry label:** All "typical" estimates in this section are **structural inferences** derived from workflow instructions and file-loading patterns, not observed session data.

---

## Step 4.1 — Workflow identification

**Workflow name:** research-workflow
**Definition:** 5-stage pipeline — Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production.
**Canonical files defining the workflow:**
- `workflows/research-workflow/CLAUDE.md` — project-level rules (template, operator-customized at deployment)
- `workflows/research-workflow/reference/stage-instructions.md` — stage-by-step contract
- `workflows/research-workflow/.claude/commands/*.md` — 28 slash commands (run-preparation, run-execution, run-cluster, run-analysis, run-synthesis, run-report, produce-architecture, produce-prose-draft, produce-formatting, etc.)
- `workflows/research-workflow/.claude/agents/*.md` — 4 agent definitions (execution-agent, qc-gate, verification-agent, improvement-analyst)
- `workflows/research-workflow/reference/quality-standards.md`, `file-conventions.md`, `style-guide.md`, `sops/*.md`, `skills/*/SKILL.md`
- `workflows/research-workflow/.claude/settings.json` — hooks, permissions
- `workflows/research-workflow/.claude/hooks/*.sh` — friction-log-auto, check-claim-ids, detect-innovation, log-write-activity

## Measurement summary (lines / words — words×1.3 proxy per protocol header caveat ±30%)

### Core workflow files

| File | Lines | Words | Est. tokens |
|------|------:|------:|------:|
| `CLAUDE.md` (template, workflow-level) | 105 | 1,155 | ~1,502 |
| `SETUP.md` | 153 | 680 | ~884 |
| `reference/stage-instructions.md` | 129 | 2,208 | ~2,870 |
| `reference/file-conventions.md` | 142 | 950 | ~1,235 |
| `reference/quality-standards.md` | 72 | 727 | ~945 |
| `reference/style-guide.md` | 35 | 439 | ~571 |
| `reference/sops/research-executor-gpt.md` | 153 | 1,144 | ~1,487 |
| `reference/sops/evidence-pack-compressor-gpt.md` | 146 | 1,207 | ~1,569 |
| `reference/skills/knowledge-file-producer/SKILL.md` | 135 | 1,113 | ~1,447 |
| `reference/skills/report-compliance-qc/SKILL.md` | 113 | 1,090 | ~1,417 |
| `.claude/settings.json` | 151 | 539 | ~701 |

### Parent CLAUDE.md chain (also loaded at workflow-start)

| File | Lines | Words | Est. tokens |
|------|------:|------:|------:|
| Workspace root `/CLAUDE.md` | 136 | 2,162 | ~2,811 |
| `ai-resources/CLAUDE.md` | 104 | 834 | ~1,084 |
| Workflow-level `CLAUDE.md` (shown above) | 105 | 1,155 | ~1,502 |
| **Subtotal CLAUDE.md chain at workflow start** | **345** | **4,151** | **~5,396** |

### Commands (stage orchestrators only, the ones invoked by pipeline use)

| Command | Lines | Words | Est. tokens | Role |
|---------|------:|------:|------:|------|
| `produce-prose-draft.md` | 207 | 3,313 | ~4,307 | Part 2/3 prose pipeline (4–5 subagent chain) |
| `run-analysis.md` | 181 | 1,417 | ~1,842 | Stage 3 cross-cluster |
| `run-execution.md` | 180 | 2,024 | ~2,631 | Stage 2 with 2.0–2.4 + 2.S0–2.S5 |
| `audit-structure.md` | 145 | 1,014 | ~1,318 | Utility (not pipeline) |
| `produce-formatting.md` | 110 | 1,910 | ~2,483 | Formatting pipeline (2 subagents) |
| `produce-architecture.md` | 100 | 1,343 | ~1,746 | Architecture pipeline (2 subagents) |
| `run-report.md` | 84 | 816 | ~1,061 | Stage 4 report production |
| `review.md` | 78 | 537 | ~698 |
| `run-preparation.md` | 69 | 606 | ~788 | Stage 1 |
| `verify-chapter.md` | 63 | 439 | ~571 |
| `workflow-status.md` | 56 | 385 | ~500 |
| `run-cluster.md` | 45 | 293 | ~381 | Stage 3 per-cluster |
| `run-synthesis.md` | 32 | 203 | ~264 | Stage 3 fresh-session chapter drafting |
| (remaining smaller commands omitted — all <200 words) | | | | |

**Commands total (28 files):** ~15,400 tokens if all loaded simultaneously, but only the invoked command is loaded per turn.

### Agents (subagent definitions)

| Agent | Lines | Words | Est. tokens |
|-------|------:|------:|------:|
| `improvement-analyst` | 88 | 715 | ~930 |
| `qc-gate` | 52 | 313 | ~407 |
| `verification-agent` | 40 | 212 | ~276 |
| `execution-agent` | 29 | 171 | ~222 |

### Skills loaded during the pipeline (from `ai-resources/skills/`)

Every stage's delegated step has a pattern:
1. **Main agent reads** `SKILL.md` (full content enters main context).
2. Main agent passes content to sub-agent.
3. Main agent `/compact`s after step.

| Skill | Lines | Words | Est. tokens | Boundary? |
|-------|------:|------:|------:|:-:|
| `ai-prose-decontamination` | 484 | 6,417 | ~8,342 | HIGH |
| `answer-spec-generator` | 485 | 3,687 | ~4,793 | HIGH |
| `research-plan-creator` | 464 | 3,504 | ~4,555 | HIGH |
| `evidence-to-report-writer` | 332 | 3,424 | ~4,451 | HIGH |
| `prose-compliance-qc` | 330 | 2,420 | ~3,146 | HIGH |
| `prose-formatter` | 287 | 3,194 | ~4,152 | – |
| `decision-to-prose-writer` | 290 | 2,348 | ~3,052 | – |
| `section-directive-drafter` | 259 | 2,293 | ~2,981 | – |
| `citation-converter` | 245 | 2,140 | ~2,782 | – |
| `task-plan-creator` | 245 | 1,465 | ~1,905 | – |
| `research-prompt-creator` | 220 | 3,415 | ~4,440 | – |
| `editorial-recommendations-generator` | 215 | 1,390 | ~1,807 | – |
| `answer-spec-qc` | 205 | 1,957 | ~2,544 | – |
| `research-structure-creator` | 205 | 2,468 | ~3,208 | – |
| `chapter-review` | 201 | 1,895 | ~2,464 | – |
| `architecture-qc` | 200 | 1,673 | ~2,175 | – |
| `cluster-memo-refiner` | 183 | 1,511 | ~1,964 | – |
| `research-extract-verifier` | 183 | 1,359 | ~1,767 | – |
| `h3-title-pass` | 180 | 1,734 | ~2,254 | – |
| `research-prompt-qc` | 174 | 1,558 | ~2,025 | – |
| `editorial-recommendations-qc` | 169 | 1,319 | ~1,715 | – |
| `chapter-prose-reviewer` | 169 | 2,197 | ~2,856 | – |
| `formatting-qc` | 160 | 1,506 | ~1,958 | – |
| `cluster-analysis-pass` | 158 | 1,512 | ~1,966 | – |
| `gap-assessment-gate` | 150 | 1,352 | ~1,758 | – |
| `cluster-synthesis-drafter` | 132 | 1,090 | ~1,417 | – |
| `execution-manifest-creator` | 129 | 1,436 | ~1,867 | – |
| `supplementary-evidence-merger` | 128 | 1,209 | ~1,572 | – |
| `supplementary-research-qc` | 121 | 1,073 | ~1,395 | – |
| `document-integration-qc` | 116 | 698 | ~907 | – |
| `analysis-pass-memo-review` | 115 | 1,022 | ~1,329 | – |
| `report-compliance-qc` | 113 | 1,090 | ~1,417 | – |
| `research-extract-creator` | 107 | 1,054 | ~1,370 | – |

**Boundary tag:** within ±15% of protocol thresholds (300 lines HIGH / 150 lines MEDIUM).

---

## Step 4.2 — Token flow mapping per pipeline stage

### Context loading chain at session/workflow start

1. Workspace `/CLAUDE.md` (~2,811 tokens) — loaded every turn of every session
2. `ai-resources/CLAUDE.md` (~1,084 tokens) — loaded every turn
3. Workflow `CLAUDE.md` (~1,502 tokens) — loaded every turn
4. `@reference/stage-instructions.md` via `@`-mention in CLAUDE.md line 25 — conditional, but protocol flags "only load when actively working on relevant stage." Declared as lazy-load but the CLAUDE.md line reads "read @reference/stage-instructions.md." — wording asks Claude to read; whether IDE auto-follows depends on harness.
5. `@reference/file-conventions.md`, `@reference/quality-standards.md`, `@reference/style-guide.md` — same @-mention pattern, same ambiguity.
6. Slash command file when invoked (e.g., `/run-report` → 1,061 tokens).

**Subtotal at start of any workflow turn (base-case, no @-follows):** ~5,396 tokens for CLAUDE.md chain alone.
**Subtotal if all four @-referenced files are auto-loaded by Claude Code (worst case):** 5,396 + 2,870 + 1,235 + 945 + 571 = **~11,017 tokens** per turn.

### Stage-by-stage token flow

#### Stage 1: /run-preparation (69 lines command)

- Loads at start: CLAUDE.md chain (~5,396) + command (~788)
- 4 delegated skill steps: task-plan-creator (1,905), research-plan-creator (4,555), answer-spec-generator (4,793), answer-spec-qc (2,544)
- `/compact` markers present after each delegated step (4 of them).
- Subagents: 1 general-purpose + 1 qc-gate per skill step (roughly 6 subagent launches total — Step 1, 1b, 3, 4, 5 × multiple spec files, plus gates).
- Subagent return pattern: the command repeatedly asks subagents to **return** "output file path, key scope decisions," "research question inventory," "spec file inventory," etc. — small summaries (good pattern).
- Compaction: explicit `▸ /compact` after every delegated step (5 markers in 70 lines).
- **File reads mapped:**
  - `task-plan-draft` (loaded via @ reference — size operator-dependent)
  - Skill files (1,905 + 4,555 + 4,793 + 2,544 = 13,797 tokens if all loaded in main session across the stage; only 1 in memory at a time if /compact respected)
  - Checkpoints (<500 token target per protocol)

#### Stage 2: /run-execution (180 lines command — 2,024 words, ~2,631 tokens)

- Command itself is large (second-largest pipeline command).
- **Main path steps:** 2.0 Manifest, 2.1 Prompts, 2.1b Prompt QC, 2.2b Intake Raw Reports, 2.2a Inject Dependencies (optional), 2.3 Extracts, 2.4 Verify.
- **Optional subworkflow 2.S:** 2.S0–2.S5 (6 more steps).
- **Subagent launches (main path):** 5–7 (manifest, prompts, prompt-qc, per-session extracts [plural, can parallelize], per-session verifiers [plural, can parallelize]).
- **Subagent launches (supplementary):** up to 4 more per pass, up to 2 passes = 8 additional.
- **Skill loads (main path sequential):** execution-manifest-creator (1,867), research-prompt-creator (4,440), research-prompt-qc (2,025), research-extract-creator (1,370), research-extract-verifier (1,767). **Total ~11,469 tokens** if all loaded sequentially in main session (mitigated by 5 `▸ /compact` markers in the command).
- **File reads into main session:**
  - All Answer Specs (read multiple times — Step 2.0, 2.1, 2.3). Reads can be several files of operator-defined size.
  - Research Plan (read Step 2.0, 2.1 — double read before /compact).
  - **All raw reports** (Step 2.3 line 100: "Read all raw reports from /execution/raw-reports/"). Raw research reports can easily exceed 100 lines each; multiple reports × >100 lines is a main-session read.
  - Each sub-agent pass receives the report + Answer Specs + mapping — delegated correctly.
- **Subagent return pattern:** Step 2.3 item 5 says "Return: list of extracts produced (question ID, file path, brief quality note)" — short summary. Good.
- **Step 2.2b Intake Raw Reports** writes raw reports to disk (good — operator pastes, Claude writes directly).
- **Supplementary 2.S:** S2 has operator paste Perplexity raw output; workflow writes to disk, then delegated QC/merge sub-agents process — but line 149: "Read the raw Perplexity output from Step 2.S2" and line 150–152: "Read all Research Extracts from /execution/research-extracts/{section}/" + "Read the Query Brief Section A" — main session reads these before delegating. Extract files can be many × >100 lines.

#### Stage 3a: /run-cluster (45 lines command, per-cluster)

- Runs **once per cluster** (typical project: 6–10 clusters).
- Per-cluster loads into main session:
  - All research extracts for this cluster (Step 1 line 16: "Read the research extracts for this cluster" — can be 3–6 extract files × 100+ lines each).
  - Scarcity register (if exists).
  - cluster-analysis-pass SKILL (~1,966) + cluster-memo-refiner SKILL (~1,964).
- Subagents: 2 per cluster (cluster-analysis-pass, cluster-memo-refiner).
- `/compact` after each step + "After this cluster completes, run /compact before starting the next cluster" at line 45.
- Aggregate across a 6-cluster project: 12 subagent launches + 6× main-session extract reads.

#### Stage 3b: /run-analysis (181 lines command — 2nd longest in the workflow, 1,417 words, ~1,842 tokens)

- **Step 1:** "Read all refined cluster memos from `/analysis/cluster-memos/{section}/`." — main-session read of all cluster memos (6–10 × ~100 lines).
- **Step 2 (Gap Assessment):** delegate — passes all refined cluster memo content + scarcity register to sub-agent.
- **Step 3 (Supplementary if needed):** subworkflow 3.S is **inline in main session** ("Read `/ai-resources/prompts/supplementary-research/S0-extract-failed-components.md`. Execute against the gap assessment report" lines 149–150). S.0 through S.4 are all described as `[Claude Code]` — executed in **main session**, not delegated. S.1 reads gap assessment (long), failed components, all relevant Research Extracts, cluster memos. S.3 reads raw Perplexity output + Research Extracts + Query Brief Section A. S.4 reads the merge-instructions prompt + iterates cluster memos.
  - These sections bypass the subagent-for-heavy-reads rule. 5 files per pass × up to 2 passes, potentially multiple clusters.
  - Prompt files themselves are small (<700 words each).
- **Step 4 Section Directives:** "For each cluster, launch a general-purpose sub-agent" — parallelizable. Skill: section-directive-drafter (~2,981 tokens). Each subagent receives refined memo + scarcity register.
- **Step 5 Memo Review:** "Launch a general-purpose sub-agent. Pass it: the skill content, all refined cluster memos, and all section directives." — delegated. Main session does not keep those in context before this step because of `/compact` markers above; still, the main agent needs to READ the files to pass content to subagent (per workflow's context-isolation rule "sub-agents receive content from the main agent, not file paths"), so **all refined cluster memos and all section directives pass through main session at this step**.
- **Step 5b, 5c, 5d:** 3 more subagent launches (recommendations, QC, approval). Each requires passing prior artifacts as content.
- **Subagent count for Stage 3b:** 8+ subagent launches (2 gap + N directives + 1 memo-review + 1 recommendations + 1 QC + 1 approval + optional supplementary).

#### Stage 3c: /run-synthesis (32 lines command — 203 words)

- Explicit instruction: "run via `/run-synthesis` **in a fresh session**" (good pattern).
- Loads: all refined cluster memos + all section directives + scarcity register + cluster-synthesis-drafter skill (~1,417 tokens).
- One delegated sub-agent per cluster (parallelizable).
- `▸ /compact` between clusters if >3 clusters.

#### Stage 4: /run-report (84 lines command — 816 words)

- **Step 4.0 Load Inputs** (line 13–19): SIX categories of files loaded into main session:
  1. All chapter drafts from `/analysis/chapters/{section}/`
  2. Scarcity register
  3. All section directives
  4. All refined cluster memos
  5. All research extracts
  6. Approved editorial recommendations
  - Comment: "These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths."
  - For a 6-cluster project this can be 30+ files loaded into the main-session context before delegation. This is the single highest main-session read cost in the workflow.
- **Step 4.1 Architecture:** delegated, skill research-structure-creator (~3,208).
- **Step 4.1b Architecture QC:** delegated (qc-gate), skill architecture-qc (~2,175) + inputs re-read.
- **Step 4.2 per chapter:** for N chapters, **4 subagents per chapter** (writer, reviewer, compliance-qc, citation-converter):
  - evidence-to-report-writer (~4,451 tokens) — HIGH per skill size
  - chapter-prose-reviewer (~2,856)
  - report-compliance-qc (~1,417)
  - citation-converter (~2,782)
  - Each chapter sub-agent receives full content (architecture, extracts, directive, memo, scarcity register, editorial recs, style reference). That content must pass through main session.
- **6-chapter project:** 4 × 6 = 24 subagent launches in Step 4.2 alone.
- `▸ /compact` marker after each chapter.
- **Subagent return pattern:** reviewer returns "review verdict, findings list, recommended changes" — may exceed 200 lines for a chapter with many findings.

#### Part 2/3 Path: /produce-architecture + /produce-prose-draft + /produce-formatting

Separate from the 5-stage research pipeline — used for decision-document prose (Part 2 service, Part 3 strategy).

- `/produce-prose-draft.md` is the largest command in the workflow at **207 lines / 3,313 words / ~4,307 tokens**.
- Phase 1: architecture gate, style-reference gate (main session glob + read).
- Phase 2: delegated — decision-to-prose-writer SKILL (~3,052) + `context/prose-quality-standards.md` (size project-local, unknown to audit).
- Phase 3: merged review+fix (delegated, skill chapter-prose-reviewer + prose-compliance-qc).
- Phase 4: cross-section integration check (conditional).
- Phase 5: ai-prose-decontamination SKILL (~8,342 tokens — **largest skill in repo at 484 lines**).
- 4–5 subagent launches per section, per command invocation.
- Each invocation: main session loads prose file + style reference + architecture extracts + prose quality standards → passes to subagents.

---

## Assessment per protocol Section 4 "What to assess"

### 1. Subagent return volume

Most subagents are instructed to return small structured summaries (file path + inventory + flags). Examples verified:
- `run-preparation.md` Step 1: "Return: output file path, key scope decisions." (short)
- `run-execution.md` Step 2.3: "Return: list of extracts produced (question ID, file path, brief quality note)." (short)
- `run-analysis.md` Step 2: "Return: output file path, gap inventory (gap ID, cluster, path classification, severity)." (short)
- `run-report.md` Step 4.1: "Return: architecture summary (section count, chapter-to-section mapping, structural decisions)." (short)

**Potentially larger returns (flagged):**
- `run-report.md` Step 4.2b (chapter prose reviewer): "Return: review verdict, findings list, recommended changes." — "findings list" and "recommended changes" unbounded; for a chapter with many compliance issues this may exceed 200 lines.
- `run-report.md` Step 4.2a (prose writer): "Return: chapter draft content, scarcity items addressed, evidence coverage notes." — **"chapter draft content"** suggests the full chapter prose returns to main session, not just a summary. A full chapter draft is typically 800–2,500 words = ~1,000–3,000 tokens returned into main. **HIGH severity** per protocol (>200 lines threshold).
- `produce-prose-draft.md` Phase 2 step 6: "Write a brief status note (file path, word count) — do not read the full output yet." — **correct pattern**, write to disk + read later.
- `run-preparation.md` Step 3 Research Plan: "GATE — Present the Research Plan to the operator for review. Summarize the research questions produced" — for presentation Claude likely reads the full plan back into main session at the GATE. Research plans can run 200+ lines.

### 2. Unnecessary reads in main session

Flagged:
- **Run-report.md Step 4.0** — 6 categories of files read in main session before any delegation. For a 6-cluster project this is the single largest concentrated main-session read in the pipeline. Many of these (all research extracts, all refined cluster memos) could be read only when needed per chapter and scoped to that chapter. **HIGH severity** (large file reads in main session that could be delegated).
- **Run-analysis.md Step 1** — "Read all refined cluster memos" — all cluster memos read in main session before Gap Assessment delegation. The Gap Assessment sub-agent then receives them again. This is equivalent to reading them twice (once in main, once passed as content). Could be passed file paths to the subagent — but the workflow's explicit "Context Isolation Rules" in CLAUDE.md line 53 say "Sub-agents receive content from the main agent, not file paths" — this is a structural design choice that forces main-session reads of every artifact that any subagent needs. **HIGH severity** (pattern is systemic, not a single step).
- **Run-execution.md Step 2.3** — "Read all raw reports from `/execution/raw-reports/`" in main session. Raw research reports can be 200–800 lines each × 3–6 sessions. Then main session passes them to subagents. **HIGH severity**.
- **Run-analysis.md Subworkflow 3.S** — S.0–S.4 are all `[Claude Code]` (main-session execution), not delegated. S.1 reads failed-components + Research Extracts + cluster memos; S.3 reads raw Perplexity output + Research Extracts + Query Brief Section A; S.4 reads merge-instructions prompt + iterates cluster memos. Any one pass is >3 files in main session — violates protocol guideline ("tasks requiring >3–4 file reads go to subagent"). **HIGH severity**.
- **Run-execution.md Subworkflow 2.S** — 2.S1 delegates but main session first reads failed components + all Research Extracts + all Answer Specs (lines 137–140). Then 2.S3 reads raw Perplexity + all Research Extracts + Query Brief Section A (lines 149–151). Then 2.S4 reads all Research Extracts + QC-approved results + all Answer Specs (lines 158–160). **HIGH severity** — the "pass content not paths" rule means all Research Extracts are loaded into main session 3 times per supplementary pass.
- **Produce-prose-draft.md Phase 1 step 4:** "read first 50 lines" of architecture to check section coverage — correctly scoped. Good.

### 3. Missing /compact opportunities / breakpoints

- Compaction markers (`▸ /compact`) are used extensively and correctly — 5+ markers in each pipeline command. Positive finding.
- However, the **workflow-level CLAUDE.md does not define custom `/compact` preservation instructions** (grep shows no custom compaction block) — so when `/compact` fires it relies on Claude Code defaults. **MEDIUM severity** (no compaction instructions or breakpoints beyond marker placement).
- **Session boundaries:** Step 3.6d notes "Session boundary — start new session for Step 3.7" and `/run-synthesis` is explicitly invoked "in a fresh session." These are good. However, between /run-preparation → /run-execution and /run-execution → /run-analysis, no explicit `/clear` or fresh-session directive. **LOW severity** (mitigated by extensive `/compact`).
- Stage 4 (run-report) has 24+ sub-agent launches per section run with compact between chapters, but **no explicit session break within Stage 4** even though a 6-chapter Stage 4 run will easily exceed token budget — can exhaust context before all chapters complete. **MEDIUM severity**.

### 4. Refinement multiplier

Counting QC + refinement passes across a single section run:
- **Stage 1:** 1 QC pass (answer-spec-qc).
- **Stage 2:** 1 QC pass (research-prompt-qc, up to 2 iterations) + 1 extract verification pass (research-extract-verifier) + optional supplementary passes (2 max).
- **Stage 3a per-cluster:** 1 refinement (cluster-memo-refiner) per cluster.
- **Stage 3b:** gap-assessment + recommendations + QC + auto-approve = 3 passes. Optional 3.S gap-fill (up to 2 passes).
- **Stage 4 per-chapter:** writer + reviewer + compliance-qc + fix loop. Style-reference lock first chapter.
- **Stage 5:** document-integration-qc + formatting-qc + bright-line fix loop + citation reconciliation.

**Total design-mandated passes per section:** minimum ~12 QC/refinement passes; with supplementary loops could exceed 20. This exceeds the protocol's ">3 refinement cycles" threshold by a large margin. **MEDIUM severity** per protocol (high cost, but may be justified by quality standards — protocol notes "may indicate instruction quality issue rather than token waste per se, but the token cost is real").

### 5. Context-isolation design decision

The workflow's core context-isolation rule (CLAUDE.md line 53) forces sub-agents to receive **content, not paths**. This means every file a subagent needs must first be **read into the main session** and then passed. Rationale (stated): avoid subagents rediscovering state. Token impact: every delegated step incurs a full main-session read of all inputs, even when /compact runs after. For steps with large aggregated inputs (Step 4.0's 6 file categories, Step 4.2 per chapter, Step 2.3's all raw reports), this is the structural driver of main-session token cost. **HIGH severity** — this one design rule explains most of the Stage 4 / Stage 3b token profile. Protocol's "unnecessary reads in main session" applies.

### 6. Write-to-disk pattern

Positive:
- All delegated sub-agents write to disk (research-extracts, cluster-memos, section-directives, chapters, report-architecture, etc.). Returns are summaries.
- `produce-prose-draft` Phase 2 explicitly says "Write a brief status note … do not read the full output yet" — excellent.
- Raw research reports (Step 2.2b) written to disk by main session from operator paste, then delegated.

**Exception** (flagged above): `run-report.md` Step 4.2a return value **"chapter draft content"** suggests full prose comes back to main session.

---

## Step 4.2 final — Findings table

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---------|----------|-----------------|----------|
| 1 | `run-report.md` Step 4.0 loads 6 file categories (chapter drafts, scarcity register, all section directives, all refined cluster memos, all research extracts, editorial recommendations) into main session before delegation | HIGH | Large file reads in main session that could be delegated | `run-report.md` lines 13–19; for a 6-cluster project = 30+ files |
| 2 | Context-isolation rule "sub-agents receive content from the main agent, not file paths" forces all delegated inputs to pass through main session | HIGH | Unnecessary main-session reads (systemic) | workflow CLAUDE.md line 53; affects every delegated step |
| 3 | Subworkflow 3.S (S.0–S.4) runs inline as `[Claude Code]` in main session, reading 3–5 files per pass; violates protocol ">3–4 file reads → subagent" rule | HIGH | Unnecessary main-session reads | `run-analysis.md` lines 149–182 |
| 4 | Subworkflow 2.S main-session reads: 2.S1, 2.S3, 2.S4 each re-read "all Research Extracts" in main before delegating to subagent | HIGH | Redundant reads — all extracts loaded 3× per pass | `run-execution.md` lines 137–164 |
| 5 | `run-execution.md` Step 2.3 reads "all raw reports" in main session; raw research reports can be 200–800 lines × 3–6 per section | HIGH | Main-session read of delegable content | `run-execution.md` line 100 |
| 6 | `run-report.md` Step 4.2a return value includes "chapter draft content" → full chapter prose (~800–2,500 words) returns into main session | HIGH | Subagent returning large output to main session | `run-report.md` line 55 ("Return: chapter draft content, scarcity items addressed, evidence coverage notes.") |
| 7 | `run-analysis.md` Step 1 reads all refined cluster memos into main before Step 2 Gap Assessment delegate receives them again | HIGH | Duplicate read (main session + passed as content to sub-agent) | `run-analysis.md` lines 14, 21 |
| 8 | Largest pipeline command file is `produce-prose-draft.md` at 207 lines / 3,313 words (~4,307 tokens). Loaded fully every invocation of the Part 2/3 prose pipeline. | HIGH | Per-invocation command overhead | command file measurement |
| 9 | `ai-prose-decontamination` SKILL at 484 lines / 6,417 words (~8,342 tokens) — loaded into main session in `produce-prose-draft` Phase 5 before passing to sub-agent | HIGH | Large skill read into main session | skill measurement |
| 10 | `answer-spec-generator` SKILL at 485 lines (~4,793 tokens); `research-plan-creator` at 464 lines (~4,555 tokens); `evidence-to-report-writer` at 332 lines (~4,451 tokens) — all >300 line threshold, all loaded in main session during their stages | HIGH | Large skill reads in main (mitigated by /compact) | skill measurements |
| 11 | No custom `/compact` preservation instructions in workflow CLAUDE.md; `/compact` markers present but compaction behavior falls back to Claude Code default | MEDIUM | No compaction instructions or breakpoints defined | grep "compact" workflow CLAUDE.md: no preservation block found |
| 12 | Stage 4 run-report has 24+ subagent launches per 6-chapter section run (4 per chapter × 6) with no session-break directive mid-stage | MEDIUM | Potential context exhaustion mid-stage | `run-report.md` structure |
| 13 | Refinement multiplier: minimum ~12 QC/refinement passes per section (up to 20+ with supplementary loops) | MEDIUM | Consistent >3 refinement cycles; token cost real regardless of quality benefit | aggregate across stage-instructions + commands |
| 14 | Workflow CLAUDE.md uses `@`-references to 4 reference files (stage-instructions, file-conventions, quality-standards, style-guide) with advisory language "Only load these when actively working on the relevant stage"; whether Claude Code auto-follows @-mentions is ambiguous — worst case adds ~5,621 tokens per turn | MEDIUM | Possible unnecessary reference loading every turn | workflow CLAUDE.md line 25 |
| 15 | CLAUDE.md chain at workflow start already ~5,396 tokens (workspace + ai-resources + workflow), exceeding Anthropic's 200-line recommendation in aggregate (345 lines combined across 3 files) | MEDIUM | Per-turn CLAUDE.md cost | aggregate measurements |
| 16 | `run-execution.md` command is 180 lines / 2,024 words (~2,631 tokens), large enough to count against per-invocation budget | MEDIUM | Per-invocation command overhead | command file measurement |
| 17 | `run-analysis.md` command is 181 lines / 1,417 words (~1,842 tokens) | MEDIUM | Per-invocation command overhead | command file measurement |
| 18 | No explicit `/clear` or fresh-session directive between Stages 1→2, 2→3a, 3a→3b (only between 3b→3c and 3c→4 is there a "fresh session" directive) | LOW | Stale context compounds across stages (mitigated by compact) | cross-command reading |
| 19 | Subagent return value phrasing in multiple places ("findings list, recommended changes") is unbounded — could exceed 200-line threshold for chapters with many findings | LOW | Variable-size subagent returns | e.g. `run-report.md` 4.2b |
| 20 | Reference files in `reference/` are loaded via `@`-mention without explicit "load only when" gating in the @-syntax — depends on Claude Code to honor the prose caveat | LOW | Conditional reads may fire unnecessarily | workflow CLAUDE.md line 25 |

---

## Protocol gaps encountered during execution

1. Section 4 "map the token flow" does not specify how to handle workflow **templates** (read-only scaffolding, no operator-filled placeholders). Measurements here are of the template files; at deployment the `{{PROJECT_TITLE}}` etc. placeholders get replaced with project-specific content which may increase token cost further. Stated in notes; not impacting findings.
2. Section 4 thresholds (">200 lines HIGH for subagent returns") apply to line counts but subagent returns in this workflow are typically measured in words/structured fields. I interpreted per-protocol line threshold as approximately 2,600 tokens / ~200 lines of prose return, consistent with the header's ±30% caveat.
3. Protocol does not instruct how to classify the **context-isolation-by-design** pattern (workflow explicitly mandates main-session reads). Classified as HIGH per "large file reads in main session that could be delegated" — but note the workflow author made this choice deliberately.

---

## Token-estimation boundary flags (±15% of protocol thresholds)

Skills within ±15% of the 300-line boundary (255–345 lines):
- `evidence-to-report-writer` — 332 lines (inside boundary)
- `prose-compliance-qc` — 330 lines (inside boundary)
- `decision-to-prose-writer` — 290 lines (inside boundary)
- `prose-formatter` — 287 lines (inside boundary)
- `section-directive-drafter` — 259 lines (inside boundary)

These are currently flagged HIGH/MEDIUM by the 300-line threshold; under a real tokenizer the classification could flip to the 150–300 line MEDIUM band.

Skills within ±15% of the 150-line boundary (127–173 lines):
- `cluster-analysis-pass` — 158 lines
- `gap-assessment-gate` — 150 lines (on the line)
- `research-extract-verifier` — 183 lines (outside boundary)
- `cluster-memo-refiner` — 183 lines (outside boundary)
- `execution-manifest-creator` — 129 lines (inside boundary)
- `supplementary-evidence-merger` — 128 lines (inside boundary)

Command files within ±15% of 200-line boundary (170–230 lines):
- `produce-prose-draft.md` — 207 lines (inside boundary, currently uncategorized by Section 4 but note it's largest).

---

## Summary counts for this section

**HIGH findings:** 10
**MEDIUM findings:** 7
**LOW findings:** 3
**Total findings:** 20
