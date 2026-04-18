# Section 4 — Workflow Token Efficiency Audit

**Workflow:** Service Development Workflow (Parts 2–3 and Working Hypotheses)
**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan`
**Scope:** Local `.claude/commands/` + `.claude/agents/` + `/context/` only. Symlinked/ai-resources files not deep-read (audited separately).

---

## Step 4.1 — Workflow Identification

Workflow defined in `projects/buy-side-service-plan/CLAUDE.md` lines 74–159. Three-part lifecycle:
`notes/` → `drafts/` (iterative, numbered) → `approved/`. Gate sequence: `/draft-section` → `/review` (or `/content-review`) → `/challenge` → `/service-design-review` → move to `approved/`.

Commands under scope (local, non-symlinked):
| File | Lines | Words | ~Tokens (×1.3) |
|------|-------|-------|----------------|
| `.claude/commands/draft-section.md` | 70 | 701 | ~911 |
| `.claude/commands/review.md` | 78 | 537 | ~698 |
| `.claude/commands/challenge.md` | 29 | 227 | ~295 |
| `.claude/commands/service-design-review.md` | 29 | 227 | ~295 |
| `.claude/commands/content-review.md` | 17 | 137 | ~178 |
| **Local commands total** | **223** | **1,829** | **~2,378** |

Agents under scope (local, non-symlinked):
| File | Lines | Words | ~Tokens (×1.3) |
|------|-------|-------|----------------|
| `.claude/agents/section-drafter.md` | 88 | 694 | ~902 |
| `.claude/agents/service-designer.md` | 109 | 1,643 | ~2,136 |
| `.claude/agents/strategic-critic.md` | 63 | 806 | ~1,048 |
| `.claude/agents/qc-reviewer.md` | 73 | 619 | ~805 |
| **Local agents total** | **333** | **3,762** | **~4,891** |

Context reference files (per CLAUDE.md lines 130–136, plus four additional files present in `/context/`):
| File | Lines | Words | ~Tokens (×1.3) |
|------|-------|-------|----------------|
| `context/content-architecture.md` | 127 | 1,395 | ~1,814 |
| `context/project-brief.md` | 75 | 939 | ~1,221 |
| `context/style-guide.md` | 4 | 43 | ~56 |
| `context/glossary.md` | 6 | 38 | ~49 |
| `context/domain-knowledge.md` | 4 | 42 | ~55 |
| `context/reader-persona.md` | 75 | 1,168 | ~1,518 |
| `context/documentation-phase-specs.md` | 174 | 1,276 | ~1,659 |
| `context/prose-quality-standards.md` | 753 | 7,858 | ~10,215 |
| `context/doc-2-production-plan.md` | 340 | 3,733 | ~4,853 |
| `context/doc-3-production-plan.md` | 239 | 3,062 | ~3,981 |
| **context/ total** | **1,797** | **19,554** | **~25,420** |

Cross-part reference stores (summary only):
- `report/chapters/` — 45 files, 57,646 words total, ~74,940 tokens if all read
- `parts/part-2-service/approved/` — 9 files, 3,258 lines / 65,905 words, ~85,677 tokens if all read
- `parts/working-hypotheses/approved/working-hypotheses-v3.md` — 370 lines / 3,740 words, ~4,862 tokens
- `parts/part-2-service/drafts/` — numerous files, largest at 641 lines / 14,506 words (~18,858 tokens — `2.8-draft-04.md`)
- `final/modules/` — empty

---

## Step 4.2 — Token Flow Mapping

### Focus Point 1: File-read footprint per drafting session

**Per `/draft-section` invocation (Phase 1 — main session):**
- Reads only `context/content-architecture.md` (target section entry ~10 lines) — small
- Uses Glob (not Read) to check upstream dependency existence
- If iterating: reads the most recent draft (can be 500–650 lines / ~16,000 tokens for large sections like 2.8/2.9)

Main-session context loaded at Phase 1 approval point: small (~10 lines of architecture spec + possibly 1 prior draft). Clean design.

**Per `/draft-section` invocation (Phase 2 — section-drafter subagent):**
The subagent reads (all in its own context, not main):
- `/context/content-architecture.md` (127 lines, ~1,814 tokens)
- Dependency files: WH (370 lines, ~4,862 tokens) + 1–2 knowledge files OR Part 2 approved sections (220–584 lines each, ~4,900–12,705 tokens each)
- `/context/style-guide.md` (6 lines, trivial)
- `/context/glossary.md` (6 lines, trivial)
- `/context/domain-knowledge.md` (4 lines, trivial — **note: file is effectively empty/placeholder at 4 lines**)
- `/logs/decisions.md` (size unknown, not in scope)
- `/parts/part-2-service/notes/drafter-corrections.md` (size unknown, not in scope)
- Previous draft if iterating (up to ~18,858 tokens for 2.8-draft-04)

**Subagent context load per invocation:** typically 15,000–40,000 tokens depending on number of dependencies and section size. Main session stays lean — subagent discards context on return.

### Focus Point 2: Subagent file-reading pattern

`section-drafter.md` declares tools: `Read, Write, Glob, Grep` — reads directly from filesystem. Matches CLAUDE.md lines 44–47 pattern ("execution agents may read files directly when the main agent provides the file list"). **Good pattern — no main-session content transfer.**

`strategic-critic.md` (lines 16–23): reads `/context/*` + `/parts/working-hypotheses/*` + `/report/chapters/` + `/final/modules/` directly. **Good pattern — reads files directly from filesystem, not from main session.**

`service-designer.md` (lines 25–31): reads `/context/*` + `/parts/working-hypotheses/*` + `/report/chapters/` + `/final/modules/` directly. **Good pattern.**

`qc-reviewer.md` (lines 16–23): reads `/context/*` directly. **Good pattern.**

Cross-reference to CLAUDE.md lines 43–44 states: "QC and evaluation agents receive content from the main agent, not file paths. The main agent reads the file and passes the content." However, all three evaluator agents (strategic-critic, service-designer, qc-reviewer) are configured with `Read/Glob/Grep` tools and explicit "read these reference files" instructions. **Finding: CLAUDE.md rule and agent implementation disagree.** The agent files tell the agent to read reference files, but not how the primary draft reaches the agent — the `/review`, `/challenge`, and `/service-design-review` commands just say "Use the X agent to evaluate" without specifying whether the draft content is passed inline or by path. Ambiguity at the command layer.

### Focus Point 3: QC cycle token cost

Three review layers per Part 2 draft (CLAUDE.md lines 146–153): `/review` → `/challenge` → `/service-design-review`.

**`/review` (local variant, distinct from the symlinked chapter review):** Loads `qc-reviewer` agent (73 lines). Returns structured verdict + findings list. The command file says findings "are presented" to Patrik — does NOT instruct writing report to disk. Main session receives full finding list.

**`/challenge`:** Loads `strategic-critic` agent (63 lines). Returns "strategic verdict," "key challenges," "what works," and "the hardest question." Command file (challenge.md lines 13–14): "Present the strategic verdict and key challenges." — findings returned to main session, no disk write instruction.

**`/service-design-review`:** Loads `service-designer` agent (109 lines). Returns "experience verdict," "friction points," "what works," "the fund partner's Monday morning." Command file (lines 13–14): "Present the experience verdict and friction points." — findings returned to main session, no disk write instruction.

**Estimated return volumes per QC layer (structural inference from output-format specs):**
- qc-reviewer: 8 criteria × multiple findings, each with Category/Location/Issue/Severity/Fix + optional mental-model framing (4 sub-elements). Typical return: **300–600 lines, ~4,000–8,000 tokens** into main session.
- strategic-critic: 6 criteria × challenges, each with 5 sub-elements (What/Why/Counter/Direction/What the Partner Sees) + verdict + what-works + hardest-question. Typical return: **200–400 lines, ~3,000–5,000 tokens** into main session.
- service-designer: 6 criteria × friction points, each with 4 sub-elements + verdict + what-works + Monday-morning scenario. Typical return: **250–450 lines, ~3,500–6,000 tokens** into main session.

**Total QC cycle cost per draft iteration (structural estimate):** ~10,500–19,000 tokens returned to main session, distributed across three review cycles. **Severity: HIGH** — each of three review layers returns >200 lines to main session. Command files do NOT instruct subagents to write findings to disk and return only a file path + summary. Findings accumulate in main session across the three layers plus any prior iterations' findings still in context.

### Focus Point 4: Draft iteration pattern

CLAUDE.md line 98: "Never overwrite a previous draft — always create a new numbered version."
CLAUDE.md lines 100–104: Fix application = single new draft via Write, not Edit.

**Subagent re-read cost per iteration:** Per `section-drafter.md` Step 4, the subagent reads the previous draft file when iterating. Example: 2.8 has 9 draft iterations. Draft 9 would have been produced after reading draft 8 (584 lines, ~16,517 tokens). Each iteration, the subagent re-reads the prior draft.

**Cumulative iteration cost in subagent context (per section with N iterations):**
- Iteration 1: base context ~15,000–25,000 tokens
- Iteration N (N>1): base context + previous draft (~12,000–18,000 tokens for mature sections) + operator feedback

For 2.8 (9 iterations), total subagent tokens consumed across all iterations: ~150,000–250,000 tokens cumulative (structural estimate). All subagent tokens — not main session.

**Main-session cost per iteration:** per `draft-section.md` Phase 3 Step 1, main session reads the new draft (~500–640 lines = ~13,000–18,800 tokens for mature sections) to present a summary to Patrik. **Severity: HIGH** — 500+ line file read in main session on every iteration is delegable (subagent already produced a summary in its return message per draft-section.md Step 7).

### Focus Point 5: Bright-Line Rule PreToolUse hook

From `.claude/settings.json` lines 4–14: PreToolUse hook on `Edit` tool matches paths `/(report/chapters|final/modules)/` and emits `{"decision":"block","reason":"BRIGHT-LINE RULE..."}`. **Scope:** only blocks Edit on `report/chapters/` and `final/modules/` paths. **Does NOT block** Edit on `parts/*/drafts/` or `parts/*/approved/` — which is correct, since CLAUDE.md lines 53–62 applies the Bright-Line Rule at "Step 4.2, Step 5.2, Step 5.7, and `/verify-chapter`" (research workflow stages operating on `report/chapters/`).

**Overlap with `/verify-chapter`:** Both the hook and `/verify-chapter` enforce the same rule at the same paths. Hook is a mechanical block; `/verify-chapter` is a procedural check. Overlap is redundant but not costly — the hook's `reason` payload is ~250 characters (~80 tokens), emitted only when Edit is attempted on a blocked path. Token cost: **LOW** — trivial per-invocation.

### Focus Point 6: Cross-part referencing size

When drafting Part 2, the subagent reads Part 1 approved outputs in `/report/chapters/` + `/final/modules/` (per CLAUDE.md lines 122–123; mapped in section-drafter Step 2 to specific knowledge files, not the full chapters directory).

- `report/chapters/` — 45 files, 57,646 words, ~74,940 tokens — **not fully loaded**; section-drafter maps specific dependency codes (1.1, 1.2, 1.3, 1.4) to specific knowledge file paths. Only 1–4 knowledge files per dependency are read, not the full chapters directory.
- Actual knowledge files read are in `output/knowledge-files/` (per `section-drafter.md` Step 2 mapping table), NOT `report/chapters/`. The CLAUDE.md statement "reference Part 1 approved outputs in `/report/chapters/` or `/final/modules/`" conflicts with the subagent's actual mapping which points at `output/knowledge-files/{section}-knowledge-file*.md`. **Documentation/implementation mismatch.**
- `final/modules/` — empty directory — no content to reference despite documentation naming it.

---

## Findings

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---------|----------|-----------------|----------|
| 1 | Three QC/review commands (`/review`, `/challenge`, `/service-design-review`) return full findings to main session instead of writing report to disk and returning only a path + summary | HIGH | Subagent return volume — each ~3,000–8,000 tokens per layer × 3 layers = 10,500–19,000 tokens per draft iteration accumulating in main session | review.md line 4 "Present the QC verdict and findings"; challenge.md line 14 "Present the strategic verdict and key challenges"; service-design-review.md line 14 "Present the experience verdict and friction points" — no disk-write instruction in any of the three command files |
| 2 | Main session re-reads full draft file (up to 640 lines / ~18,800 tokens) after every `/draft-section` Phase 3 completion | HIGH | Unnecessary large file read in main session — subagent's Step 7 return summary already contains file path, word count, sections produced, flags | draft-section.md Phase 3 Step 1 "Read the draft the agent produced"; largest draft is 2.8-draft-04.md at 641 lines / 14,506 words |
| 3 | `/draft-section` command file does not instruct main session to `/compact` between iterations; drafts/reviews/feedback accumulate across multiple iterations (2.8 has 9 iterations, 2.9 has 7+) | MEDIUM | No compaction breakpoints — each iteration's draft-read plus each iteration's three QC returns compound in main session. 9 iterations × average ~25,000 tokens/iteration = ~225,000 tokens accumulated if no compaction | draft-section.md has no mention of `/compact`; no ▸ /compact marker as seen in the symlinked `/review` (line 51) command |
| 4 | Ambiguity between CLAUDE.md context-isolation rule and evaluator-agent implementation regarding how the draft reaches the agent | MEDIUM | Command files don't specify whether the main agent passes draft content inline (cost: full draft tokens passed) or the subagent reads it by path (cost: zero main-session transfer) | CLAUDE.md lines 43–44 states QC agents receive content from main agent; qc-reviewer/strategic-critic/service-designer all have Read tool and "Before Reviewing, read these reference files" instructions but no specification on how the draft itself is delivered; review.md/challenge.md/service-design-review.md similarly silent |
| 5 | Documentation/implementation mismatch on Part 1 dependency location. CLAUDE.md says references live in `/report/chapters/` + `/final/modules/`; section-drafter agent maps to `/output/knowledge-files/{section}*` | MEDIUM | Documentation ambiguity may cause the subagent or a fresh main session to explore and read the wrong directory — `/report/chapters/` contains 45 files / 57,646 words (~74,940 tokens) vs the 4–5 targeted knowledge files. Misdirected exploration reads are delegable waste | CLAUDE.md lines 87–90 + 122–123 point at `/report/chapters/` + `/final/modules/`; section-drafter.md Step 2 table points at `/output/knowledge-files/*`; `/final/modules/` is empty |
| 6 | `context/prose-quality-standards.md` is 753 lines / 7,858 words (~10,215 tokens) (boundary — threshold 500 tokens for "high-cost context load") — read by section-drafter or main session if referenced as a `/context/` file | HIGH (boundary) | If read in main session during any iteration for consistency checking, costs ~10,215 tokens per read. Not referenced explicitly in draft-section.md, qc-reviewer.md, strategic-critic.md, or service-designer.md, but present in `/context/` and may be read via exploration | File listing from `wc -l -w` on `/context/`; no agent/command explicitly lists it but none explicitly excludes it either |
| 7 | `context/doc-2-production-plan.md` (340 lines, ~4,853 tokens) and `context/doc-3-production-plan.md` (239 lines, ~3,981 tokens) are large production-plan artifacts sitting in `/context/` where any fresh agent exploring the context directory may read them | MEDIUM | If read during any agent's "Read reference files" step, each costs ~4,000–4,900 tokens. No deny-rule coverage confirmed for these documentation artifacts | File listing from `wc -l -w`; `/context/` is listed as the canonical reference directory in CLAUDE.md line 131 |
| 8 | Empty/placeholder context files referenced by agents: `domain-knowledge.md` (4 lines, 42 words), `glossary.md` (6 lines, 38 words), `style-guide.md` (4 lines, 43 words) | LOW | Every subagent invocation (section-drafter, qc-reviewer, strategic-critic, service-designer) reads these 3 files — trivial individual cost (~150 tokens combined) but the design promise (agents ground in domain-knowledge, glossary, style-guide) is unfulfilled. Token cost is negligible; analytical cost is structural | Files measured at <6 lines each; section-drafter.md Step 3 and all three evaluator agents reference these files in "Before Reviewing" / "Read Reference Files" steps |
| 9 | Subagent re-reads previous draft on every iteration (section-drafter.md Step 4); no summary-based delta pattern | MEDIUM | Iteration cost in subagent scales linearly with draft size × iteration count. 2.8 at 9 iterations: prior draft re-read each time at ~16,000 tokens = ~128,000 tokens of redundant prior-draft reads across the section's iteration history (subagent-scoped, not main — but still real API cost) | section-drafter.md lines 60–65; drafts directory shows 2.8 at 9 drafts, 2.9 at 7 drafts |
| 10 | Bright-Line hook's blocking message fires only on `Edit` matcher, not on `Write` or `MultiEdit`; scope is limited to `report/chapters/` and `final/modules/` paths only — the rule per CLAUDE.md line 62 applies at "Step 4.2, Step 5.2, Step 5.7, and `/verify-chapter`" | LOW | Token cost of hook payload: ~80 tokens per blocked attempt. Hook scope narrower than documented rule scope (Parts 2–3 not covered) but not a waste mechanism — it's a correctness gap, not a token gap | `.claude/settings.json` lines 4–14; CLAUDE.md lines 53–62 |

---

## Protocol gaps

- Section 4 Step 4.2 question 1 ("what gets loaded at workflow start") is ambiguous when a workflow has multiple entry commands (`/draft-section` vs `/review` vs `/challenge`). Treated as per-command load mapping.
- Protocol does not specify whether "context files the workflow reads" includes files read by subagents. Interpreted as yes, since subagent context loading still consumes API tokens even though it does not accumulate in main session.
- Severity threshold for "subagent returning >200 lines to main session" assumes line count; QC agent return volumes estimated from output-format specs (structural inference), not observed execution data — labeled as such per the protocol's instruction in Step 4.2.

## Threshold-boundary findings

- Finding #6 (`prose-quality-standards.md` 753 lines): well above 300-line HIGH threshold; not a boundary case at line level. However, classification as "loaded in context" depends on whether any command/agent actually references it — that's indirect evidence. Tagged **(boundary)** on the "high-cost context load" claim since no explicit load path was found.
- Finding #9 (iteration re-read cost): 9 iterations for 2.8 is specific to one section; other sections have 2–4 iterations. Scaling the finding across all sections is estimate-dependent.
