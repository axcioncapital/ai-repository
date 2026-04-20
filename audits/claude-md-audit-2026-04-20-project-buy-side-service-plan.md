# CLAUDE.md Audit — 2026-04-20

**Scope:** workspace + project (buy-side-service-plan)
**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 294 lines, ~5,444 tokens
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/CLAUDE.md` — 159 lines, ~2,163 tokens
- Combined always-loaded per turn: ~7,600 tokens (before `@reference/stage-instructions.md` and two other `@`-imports loaded per turn in project sessions)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 9 / MEDIUM: 12 / LOW: 5
- Total always-loaded cost (workspace + project) is ~7,600 tokens/turn — roughly 12× the external best-practice budget of ~600 tokens/turn for root CLAUDE.md, and ~38× the 200-line ceiling guidance.
- Projected savings if all HIGH + MEDIUM recommendations applied: ~3,900 tokens/turn — ~117,000/session at 30 turns, ~195,000/session at 50 turns.
- **Net verdict:** Both files are materially oversized. The workspace file has crossed from "rules" into "operational manual" and pays per-turn cost for content that applies to <25% of turns (Session Guardrails, Agent Tier table, Agent Harness, AI Resource Creation Rules). The project file embeds workflow methodology that belongs in `reference/stage-instructions.md` (already referenced via `@`) and carries dated phase status that drifts. Primary recommendations: move Agent Tier table, Session Guardrails details, Agent Harness block, AI Resource Creation Rules, and the project "Service Development Workflow" sub-blocks into lazy-loaded reference files; delete the project "Current Phase" paragraph; trim prose across most remaining blocks.

## Per-File Inventory

### Workspace CLAUDE.md

| # | Block (heading) | Approx tokens | Type | @-refs |
|---|---|---|---|---|
| W1 | What This Workspace Is For | ~60 | descriptive | no |
| W2 | Projects | ~180 | reference/descriptive | no |
| W3 | Axcíon's Tool Ecosystem | ~90 | descriptive | no |
| W4 | Skill Library | ~80 | rule | no |
| W5 | AI Resource Creation Rules | ~330 | rule (multi-bullet) | no |
| W6 | Design Judgment Principles | ~280 | discretionary | no |
| W7 | QC Independence Rule | ~440 | rule (3 sub-blocks) | no |
| W8 | Completion Standard | ~130 | rule | no |
| W9 | Working Principles | ~260 | rule (bullet list) | no |
| W10 | Input File Handling | ~330 | rule | no |
| W11 | Operator-Provided File Intake | ~280 | rule | no |
| W12 | Autonomy Rules | ~160 | rule | no |
| W13 | Applying Audit Recommendations | ~220 | rule | no |
| W14 | Session Guardrails (parent) | ~130 | rule | no |
| W14a | H3: `[HEAVY]` | ~190 | rule | no |
| W14b | H3: `[SCOPE]` | ~170 | rule | no |
| W14c | H3: `[AMBIGUOUS]` | ~140 | rule | no |
| W14d | H3: `[COST]` | ~200 | rule | no |
| W14e | H3: Tuning | ~90 | rule | no |
| W15 | Plan Mode Discipline | ~170 | rule | no |
| W16 | CLAUDE.md Scoping | ~280 | meta-rule | no |
| W17 | Model Tier (parent) | ~230 | rule | no |
| W17a | H3: Agents (+ tier table) | ~620 | rule + 20-row inline table | no |
| W18 | File verification and git commits (parent) | ~30 | rule | no |
| W18a | H3: Use the filesystem, not git | ~110 | rule | no |
| W18b | H3: Commit behavior | ~180 | rule | no |
| W18c | H3: Commit-boundary sequencing | ~110 | rule | no |
| W18d | H3: Concurrent-session staging discipline | ~170 | rule | no |
| W19 | Delivery | ~25 | descriptive | no |
| W20 | Agent Harness | ~310 | rule (harness-only, gated) | 1 (`@.claude/references/harness-rules.md`) |

Total: ~5,444 tokens across 20 H2 / 10 H3 blocks.

### Project CLAUDE.md

| # | Block (heading) | Approx tokens | Type | @-refs |
|---|---|---|---|---|
| P1 | Project Context | ~200 | status/descriptive | 1 (`@reference/stage-instructions.md`) |
| P2 | Operator Profile | ~50 | descriptive | no |
| P3 | Workflow Overview | ~100 | descriptive | 3 (stage-instructions, file-conventions, quality-standards) |
| P4 | Workflow Status Command | ~80 | command doc | no |
| P5 | Collaboration Coach | ~100 | command doc | no |
| P6 | Cross-Model Rules | ~80 | rule | no |
| P7 | Context Isolation Rules | ~210 | rule | no |
| P8 | Citation Conversion Rule | ~80 | rule | no |
| P9 | Bright-Line Rule (All Fix Steps) | ~130 | rule | no |
| P10 | Model Selection | ~140 | rule | no |
| P11 | Adaptive Thinking Override | ~60 | rule | no |
| P12 | Service Development Workflow (parent) | ~10 | heading only | no |
| P12a | H3: Content Architecture | ~110 | workflow methodology | no |
| P12b | H3: Where Part 1 Content Lives | ~70 | workflow methodology | no |
| P12c | H3: Content Lifecycle (Parts 2–3 and WH) | ~200 | workflow methodology | no |
| P12d | H3: Plan Mode | ~230 | rule + workflow guidance | no |
| P12e | H3: Cross-Part Referencing | ~90 | workflow methodology | no |
| P12f | H3: Directory Clarification | ~70 | workflow methodology | no |
| P12g | H3: Context Reference Files | ~80 | reference list | no |
| P12h | H3: Save Progress Incrementally | ~45 | rule | no |
| P12i | H3: Friction Log Auto-Start | ~60 | rule | no |
| P12j | H3: Strategic Evaluation | ~190 | workflow methodology | no |

Total: ~2,163 tokens across 12 H2 / 10 H3 blocks.

---

## Tier 1 — Token Cost

### HIGH

**F1-1 [HIGH] — W17a "Agents" (Agent Tier table).** ~620 tokens. Largest single block in the workspace file (~11% of workspace total). A 20-row agent tier inventory is documentation, not rule. It informs behavior on <5% of turns (only when adding/retrofitting an agent). This is textbook "verbose table inline" anti-pattern per external guidance. **Evidence:** table has no conditional-load hook; loads every turn; content is Haiku/Sonnet/Opus assignment per agent — nothing that changes per-turn behavior. Source: external guidance ("verbose tables belong in referenced file").

**F1-2 [HIGH] — W14 Session Guardrails (parent + 5 H3s).** ~920 tokens combined (~17% of workspace file). Four flags with extensive trigger enumeration, exempted-command lists, flag-format templates, and a tuning plan. Applies to a specific subset of turn-situations. High elaboration for a self-enforcement mechanism that explicitly says it has "no hook, no hard gate." Source: priors + external guidance ("over-specification erosion past ~200 lines").

**F1-3 [HIGH] — W20 Agent Harness block.** ~310 tokens. Entirely gated on "when running any harness skill, session, or command" — applies to 0% of buy-side-service-plan turns (harness is unrelated to the research workflow in this project). Self-instruction "Do NOT load harness rules when doing unrelated work" is followed by the full list of harness skills, commands, and hard rules inline, paying the cost anyway. Source: external guidance + priors (block is conditional-load by its own admission).

**F1-4 [HIGH] — W5 AI Resource Creation Rules.** ~330 tokens. Applies only on turns where a skill gap surfaces (rare — empirically <10% of turns in this project, which is a research workflow, not an AI-resource-building session). Long prose argument could compress to: "Shared AI resources live in `ai-resources/`; use `/create-skill`, `/improve-skill`, `/migrate-skill`; do not improvise skill-like artifacts." Source: external guidance (conditional-load pattern).

### MEDIUM

**F1-5 [MED] — W7 QC Independence Rule.** ~440 tokens. Applies broadly but the three sub-blocks (Evaluation context isolation, Post-edit QC, Plan QC) are each dense prose paragraphs that could compress to bullet form at ~180 tokens total without losing operational substance.

**F1-6 [MED] — W10 Input File Handling.** ~330 tokens. Core rule ("default to Read, don't Write") is bright-line. Rationale paragraph and "Exception: legitimate copying" clause add ~150 tokens for edge cases that fire on <5% of turns.

**F1-7 [MED] — W11 Operator-Provided File Intake.** ~280 tokens. Overlaps conceptually with W10 (Input File Handling). Combined, W10+W11 = ~610 tokens governing file-write discipline.

**F1-8 [MED] — W6 Design Judgment Principles.** ~280 tokens. Six bullet points of discretionary "principles." External guidance flags aspirational/descriptive prose as deletion candidates — "Ambiguity is normal" and "Friction is diagnostic" do not change behavior Claude wouldn't otherwise exhibit.

**F1-9 [MED] — P7 Context Isolation Rules.** ~210 tokens. Applies on delegation turns only (subset). Could compress to 3 bullets.

**F1-10 [MED] — P12d Plan Mode sub-block.** ~230 tokens. Conflates two concepts (plan-mode default and assumptions-gate) — the assumptions-gate is the load-bearing rule; the plan-mode defaulting could compress or route to a `/draft-section` command file.

**F1-11 [MED] — P12j Strategic Evaluation.** ~190 tokens. Workflow methodology describing three review layers and cross-section edit routing. Applies only when drafting Part 2 or WH — not every turn.

**F1-12 [MED] — W2 Projects block.** ~180 tokens. Descriptive inventory of directories. External guidance: documentation Claude can find by reading source files does not belong in always-loaded memory (boundary — some of this is orientation, some is drift).

---

## Tier 2 — Redundancy

### HIGH

**F2-1 [HIGH] — Skill Library rule duplicated: W4 (workspace) ↔ W9 (Working Principles bullet 1) ↔ W5 (AI Resource Creation Rules point 4).**
- W4: "Read the relevant SKILL.md before performing any task that has a corresponding skill."
- W9 bullet 1: "Read the relevant SKILL.md before performing any task that has a corresponding skill" (verbatim).
- W5 point 4: "Always use the canonical pipelines: `/create-skill` for new skills..."
Three separate statements, same rule surface. Minimum ~80 tokens redundant.

**F2-2 [HIGH] — Model selection duplicated across workspace and project: W17 "Model Tier" ↔ P10 "Model Selection".**
- W17 (workspace): "Default model for all Axcíon projects is Sonnet."
- P10 (project): "Default model for this project is Opus 4.7."
These are not just redundant — they are directly contradictory (see Tier 3). Even setting aside the contradiction, both files spend tokens establishing defaults, per-command overrides, and command categorizations.

**F2-3 [HIGH] — QC independence / post-edit QC rule in workspace ↔ project Strategic Evaluation sub-block.**
- W7 workspace: "Post-edit QC pass is mandatory" + plan QC pass.
- P12j project: three-layer review (QC → challenge → service-design-review).
Both assert QC-before-approval discipline. The workspace rule is general; the project rule is workflow-specific but restates the "never skip QC" logic already in W9 (Working Principles) and W7.

### MEDIUM

**F2-4 [MED] — Working Principles (W9) restates rules already covered elsewhere.**
- "Read the relevant SKILL.md..." (duplicates W4).
- "Follow the project's defined sequence — don't skip gates" (duplicates W8 Completion Standard and W12 Autonomy Rules).
- "Never skip QC" (duplicates W7).
- "Run evaluations via subagent for independence" (duplicates W7).
W9 is a digest of other blocks. ~150 tokens redundant.

**F2-5 [MED] — Content architecture restated in P1 and P12a.**
- P1: "Document architecture: Working Hypotheses → Part 1 → Part 2 → Part 3."
- P12a: same sequence re-stated with bullets, then "Development sequence: Part 1 → Working Hypotheses → Part 2 → Part 3."
~70 tokens overlap; also a minor inconsistency in how the bridge (Working Hypotheses) is sequenced.

**F2-6 [MED] — CLAUDE.md Scoping (W16) explicitly calls out workflow methodology belongs in `reference/*.md`, yet P12 block embeds workflow methodology inline.** The workspace meta-rule is correct but not enforced against the project file — the redundancy here is "the rule that says don't duplicate" paying tokens while the very duplication it forbids exists in the peer file.

---

## Tier 3 — Contradictions

### HIGH

**F3-1 [HIGH] — Default model: Sonnet (workspace W17) vs. Opus 4.7 (project P10).**
- W17: "Default model for all Axcíon projects is Sonnet."
- P10: "Default model for this project is Opus 4.7 (`claude-opus-4-7`, set in `.claude/settings.local.json`)."
Direct contradiction for buy-side-service-plan sessions. Project-level override is legitimate practice, but the workspace rule says "all Axcíon projects" without carve-out, and the project rule claims Opus as its default. A reader (human or model) encountering both cannot tell which wins without out-of-band knowledge. Scenario where they diverge: a new command added to the project without explicit frontmatter — workspace rule says Sonnet, project rule says Opus.

**F3-2 [HIGH] — Autonomy posture: workspace W12 "proceed through stages automatically" + "err toward proceeding" vs. project P9 Bright-Line Rule (All Fix Steps) + P12d Plan Mode + P12j Strategic Evaluation which mandate PAUSE gates.**
- W12: "When in doubt about severity, err toward proceeding and logging what you did rather than stopping to ask."
- P9: "Before applying ANY fix to report prose... If ANY check is true, the fix MUST NOT be applied without explicit operator approval."
- P12d: "Wait for Patrik's approval before drafting."
These are resolvable by scope (workspace rule for non-critical, project rule for prose fixes) but neither rule carves out the other explicitly. A fix that touches a sourced statement could be read as "proceed (workspace)" or "pause (project)." The project bright-line is stricter and presumably wins, but this should be stated.

**F3-3 [HIGH] — Plan mode: workspace W15 "Do not re-enter plan mode to address QC findings" vs. project P12d "Use plan mode as the default for content work."**
- W15: "If the harness forces plan mode re-entry... still avoid the full five-phase ritual."
- P12d: "Before executing a drafting task, present the full plan... Wait for Patrik's approval before drafting."
Workspace rule discourages ceremony; project rule mandates it for content work. These do not formally contradict (workspace covers QC-fix re-entry, project covers drafting start) but the overlap (a QC-fix on content that arguably counts as "content work") is ambiguous.

---

## Tier 4 — Staleness

### HIGH

**F4-1 [HIGH] — P1 "Current Phase" paragraph.**
"Doc 3 ... v1.0 complete as of 2026-04-13. Doc 2 ... v1.0 complete. Part 1 research (1.1–1.4) complete and published. Part 2 Service Creation (2.1–2.9) approved. Part 3 (3.1 ...) approved and serving as style anchor. Working Hypotheses v3 locked. Next: session wrap and next-priority selection."
~90 tokens of phase status embedded in always-loaded memory. External guidance: "Storing task state, history, or project status in CLAUDE.md" is a HIGH-severity anti-pattern — status drifts silently and pays per-turn tokens for stale content. The "Next: session wrap and next-priority selection" clause was true on 2026-04-13; today is 2026-04-20 with multiple commits since. Source: external guidance ("Storing task state, history, or project status").

### MEDIUM

**F4-2 [MED] — W17a Agent Tier table tagged "as of 2026-04-18".** The dated marker is honest but signals the content is a living inventory that will drift without enforcement. Retrofit notes ("Retrofitted 2026-04-18 from inherit") are change-history that no longer informs forward behavior.

**F4-3 [MED] — W18d Concurrent-session staging discipline cites "The 2026-04-18 `/wrap-session` incident is the motivating case."** The incident justifies the rule but the rule itself is now standing. The incident citation is a change-log note, not behavioral guidance — the rule would read cleanly without it (save ~25 tokens; also prevents staleness as incidents accumulate).

**F4-4 [MED] — W5 AI Resource Creation Rules references specific legacy command patterns:** "the `kb-*` commands in global-macro-analysis, the `plan-*`/`spec-*` commands in project-planning". These are examples from other projects used as illustration — stale if those projects rename or deprecate commands.

---

## Tier 5 — Misplacement

Workspace CLAUDE.md W16 explicitly states: "Skill methodology → belongs in SKILL.md", "Workflow methodology → belongs in workflow's reference docs", "Canonical workspace rules ... A short pointer in project CLAUDE.md is acceptable; verbatim duplication is not."

### HIGH

**F5-1 [HIGH] — W17a "Agents" + Agent Tier table (~620 tokens).** Belongs in `ai-resources/.claude/agents/README.md` or `ai-resources/docs/agent-tier-table.md`. A one-line pointer in workspace CLAUDE.md ("Agent model tiers: see `ai-resources/docs/agent-tier-table.md`") preserves the rule while offloading the inventory. Source: external guidance ("verbose tables belong in referenced file").

**F5-2 [HIGH] — W20 Agent Harness (~310 tokens).** Entirely conditional ("When running any harness skill, session, or command"). Move the hard rules into `.claude/references/harness-rules.md` (already exists per the `@`-ref) and replace the workspace block with a single line: "Agent Harness: see `@.claude/references/harness-rules.md` when running harness skills/commands." Source: external guidance (conditional-load pattern).

**F5-3 [HIGH] — W14 Session Guardrails H3 details (~920 tokens).** Move flag-trigger enumerations, exempted-command lists, and tuning plan to `ai-resources/docs/session-guardrails.md`. Keep a compressed workspace block: the four flag tags, one-line triggers, and a pointer. Source: external guidance + priors.

**F5-4 [HIGH] — P12 Service Development Workflow block and sub-blocks (~1,155 tokens project-side).** Content Architecture (P12a), Where Part 1 Content Lives (P12b), Content Lifecycle (P12c), Cross-Part Referencing (P12e), Directory Clarification (P12f), Context Reference Files (P12g), Save Progress Incrementally (P12h), Strategic Evaluation (P12j) are all workflow methodology. `reference/stage-instructions.md` already exists and is `@`-referenced. Move these sub-blocks there (or to `reference/content-workflow.md`) and keep only the pointer and the bright-line rules (Assumptions gate in P12d is the one genuine rule worth keeping in CLAUDE.md). Source: W16 CLAUDE.md Scoping + external guidance.

### MEDIUM

**F5-5 [MED] — W5 AI Resource Creation Rules.** Move the detailed routing prose to `ai-resources/docs/ai-resource-creation.md`; keep a 3-line pointer in workspace CLAUDE.md. Fires on <10% of turns in most projects. Source: external guidance (conditional-load).

**F5-6 [MED] — W13 Applying Audit Recommendations.** ~220 tokens that apply only when running or consuming an audit. Belongs in the audit commands' own files or in `ai-resources/docs/audit-discipline.md`, with workspace pointer.

**F5-7 [MED] — P4 Workflow Status Command + P5 Collaboration Coach.** ~180 tokens combined describing what individual slash commands do. Slash commands are self-documenting when invoked; these descriptions belong in the command files, not CLAUDE.md.

**F5-8 [MED] — P12g Context Reference Files.** Bullet list of context file paths. Belongs in a manifest file (`context/README.md` or `reference/context-manifest.md`) referenced on demand.

---

## Tier 6 — Clarity

### MEDIUM

**F6-1 [MED] — W9 Working Principles, "Pre-compact checkpoint."** "When context usage approaches ~50%" — Claude cannot reliably self-measure context percentage from inside the model (the Session Guardrails section explicitly acknowledges this for `[COST]`). This threshold is unverifiable; the deterministic triggers in `[COST]` are the actually-fireable version. Rewording: remove the "~50%" self-measurement cue, defer entirely to `[COST]` triggers.

**F6-2 [MED] — W12 Autonomy Rules, "non-critical issues (formatting, minor wording, small structural fixes)."** "Small" is undefined. Project P9 Bright-Line Rule gives concrete scope (multi-paragraph / analytical-claim / sourced-statement) — workspace rule would benefit from a similar bright-line threshold or an explicit deference to P9.

### LOW

**F6-3 [LOW] — W6 Design Judgment Principles, "When in doubt."** Several bullets use "when appropriate," "should consider," without bright-line thresholds.

**F6-4 [LOW] — P12d Plan Mode, "simple, well-defined tasks."** The carve-out list (glossary term, renaming a file) is helpful but "simple" remains a judgment call.

**F6-5 [LOW] — W8 Completion Standard, "substantial artifact."** Substantial is not defined.

**F6-6 [LOW] — P3 Workflow Overview artifact chain is a descriptive one-liner.** Not wrong, but unclear whether it is a rule (must follow this order) or documentation (this is how it flows). Flagging as low-severity clarity.

**F6-7 [LOW] — W18a "Use the filesystem, not git."** The principle is clear; the header phrasing ("Use the filesystem, not git, to verify your own work") is slightly narrower than the rule body (which covers both verification and does not fully address cases where git status legitimately matters, e.g., during commit staging). Minor.

---

## Per-Block Verdict Table

Every block from both files appears below. Move-target paths are suggestions; no edits are proposed here.

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| W1 What This Workspace Is For | workspace | 60 | Keep | Orientation; small | — | priors |
| W2 Projects | workspace | 180 | Trim | Compress directory inventory to essentials | — | guidance |
| W3 Axcíon's Tool Ecosystem | workspace | 90 | Keep | Small, cross-cutting; load-bearing for tool routing | — | priors |
| W4 Skill Library | workspace | 80 | Trim | Collapse into a single sentence; duplicates W9 bullet 1 | — | priors |
| W5 AI Resource Creation Rules | workspace | 330 | Move | Applies to <10% of turns; pipeline-specific | `ai-resources/docs/ai-resource-creation.md` | guidance |
| W6 Design Judgment Principles | workspace | 280 | Trim | Aspirational prose; keep "Conflicts must be surfaced" and "Separate evidence from interpretation" — delete the rest | — | guidance |
| W7 QC Independence Rule | workspace | 440 | Trim | Compress three sub-blocks into bulleted rules | — | guidance |
| W8 Completion Standard | workspace | 130 | Keep | Load-bearing; defines BLOCKING vs IMPORTANT | — | priors |
| W9 Working Principles | workspace | 260 | Trim | Deduplicate against W4/W7/W8/W12; keep only unique items (Pre-compact checkpoint, version-file pattern) | — | priors |
| W10 Input File Handling | workspace | 330 | Trim | Keep bright-line default-Read rule; move exception detail to footnote or command file | — | guidance |
| W11 Operator-Provided File Intake | workspace | 280 | Trim | Merge with W10 under one "File Write Discipline" block; ~150 tokens saved | — | priors |
| W12 Autonomy Rules | workspace | 160 | Keep | Bright-line rule; used constantly | — | priors |
| W13 Applying Audit Recommendations | workspace | 220 | Move | Fires only during audits | `ai-resources/docs/audit-discipline.md` or audit command files | guidance |
| W14 Session Guardrails (parent) | workspace | 130 | Trim | Keep the four tag names and a pointer | — | priors |
| W14a `[HEAVY]` | workspace | 190 | Move | Detailed triggers belong in reference | `ai-resources/docs/session-guardrails.md` | guidance |
| W14b `[SCOPE]` | workspace | 170 | Move | Same as W14a | `ai-resources/docs/session-guardrails.md` | guidance |
| W14c `[AMBIGUOUS]` | workspace | 140 | Move | Same | `ai-resources/docs/session-guardrails.md` | guidance |
| W14d `[COST]` | workspace | 200 | Move | Same | `ai-resources/docs/session-guardrails.md` | guidance |
| W14e Tuning | workspace | 90 | Move | Maintenance note; not behavioral | `ai-resources/docs/session-guardrails.md` | priors |
| W15 Plan Mode Discipline | workspace | 170 | Keep | Active anti-ritual rule; firing often | — | priors |
| W16 CLAUDE.md Scoping | workspace | 280 | Trim | Compress to bullet list; this meta-rule is load-bearing but verbose | — | priors |
| W17 Model Tier (parent) | workspace | 230 | Trim | Compress command categorization; resolve contradiction with P10 | — | priors |
| W17a Agents + Tier Table | workspace | 620 | Move | 20-row table and tier guidance both → reference | `ai-resources/docs/agent-tier-table.md` | guidance |
| W18 File verification (parent) | workspace | 30 | Keep | Heading; small | — | priors |
| W18a Filesystem not git | workspace | 110 | Keep | Bright-line; fires on most sessions | — | priors |
| W18b Commit behavior | workspace | 180 | Keep | Core commit rule; heavily used | — | priors |
| W18c Commit-boundary sequencing | workspace | 110 | Keep | Bright-line; fires during plan execution | — | priors |
| W18d Concurrent-session staging | workspace | 170 | Trim | Remove 2026-04-18 incident citation; keep the rule | — | priors |
| W19 Delivery | workspace | 25 | Keep | Small | — | priors |
| W20 Agent Harness | workspace | 310 | Move | 0% of buy-side turns; already has `@`-ref target | `.claude/references/harness-rules.md` (already exists) | guidance |
| P1 Project Context | project | 200 | Trim | Delete "Current Phase" paragraph (stale, drifts); keep What/Lens/Evidence | — | guidance |
| P2 Operator Profile | project | 50 | Keep | Small | — | priors |
| P3 Workflow Overview | project | 100 | Keep | Orientation + `@`-refs; well-structured | — | priors |
| P4 Workflow Status Command | project | 80 | Move | Self-documenting command | inside command file or delete | priors |
| P5 Collaboration Coach | project | 100 | Move | Self-documenting command | inside command file or delete | priors |
| P6 Cross-Model Rules | project | 80 | Keep | Bright-line tool-routing rules | — | priors |
| P7 Context Isolation Rules | project | 210 | Trim | Compress to bullets; fires on delegation turns | — | guidance |
| P8 Citation Conversion Rule | project | 80 | Keep | Bright-line; fires during citation conversion | — | priors |
| P9 Bright-Line Rule (All Fix Steps) | project | 130 | Keep | Core project rule; frequently fires | — | priors |
| P10 Model Selection | project | 140 | Trim | Resolve contradiction with W17; compress | — | priors |
| P11 Adaptive Thinking Override | project | 60 | Keep | Single session-env rule | — | priors |
| P12 Service Dev Workflow (parent) | project | 10 | Keep | Heading | — | priors |
| P12a Content Architecture | project | 110 | Move | Workflow methodology | `reference/stage-instructions.md` | W16 guidance |
| P12b Where Part 1 Content Lives | project | 70 | Move | Workflow methodology | `reference/stage-instructions.md` or `reference/file-conventions.md` | W16 guidance |
| P12c Content Lifecycle | project | 200 | Move | Workflow methodology (lifecycle rules, Fix vs Iteration) | `reference/stage-instructions.md` | W16 guidance |
| P12d Plan Mode | project | 230 | Trim | Keep "Assumptions gate" bright-line in CLAUDE.md; move plan-mode defaulting to draft-section command | partial → command file | priors |
| P12e Cross-Part Referencing | project | 90 | Move | Workflow methodology | `reference/stage-instructions.md` | W16 guidance |
| P12f Directory Clarification | project | 70 | Move | File-layout rule | `reference/file-conventions.md` | W16 guidance |
| P12g Context Reference Files | project | 80 | Move | Manifest | `context/README.md` | priors |
| P12h Save Progress Incrementally | project | 45 | Keep | Small, cross-cutting | — | priors |
| P12i Friction Log Auto-Start | project | 60 | Keep | Documents a hook; small | — | priors |
| P12j Strategic Evaluation | project | 190 | Move | Workflow methodology (three-review-layer process) | `reference/stage-instructions.md` | W16 guidance |

Row count: 52 (30 workspace + 22 project) — exceeds total block count (20 H2 + 10 H3 workspace = 30; 12 H2 + 10 H3 project = 22). Every block listed.

---

## Estimated Savings

Per-turn savings if HIGH + MEDIUM recommendations applied (rough, estimation caveat applies):

| Tier | Savings est. (tokens/turn) |
|---|---|
| T1 Token cost (trims only, no moves) | ~800 |
| T2 Redundancy (merges, deduplications) | ~300 |
| T4 Staleness (delete "Current Phase," drop dated incident) | ~120 |
| T5 Misplacement (W17a + W20 + W14 H3s + P12 sub-blocks) | ~2,700 |
| T6 Clarity (rewordings; minor) | ~20 |

Note: T1 and T5 overlap — moving W17a already counts the T1 savings. Net independent savings after de-overlap: ~3,900 tokens/turn.

| Horizon | Savings |
|---|---|
| Per turn | ~3,900 tokens |
| 30-turn session | ~117,000 tokens |
| 50-turn session | ~195,000 tokens |

Target end-state: workspace ~1,500 tokens, project ~800 tokens, combined ~2,300 tokens/turn — still above the 600-token external ideal but within a 2–3× factor and consistent with an index-plus-links architecture. Further reduction possible by consolidating W18 H3s and collapsing W6–W9 into a unified "Working Principles" block with bullets.

---

## External Guidance Cited

1. [Best Practices for Claude Code](https://code.claude.com/docs/en/best-practices) — root CLAUDE.md size budget, conditional-load pattern.
2. [How Claude remembers your project](https://code.claude.com/docs/en/memory) — `@import` semantics; import depth; per-turn load.
3. [Writing a good CLAUDE.md — HumanLayer](https://www.humanlayer.dev/blog/writing-a-good-claude-md) — 50–100 line target, ~200 line ceiling, prune ruthlessly.
4. [You (probably) don't understand Claude Code memory — Parreo Garcia](https://joseparreogarcia.substack.com/p/claude-code-memory-explained) — anti-patterns: storing task state, aspirational prose, verbose tables.
5. [Claude Code Token Optimization Guide 2026 — buildtolaunch](https://buildtolaunch.substack.com/p/claude-code-token-optimization) — per-turn token tax, index+link pattern, Opus long-context does not relax the budget.
6. Priors: workspace W16 "CLAUDE.md Scoping" meta-rule (self-asserted scoping constraints) and the audit notes file.
