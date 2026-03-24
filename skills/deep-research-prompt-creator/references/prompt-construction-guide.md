# Prompt Construction Guide

Reference for building Deep Research execution prompts. Load this file when constructing per-session prompt blocks.

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
- Specify output shape per directive: "as a table," "in 2–3 sentences," "as a numbered list"
- Embed scope parameters from the Research Plan directly into the directive text — do not reference the Research Plan abstractly (e.g., "as defined in the Research Plan")
- When a component requires quantitative data, specify the minimum data points or sources explicitly
- When a component requires qualitative assessment, specify the dimensions to assess

## Output Format Templates

Use these within execution prompts to control Deep Research output structure.

### For Structured/Quantitative Data

```
Present findings in a table with the following columns: [column list].
Include source attribution per row. If data is unavailable for a cell, mark it "[Not found]" rather than omitting the row.
```

### For Analytical/Qualitative Content

```
Provide a focused analysis in 3–5 short paragraphs. Each paragraph should address one distinct aspect.
Lead each paragraph with the key finding, then supporting evidence. Cite sources inline.
```

### For Comparative Content

```
Structure as a comparison table with [entities] as rows and [dimensions] as columns.
Below the table, add 2–3 sentences highlighting the most significant differences.
```

### For Inventory/Landscape Content

```
Produce a comprehensive list organized by [grouping criterion].
For each entry, include: [required fields].
Aim for completeness over depth — capture all identifiable entries, then flag which ones have thin coverage.
```

## Depth and Priority Signals

Embed these phrases in prompts to steer Deep Research's time allocation.

### High Priority

- "This is the highest-priority section of this research session."
- "Allocate the majority of your research time to this question."
- "Depth matters more than breadth here — go deep on fewer sources rather than skimming many."

### Standard Priority

- No special signal needed. Default treatment.

### Lower Priority (Acceptable if Thin)

- "Coverage here is secondary to [other question]. If time or sources are limited, a brief summary is acceptable."
- "A high-level overview is sufficient — do not spend extended time on this if results are scarce."

### Trade-off Instructions

- "If you need to make trade-offs between Question X.Y and Question X.Z, prioritize X.Y."
- "If comprehensive data is unavailable, provide the best available partial data and explicitly note what is missing."

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
