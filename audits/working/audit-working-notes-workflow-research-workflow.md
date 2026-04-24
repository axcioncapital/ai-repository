# Section 4 Working Notes — Workflow: research-workflow

**Scope:** `ai-resources/workflows/research-workflow/` (template workflow; project-scoped instances inherit this structure).
**Focus per orchestrator:** token flow through the three-command prose pipeline (`produce-architecture`, `produce-prose-draft`, `produce-formatting`), subagent return volumes, and inline file-loading that could be delegated.
**Protocol:** token-audit-protocol v1.2, Section 4, Steps 4.1–4.2.
**Token estimation method:** word count × 1.3 (±30% drift caveat per protocol header).

---

### 4. Workflow Token Efficiency

**Workflows identified:** `research-workflow` (template at `workflows/research-workflow/`). This invocation audits that workflow only; other workflow-like artifacts in `ai-resources/` (e.g., `/create-skill` pipeline, `/token-audit`) are out of scope.

#### Workflow: research-workflow (prose sub-pipeline: produce-architecture → produce-prose-draft → produce-formatting)

**Context loading chain (per-command start, main session):**

`produce-architecture` (per-part, called once per Part 2/3):
1. CLAUDE.md (project) ~1,768 tokens (1,360 w × 1.3)
2. stage-instructions.md (via @ reference in CLAUDE.md; loaded on activation) ~2,870 tokens (2,208 w × 1.3)
3. produce-architecture.md command body ~1,746 tokens (1,343 w × 1.3)
4. Phase 2 reads: all section drafts (variable, 4–9 sections × ~1,500–3,000 words = ~7,800–35,000 tokens), `context/project-brief.md`, `context/content-architecture.md`, `research-structure-creator/SKILL.md` (~3,208 tokens, 2,468 w × 1.3)
5. Phase 3 reads: `architecture-qc/SKILL.md` (~2,175 tokens), architecture file, all section drafts again (same content re-read in main session)

**Estimated start-of-workflow context (produce-architecture, Phase 2 entry):** ~20,000–50,000 tokens depending on draft count.

`produce-prose-draft` (per section, called N times per part):
1. CLAUDE.md ~1,768 tokens
2. stage-instructions.md (~2,870 tokens, ≈loaded; @ reference from CLAUDE.md)
3. produce-prose-draft.md command body ~4,532 tokens (3,486 w × 1.3) — **by far the largest command file in the workflow**
4. Phase 2 inline reads (main session): source document (~1,500–5,000 tokens), `decision-to-prose-writer/SKILL.md` (~3,110 tokens), architecture.md extracted subset (~500–1,500 tokens)
5. Phase 3 inline reads: prose file (~2,000–6,000 tokens), source document again, `chapter-prose-reviewer/SKILL.md` (~2,898 tokens), `prose-compliance-qc/SKILL.md` (~2,591 tokens)
6. Phase 4 inline reads: prose file + adjacent prose + non-adjacent prose (6+ sections; even with opening/closing excerpt rule, ~6,000–18,000 tokens)
7. Phase 5 inline reads: prose file again, source document again, `ai-prose-decontamination/SKILL.md` (~5,652 tokens)

**Estimated peak context (produce-prose-draft, before Phase 3 /compact):** ~18,000–25,000 tokens loaded into main session across Phases 1–3.

`produce-formatting` (per section, called N times per part):
1. CLAUDE.md ~1,768 tokens
2. stage-instructions.md ~2,870 tokens (if loaded)
3. produce-formatting.md command body ~2,583 tokens (1,987 w × 1.3)
4. Phase 2 inline reads: prose file, `prose-formatter/SKILL.md` (~4,152 tokens), `h3-title-pass/SKILL.md` (~2,254 tokens). Style reference is passed by path — NOT read in main session (confirmed anti-pattern avoided).
5. Phase 3 inline reads: prose file (post-Phase 2), `formatting-qc/SKILL.md` (~2,327 tokens), `document-integration-qc/SKILL.md` (~907 tokens), architecture.md again

**Estimated start-of-command context (produce-formatting, Phase 2 entry):** ~14,000 tokens.

**Full-part run estimate (Part 2 with ~8 sections):** 1× produce-architecture (~30k peak) + 8× produce-prose-draft (~20k peak each, fresh session per section is the implied discipline) + 8× produce-formatting (~14k peak). 17 command invocations per part.

---

**File reads during execution (scope: the three produce-* commands):**

| File | Est. size | Read in main/subagent | Necessary / Delegable? |
|------|-----------|----------------------|------------------------|
| `decision-to-prose-writer/SKILL.md` | ~3,100 tok | MAIN (prose-draft Phase 2 step 2) | Delegable — only the subagent applies the skill; main session does not reason over skill logic |
| `chapter-prose-reviewer/SKILL.md` | ~2,900 tok | MAIN (prose-draft Phase 3 step 3) | Delegable — subagent applies it |
| `prose-compliance-qc/SKILL.md` | ~2,600 tok | MAIN (prose-draft Phase 3 step 4) | Delegable — subagent applies it |
| `ai-prose-decontamination/SKILL.md` | ~5,700 tok | MAIN (prose-draft Phase 5 step 3) | Delegable — subagent applies it; main session compacts immediately after |
| `research-structure-creator/SKILL.md` | ~3,200 tok | MAIN (architecture Phase 2 step 4) | Delegable — subagent applies it |
| `architecture-qc/SKILL.md` | ~2,200 tok | MAIN (architecture Phase 3 step 1) | Delegable — subagent applies it |
| `prose-formatter/SKILL.md` | ~4,200 tok | MAIN (formatting Phase 2 step 2) | Delegable — subagent applies it |
| `h3-title-pass/SKILL.md` | ~2,300 tok | MAIN (formatting Phase 2 step 3) | Delegable — subagent applies it |
| `formatting-qc/SKILL.md` | ~2,300 tok | MAIN (formatting Phase 3 step 2) | Delegable — subagent applies it |
| `document-integration-qc/SKILL.md` | ~900 tok | MAIN (formatting Phase 3 step 3) | Delegable (small but still delegable) |
| Source document (decision doc) | ~1,500–5,000 tok | MAIN (prose-draft Phases 2, 3, 5) | Necessary in Phase 2; re-reads in Phases 3 and 5 delegable — subagent could read by path |
| Architecture.md (full file) | variable | MAIN, "first 50 lines" in Phase 1 + extract in Phase 2 | Necessary (to extract section-specific subset before passing to subagent) |
| All section drafts (architecture Phase 2) | ~7,800–35,000 tok | MAIN (architecture Phase 2 step 1 AND Phase 3 step 3) | Phase 2: necessary. Phase 3 re-read: delegable |
| Adjacent + non-adjacent prose sections | ~6,000–18,000 tok | MAIN (prose-draft Phase 4 steps 5–6) | Delegable — integration-check subagent could glob + read internally |
| Prose file (post-each-phase) | ~2,000–6,000 tok | MAIN (prose-draft Phases 3, 4, 5; formatting Phases 3, 4) | Phase 3 first read is necessary (main routes on findings). Subsequent re-reads delegable |

**Files correctly delegated (already in the workflow — not findings):**
- `style-reference.md` — passed by absolute path to subagents in prose-draft Phases 2, 3, 5 and formatting Phase 2, 3. Main session never loads it. (Phase 2 step 0 of prose-draft, line 53, documents this.)
- `context/prose-quality-standards.md` — same pattern; passed by absolute path.

These two are the "Context Isolation Rules exception for large read-only reference files" documented in the workflow CLAUDE.md. The exception is applied correctly for these two files; finding #4 below notes the exception is NOT applied to skill files.

**Files written during execution:**
- Architecture outputs written to disk via subagent (`architecture.md`, `architecture-qc.md`). Main session only reads summary. Correct discipline.
- Prose files written to disk via subagent (Phase 2, 3 fix, 5 outputs). Main session reads them back in subsequent phases. Write discipline correct; read discipline below.
- Decontamination log written to disk (`decontamination-log.md`).
- Formatted prose overwrites prose file (Phase 2 of produce-formatting). Main session reads it back in Phase 3.

---

**Subagent pattern:**

`produce-architecture`:

| Subagent purpose | Returns to main? | Return size estimate |
|-----------------|------------------|---------------------|
| Phase 2: general-purpose — architecture generation (research-structure-creator) | Yes | "section count, processing order, flagged overlaps/conflicts/gaps, word count allocations per section" — structured summary, est. 30–100 lines |
| Phase 3: qc-gate — architecture QC | File to disk; main also reads QC file in Phase 4 | QC file typically 50–150 lines; re-read in Phase 4 for operator presentation |

`produce-prose-draft`:

| Subagent purpose | Returns to main? | Return size estimate |
|-----------------|------------------|---------------------|
| Phase 2: general-purpose — decision-to-prose conversion | Yes | "file path, word count, section count, any flags" — ~10–20 lines |
| Phase 3: qc-reviewer — merged diagnostic + compliance review | Yes — unified findings list combining all passes, with severity ratings and per-spec verdicts | **LARGE.** 4 compliance scans + 13 prose quality standards + expanded detection tests = est. 60–200+ lines for a real section |
| Phase 3 (conditional): general-purpose — fix agent | Yes — writes corrected file + reports fixes | ~20–60 lines |
| Phase 4 (conditional): general-purpose — integration check | Yes — transition drafts, redundancy/contradiction findings, clean-pass note | ~30–150 lines |
| Phase 5: general-purpose (sonnet) — AI prose decontamination | Yes — change counts per pass and per sub-pattern, bright-line flags, constrained passages | ~30–80 lines |

`produce-formatting`:

| Subagent purpose | Returns to main? | Return size estimate |
|-----------------|------------------|---------------------|
| Phase 2: general-purpose (sonnet) — formatting + H3 pass | Yes — MTC pre-scan results, formatting change log, H3 decisions table, SPLIT verdicts, final H3 count, flagged items | **LARGE.** H3 decisions table lists every heading with verdict + rationale + reversal instruction. Est. 50–200+ lines. Return explicitly required (line 49). |
| Phase 3: qc-reviewer — merged formatting-qc + document-integration-qc | Yes — Stage 1 findings, fixes applied log, bright-line candidates, Stage 2 findings grouped by four check categories, transition drafts, verdict | **LARGE.** Two skills' findings + transition drafts. Est. 60–200+ lines. |

---

**Findings:**

| # | Finding | Severity | Waste mechanism | Location |
|---|---------|----------|----------------|----------|
| 1 | Phase 2 subagent of `produce-formatting` returns the full H3 decisions table + formatting change log + MTC pre-scan + SPLIT verdicts to main session. For a section with 10–20 headings, return volume commonly exceeds 200 lines. Required by design (operator must see REMOVE verdicts for reversal at Phase 4). | HIGH | Large subagent return written into main-session context; cannot be /compacted away before Phase 3 because Phase 3 passes "deferred items list from Phase 2" (line 76) and Phase 4 reports them (line 102–105). | `produce-formatting.md:49–55`, `:102–105` |
| 2 | Phase 3 subagent of `produce-formatting` returns a unified two-stage QC report (formatting-qc + document-integration-qc findings, fixes applied log, bright-line candidates, Stage 2 findings grouped by four check categories, transition drafts, verdict). Est. 60–200+ lines. | HIGH | Large subagent return consumed by main session for routing (line 87–92) and Phase 4 handoff presentation. | `produce-formatting.md:71–86` |
| 3 | Phase 3 subagent of `produce-prose-draft` returns a unified findings list combining chapter-prose-reviewer diagnostic review + prose-compliance-qc four-scan findings + 13 prose quality checks with severity ratings and per-spec verdicts. Est. 60–200+ lines for a real section. | HIGH | Large subagent return; main session routes on this content (Phase 3 step 6, five-way branch) and carries it forward into Phase 6 handoff (line 113 explicitly requires it survive /compact). | `produce-prose-draft.md:88–104`, `:113` |
| 4 | Ten skill files are read in the main session before being passed to subagents. Total main-session skill-file load across the three-command pipeline per section: ~29,400 tokens of skill content (decision-to-prose-writer 3,100 + chapter-prose-reviewer 2,900 + prose-compliance-qc 2,600 + ai-prose-decontamination 5,700 + research-structure-creator 3,200 + architecture-qc 2,200 + prose-formatter 4,200 + h3-title-pass 2,300 + formatting-qc 2,300 + document-integration-qc 900). | HIGH | Inline read in main session for "content passing" to subagent. Main agent does not reason over the skill logic; the subagent does. Could be reduced to subagent reading the skill by path (symmetric with how `style-reference.md` and `prose-quality-standards.md` are already passed). The workflow CLAUDE.md names this exception; it is not applied to skill files. | `produce-prose-draft.md:55, 86, 87, 171`; `produce-architecture.md:46, 67`; `produce-formatting.md:34, 35, 65, 66` |
| 5 | Source document is read in `produce-prose-draft` main session three times: Phase 2 step 1, Phase 3 step 2, Phase 5 step 2. Each phase's subagent then receives it as content in the brief. | HIGH | Redundant main-session file reads; typical decision doc 1,500–5,000 tokens × 3 phases = up to 15,000 wasted main-session tokens per section. | `produce-prose-draft.md:54, 85, 170` |
| 6 | `produce-prose-draft` Phase 4 (integration check) reads adjacent prose sections AND all other completed prose sections in main session (steps 5–6). For a document part with 6+ completed sections, even with the "opening and closing paragraphs only" rule, this is 6,000–18,000 tokens loaded into main session before being passed to the subagent. | HIGH | Large main-session file read that is entirely delegable — the integration-check subagent could glob and read the files itself. | `produce-prose-draft.md:125, 129–130` |
| 7 | `produce-architecture` Phase 3 re-reads all section drafts in main session (step 3) for the QC subagent, even though Phase 2 already loaded them. Drafts can total 7,800–35,000 tokens. (boundary — depends on whether Phase 2 draft reads are still in context or were compacted) | HIGH | Second full read of section drafts in main session when the QC subagent could read paths directly. | `produce-architecture.md:69` |
| 8 | No `/compact` directive between phases of `produce-architecture` before Phase 3's re-read of section drafts. Phase 2 ends with `▸ /compact` (line 59) and Phase 3 ends with `▸ /compact` (line 84), but Phase 3 still reads section drafts after Phase 2's compact, meaning drafts re-enter context. | MEDIUM | Compaction markers exist but the re-read pattern defeats them (finding #7 above). | `produce-architecture.md:59, 84` |
| 9 | `produce-prose-draft.md` command file itself is 3,486 words / ~4,532 tokens / 203 lines — the largest command file in the workflow. Loaded on every invocation. Command body is ~2.6× larger than `produce-architecture.md`. (boundary — protocol's 300-line threshold applies to skills; no explicit command-file threshold) | MEDIUM | Command file loaded once per invocation × N sections; each section invocation reloads the full command body. | `produce-prose-draft.md` file size |
| 10 | Refinement multiplier: `produce-prose-draft` designs for up to 5 subagent launches per section (Phase 2 writer + Phase 3 reviewer + conditional Phase 3 fix + conditional Phase 4 integration + Phase 5 decontamination) plus routing decisions that can PAUSE and re-run Phase 2. Combined with `produce-architecture` (2 subagents) and `produce-formatting` (2 subagents), a single section routed through the full pipeline uses 7–9 subagent invocations. Documented target: "4–5 subagent launches" per produce-prose-draft section (line 8). | MEDIUM | Protocol flags ">3 refinement cycles consistently" as MEDIUM. 4–5 per command × 3 commands = structurally high. | `produce-prose-draft.md:8` header note |
| 11 | Phase 3 of `produce-prose-draft` returns the unified findings list to a "handoff note for the main session" (line 113) that "must survive the compact" — meaning the large return is explicitly protected from /compact. This prevents the /compact at step 8 from reclaiming the tokens. | MEDIUM | Intentional context retention pattern: the findings list stays in main-session context through Phase 4, 5, 6. Increases effective session-long context footprint. | `produce-prose-draft.md:113, 115` |
| 12 | `produce-formatting` Phase 3 passes "Cross-section integration findings from `/produce-prose-draft` Phase 4 (if available in the session context)" (line 77) — implying main-session carryover of Phase 4 findings across the boundary between the two commands. If both commands run back-to-back without /clear, Phase 4 findings from prose-draft + findings carried into formatting Phase 3 compound. | MEDIUM | Implicit cross-command context carryover; no explicit /clear between `produce-prose-draft` and `produce-formatting`. | `produce-formatting.md:77` |
| 13 | `produce-formatting` Phase 1 step 4 "Decontamination check" only verifies the decontamination log contains an entry for the section; it does not gate on `/clear` between commands. Phase 4 handoff of `produce-prose-draft` already loaded the post-decontamination prose file (line 193), so if `/produce-formatting` runs in the same session, that content is still resident. (boundary — depends on operator session-break habits) | MEDIUM | No enforced session boundary between the three commands. | `produce-formatting.md:21–23`; `produce-prose-draft.md:193` |
| 14 | `architecture.md` is read in main session in three places across the pipeline: `produce-prose-draft` Phase 1 step 4 ("first 50 lines"), Phase 2 step 0 subagent brief construction (extracted subset), Phase 4 step 4; `produce-formatting` Phase 3 step 4. The "first 50 lines" read is small verification; the full extraction in Phase 2 is delegable. | LOW | Small per-read size; accumulates modestly. | `produce-prose-draft.md:28, 62, 128`; `produce-formatting.md:67` |
| 15 | Other workflow commands (`workflow-status`, `run-preparation`, `run-execution`, `run-analysis`, `run-report`, `run-synthesis`, `run-cluster`) are outside the scope of this audit. `run-execution.md` is 16,100 bytes — larger than the three produce-* commands — and warrants a future audit pass. | LOW (out of scope) | Not measured in this section. | `.claude/commands/run-execution.md` |
| 16 | `produce-prose-draft.md` embeds very detailed Tier 1/2/3 standard lists inline in the subagent brief (Phase 2 step 3, task 4 — ~800 words of standards text) instead of referencing the quality-standards file by path. This text is loaded into main-session context on every section invocation even though the subagent also receives the path to `prose-quality-standards.md`. | MEDIUM | Duplication: quality standards file passed by path AND command body inlines a Tier 1/2/3 summary of the same standards. | `produce-prose-draft.md:72` |
| 17 | `produce-prose-draft.md` Phase 3 inlines "Expanded detection tests for Standards 10, 11, 12, 13" (~400 words, line 102) directly in the subagent brief. Same pattern as #16 — these tests belong in `prose-quality-standards.md` or `prose-compliance-qc/SKILL.md`, not in the command body. | MEDIUM | Inline test specifications bloat the main-session-loaded command file on every invocation. | `produce-prose-draft.md:102` |
| 18 | `CLAUDE.md` for research-workflow uses `@reference/stage-instructions.md` (128-line CLAUDE.md + 129-line stage-instructions = 257 lines of always-loaded project context, est. 3,568 w × 1.3 = ~4,640 tokens combined). The @ reference loads stage-instructions on every turn per CLAUDE.md conventions. (boundary — @ reference semantics are "load on activation") | MEDIUM | Near-always-loaded context for every command invocation. | `workflows/research-workflow/CLAUDE.md:15` |

**/compact opportunity assessment:**
- `produce-architecture` has `▸ /compact` at end of Phase 2 (line 59) and Phase 3 (line 84). Present, but undercut by Phase 3's re-read of section drafts (finding #7, #8).
- `produce-prose-draft` has `▸ /compact` at end of Phase 2 (line 76), Phase 3 (line 115), Phase 4 (line 159), Phase 5 (line 187). Frequent. But Phase 3 handoff note is explicitly preserved across compact (line 113) — intentional but contributes to sustained context footprint.
- `produce-formatting` has `▸ /compact` at end of Phase 2 (line 56) and Phase 3 (line 93). Present.
- No `/clear` directive between commands. Findings #12 and #13 note this.

**Subagent return-volume summary:**
Seven to nine subagent calls in the three-command prose pipeline (architecture 2 + prose-draft 3–5 + formatting 2). Of these, five return structured findings/decision tables that can exceed 60–200 lines (findings #1, #2, #3; plus the prose-draft Phase 3 fix-agent return and Phase 4 integration-check return). Two return small summaries (prose-draft Phase 2 writer; prose-draft Phase 5 decontamination). Large-return subagents drive the majority of main-session context cost downstream.

**Refinement multiplier (per section, full pipeline):**
Structural: 7–9 subagent launches end-to-end. Protocol threshold for concern is ">3 consistently" — research-workflow structurally exceeds this. The April 2026 split (consolidated produce-prose.md → three commands) kept the launch count unchanged; it redistributed ownership into smaller per-command scopes.

---

### Protocol gaps (interpretation notes)

- Protocol Section 4 does not define a line threshold for command files themselves. Finding #9 (produce-prose-draft = 203 lines / ~4,532 tokens) is flagged by analogy to the skill 300-line threshold but is not strictly covered by the severity rules. Tagged MEDIUM (boundary).
- Protocol's "~200 lines returned to main session → HIGH" threshold is applied to findings #1, #2, #3. All three are structurally capable of exceeding 200 lines for real prose sections; whether they do on any given run depends on section length and number of findings. Tagged HIGH but acknowledged as range estimates.
- Findings #7, #13, #18, #9 are tagged `(boundary)` — they depend on session-state assumptions (whether /compact fully cleared prior loads; whether operator ran /clear between commands; @ reference loading semantics; command-line threshold by analogy) that cannot be verified from the command text alone.
- The "session telemetry" referenced in the protocol is not available to this subagent scope — all estimates here are structural inferences from command text, not observed data.

### File paths inspected

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md` (loaded via system-reminder)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md` (loaded via system-reminder)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/file-conventions.md` (partial)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-architecture.md` (full)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md` (full)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-formatting.md` (full)
- Skill word counts: `decision-to-prose-writer`, `chapter-prose-reviewer`, `prose-compliance-qc`, `ai-prose-decontamination`, `prose-formatter`, `h3-title-pass`, `formatting-qc`, `document-integration-qc`, `research-structure-creator`, `architecture-qc` (inventory only — word counts measured, full SKILL.md bodies not read)
