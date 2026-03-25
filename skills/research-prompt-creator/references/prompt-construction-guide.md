# Prompt Construction Guide

Reference for building research execution prompts. Load this file when constructing per-session prompt blocks.

## Translating Answer Spec Components into Research Directives

Answer Specs define what a complete answer must contain using evidence components and completion gates. Deep Research does not understand Answer Spec terminology. The skill must translate each component into a plain-language research directive.

### Translation Pattern

| Answer Spec Element | Research Directive Translation |
|---|---|
| Evidence component: "Market size data with 3+ independent sources" | "Find market size estimates from at least three independent sources. Present as a comparison table with source, year, methodology, and figure." |
| Evidence component: "Historical trend over 5+ years" | "Trace the historical trajectory over the past five or more years. Provide year-by-year data points where available." |
| Completion gate: "Minimum 3 sources per claim" | "For each major finding, cite at least three distinct sources." |
| Completion gate: "Conflicting data must be surfaced" | "Where sources disagree, present both figures side by side with source attribution. Do not silently pick one." |
| Scope constraint: "Nordic mid-market only" | "Focus exclusively on the Nordic region (Sweden, Norway, Denmark, Finland, Iceland). Mid-market defined as [definition from Research Plan]." |

### Principles

- Use imperative verbs: "Find," "Compare," "Present," "Trace," "Identify"
- **Format prescription by directive type:** Specify output shape ("as a table," "as a numbered list") only for structured/quantitative directives. For analytical or qualitative directives, state the deliverable and let the model choose format.
- Place scope parameters in a clearly labeled standalone block at the top of the execution prompt with literal values (not abstract references like "as defined in the Research Plan"). Directives reference this block rather than re-embedding scope inline.
- When a component requires quantitative data, specify the minimum data points or sources explicitly
- When a component requires qualitative assessment, specify the dimensions to assess
- **Claim anchoring:** When the inputs contain a specific figure, ratio, or benchmark, embed it as a validation anchor (e.g., "Industry reports suggest a 500:1 ratio — validate this figure and report the range across sources"). This focuses research on testing a concrete claim rather than open-ended exploration.
- **Omit redundant instructions:** Do not include directives the model would follow naturally from a clear research question — e.g., "cross-reference for consistency," "cite your sources," "ensure accuracy." These waste the model's token budget on instruction-parsing and risk turning the prompt into a checklist rather than an investigation.

## Output Format Templates

Use these within execution prompts only when the directive type benefits from prescribed structure. For analytical or qualitative directives, state the deliverable clearly but let the model choose the best format — over-prescribing format on qualitative work forces insights into structures that may not serve them.

### For Structured/Quantitative Data (prescribe format)

```
Present findings in a table with the following columns: [column list].
Include source attribution per row. If data is unavailable for a cell, mark it "[Not found]" rather than omitting the row.
```

### For Comparative Content (prescribe format)

```
Structure as a comparison table with [entities] as rows and [dimensions] as columns.
Below the table, add 2–3 sentences highlighting the most significant differences.
```

### For Inventory/Landscape Content (prescribe format)

```
Produce a comprehensive list organized by [grouping criterion].
For each entry, include: [required fields].
Aim for completeness over depth — capture all identifiable entries, then flag which ones have thin coverage.
```

### For Analytical/Qualitative Content (flexible format)

Do not prescribe tables or paragraph counts. Instead, state the deliverable:

```
Analyze [topic]. Identify the key patterns, provide supporting evidence with inline citations, and flag where evidence is thin or conflicting.
```

The model will choose the best structure — narrative, examples, embedded tables — based on what the evidence warrants.

## Depth and Priority Signals

Embed these phrases in prompts to steer Deep Research's time allocation. Always pair qualitative labels with a concrete effort allocation so the model can budget its research time.

### High Priority

- "This is the highest-priority directive in this session. Allocate approximately [X]% of your research effort here."
- "Depth matters more than breadth here — go deep on fewer sources rather than skimming many."

### Standard Priority

- No special signal needed. Default treatment.

### Lower Priority (Acceptable if Thin)

- "This directive is lower priority. Allocate approximately [X]% of your research effort here — a focused summary is acceptable."
- "A high-level overview is sufficient — do not spend extended time on this if results are scarce."

### Trade-off Instructions

- "If you need to make trade-offs, allocate effort roughly as: Directive 1 ([X]%), Directive 2 ([Y]%), Directive 3 ([Z]%)."
- "If comprehensive data is unavailable, provide the best available partial data and explicitly note what is missing."

### Sufficiency Signals

Include one per directive to give the model permission to stop and report gaps:

- "If fewer than [N] independent sources exist for this topic, report what is available and characterize the evidence gap."
- "If [specific data type] is not publicly available, note the gap and provide the closest available proxy data."
- "Limited evidence is acceptable here — report what you find and flag the coverage level."

## Steering Notes Patterns

Steering notes are per-session guidance for the operator. They anticipate likely failure modes and provide recovery actions.

### When to Include Steering Notes

Every session block gets steering notes. They address:

1. **Likely thin-results areas** — which questions or sub-questions may return scarce data
2. **Alternative search angles** — what to try if initial results are weak
3. **Acceptance criteria for scarcity** — when to accept thin results vs. push harder
4. **Cross-session flags** — what to watch for that affects other sessions

### Steering Note Templates

**For likely data scarcity:**
```
[Question X.Y] may return limited results because [reason — e.g., private market data, niche geography, recent phenomenon]. If Deep Research finds fewer than [threshold] sources:
- Try narrowing the geography or expanding the time frame
- Accept partial coverage and flag for supplementary research via Perplexity
```

**For definitional ambiguity:**
```
[Question X.Y] uses the term "[term]" which has multiple industry definitions. If Deep Research returns results using inconsistent definitions:
- Note which definition each source uses
- Do not attempt to reconcile — flag for operator decision
```

**For cross-session dependency:**
```
Session [X] results will define the scope for this question. If Session [X] hasn't completed:
- Run with the scope assumptions in the Research Plan
- Flag any findings that would change under a different scope definition
```

## Site Restriction Guidance

Since February 2026, Deep Research supports site-level restrictions (restrict to specific sites, or prioritize specific sites while allowing broader search).

### When to Restrict

- When the Research Plan specifies authoritative sources for a domain
- When questions target a specific data provider (e.g., regulatory filings, industry databases)
- When broad web search would return excessive noise for niche topics

### When to Prioritize (Not Restrict)

- Most research sessions — prioritize known high-quality sources but allow broader discovery
- When the topic is emerging or poorly documented in traditional sources

### How to Specify

In each session block, include site guidance as:

```
Site settings for this session:
- Mode: [Restrict to / Prioritize] these sites
- Sites: [comma-separated list]
- Rationale: [brief reason]
```

If no site restrictions apply: "Site settings: Default (full web search, no restrictions)."

## File Attachment Instructions

Every execution prompt assumes the Research Plan document is attached to the Deep Research session. The prompt references it for:

- Scope definitions (geography, deal size, fund size, time frame)
- Key terminology and definitions
- Source preferences

The prompt should reference the attachment explicitly:
```
The attached document is the Research Plan for this project. Use it for scope definitions, key terms, and source preferences. Do not reproduce the Research Plan — use it as context for your research.
```

## Post-Execution Notes Template

Include at the end of the full document:

```
## Post-Execution Notes

After all sessions complete:

1. **Save each session output** using naming convention: [Project Name] — DR Session [Letter] — [Date]
2. **Cross-session review**: Scan outputs for:
   - Contradictions between sessions (same entity, different data)
   - Gaps where one session assumed another would cover a topic
   - Scope drift (results outside the defined parameters)
3. **Flag for downstream**: Note any findings that challenge Research Plan assumptions or require Answer Spec revision before evidence compression begins.
```
