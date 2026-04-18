# Section 4 — Workflow Token Efficiency: /new-project

**Workflow name:** `/new-project`
**Orchestrator file:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md` (351 lines, 3,552 words, ~4,618 tokens)
**Pipeline model:** 6 core stages (2, 2.5, 3a, 3b, 3c, 4, 5) + optional Stage 6 (session guide) — each delegated to a dedicated `pipeline-stage-*` subagent (or `session-guide-generator` for Stage 6).
**Scope:** Orchestrator lives in `ai-resources/.claude/commands/`; pipeline runs at workspace scope (projects created under `projects/{name}/`).

All token estimates use the protocol's word × 1.3 proxy. Per the header caveat, this can drift ±30% vs. a real tokenizer; findings within ±15% of a threshold are tagged `(boundary)`.

---

## 4.2.1 — What gets loaded at workflow start

Main session at `/new-project` invocation (from workspace root or a project):

| Item | Path | Lines | Words | Est. tokens |
|------|------|-------|-------|-------------|
| Workspace CLAUDE.md | `CLAUDE.md` | 136 | 2,162 | ~2,811 |
| ai-resources CLAUDE.md | `ai-resources/CLAUDE.md` | 104 | 834 | ~1,084 |
| Orchestrator body | `.claude/commands/new-project.md` | 351 | 3,552 | ~4,618 |
| **Total start-of-workflow context (excluding skills lazy-load + tool defs)** | | **591** | **6,548** | **~8,513** |

Notes:
- Workspace CLAUDE.md loads always (harness pattern). ai-resources CLAUDE.md loads because ai-resources is connected via `--add-dir` (per CLAUDE.md / mandated by `/new-project` to reach shared skills + commands).
- Orchestrator `new-project.md` is loaded in full when the slash command is invoked. 12 top-level sections. Contains two full jq bash procedures (~90 lines), a canonical Commit Rules block, a canonical Input File Handling block, a canonical permissions block, and a multi-branch heredoc for CLAUDE.md creation.
- Pipeline stage agent files are NOT loaded at orchestrator start — they load only when the matching subagent is spawned (per Claude Code subagent loading semantics).
- Skills listed in each stage agent's `skills:` frontmatter key are discovered at agent spawn, not eagerly loaded into the orchestrator.

## 4.2.2 — Subagent call count (workflow design)

Per project run (happy path):

| Stage | Subagent | Model | Spawned by |
|-------|----------|-------|-----------|
| 2 | `pipeline-stage-2` | inherit | `/new-project` orchestrator |
| 2.5 (optional) | `pipeline-stage-2-5` | inherit | orchestrator (if not SKIP) |
| 3a | `pipeline-stage-3a` | sonnet | orchestrator |
| 3b | `pipeline-stage-3b` | opus | orchestrator |
| 3c | `pipeline-stage-3c` | inherit | orchestrator |
| 4 | `pipeline-stage-4` | inherit (isolation: worktree) | orchestrator |
| 5 | `pipeline-stage-5` | sonnet | orchestrator |
| 6 (optional) | `session-guide-generator` | inherit | orchestrator (if NEXT after 5) |

Total subagent spawns per run: **6 to 8** (minimum: 2, 3a, 3b, 3c, 4, 5 = 6; with 2.5 and 6 = 8).

Each stage has exactly one subagent call per invocation; no fan-out or parallel subagent patterns are defined. Refinement cycles (re-running a failed stage) multiply this count.

## 4.2.3 — Estimated output volume returned to main session

Per stage, the subagent writes a full artifact to disk under `projects/{name}/pipeline/`. The announcement back to the main orchestrator is a single sentence (template in each agent's "announce" block). Return content **per stage is a short announcement string** (1 line), not the full artifact.

However: the orchestrator/user negotiation to approve each artifact (per `## Gate Protocol` "Never advance a stage without user confirmation (`NEXT`)") happens in the main session. Every stage's artifact must be reviewed by the user before NEXT — this implies the main session or the user reads the artifact from disk between stages. The orchestrator command itself does not instruct the main session to read the artifact, but in practice each stage's output is inspected before approving. Sizes of expected outputs:

| Stage output | Expected size basis | Est. words | Est. tokens (if main reads) |
|---|---|---|---|
| `project-plan.md` (Stage 2) | implementation-project-planner skill defines structure; no size cap | unknown, typically ~1,500–3,000 words | ~1,950–3,900 |
| `technical-spec.md` (Stage 2.5) | spec-writer skill; system design scope | unknown, typically ~1,500–4,000 words | ~1,950–5,200 |
| `repo-snapshot.md` (Stage 3a) | mechanical repo scan — skill inventory + .claude/ subdirs + workflows + file tree for the entire ai-resources repo | unknown; scales with repo (current ai-resources has ~90+ skills alone) — likely 2,000–5,000+ words | ~2,600–6,500+ |
| `architecture.md` (Stage 3b) | architecture-designer skill | ~1,500–3,000 words | ~1,950–3,900 |
| `implementation-spec.md` (Stage 3c) | implementation-spec-writer skill (line-level ops) | ~2,000–5,000 words | ~2,600–6,500 |
| `implementation-log.md` (Stage 4) | project-implementer log | ~500–2,000 words | ~650–2,600 |
| `test-results.md` (Stage 5) | project-tester report | ~500–1,500 words | ~650–1,950 |
| `session-guide.md` (Stage 6) | session-guide-generator | ~1,500–3,000 words | ~1,950–3,900 |

These artifacts are not forced into main-session context by the orchestrator; loading only happens when the user (or main session) opens them for review. Return-to-main-session via the subagent's final message is **summary only** (one line with path and counts) — this conforms to best practice #10.

## 4.2.4 — QC / refinement cycles the workflow designs for

The orchestrator defines three gate commands per stage: NEXT / SKIP / ABORT. It does not design for QC-refinement multipliers — there is no `qc-reviewer` subagent invoked between stages. Each stage assumes one pass and user approval. If a stage is rejected, the user must either:

- rerun the failed stage (manual re-invocation via orchestrator continuation logic), or
- abort and fix manually.

Stage 4 defines "Partial failure" vs "Fundamental failure" error recovery — fundamental failure can send the user back to Stage 3c or 3b, adding unbounded refinement cycles.

No formal QC pass is defined post-stage. The workspace CLAUDE.md has a project-wide **"Post-edit QC pass is mandatory"** rule and a **"Plan QC pass before presenting plans for approval"** rule, but these are not explicitly wired into the `/new-project` orchestrator's stage-transition protocol.

Typical refinement multiplier: structurally 1 per stage on happy path. If each stage lands cleanly, total session count = 1 orchestrator session with 6–8 subagent spawns. If any stage is rejected, +1 rerun per rejection. Without telemetry, the designed multiplier is 1.0; observed multiplier unknown.

## 4.2.5 — File read mapping

### Orchestrator (`new-project.md`) file reads during its own execution

| File read | Trigger | Size | Main-session or subagent? | Necessary / Delegable |
|---|---|---|---|---|
| `projects/*/pipeline/pipeline-state.md` | Every invocation (first-run vs continuation check) | small (~20–40 lines) | main | Necessary (routing decision) |
| `projects/*/pipeline-state.md` (legacy) | Fallback check | small | main | Necessary |
| `.claude/shared-manifest.json` in new project | Post-pipeline enrichment | small (~10 lines) | main | Necessary |
| `projects/{name}/.claude/settings.json` | Post-pipeline enrichment jq merge | small | main | Necessary |
| `projects/{name}/CLAUDE.md` | Post-pipeline enrichment idempotency check | varies | main | Necessary |

All orchestrator-level reads are small config/state files. None flagged.

### Pipeline stage file reads (per stage, executed inside each subagent's context)

| Stage | File reads in subagent | Subagent or main? | Notes |
|---|---|---|---|
| 2 | `context-pack.md` (user-provided, size varies — can be 1,000–5,000+ words) | subagent | Delegated correctly |
| 2.5 | `context-pack.md` + `project-plan.md` | subagent | Delegated correctly |
| 3a | Entire ai-resources repo scan: root CLAUDE.md + every SKILL.md + every `.claude/` subdir file + every workflow's `.claude/` subdir + 2-level file tree | subagent | **Heavy read** — this is the single largest file-read operation in the pipeline. All inside the stage-3a subagent's context (Model: sonnet). Returns only the snapshot markdown to disk, not raw content to main. Delegation is correct. |
| 3b | `project-plan.md` + `repo-snapshot.md` + `decisions.md` + (optional) `technical-spec.md` | subagent | Model: opus. Delegated correctly. |
| 3c | `architecture.md` + `repo-snapshot.md` + `decisions.md` + `project-plan.md` + (optional) `technical-spec.md` | subagent | Up to 5 files read inside subagent. Delegated correctly. |
| 4 | `implementation-spec.md` + `decisions.md` | subagent | Plus executes file writes across the project (implementation ops). Isolation: worktree. |
| 5 | `implementation-spec.md` + `implementation-log.md` | subagent | Model: sonnet. |
| 6 | All pipeline artifacts + independent scan of CLAUDE.md, `skills/`, `.claude/commands/`, `.claude/agents/` | subagent | Model: inherit. Second repo-wide scan (duplicating 3a's work) — see finding F3. |

**Flagged reads in main session:** None. All large reads are correctly delegated to subagents.

### File writes

All stages write outputs to disk in `projects/{name}/pipeline/`. No stage is designed to return its full artifact as subagent-return content. Compliant with best practice #10.

## 4.2.6 — Context loading chain summary

1. Workspace CLAUDE.md (~2,811 tokens) + ai-resources CLAUDE.md (~1,084 tokens) = ~3,895 tokens (always loaded).
2. `/new-project` invocation loads orchestrator body (~4,618 tokens).
3. At stage spawn: subagent loads its own agent file + the invoked skill's SKILL.md (each in isolated subagent context, NOT main).
4. Main-session total at orchestrator start: **~8,513 tokens** (before any subagent spawn or any user context pack paste).
5. Over a pipeline run spanning ~30 turns of gate interactions (6–8 NEXT confirmations + any in-stage discussion), per-turn cost of the above loading is ~8,513 × 30 = ~255,000 tokens in baseline loading (orchestrator + CLAUDE.md content preserved in context across turns).

---

## Findings (Section 4 severity classification applied)

### F1 — Orchestrator file is 351 lines / ~4,618 tokens, loaded on every `/new-project` invocation

**Severity:** MEDIUM

**Evidence:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md`, 351 lines, 3,552 words. Contains multiple large embedded content blocks: canonical permissions block (~20 lines), full jq merge procedure (~20 lines), `additionalDirectories` jq procedure (~20 lines), canonical Commit Rules block (~7 lines, repeated in both "if missing" heredoc and "idempotent append" path = duplicated twice), canonical Input File Handling block (~9 lines, also duplicated twice), full CLAUDE.md heredoc including both blocks verbatim (~27 lines).

**Waste mechanism:** Large orchestrator command means every `/new-project` invocation loads ~4,618 tokens of prose + bash scaffolding, much of which is implementation scaffolding (jq commands, heredoc templates) rather than orchestration logic. Per the protocol's Section 4 assessment #1, large files in main session that could be delegated are HIGH; however, command files are necessarily main-session content. Treating as MEDIUM because the scaffolding could be extracted to a helper script. (boundary — near the 300-line HIGH threshold at 351 lines, just over +15%).

### F2 — No `/compact` or `/clear` breakpoints defined between stages

**Severity:** MEDIUM

**Evidence:** `grep -i "compact|/clear|session boundary|breakpoint"` on `new-project.md` returns zero matches. The 6–8 stages run sequentially in a single orchestrator main session. Each stage requires user NEXT confirmation, each produces an artifact that is read for review, and the main session accumulates: orchestrator body + CLAUDE.md + pipeline-state reads + all review-time reads of artifacts.

**Waste mechanism:** Natural breakpoints exist at every NEXT/SKIP gate. Protocol section 4 assessment #3 flags "No compaction instructions or breakpoints defined" as MEDIUM. No guidance tells the operator or main session to `/compact` after (say) Stage 3a's large repo-snapshot read is reviewed, or to `/clear` between Stage 5 and Stage 6.

### F3 — Stage 6 (session-guide-generator) re-scans the repo that Stage 3a already inventoried

**Severity:** MEDIUM

**Evidence:** `pipeline-stage-3a.md` produces `repo-snapshot.md` covering CLAUDE.md, skills, `.claude/` infrastructure, workflows, file tree. `session-guide-generator.md` lines 28–29 state: "In all cases, also scan the repo state independently: CLAUDE.md, `skills/` directory, `.claude/commands/`, `.claude/agents/`." This is a second full repo scan, even though Stage 6 also reads `repo-snapshot.md` from pipeline artifacts.

**Waste mechanism:** Duplicate repo scan. Both scans happen inside their respective subagents (isolated contexts), so the cost is not main-session token accumulation, but it doubles the per-pipeline-run scan work and re-measures ~90+ SKILL.md files. Since the 3a snapshot is available as a fresh artifact, the independent re-scan is avoidable.

### F4 — No subagent output-size cap or truncation instruction across any pipeline-stage agent

**Severity:** MEDIUM

**Evidence:** Read of all 8 stage agent files. None contains a line-count, word-count, or token-count cap on the artifact the subagent writes to disk. `pipeline-stage-3a.md` line 135 says "Keep the snapshot concise. Full file contents are NOT included — only summaries and metadata" but no numeric cap. Other stages (3b, 3c, 4, 5, 6) have no size guidance at all.

**Waste mechanism:** Artifacts could grow arbitrarily large. When the user (or main session) reads the artifact for review-before-NEXT, a 10,000-word artifact costs ~13,000 tokens of main-session context. No bound exists. Section 4 assessment #1 treats "subagent returning >200 lines to main session" as HIGH, but here the subagent technically writes to disk (not returns), so the severity lands at MEDIUM for the indirect main-session cost at review time.

### F5 — No QC / independent review subagent wired between pipeline stages

**Severity:** MEDIUM

**Evidence:** Workspace CLAUDE.md mandates: "Post-edit QC pass is mandatory" and "Plan QC pass before presenting plans for approval." `new-project.md` Gate Protocol defines only NEXT / SKIP / ABORT. No stage agent delegates to `qc-reviewer`, `evaluator`, or any independent-context reviewer before announcing completion. Stage 3b produces an architecture (large, plan-like artifact that by workspace rule deserves plan QC); no QC subagent is spawned.

**Waste mechanism:** Per Section 4 assessment #4, "Consistent need for >3 refinement cycles" is MEDIUM — and the absence of built-in QC typically correlates with higher refinement counts discovered at review time. If an architecture is rejected at stage 3b review, the re-run of 3b (and possibly 3c + 4 downstream) is a refinement multiplier. Since no telemetry exists, the designed multiplier is 1 but the observed risk is not mitigated. Flagged as MEDIUM (structural inference — no observed data).

### F6 — Orchestrator reloaded on every `/new-project` continuation invocation

**Severity:** LOW

**Evidence:** Because pipeline runs typically span multiple sessions (per the "Continuation" mode in `new-project.md` lines 84–90), each new session that resumes the pipeline re-loads: workspace CLAUDE.md + ai-resources CLAUDE.md + full orchestrator body (~8,513 tokens) before a single turn of actual pipeline work. Across an 8-stage, 8-session pipeline, that is 8 × ~8,513 = ~68,100 tokens spent on startup loading alone.

**Waste mechanism:** This is a fixed cost of the architecture, not a waste per se, but it is proportional to orchestrator size (F1) — shrinking the orchestrator compounds with session count. Severity LOW because the alternative (single-session pipeline) is not feasible given gate semantics.

### F7 — 7 pipeline skills (1,707 lines combined, ~15,460 tokens) are loaded per-stage in isolated subagent contexts

**Severity:** LOW

**Evidence:** Per-skill line counts: implementation-project-planner 207, spec-writer 242, architecture-designer 239, implementation-spec-writer 294 (boundary — 294 is near but under the 300-line HIGH threshold), project-implementer 185, project-tester 220, session-guide-generator 320 (over 300-line HIGH threshold — HIGH per Section 2 criteria but LOW for Section 4 because loaded in a subagent, not main). Only one skill loads per stage subagent; each subagent has its own clean context.

**Waste mechanism:** None directly for main session — the subagent isolation works correctly. Flagging here because the subagent context cost (subagent model tokens) adds up across 6–8 spawns per pipeline run. Skill sizes are the per-stage overhead for the subagent's own context budget.

Skills with boundary/HIGH sizes that pipeline stages invoke:
- `session-guide-generator/SKILL.md` — 320 lines (HIGH per Section 2 protocol)
- `implementation-spec-writer/SKILL.md` — 294 lines (boundary — within 15% of HIGH)

### F8 — Stage 3a (repo snapshot) is unbounded: scales with ai-resources repo size

**Severity:** MEDIUM

**Evidence:** `pipeline-stage-3a.md` lines 22–65. Instructions tell the subagent to read every skill's SKILL.md, every file in every `.claude/` subdirectory, every workflow's `.claude/` subdirectory (recursive), plus a 2-level deep file tree. The ai-resources repo currently contains 90+ skills (per Section 2 measurement from parallel audit). A single 3a run therefore reads 90+ skill frontmatters + N command files + N agent files + N hook files + workflow trees.

**Waste mechanism:** Stage 3a subagent context cost grows linearly with ai-resources repo size. Output artifact (repo-snapshot.md) must summarize all this. Because this is in a subagent (not main), it doesn't hit main-session context, but it consumes subagent token budget and wall-clock time. If ai-resources continues to grow, this stage degrades first. Severity MEDIUM for subagent cost (best-practice recommends paginating or filtering large-file scans; no such filtering here).

---

## Protocol gaps

- Section 4 severity rules are written for scenarios where subagents return content to main. `/new-project`'s pattern (write-to-disk, return short announcement) complies with best practice #10 but shifts the main-session cost to artifact-review time, which is not explicitly covered by the HIGH/MEDIUM/LOW thresholds. I interpreted artifact-review-time cost as MEDIUM (indirect return), noted in F4.
- Protocol does not specify how to weight per-stage-subagent skill loading (F7). Treated as a LOW informational finding.
- "Consistent need for >3 refinement cycles" (Section 4 assessment #4) requires telemetry. No session-usage-analyzer data is available for this workflow, so F5 is a structural inference.
