# Prompt Construction Guide

Reference for building research execution prompts. Load this file when constructing per-session prompt blocks.

## Translating Answer Spec Components into Research Directives

Answer Specs define what a complete answer must contain using evidence components and completion gates. The research executor does not understand Answer Spec terminology. The skill must translate each component into a plain-language research directive.

### Translation Pattern

Every directive header must carry the Answer Spec component ID so downstream tools (`research-extract-creator`) can match outputs to specs. Format: `Directive [N] (Q[n]-A##) — [Short title]`.

| Answer Spec Element | Research Directive Translation |
|---|---|
| Evidence component Q1-A01: "Market size data with 3+ independent sources" | "**Directive 1 (Q1-A01) — Market size estimates** Find market size estimates from at least three independent sources. Present as a comparison table with source, year, methodology, and figure." |
| Evidence component Q1-A02: "Historical trend over 5+ years" | "**Directive 2 (Q1-A02) — Historical trajectory** Trace the historical trajectory over the past five or more years. Provide year-by-year data points where available." |
| Completion gate: "Minimum 3 sources per claim" | "For each major finding, cite at least three distinct sources." |
| Completion gate: "Conflicting data must be surfaced" | "Where sources disagree, present both figures side by side with source attribution. Do not silently pick one." |
| Scope constraint: "Nordic mid-market only" | "Focus exclusively on the Nordic region (Sweden, Norway, Denmark, Finland, Iceland). Mid-market defined as [definition from Research Plan]." |

If a single directive covers multiple components, list all IDs: `Directive 3 (Q2-A01, Q2-A02) — Regulatory landscape`. If the Answer Specs do not use the `Q[n]-A##` convention, preserve whatever ID scheme they use.

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

Effort signals must be operative — they must change the execution tool's search behavior, not just describe intent. Percentage allocations alone are descriptive; the execution tool front-loads effort on whichever directives it encounters first and runs out of budget for later ones.

Two mechanisms make effort signals operative:

1. **Directive ordering:** Place the hardest or most important components first in the prompt. The execution tool allocates disproportionate effort to early directives.
2. **Minimum search allocations:** Specify a floor number of dedicated searches per component, so critical components get attention regardless of what earlier directives consume.

### High Priority

- "This is the highest-priority directive in this session. Allocate at least [N] dedicated searches to this directive."
- "Depth matters more than breadth here — go deep on fewer sources rather than skimming many."

### Standard Priority

- No special signal needed. Default treatment.

### Lower Priority (Acceptable if Thin)

- "This directive is lower priority — a focused summary is acceptable if results are scarce."
- "A high-level overview is sufficient — do not spend extended time on this if results are scarce."

### Trade-off Instructions

- "If you need to make trade-offs: Directive 1 / Q1-A01 gets at least [N] dedicated searches. Directive 2 / Q1-A02 gets at least [M]. Remaining budget goes to Directive 3 / Q1-A03."
- "If comprehensive data is unavailable, provide the best available partial data and explicitly note what is missing."

### Operative Allocation Example

```
Research the following directives in the order presented. Directive 2 is the hardest research problem in this session — allocate at least 3 dedicated searches to it regardless of results on Directive 1. Directive 3 is lower priority; a focused summary from 1–2 searches is acceptable.
```

### Sufficiency Signals

Include one per directive to give the model permission to stop and report gaps:

- "If fewer than [N] independent sources exist for this topic, report what is available and characterize the evidence gap."
- "If [specific data type] is not publicly available, note the gap and provide the closest available proxy data."
- "Limited evidence is acceptable here — report what you find and flag the coverage level."

### Volume Calibration

The Answer Spec's Expected Claims ranges indicate how much evidence each component should produce. Translate these into natural-language volume signals so the execution tool calibrates effort per directive rather than treating all directives equally.

| Expected Claims Range | Component Type | Directive Language Pattern |
|---|---|---|
| 5–10 | Inventory/catalog | "Identify all distinct [items] you can find. Aim for comprehensive coverage — if fewer than [lower bound] surface, report what exists and characterize the gap." |
| 3–6 | Mechanics/process | "Trace the main [steps/mechanisms]. Cover the primary paths." |
| 3–5 | Comparison/difference | "Identify the key [differences/axes]. Focus on the most significant ones." |
| 2–4 | Analytical/evaluative | "Analyze in depth. 2–3 well-supported findings are more valuable than 5 shallow ones." |
| 0–3 | Boundary/edge case | "Report what exists — thin evidence is expected here. Do not force volume." |

**How to use:**
- Use the **lower bound** as the sufficiency threshold — below this count, the executor should flag a gap
- Use the **upper end** as a soft ceiling — above this, diminishing returns are likely
- For **Optional** components (lower bound = 0), use the boundary/edge case pattern regardless of the upper bound
- Do not embed the numeric ranges literally in the prompt — translate into the natural-language patterns above

**Volume calibration and directive ordering interact:** Components with higher Expected Claims ranges typically need more search budget. When using operative effort allocation (directive ordering + minimum search counts), account for volume differences — an inventory component needing 5–10 items requires more searches than an analytical component needing 2–4 findings.

### Per-Component Source Quality Floors

Aggregate source targets let the execution tool concentrate quality on easy components. Embed a per-component floor directly in the prompt:

```
Source quality rule: No component's findings may rest on fewer than 2 independent sources. If you can only find 1 source for a component after dedicated searching, classify that component as "thin coverage" and explicitly document the gap — do not pad with tangentially related sources.
```

This instruction goes near the top of the prompt, after the scope block and before directives. It applies globally across all directives in the session.

### Source Authority Emphasis

When the Answer Spec's completion gates include `min_high_sources` ≥ 3, the execution tool needs explicit guidance to prioritize authoritative sources. Without this, it may meet source count thresholds entirely with secondary commentary.

**When to include:** Check the Answer Spec's `min_high_sources` gate. If it is 3 or higher, embed the authority emphasis.

**Template:**

```
Source authority emphasis: For this session, prioritize authoritative primary sources — industry body publications, regulatory filings, large-sample surveys, peer-reviewed research. Secondary commentary and news summaries are acceptable as supporting evidence but should not be the sole basis for any finding.
```

**Placement:** After the source quality floor instruction, before directives. Like the quality floor, this applies globally across all directives in the session.

**When `min_high_sources` < 3 or is "n/a":** Omit the authority emphasis. The default source quality floor is sufficient.

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
[Question X.Y] may return limited results because [reason — e.g., private market data, niche geography, recent phenomenon]. If the research executor finds fewer than [threshold] sources:
- Try narrowing the geography or expanding the time frame
- Accept partial coverage and flag for supplementary research via Perplexity
```

**For definitional ambiguity:**
```
[Question X.Y] uses the term "[term]" which has multiple industry definitions. If the research executor returns results using inconsistent definitions:
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

Research GPT supports site-level restrictions (restrict to specific sites, or prioritize specific sites while allowing broader search).

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

## Search Seed Construction

Search seeds are the keywords and phrases embedded in the prompt that the execution tool uses as starting points for web searches. Seed quality is the single biggest lever on source quality — generic seeds return generic results.

### Tiering by Question Difficulty

Every session prompt should include two tiers of seeds:

**Tier 1 — Broad seeds** (topic coverage): Standard industry terms that cast a wide net. Appropriate for well-documented topics where good sources are easy to find.

```
Search seeds: "private equity deal process," "PE investment lifecycle," "buyout fund operations"
```

**Tier 2 — Narrow seeds** (hard components): High-specificity phrases targeting the source types where difficult evidence lives. Use for components probing practitioner behavior, tacit knowledge, operational detail, or niche data. These seeds should name specific source types, organizations, or publication formats.

```
Narrow seeds for [component ID]: "GP survey deal selection process," "PE partner screening intuition behavioral finance," "private equity pattern recognition investment decisions," "operational due diligence practitioner survey"
```

**When to use each tier:** If a directive asks for factual, well-documented information (market size, regulatory framework, standard process), Tier 1 seeds are sufficient. If a directive asks for how something works in practice, what practitioners actually do vs. what frameworks prescribe, or evidence that lives in surveys/interviews/operational reports rather than textbooks, add Tier 2 seeds.

### Geographic Seed Coverage

When the scope names a region (e.g., "Nordic," "Southeast Asian," "Latin American"), the seeds must cover all constituent countries or markets — not just the most prominent ones. Map the region to its constituent markets and include at least one specific seed per market.

```
Nordic scope — ensure seeds include:
- Sweden: "[Swedish industry association acronym]," "[Swedish-language term if applicable]"
- Norway: "[Norwegian equivalent]"
- Denmark: "[Danish equivalent]"
- Finland: "[Finnish equivalent]"
- Iceland: (if applicable to scope)
```

Use the Research Plan's search terminology guidance as the source for country-specific terms. If the Research Plan omits some constituent markets, flag the gap.

### Concrete Source Paths

Do not just name institutions — give the execution tool searchable paths to their relevant outputs.

| Weak (name only) | Strong (concrete path) |
|---|---|
| "Preqin" | "Preqin private equity operational benchmarks," "Preqin GP survey" |
| "ILPA" | "ILPA due diligence questionnaire guidelines," "ILPA principles 3.0" |
| "Academic research" | "Journal of Private Equity deal process," "Journal of Financial Economics buyout" |

### Query Budget Awareness

Execution tools have a finite number of searches per session. Generic seeds burn budget on shallow results, leaving nothing for harder components. Design seed lists with this constraint in mind:

- Front-load high-value narrow seeds for the hardest components
- Use broad seeds sparingly — one or two per directive is usually sufficient for well-documented topics
- If the execution tool has a known query limit, the total seed count across all directives should not exceed that limit

## Proxy Hierarchy Patterns

When the scope includes specificity constraints that are likely to produce data gaps, the prompt must include an explicit proxy fallback chain. Without this, the execution tool either reports "no data found" or silently uses an approximation without flagging it.

### When to Include a Proxy Hierarchy

Include when any scope parameter is narrow enough that exact-match data may not exist:

- **Geographic:** Niche region or small market (e.g., "Nordic mid-market," "Southeast Asian lower mid-market")
- **Segment:** Narrow size band (e.g., "€5M–€25M enterprise value")
- **Temporal:** Recent phenomenon with limited historical data
- **Domain:** Intersection of two specialties (e.g., "PE operational value creation in healthcare")

### How to Construct

Define a priority-ordered chain from most specific to most general. Each level must be a concrete, searchable scope — not a vague broadening. Require the execution tool to state which level it used.

**Template:**

```
If [specific-scope] data is unavailable, use this priority order:
(a) [Closest proxy — one step broader, still highly relevant]
(b) [Next proxy — broader geography or adjacent segment]
(c) [Broadest acceptable proxy — global/large-market data with explicit adjustment logic]
State which proxy level was used for each finding.
```

**Geographic example:**

```
If Nordic-specific data is unavailable, use this priority order:
(a) Pan-Nordic reports (e.g., KPMG Nordic, Roland Berger Nordics)
(b) Individual Nordic country data (SVCA, NVCA, DVCA, FVCA)
(c) Small European market comparables (Benelux, Switzerland)
(d) Global data — state explicitly that this is a global proxy and note limitations for Nordic applicability
```

**Segment example:**

```
If €5M–€25M enterprise value data is unavailable, use this priority order:
(a) Sub-€50M or "lower mid-market" data
(b) Sub-$250M or "mid-market" data
(c) All-size PE data — state the proxy range and its limitations for the target segment
```

### Placement

Embed the proxy hierarchy in the prompt immediately after the scope block, before directives. It applies globally to all directives in the session. If different directives need different proxy chains, embed per-directive instead.

## Context Pack Embedding

Every execution prompt includes a context pack — a compact project summary that provides the research executor with orientation context. The prompt creator generates this inline from the Research Plan inputs.

### What the Context Pack Contains

- Project background (client, goal, analytical lens, target market) — **universal across sessions**
- Analytical framework (value chain, foundational concepts) — **universal across sessions**
- Section description — **session-specific:** frame the session's investigation (which categories, hypotheses, or research areas this session covers), not the full section objective. Only mention hypotheses the session tests, prior findings the session builds on, and content map areas the session investigates.
- Prior findings from earlier sections — **include only if session-relevant** (e.g., include the adoption gradient for technology/platform sessions, omit for sessions investigating traditional intermediaries)
- One-line scope reference pointing to the standalone scope block (e.g., "Scope parameters are defined in the SCOPE block above") — do NOT duplicate scope values here

The context pack is NOT an Answer Spec. It provides big-picture orientation only. All execution-level detail (source requirements, depth calibration, completion gates) comes from the per-question directives in the prompt.

**Why session-specific filtering matters:** Execution tools have finite context windows and attention budgets. Every irrelevant hypothesis or research area in the context pack is a marginal dilution of focus on the elements that matter for the session. A context pack listing eleven hypotheses when the session tests two creates ambiguity about what the session is actually investigating and may cause the model to reference irrelevant content in its output.

### How to Embed

Place the context pack inside the code-fenced execution prompt, after the scope block and before the first research directive:

```
[Scope block]

--- CONTEXT PACK ---
[Full content of the context pack file]
--- END CONTEXT PACK ---

[Research directives begin here]
```

### What NOT to Include

- Do not list all research questions from the research plan
- Do not reproduce Answer Spec content (source rules, evidence components)
- Do not add execution instructions — those belong in the directives

## Post-Execution Notes Template

Include at the end of the full document:

```
## Post-Execution Notes

After all sessions complete:

1. **Save each session output** using naming convention: [Project Name] — Session [Letter] — [Date]
2. **Cross-session review**: Scan outputs for:
   - Contradictions between sessions (same entity, different data)
   - Gaps where one session assumed another would cover a topic
   - Scope drift (results outside the defined parameters)
3. **Flag for downstream**: Note any findings that challenge Research Plan assumptions or require Answer Spec revision before evidence compression begins.
```
