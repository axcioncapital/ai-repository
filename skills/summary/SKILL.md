---
name: summary
description: >
  Compresses long markdown or plain-text documents (plans, strategies, proposals, memos) into
  shorter, faithful summaries for stakeholder distribution. Preserves source structure, all
  numbers, names, decisions, commitments, quotations, citations, and tables — drops only
  rhetorical scaffolding and illustrative material. Use when the operator invokes /summary
  <path> on a substantial markdown or plain-text document. Do NOT use for code files, reference
  data, analytical reframing, or trivially short inputs.
model: opus
allowed-tools: Read, Write
disable-model-invocation: true
---

# summary

Produce a faithful, information-dense compression of a long document for stakeholder distribution. The output preserves the source author's structure and claims — it is **not** an editorial digest, analytical reframe, or interpretive memo.

## Purpose

Given a substantial source document (typically 10+ pages or 5k+ words), produce a shorter version at a specified compression target that a stakeholder can read instead of the full source. The summary must be faithful enough that a reader acting on it will not be surprised by the full document, and dense enough to be worth sending.

The skill enforces an asymmetric preservation policy: **rhetorical scaffolding can be dropped; load-bearing content cannot.** When in tension with the word target, fidelity wins — overshooting the target is preferable to dropping load-bearing content.

## When to use

Use when the operator invokes `/summary <path>` with a substantial markdown or plain-text document as input.

**Do not use for:**
- Code files — structure doesn't compress the same way.
- Reference data / tables-only documents — compression would strip the data.
- Analytical reframing ("summarize this plan from Daniel's perspective," "distill to key principles") — that is a different product; this skill does faithful compression only, not editorial reframing.
- Trivially short inputs (under ~5k words) — diminishing returns; note this and proceed only if the operator confirms.

## Input contract

**Required:** path to source document (markdown or plain text).

**Optional arguments:**

| Argument | Meaning | Default |
|---|---|---|
| `--target <N>w` | Word target (authoritative unit). Example: `--target 2000w`. | — |
| `--target <N>p` | Page target (shortcut, converted at 500 words/page). Example: `--target 10p`. | — |
| `--target <N>%` | Ratio target. Example: `--target 17%`. | — |
| `--output <path>` | Output file path. | Same directory as source, filename `{source-stem}-summary.md`. |
| `--force` | Permit overwrite of existing output path. | Off. |

If `--target` is omitted, default to **1/6 of source word count** (round to nearest 500 words). This default derives from a 60→10 page calibration example; it is a heuristic, not a strict rule.

**Feasibility check:** If the requested target is below **2% of source word count**, abort with a message explaining that fidelity rules cannot be honored at that compression level, and suggest a less-aggressive target. Do not silently produce a summary that violates the fidelity rules to hit an impossible target.

**Overwrite guard:** If the output path exists and `--force` is not set, abort with a message stating the path exists. Do not overwrite silently.

## Output structure

Two sections only:

### 1. TL;DR

5–10 bullet points at the top of the summary, covering:
- Headline findings or thesis
- Key decisions the source commits to
- Major commitments, deadlines, or dependencies
- Open questions or escalations the source surfaces

Write the TL;DR **last**, after the compressed body, so it reflects what actually survived compression rather than what seemed important on first read.

### 2. Compressed body

Mirrors the source's section structure — **same headings, same order**. Each section is compressed per the fidelity rules below.

Do not:
- Reorder sections.
- Merge sections across the source's heading boundaries (even if similar).
- Introduce new section headings not present in the source.
- Add an executive summary, appendix, entity index, or other novel structural element.

## Fidelity rules

These are load-bearing. When any rule conflicts with the word target, the rule wins.

### Must survive compression

- **All numerical figures** — amounts, percentages, counts, dates, timeframes, thresholds.
- **All named entities** — people, organizations, products, places, systems, documents.
- **All commitments, decisions, dependencies, assignments, deadlines.**
- **All risks, open questions, escalations.**
- **All specific claims with attribution** — if the source says "per legal review," preserve the attribution.
- **Direct quotations** — verbatim, with attribution. Do not paraphrase quoted material.
- **Source citations / footnotes** — preserve with original numbering, or convert to inline attribution. Do not drop citations.
- **Tables** — preserve as tables when they carry numerical or structural data. Prose-convert only if the table is purely decorative (e.g., a comparison table whose content is one line per cell).
- **Code blocks and formulas** — verbatim.
- **Hyperlinks** — preserve both anchor text and URLs.

### Can drop or collapse

- Transitions ("turning to the next section…", "as noted above…").
- Rhetorical scaffolding and repeated framing ("the importance of X cannot be overstated…").
- Illustrative examples — keep **one** representative example per point; drop the rest.
- Defensive hedging and meta-commentary on the document itself ("this section covers…", "before we dive in…").
- Figures / images — replace with a one-line descriptive caption noting what the figure shows. Do not attempt to recreate.

### Must not introduce

- **Claims not in the source.** If the source is silent on X, the summary is silent on X.
- **Analytical conclusions the source does not draw.** Do not connect dots the author left unconnected.
- **Inferred motivations or intent.** "The author seems to believe…" does not belong in a faithful compression.
- **Cleaner certainty.** If the source hedges ("may", "could", "under certain conditions"), preserve the hedging. Do not resolve the author's ambiguity.

## Execution workflow

Follow this sequence. Do not skip steps.

### 1. Parse and validate

- Parse the invocation arguments.
- Verify the source path exists and is readable. If not, abort with a clear error message.
- Verify the output path does not exist (or `--force` is set). If it exists without `--force`, abort.

### 2. Read and inventory the source

- Read the source document in full.
- Count the source word count.
- Build a heading inventory: list every heading in order with its level (H1, H2, H3…) and the word count under it.
- Identify load-bearing elements across the whole document: count numbers, named entities, quotations, citations, tables, code blocks, hyperlinks, figures. Hold this inventory in mind for the verification step.

### 3. Calculate targets and check feasibility

- Resolve the word target from `--target` or the 1/6 default.
- Round target to the nearest 500 words.
- If target < 2% of source word count, abort with a feasibility message.
- Compute per-section word budget proportional to source section word counts. Sections dense in load-bearing content (tables, numbers, citations) may need upward adjustment — do not force uniform compression ratio per section.

### 4. Compress section by section

Work through the source in order, one section at a time. For each section:

- Apply the fidelity rules.
- Aim for the section's word budget but allow overshoot when load-bearing content demands it.
- If a section is very short or purely transitional in the source, it may be dropped entirely — but **reconcile the heading hierarchy** so no orphan headings remain. (If you drop an H2 that was the only H2 under an H1, the H1's H3s may need to be promoted to H2s, or the H1 may need a compressed synthesis paragraph.)
- Preserve tables as tables. Do not prose-convert data-bearing tables to hit a word target.

### 5. Draft the TL;DR

After the compressed body is drafted:

- Write 5–10 bullets covering: headline findings, key decisions, major commitments, open questions.
- Each bullet should reference content present in the compressed body. Do not introduce TL;DR points that do not appear in the body.
- Place the TL;DR at the top of the output, above all section headings.

### 6. Verification pass

Before writing to file, run these checks on the draft:

- **Numbers and dates:** Does every numerical figure and date in the source that belongs to a surviving section appear in the summary?
- **Named entities:** Does every named entity tied to a commitment, decision, or claim appear in the summary?
- **Quotations:** Are all retained quotations verbatim with attribution?
- **Introduced claims:** Does any claim in the summary lack a source anchor? If yes, remove or correct.
- **Structure match:** Does heading order match the source (or has drop-reconciliation been handled cleanly)?
- **Hedging preserved:** Where the source hedges, does the summary preserve the hedge?

If a check fails, fix and re-run the affected check. Do not proceed to write until all checks pass.

### 7. Write and report

- Write the summary to the resolved output path.
- Report to the operator: output path, final word count (actual), achieved compression ratio, any sections dropped or merged, and any notable fidelity trade-offs (e.g., "section 4 overshoots budget because of a dense compliance table that could not be compressed").

## Bias countering

Four biases commonly distort summaries. Counter each actively.

1. **Compression bias** — wanting to drop material to hit the target. Fidelity rules take precedence over the target. Overshooting is acceptable; under-preserving is not.

2. **Interpretation drift** — introducing framing, emphasis, or synthesis the source does not contain. If you catch yourself writing "this reveals…" or "the implication is…," check whether those words appear in the source. If not, delete them.

3. **Selection bias** — compressing the parts you find interesting and glossing the parts you don't. Counter: work through sections in source order with proportional word budgets. Do not decide a section is "less important" — the source author already made the structural choices.

4. **Confidence inflation** — resolving the source's uncertainty into cleaner claims. If the source says "may be feasible under conditions X and Y," do not summarize as "is feasible." Preserve the conditional.

Additionally: if the source contains claims that seem questionable, inconsistent, or erroneous, **preserve them faithfully and note the observation to the operator in the completion report.** Do not silently correct the author. The summary is a compression, not a QC pass.

## Known pitfalls

- **Very long sources (>50k words / >100 pages).** Claude's context window handles typical strategy/plan documents (15–30k words) easily, but very long sources may exceed working capacity. If the source is oversized, flag this to the operator before attempting a full read — a different approach (chunked summarization, table-of-contents-guided extraction) may be needed.

- **Dense table-heavy documents.** Tables are preserved verbatim; they do not compress. A source that is 60% tables may produce a summary that is barely shorter than the source once TL;DR, prose compression, and tables are assembled. This is correct behavior — do not artificially shrink tables to hit a target.

- **Sources without clear heading structure.** If the source is one long untitled essay, structure preservation has nothing to mirror. Compress linearly, preserving paragraph order, and note in the completion report that no section structure was available.

- **Mixed-language sources.** If the source contains passages in a language other than the source's primary language, preserve those passages in their original language unless the source itself translates them.

- **Orphan headings after section drop.** Dropping a section requires reconciling the heading hierarchy (see Step 4). Do not leave empty headings; do not break hierarchy validity (an H3 without a parent H2).

## Runtime recommendations

- **Model:** Opus. Fidelity-sensitive compression rewards careful reading; Sonnet tends to paraphrase quotations and resolve source hedging into cleaner claims, which violates the fidelity rules. Do not downgrade unless deliberately trading fidelity for speed.
- **Context window:** Typical sources (plans, strategies, proposals) run 5k–30k words and fit comfortably. Sources above ~50k words risk running into working-capacity limits; for those, flag to the operator before attempting a full read rather than producing a degraded partial summary.
- **Subagent posture:** Safe to run in the main session or as a subagent. When run as a subagent, return the completion report and output path only; do not return the full summary inline.
- **Tool access:** Requires Read (source) and Write (output). No external tools or network access.
- **Paths:** No path scoping — operator supplies the source path at invocation.

## Failure behavior

- **Source not found or unreadable:** Abort with a clear error; do not attempt partial processing.
- **Output path exists without `--force`:** Abort; state the path and the `--force` flag.
- **Target below 2% feasibility threshold:** Abort; state the minimum feasible target for this source.
- **Source is below the trigger threshold (~5k words):** Note to operator; proceed only if operator confirms.
- **Source too long for reliable single-pass processing:** Flag to operator; do not produce a degraded partial summary silently.
- **Fidelity-rule conflict that cannot be resolved at the requested target:** Produce the faithful summary and overshoot the target. Flag the overshoot in the completion report with specifics.
- **Ambiguous or contradictory source content:** Preserve the ambiguity or contradiction faithfully; flag the observation in the completion report.

If the operator's invocation is missing load-bearing detail (no source path, ambiguous target), ask once. Do not infer.

## Validation checklist

Before reporting completion, confirm:

- [ ] Output file written at the resolved path.
- [ ] TL;DR present at top, 5–10 bullets, all bullets traceable to body content.
- [ ] Compressed body mirrors source heading structure (with any drops reconciled).
- [ ] All numerical figures, named entities, quotations, citations, tables, code blocks, hyperlinks from surviving sections are present.
- [ ] No claims introduced that lack a source anchor.
- [ ] Source hedging preserved where present.
- [ ] Achieved word count within a reasonable band of target, or overshoot is justified and flagged.
- [ ] Completion report delivered with path, word count, compression ratio, and any fidelity trade-offs.

## Example

Compact illustrative example. Real sources are typically 5k–30k words; this 400-word toy source is sized for SKILL.md only.

### Sample source (`q3-iberia-plan.md`, 405 words)

```markdown
# Q3 Iberia Market Entry Plan

## Executive mandate

As we've discussed in multiple forums over the past year, and as has been emphasized by the CEO on several occasions, the time has come to commit to an Iberia market entry. The Board approved this direction on 2026-02-14, after extensive debate that I want to briefly recap. The decision is conditional on a €4.5M year-one capex envelope, and — importantly — a go/no-go review at month 9. Maria Silva has been named to lead the initiative, reporting into the CEO with a dotted line to CFO Torben Jensen specifically on capex draws. It's worth noting that this plan is the direct outgrowth of the 2025 European expansion study we commissioned last year. This plan supersedes the 2024 Italy-first proposal, which was deferred indefinitely per the Q4 2025 strategy offsite.

## Go-to-market

Our go-to-market approach is deliberate. We will stand up a Madrid office first — this should not be controversial given the team sizing study. Staffing in H2 2026 will be 12 FTEs, broken down as 4 commercial, 3 product, 3 ops, and 2 compliance. Product launch will target Lisbon overflow from month 7. Before that, we intend to run a soft pilot limited to our existing Spanish-subsidiary accounts (no more than 20). Pricing will be 8% below our UK benchmark, which reflects market willingness-to-pay per the March 2026 Kantar study we commissioned.

## Risks

Two risks deserve particular attention. First, Spanish data-residency regulations may force a local-cloud deployment. This could add €600k–€900k to capex, per Legal's preliminary read dated 2026-04-01. Second, the Catalonia VAT question remains unresolved — we are awaiting the Deloitte opinion, which is expected May 2026. Both of these are go/no-go gates at month 9.

## Open questions

- Who owns the Portuguese localization decision: commercial or product?
- Does the 8% price differential erode to zero once Kantar's "price perception" uplift is modeled in?
```

### Sample output (`q3-iberia-plan-summary.md`, ~140 words body + TL;DR)

```markdown
## TL;DR

- Board approved Iberia entry 2026-02-14; €4.5M year-one capex; month-9 go/no-go.
- Maria Silva leads; CFO Torben Jensen approves capex draws.
- Madrid office first (12 FTEs H2 2026); Lisbon overflow from month 7.
- Pricing 8% below UK benchmark (March 2026 Kantar study).
- Risks: Spanish data residency (€600k–€900k capex add, Legal 2026-04-01); Catalonia VAT (Deloitte opinion May 2026).
- Open: Portuguese localization ownership; durability of 8% price differential.

## Q3 Iberia Market Entry Plan

### Executive mandate
Board approved Iberia entry 2026-02-14. €4.5M year-one capex; month-9 go/no-go review. Maria Silva leads (reports to CEO; dotted line to CFO Torben Jensen on capex draws). Supersedes the 2024 Italy-first proposal (deferred at Q4 2025 strategy offsite). Outgrowth of the 2025 European expansion study.

### Go-to-market
Madrid office first; H2 2026 staffing 12 FTEs (4 commercial, 3 product, 3 ops, 2 compliance). Lisbon overflow from month 7. Pre-GA soft pilot: ≤20 existing Spanish-subsidiary accounts. Pricing 8% below UK benchmark per March 2026 Kantar study.

### Risks
- Spanish data residency may force local-cloud deployment, adding €600k–€900k capex (Legal, 2026-04-01).
- Catalonia VAT unresolved; Deloitte opinion due May 2026.

Both are go/no-go gates at month 9.

### Open questions
- Portuguese localization ownership: commercial or product?
- Does the 8% price differential erode once Kantar "price perception" uplift is modeled?
```

### Sample completion report

```
- Output: /path/to/q3-iberia-plan-summary.md
- Source words: 405
- Summary words: 140 (body only, excluding TL;DR)
- Compression ratio: 35%
- Sections dropped/merged: none
- Fidelity trade-offs: none
```

Notice what the compression did: dropped transitions ("As we've discussed…", "Our go-to-market approach is deliberate"), rhetorical scaffolding ("importantly", "It's worth noting"), and meta-commentary ("that I want to briefly recap"). Preserved every number, date, named entity, commitment, and attribution. Structure mirrors the source.
