---
name: /summary — faithful document summarization
status: draft — awaiting /create-skill
created: 2026-04-22
type: build brief
---

# `/summary` Skill — Build Brief

## Problem statement

Patrik periodically needs to produce stakeholder-facing summaries of long documents (strategy, plans, proposals, memos) — compressing e.g. a 60-page plan into a ~10-page digest suitable for sending to a colleague like Daniel. The summary must be information-dense and precise: a **faithful compression** of the source, not an analytical reframe, not a TL;DR-only executive abstract, not a selective highlight reel. No capability of this shape exists in the workspace today.

The core design tension: compression implies dropping content, but a stakeholder-facing summary must not drop the load-bearing content (numbers, names, decisions, commitments). The skill's job is to enforce that asymmetry — drop rhetorical scaffolding and illustrative material, preserve all factual and decision-relevant content.

## Capability / what it does

Given a path to a substantial markdown or plain-text document, `/summary` produces a shorter document at a specified compression target, with:

- A **TL;DR** at the top (5–10 bullets covering headline findings, key decisions, commitments, open questions).
- A **compressed body** that mirrors the source's section structure (same headings, same order) — each section compressed to preserve load-bearing content only.

The summary is written to a new file (never overwrites source) and the output path is returned to the operator.

## Trigger conditions

Use when:
- Operator invokes `/summary <path>` on a markdown or plain-text document.
- Source is substantial (~>10 pages or ~>5k words). Below that threshold, summarization has diminishing returns and the skill should note this but proceed if the operator confirms.

Do NOT use for:
- Code files (structure doesn't map to compression in the same way).
- Reference data / tables-only documents (would strip the data).
- Analytical reframing ("rewrite this strategy from Daniel's perspective") — that's a different task, not compression.
- Trivially short inputs.

## Input contract

- **Required argument:** path to source document.
- **Optional arguments:**
  - `--target <N>w` — word target (primary unit, authoritative). Example: `--target 2000w`.
  - `--target <N>p` — page target (convenience shortcut, converted at 500 words/page).
  - `--target <N>%` — ratio target. Example: `--target 17%`.
  - If `--target` omitted: default to **1/6 of source word count** *(default derived from operator's 60-page → 10-page example; pipeline should confirm this calibration in Step 1)*.
  - `--output <path>` — default: same directory as source, filename `{source-stem}-summary.md`. If target path exists, skill aborts with a message; does not overwrite silently. `--force` permits overwrite.

## Output structure

Two sections only:

1. **TL;DR** — 5–10 bullets: headline findings, key decisions, commitments, open questions surfaced in the source.
2. **Compressed body** — mirrors source's section structure (same headings, same order). Each section compressed per the fidelity rules below.

## Fidelity rules (load-bearing)

### Must survive compression

- All numerical figures (amounts, percentages, counts, dates, timeframes)
- All named entities (people, orgs, products, places, systems)
- All commitments, decisions, dependencies, assignments, deadlines
- All risks, open questions, escalations
- All specific claims with attribution
- **Direct quotations** — preserve verbatim with attribution; do not paraphrase
- **Source citations / footnotes** — preserve with original numbering, or convert to inline attribution; do not drop
- **Tables** — preserve as tables when they carry numerical or structural data; prose-convert only if the table is purely decorative
- **Code blocks and formulas** — verbatim
- **Hyperlinks** — preserve anchor text and URLs

### Can drop or collapse

- Transitions, rhetorical scaffolding, repeated framing
- Illustrative examples — keep one representative per point
- Defensive hedging, "as noted above" back-references
- Meta-commentary on the document itself ("this section covers...")
- **Figures / images** — replace with a one-line descriptive caption noting what the figure shows; do not attempt to recreate

### Must not introduce

- Claims not in source
- Analytical conclusions the source does not draw
- Inferred motivations or intent

## Dependencies

None beyond base Claude Code file I/O. No subagents, no external API calls, no bundled scripts anticipated.

## Open questions for `/create-skill` Step 1

The following expand scope beyond the operator's core request and are flagged for the pipeline to decide rather than being prescribed here:

1. **Built-in fidelity QC.** Should the skill include a post-draft QC pass (self-check or subagent) verifying that numbers/dates/named entities in surviving sections of the source are present in the summary, and that no claims were introduced? Or leave QC to operator invocation of `/qc-pass`?
2. **Optional appendix.** Should the output offer an optional appendix (entity index, date table, numerical roll-up) for very long sources? Operator did not request this; it is a plausible but non-essential extension.
3. **Audience framing.** Should the skill take an `--audience` flag or similar to shape front-matter framing (the operator mentioned "for Daniel" as an example recipient), or leave this to operator prompt at invocation?
4. **Page-conversion constant.** The 500-words-per-page figure is a round default. Should this be tuned (some documents are denser than others) or treated as fixed?
5. **Source-format coverage.** Brief anticipates markdown and plain text. Should the skill explicitly handle other inputs (e.g., operator-pasted text, Google Drive files via MCP, PDFs)? Default answer: no for v1 — file paths only.

## References

- Workspace convention: `ai-resources/skills/ai-resource-builder/SKILL.md` (skill format + Create Workflow)
- Pipeline: `ai-resources/.claude/commands/create-skill.md`
- Target command location post-build: `ai-resources/.claude/commands/summary.md` (thin invoker; produced manually post-pipeline, as `/create-skill` produces SKILL.md only)
- Workspace design principle: "Separate evidence from interpretation" (workspace CLAUDE.md) — this skill is compression (evidence preservation), not interpretation.
