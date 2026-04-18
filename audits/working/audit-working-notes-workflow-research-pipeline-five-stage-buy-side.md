# Section 4 — Workflow Token Efficiency Audit: research-pipeline-five-stage (buy-side-service-plan)

**Scope:** Five-stage research pipeline in `projects/buy-side-service-plan/` producing Part 1 content.
**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan`
**Canonical workflow source:** `reference/stage-instructions.md` (127 lines, 2,107 words)
**Protocol section:** 4 (v1.2)
**Note on estimates:** word × 1.3 proxy; ±30% drift possible. Boundary findings tagged.

---

## 4.1 — Workflow identification (already resolved)

Workflow = five-stage pipeline: Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production.

Local (non-symlinked) project commands that drive the workflow:
- `run-preparation.md` (69 lines / 606 words) — Stage 1
- `run-execution.md` (180 lines / 2,024 words) — Stage 2
- `run-analysis.md` (181 lines / 1,417 words) — Stage 3 cross-cluster
- `run-cluster.md` (45 lines / 293 words) — Stage 3 per-cluster
- `run-synthesis.md` (32 lines / 203 words) — Stage 3 chapter synthesis (fresh session)
- `produce-knowledge-file.md` (73 lines / 452 words) — Stage 5 Chat knowledge file
- `inject-dependency.md` (64 lines / 475 words) — Stage 2 dependency injection
- `draft-section.md` (70 lines / 701 words) — Stage 4 drafting (three-phase)
- `review.md` (78 lines / 537 words) — Stage 4 chapter review
- `content-review.md` (17 lines / 137 words) — Stage 4 draft QC
- `intake-reports.md` (48 lines / 488 words) — Stage 2 report intake
- `verify-chapter.md` (symlink, 63 lines in ai-resources) — Stage 4 verification

---

## 4.2 — Token flow mapping

### 1) Context loaded at workflow start (each session)

| Item | Lines | Words | Est. tokens | Notes |
|---|---|---|---|---|
| Project `CLAUDE.md` | 167 | 1,748 | ~2,272 | Loaded every session. Between the "under 200 lines" guideline and the 200–300 MEDIUM threshold; acceptable. Includes 3 `@reference/...` **inline text pointers** (lines 11, 25) — NOT `@`-imports (those must be at line start to auto-load); these pointers are plain instructions, so Stage Instructions / File Conventions / Quality Standards do NOT auto-load. |
| `reference/stage-instructions.md` | 127 | 2,107 | ~2,739 | Loads only on operator instruction "read @reference/..." or when a command step requires it. Not auto-loaded. |
| `reference/file-conventions.md` | 142 | 952 | ~1,238 | Same — not auto-loaded. |
| `reference/quality-standards.md` | 52 | 513 | ~667 | Same — not auto-loaded. |
| `SessionStart` hook additionalContext | — | — | ~30–50 | Injects one line: "Section X.X, Stage: Y, Latest checkpoint: path". Lean. |
| `.claude/settings.json` additionalDirectories | — | — | 0 at load | Grants read access to entire `Axcion AI Repo` tree but does not preload content. |

**Total auto-loaded at start per session:** ~2,300 tokens (CLAUDE.md + SessionStart additionalContext). Well under the HIGH-severity threshold.

Finding F1 (LOW, boundary): CLAUDE.md is at 167 lines — 16% below the 200-line recommendation, comfortably clear; however, its word count (1,748) is modestly larger than the line count suggests (dense paragraphs, multiple sections). Not a finding on size; noted only for completeness.

### 2) Per-command context accumulation (stepwise-loaded reference and skill content)

Protocol: "stepwise" = each step reads the skill, delegates work to a subagent, the subagent produces output, the main session writes a checkpoint and runs `/compact`. Skill content does not persist in main context.

**`run-preparation.md`** — 5 steps + 1 log. Stepwise-loaded skills:
- Step 1: `task-plan-creator` (delegate) — reads skill, launches subagent, `/compact`
- Step 3: `research-plan-creator` (delegate) — reads skill, launches subagent, `/compact`
- Step 4: `answer-spec-generator` (delegate) — reads skill, launches subagent, `/compact`
- Step 5: `answer-spec-qc` (delegate-qc) — reads skill in main session, passes criteria to qc-gate subagent, `/compact`

Stepwise pattern is fully applied. Each `/compact` directive explicitly scoped to "skill content and checkpoint carries forward."

Finding F2 (LOW): Step 5 in `run-preparation.md` — the main session reads the full `answer-spec-qc` SKILL.md (reported in ai-resources audit to be one of the larger skills), then "extracts its evaluation criteria" to pass to subagent. Main session still holds the full skill content for a turn before the `/compact` at step 5 line 5. Minor residual drain vs. pure "pass file path" pattern.

**`run-execution.md`** — 10 steps across prep-check, 2.0, 2.1, 2.1b, 2.2a/b (manual), 2.3, 2.4, plus Subworkflow 2.S (5 substeps). Stepwise-loaded skills:
- Prereq: `answer-spec-qc` — main session reads skill content, passes to qc-gate. Same residual pattern as above.
- Step 2.0: `execution-manifest-creator` — skill + Research Plan + all Answer Specs → subagent → `/compact`
- Step 2.1: `research-prompt-creator` — skill + manifest + plan + specs → subagent → `/compact`
- Step 2.1b: `research-prompt-qc` — skill + prompts + specs + plan → qc-gate → `/compact`
- Step 2.3: `research-extract-creator` — skill + raw reports + specs + mapping → subagent(s), parallel → `/compact`
- Step 2.4: `research-extract-verifier` — skill + raw reports + extracts + specs → qc-gate, parallel → `/compact`
- Subworkflow 2.S: 4 additional skills (query-brief-drafter, supplementary-research-qc, supplementary-evidence-merger)

Finding F3 (MEDIUM): `run-execution.md` Step 2.1, Step 2.3, Step 2.4 each direct the MAIN session to "Read" the raw research reports and all Answer Specs before delegating. Protocol threshold: files over 100 lines in main session that could be delegated → HIGH. Answer Specs (per section) and raw research reports can easily be 200–500 lines each. Step 2.3 reads: "all raw reports from /execution/raw-reports/" plus "corresponding Answer Specs" plus "skill content" plus "checkpoint." Main session materializes potentially 1,000+ lines of inputs before delegating. The pattern could instead pass file paths to subagent and let subagent read. Severity MEDIUM not HIGH because the files then get `/compact`ed out after each step, but the materialize-then-compact cycle is expensive and happens 4+ times in Stage 2.

Finding F4 (MEDIUM): Same pattern repeats across Steps 2.S1, 2.S3, 2.S4 — main session reads all Research Extracts (38 files, total ~101,823 words / ~132,000 tokens at full) each time. Even scoped to one section (typically 8–10 extracts per section, ~20,000–30,000 words), this is a heavy main-session load immediately before delegation. Extract 1.2-Q1 alone is 336 lines; 1.2-Q6 is 311; 1.4-Q3 is 273; seven extracts are >200 lines.

**`run-analysis.md`** — 7 steps (Load Inputs, Gap Assessment, Supp Research, Directives, Memo Review, Recommendations, QC, Approve, Handoff) + Subworkflow 3.S. Stepwise-loaded skills:
- Step 1 (main session): Reads "all refined cluster memos from /analysis/cluster-memos/{section}/"
- Step 2: `gap-assessment-gate` (delegate) — skill + memos + scarcity register → subagent → `/compact`
- Step 4: `section-directive-drafter` (delegate, parallel per cluster) — skill + memo + scarcity → subagent
- Step 5: `analysis-pass-memo-review` (delegate) — skill + all memos + all directives → subagent
- Step 5b: `editorial-recommendations-generator` (delegate)
- Step 5c: `editorial-recommendations-qc` (delegate-qc)
- Step 5d: auto-delegate (no new skill load) → approval decision subagent
- Subworkflow 3.S: prompt-file-based, not skill-file-based

Finding F5 (HIGH, boundary): `run-analysis.md` Step 1 instructs main session to "Read all refined cluster memos." For a typical section (1.1, 1.2, 1.3, 1.4) there are 3–4 refined memos averaging ~100 lines each. Main session materializes ~400 lines / ~3,500 words / ~4,500 tokens of memo content up front — BEFORE any step delegates. Step 2 then also passes "all refined cluster memo content" to the gap-assessment subagent. So the memos get duplicated (main + subagent input). Total 28 refined memo files in repo at 28,537 words (~37,100 tokens) across all sections; per-section share is ~7,000–10,000 tokens. Severity boundary HIGH (delegable — the skill subagent can read memos directly from paths rather than receiving content). Tagged `(boundary)` because protocol threshold is >100 lines, and per-file memos are ~100 (at or near threshold).

Finding F6 (MEDIUM): Step 5 (Memo Review) and Step 5b (Recommendations) and Step 5c (QC) each re-materialize "all refined cluster memos" and "all section directives" in the subagent input payload. Main session doesn't reload them (assuming `/compact` fired between steps), but the pattern means every downstream subagent receives the full memo+directive bundle again. That is subagent context cost, not main-session cost — lower severity. But compounded across 4 consecutive delegations to general-purpose/qc-gate subagents, it is non-trivial.

Finding F7 (MEDIUM): Subworkflow 3.S in `run-analysis.md` is NOT delegated. Steps 3.S.0, 3.S.1, 3.S.3, 3.S.4 are all "[Claude Code]" — main-session execution. Each reads a prompt file from `ai-resources/prompts/supplementary-research/` then executes inline against gap assessment + cluster memos + Research Extracts. Step 3.S.3 and 3.S.4 merge findings into cluster memos using Edit (implied) from main session. For a subworkflow that touches memos and extracts, this is main-session-heavy. Note: stage-instructions.md Step 3.S3 also specifies main-session execution for this subworkflow, so the pattern is intentional, not a drift.

**`run-cluster.md`** — 3 steps + log. Delegated:
- Step 2: `cluster-analysis-pass` — main reads extracts + scarcity → passes content to subagent → `/compact`
- Step 3: `cluster-memo-refiner` — main reads memo → passes to subagent → `/compact`

Finding F8 (HIGH): `run-cluster.md` Step 1 instructs main session to "Read the research extracts for this cluster from /execution/research-extracts/{section}/". A cluster typically has 2–3 extracts. Five of the extracts (1.2-Q1, 1.2-Q6, 1.4-Q3, 1.4-Q7, 1.1-Q6) are >250 lines. Main session materializes 500–900 lines / ~5,000–7,000 words of extract content up front. Then Step 2 passes "the cluster's research extracts" to the subagent as content. Full materialization + duplication to subagent. Protocol threshold for main-session reads of files over 100 lines that are delegable → HIGH. Delegable because `cluster-analysis-pass` subagent can be given file paths and read them independently.

**`run-synthesis.md`** — 2 steps + log. Runs in fresh session per stage-instructions.md line 77. Very lean (32 lines / 203 words total).
- Step 1 (main session): Reads all refined memos + all directives + scarcity register
- Step 2: `cluster-synthesis-drafter` (delegate, parallel per cluster)

Finding F9 (MEDIUM): `run-synthesis.md` Step 1 — main session "Read all refined cluster memos" + "Read all section directives" + scarcity register. For a full section: ~3–4 memos (~100 lines each) + ~3–4 directives + register. Main session loads ~700–1,000 lines / ~7,000–10,000 words before any delegation. Then Step 2 passes "the cluster's refined memo, the cluster's section directive, and any relevant scarcity register entries" to the subagent — so main session load is not even used by subagent beyond scoping. Delegable (fresh session could just pass paths). Mitigated by "fresh session" design, which Stage 3 handoff in `run-analysis.md` Step 6 explicitly instructs.

**`produce-knowledge-file.md`** — 6 steps. Mixed:
- Step 2 (main session): Reads all cited chapter files for the section
- Step 3 (main session, per command text): "Read the knowledge-file-producer skill from /reference/skills/..." — and applies skill logic directly in main session; no delegate tag, no subagent launch
- Step 5: QC delegated to subagent

Finding F10 (HIGH): `produce-knowledge-file.md` does NOT delegate the main production step. Step 2 reads "all cited chapter files for the section" in main session. For section 1.1, cited chapters are in `/report/chapters/1.1/` and the approved synthesis produces 4 chapters per section (per architecture). The operator's output `document-1-buy-side-market-analysis.md` is 164,429 bytes / roughly 2,000+ lines (which is the assembled module), indicating per-chapter prose is substantial. Main session then reads the skill file and applies its logic inline (Step 3 says "Apply the skill's logic to produce the knowledge file"), meaning the knowledge file is PRODUCED in main session with all the cited chapters still in context. This is inverted from the delegate-stepwise pattern used in earlier stages. HIGH — this is a large-file read chain in main session that is the single biggest drain point of Stage 5 Chat file production.

Finding F11 (LOW): `produce-knowledge-file.md` Step 5 QC subagent receives "The knowledge file content" AND "The cited chapter files (source content)" AND "The skill file content." Full content passed. Appropriate for QC independence, but subagent input payload is heavy.

**`draft-section.md`** — 3 phases. Clean design:
- Phase 1: Plan (main session, lightweight — reads only 10 lines of architecture and the latest draft)
- Phase 2: Delegated to `section-drafter` agent — agent reads all source material directly
- Phase 3: Review (main session reads only the new draft)

Finding F12 (PASS / positive reference): `draft-section.md` is the most token-efficient command in this workflow — explicit comment "Do NOT read knowledge files, WH, or other heavy source material — that's the drafting agent's job." Main session never materializes source material. Iteration loop preserves lean main session.

**`review.md`** — 3 steps.
- Step 1 (main session): Reads chapter + architecture spec + style reference + section directive + scarcity register + cluster memo + synthesis brief = 6–7 files
- Step 2 (delegate-qc): Passes all content to qc-gate subagent; then `/compact`

Finding F13 (HIGH): `review.md` Step 1 main session "Load the following inputs (read all files)" — 6–7 files simultaneously in main context before delegation. Chapter prose alone can be 500–1,000+ lines; style reference is typically 150–300 lines; cluster memo is ~100 lines. Total main-session load before delegation is plausibly 1,000–2,000 lines / 8,000–15,000 tokens. Protocol explicitly flags "reading more than 3–4 large files should be delegated to a subagent" — this command reads 6–7. Content IS then passed to the subagent (via content, not paths), so the main session copy is redundant after the delegation kicks off. The `/compact` at Step 2.9 recovers the context, but the delta during the read-then-delegate window is large.

**`content-review.md`** — 17 lines / 137 words. Very lean. Delegates to qc-reviewer agent (`.claude/agents/qc-reviewer.md`) explicitly — does not run in main session. PASS.

**`intake-reports.md`** — 48 lines / 488 words. Operator pastes raw reports; main session writes them verbatim. "MUST run on Opus... Raw reports must be written verbatim — never summarized, truncated, or compressed." Main session touches pasted report content (which enters context from the paste, not from a file read). Dependency injection (Step 2) also happens in main session — reads raw report, extracts key structural output, drafts injection block. Single-file read at a time, but the raw reports themselves can be very large (GPT-5 deep-research output is often 3,000–10,000 words).

Finding F14 (MEDIUM): `intake-reports.md` Step 2 reads each raw report in main session to extract structural output for dependency injection. With raw reports potentially 3,000–10,000 words each, this is a substantial main-session materialization. Could be delegated to a subagent that reads the raw file and returns only the extracted injection block. Severity MEDIUM because this runs only when dependencies exist (not every section).

**`verify-chapter.md`** (symlinked to ai-resources) — 63 lines. Already audited in ai-resources run.

**`inject-dependency.md`** — 64 lines / 475 words. Manual-trigger command.
- Step 0 (main session): Reads `/logs/session-notes.md`
- Step 1 (main session): Reads `session-plan.md`
- Step 2 (main session): Reads raw reports for each completed session letter — extracts 8–12 bullets
- Step 3 (main session): Updates downstream prompt files with PRIOR RESEARCH OUTPUT block

Finding F15 (MEDIUM): `inject-dependency.md` Step 2 same issue as intake-reports.md Step 2 — reads full raw reports in main session. If 3–5 session letters are provided, 3–5 raw reports are all loaded. Could be delegated. MEDIUM.

### 3) Subagent return size

Stage-instructions.md "Sub-Agent Delegation for Heavy Steps" pattern (lines 116–125) specifies: "4. Sub-agent executes, writes output, returns summary. 5. Main agent writes step checkpoint from summary. 6. Main agent compacts." This is the canonical file-path-plus-summary pattern, and it is enforced consistently in `run-preparation.md`, `run-execution.md`, `run-analysis.md`, `run-cluster.md`, `run-synthesis.md`. Summary format in each delegated step is structured: "Return: output file path, [2–4 bullet summary items]." Typical subagent return is under 200 lines (protocol HIGH threshold) — usually 10–30 lines.

Finding F16 (PASS): Subagent return pattern across all five-stage commands is consistent and lean. File-path-plus-summary is the norm, not full output return.

### 4) QC / refinement cycles per stage

| Stage | QC/refinement cycles built in |
|---|---|
| Stage 1 (Prep) | 2 (Step 1b Task Plan QC; Step 5 Answer Spec QC) |
| Stage 2 (Exec) | 2–4 (Step 2.1b prompt QC with 1 retry; Step 2.4 extract verification with potential re-extract loop; Subworkflow 2.S up to 2 passes) |
| Stage 3 (Analysis) | 4 (Step 3 memo refinement; Step 3.4 gap assessment; Step 3.6 memo review; Step 3.6b/c recommendations + QC; plus Subworkflow 3.S up to 2 passes) |
| Stage 4 (Report) | 3 per chapter (prose review; citation conversion; optional verify-chapter) |
| Stage 5 (Final) | 3 (document-integration-qc; format QC; bibliography reconciliation) |

Finding F17 (MEDIUM): Total QC/refinement cycles per section = ~14–16 delegated subagent calls plus up to 4 operator re-entry loops (re-extraction, Path A/B gap loop, Stage 2 re-entry). Per protocol ">3 refinement cycles consistently → MEDIUM." This workflow is heavily refinement-oriented, which is appropriate for research quality but represents a real token multiplier per section.

### 5) Compaction breakpoints

`/compact` markers are explicit in the workflow commands. Count:
- `run-preparation.md`: 5 `▸ /compact` markers (after each of steps 1, 3, 4, 5 and implicit)
- `run-execution.md`: 7 `▸ /compact` markers
- `run-analysis.md`: 7 `▸ /compact` markers
- `run-cluster.md`: 2 `▸ /compact` markers
- `run-synthesis.md`: 1 `▸ /compact` marker (end)

Additional natural breakpoints: Stage 1→2 transition (operator GATE, session handoff); Stage 2→3 transition (operator GATE after extracts approved); Stage 3→4 transition (explicit: `run-analysis.md` Step 6 says "Start a new session and run `/run-synthesis`"); Stage 4→5 transition.

Finding F18 (PASS): Compaction pattern is dense and well-specified. Fresh-session handoff explicitly documented at Stage 3 → Synthesis boundary. No missing compaction opportunities observed at stage transitions.

Finding F19 (LOW): `run-cluster.md` instructs "run /compact before starting the next cluster" (line 45) but the cluster loop is not a single command invocation — it's an operator-driven loop. Compaction between clusters depends on operator running `/compact` manually before invoking `/run-cluster` again. If operator forgets, cluster 2 analysis runs on cluster 1's residual context. No hook enforces.

### 6) Large intermediate artifacts read back into main session

Artifact sizes observed in repo:
- Research extracts: 38 files, ~101,823 total words (~132,000 tokens). Per-section share ~8–10 files, ~25,000 words (~32,500 tokens). Individual extracts range 130–336 lines.
- Cluster memos (refined): 28 files, 28,537 words (~37,100 tokens). Per-section ~3–4 memos.
- Knowledge files: 4 files, total 508 lines. Per-section ~109–179 lines. Lean; on target 1,500–2,500 words per skill spec.
- Final outputs: `document-1-buy-side-market-analysis.md` 164,429 bytes (~25,000 words / ~32,500 tokens). `document-2-service-model.md` 126,158 bytes (~19,500 words).

Findings F3, F4, F5, F8, F10 above cover main-session materialization of these artifacts.

Finding F20 (MEDIUM): The `final/modules/` and `report/chapters/` and `output/document-*.md` files are sitting in the project root. CLAUDE.md Cross-Part Referencing section (lines 122–125) instructs: "When drafting Part 2, reference Part 1 approved outputs in `/report/chapters/` or `/final/modules/`." This means Part 2/3 drafters MAY read Part 1 chapter prose directly. A single Part 1 module (~25,000 words) loaded into a Part 2 draft session is a 30,000+ token event. The `draft-section.md` command delegates this to section-drafter agent (good) but the main session still writes the Phase 3 review reading the full draft output.

### 7) Settings.json and Read(...) deny coverage

`projects/buy-side-service-plan/.claude/settings.json`:
- `permissions.deny` contains only: `"Bash(git push*)"`, `"Bash(rm -rf *)"`, `"Bash(sudo *)"`.
- NO `Read(...)` deny rules.

Finding F21 (HIGH): No `Read(...)` deny rules in project settings. Per-protocol 0.3 → HIGH severity. Claude Code can explore and read every directory in this project during Glob/Grep/Read operations. Directories that should be Read-denied for token hygiene include: `/logs/`, `/output/` (contains 164KB+ module files), `/final/`, `/usage/`, `/reports/`, `/parts/*/drafts/` (stale drafts), `/analysis/cluster-memos/` (non-refined variants), old checkpoints. Additionally, `additionalDirectories` grants read access to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (the parent workspace), meaning sibling projects' content is also reachable unless denied.

Finding F22 (LOW): `.claude/settings.local.json` is 26 bytes — essentially empty. No project-local Read deny additions.

### 8) Hooks that inject context

`SessionStart` hook (settings.json lines 75–97) injects:
- Latest checkpoint path via `additionalContext` (~30–50 tokens)
- Template drift check output (variable, typically short)
- Auto-sync-shared output (variable, short)

`UserPromptSubmit` hook appends to `/logs/decisions.md` — writes only, does not inject context.

Finding F23 (LOW): `SessionStart` hooks inject small amounts of session-init context. Total likely <200 tokens. Acceptable.

### 9) Files written during workflow (output-to-disk footprint)

Each stage writes to disk:
- Stage 1: `/preparation/task-plans/`, `/preparation/research-plans/`, `/preparation/answer-specs/{section}/`, `/preparation/checkpoints/`
- Stage 2: `/execution/manifest/{section}/`, `/execution/research-prompts/{section}/`, `/execution/raw-reports/{section}/`, `/execution/research-extracts/{section}/`, `/execution/extract-verification/{section}/`, `/execution/checkpoints/{section}/`, `/execution/scarcity-register/{section}/`, `/execution/supplementary/{section}/`
- Stage 3: `/analysis/cluster-memos/{section}/`, `/analysis/gap-assessment/{section}/`, `/analysis/gap-supplementary/`, `/analysis/section-directives/{section}/`, `/analysis/editorial-review/{section}/`, `/analysis/chapters/{section}/`, `/analysis/checkpoints/{section}/`
- Stage 4: `/report/chapters/{section}/`, `/report/checkpoints/{section}/`, `/report/architecture/{section}/`, `/report/style-reference/{section}/`
- Stage 5: `/final/modules/`, `/output/document-*.md`, `/output/knowledge-files/`

Output-to-disk is heavy and well-structured. Finding F21 (no Read denies) means all of these directories are visible during any Glob/Grep/exploration in later sessions. Any `/compact` that reintroduces prior checkpoint content pulls from these directories.

---

## Consolidated findings table

| # | Finding | Severity | Waste mechanism |
|---|---------|----------|----------------|
| F1 | CLAUDE.md 167 lines (boundary-OK) | LOW (boundary) | Per-turn cost |
| F2 | `run-preparation.md` Step 5 main-session reads full answer-spec-qc skill before passing criteria | LOW | Residual main-session load |
| F3 | `run-execution.md` Steps 2.1/2.3/2.4 main session reads all raw reports + specs before delegating | MEDIUM | Materialize-then-compact cycle across 4+ steps |
| F4 | `run-execution.md` Subworkflow 2.S reloads all Research Extracts in main session multiple times | MEDIUM | Repeated main-session materialization |
| F5 | `run-analysis.md` Step 1 main session reads all refined cluster memos up front | HIGH (boundary) | Pre-delegation materialization; ~100-line threshold borderline |
| F6 | `run-analysis.md` Steps 5/5b/5c repeatedly pass full memos+directives to successive subagents | MEDIUM | Subagent-side duplication across 3 consecutive delegations |
| F7 | Subworkflow 3.S in `run-analysis.md` is NOT delegated — main session reads extracts, merges | MEDIUM | Intentional per stage-instructions but still main-session-heavy |
| F8 | `run-cluster.md` Step 1 main session reads cluster's full research extracts (some >250 lines) | HIGH | Pre-delegation materialization + duplication into subagent input |
| F9 | `run-synthesis.md` Step 1 main session reads all memos + directives + scarcity register | MEDIUM | Mitigated by fresh-session design but still redundant with subagent payload |
| F10 | `produce-knowledge-file.md` does NOT delegate the production step — main session reads cited chapters AND applies skill | HIGH | Large chapter prose loaded in main session; knowledge file produced in main context |
| F11 | `produce-knowledge-file.md` QC subagent receives full chapter content + skill + knowledge file | LOW | Subagent payload, not main-session cost |
| F12 | `draft-section.md` is token-efficient (positive reference) | PASS | N/A |
| F13 | `review.md` Step 1 main session loads 6–7 files before delegation | HIGH | Explicit protocol violation ">3–4 large files → delegate" |
| F14 | `intake-reports.md` Step 2 dependency injection reads full raw reports in main session | MEDIUM | Delegable but operator-triggered only |
| F15 | `inject-dependency.md` Step 2 reads raw reports for each session letter in main session | MEDIUM | Same as F14 |
| F16 | Subagent return pattern (file-path-plus-summary) is PASS | PASS | N/A |
| F17 | ~14–16 delegated subagent calls + up to 4 re-entry loops per section | MEDIUM | Refinement multiplier; appropriate for research quality but real token cost |
| F18 | Compaction breakpoints well-specified at stage transitions | PASS | N/A |
| F19 | Inter-cluster `/compact` depends on operator running it manually; no hook | LOW | Potential residual cross-cluster context bleed |
| F20 | Final-module files (25,000+ words) live in project root; Part 2/3 drafters may read them | MEDIUM | Per-session risk if draft-section agent pattern not followed |
| F21 | No `Read(...)` deny rules in project settings.json | HIGH | Exploration reads of logs/, output/, final/, drafts/ possible anywhere |
| F22 | `settings.local.json` empty (26 bytes) — no local Read deny additions | LOW | N/A beyond F21 |
| F23 | SessionStart hook injects <200 tokens of context — acceptable | LOW | N/A |

---

## Summary counts

- **HIGH:** 5 (F5 boundary, F8, F10, F13, F21) — F5 tagged boundary
- **MEDIUM:** 8 (F3, F4, F6, F7, F9, F14, F15, F17, F20) — actually 9; recounting: F3, F4, F6, F7, F9, F14, F15, F17, F20 = **9**
- **LOW:** 6 (F1 boundary, F2, F11, F19, F22, F23) — F1 tagged boundary
- **PASS:** 3 (F12, F16, F18)

Total findings (severity-bearing): 20 plus 3 PASS references. Total 23 items.

---

## Protocol gaps (encountered during execution)

- None of significance. Section 4 protocol is well-specified for per-workflow audit. The token-estimation caveat was applied throughout.
- One minor ambiguity: protocol Step 4.2 question 5 asks to flag "files over 100 lines being read in the main session when they are delegable." The definition of "delegable" is implicit (can be performed and summarized in a subagent). Applied as: a main-session read is delegable when the skill step that uses the content runs in a subagent and could accept the file path directly instead of receiving the content materialized in main-session memory. This is the interpretation used for F3, F4, F5, F8, F13.

## Boundary findings (per token-estimation caveat)

- F1: CLAUDE.md 167 lines — 16% below 200-line guideline; NOT near a severity threshold but worth flagging for Section 10 confidence.
- F5: Per-memo line count is ~100, exactly on the protocol's >100-line threshold. Under real tokenization, the individual-memo count may come in under threshold; aggregate across 3–4 memos clearly passes.

Full notes file at: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-research-pipeline-five-stage-buy-side.md`
