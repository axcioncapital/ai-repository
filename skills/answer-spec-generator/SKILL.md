---
name: answer-spec-generator
description: >
  Trigger when generating Answer Specs from research questions or Research Plans.
  Transforms research questions into structured specifications defining required
  answer components, evidence rules, and completion gates. Also trigger when user
  asks to "spec out" or "define what a good answer looks like" for research questions.
  Do NOT trigger for general research planning, evidence collection, or report writing.
---

## Output Protocol

**Default mode: Refinement**

Before producing the full Answer Spec document, present:
- Classification summary (question type, strictness, component count per question)
- Key assumptions or inferences made
- Readiness checklist (validation results)

**Do not produce the full Answer Spec document until user says `RELEASE ARTIFACT`.** This applies to both single-question and batch generation.

When user says `RELEASE ARTIFACT`:
- Produce the complete document (preamble + all per-question specs + validation summary)
- Provide a brief summary of what was generated

## Accuracy Over Completeness

If the Research Plan provides insufficient information to confidently set scope, depth, or completion criteria, say so rather than inferring aggressively. It is acceptable to leave fields marked `[inferred]` and flag them rather than invent plausible-sounding defaults. If the Research Plan's completion criteria contain questionable assumptions (e.g., requiring evidence density that the topic cannot support), flag it constructively rather than silently encoding impossible gates.

## Information Boundary

Draw all specification parameters (scope, depth, completion criteria, claim ranges) from the Research Plan and `references/component-templates.md`. General domain knowledge may be used only for: (1) inferring strictness level from contextual signals, (2) calibrating claim ranges within the bounds defined in component-templates.md, and (3) flagging questionable assumptions in the Research Plan. Do not use general knowledge to invent scope details, evidence density estimates, or completion criteria not derivable from the provided inputs.

## Input Requirements

**Required:** Research question(s) with scope, depth, and completion criteria (typically from a Research Plan). Completion criteria are translated into measurable Completion Gates — the prose version is not preserved in the spec.

**Optional parameters:**
- `strictness`: `light | standard | strict` (inferred if not specified)
- `questions`: specific question IDs to process (default: all)
- `output`: `combined | separate` (default: combined)

**If Research Plan is incomplete** (missing scope, depth, or completion criteria): Synthesize reasonable defaults from the question text and label them as `[inferred]`. Flag to user before proceeding.

**If no Research Plan is provided** (bare questions only): Accept the questions but mark all metadata fields as `[inferred]`. Warn the user that specs generated without a Research Plan will have weaker scope boundaries and should be reviewed before execution.

## Strictness Inference

If no explicit strictness parameter, infer from context:

| Signal | Inferred Strictness |
|--------|---------------------|
| Client deliverable, decision support, high-stakes language | `strict` |
| Standard research, knowledge base entry | `standard` |
| Exploratory, brainstorming, early discovery, ambiguous scope | `light` |

Default to `standard` when signals are mixed or absent.

**Global default with per-question override:**
A global strictness can be set for a batch, with per-question overrides where warranted. Override when:
- The question requires quantitative precision (upgrade to `strict`)
- Evidence is expected to be thin/scarce (downgrade to `light` to avoid impossible gates)
- The question serves a different downstream purpose than the batch default

Format in spec: `Strictness: standard (batch default)` or `Strictness: strict (override — quantitative precision required)`

## Question Type Classification

Match each question to a primary type using trigger patterns below.

| Type | Trigger Patterns |
|------|------------------|
| **Pattern** | "What patterns exist," "how do [actors] typically," "what approaches" |
| **Comparison** | "How does X compare to Y," "differences between," "similarities" |
| **Causal** | "What drives," "what factors influence," "what causes [outcome]" |
| **Forecasting** | "What will," "projected," "expected trends," "future of" |
| **Definitional** | "What is," "how is X defined," "what constitutes" |
| **Ecosystem/Landscape** | "Who are the players," "market structure," "how do they interact" |
| **Process/Workflow** | "How is X done," "what are the steps," "typical process for" |
| **Diagnostics** | "Why is [problem] happening," "root cause," "what's driving the problem" |
| **Evaluation** | "How well does," "assess," "evaluate," "strengths and weaknesses" |
| **Recommendation** | "What should," "best approach," "which option," "how to decide" |
| **Mapping** | "What exists," "inventory of," "landscape of options" |

### Type Disambiguation Rules

**Causal vs Diagnostics:**
- **Diagnostics**: Question framed around a *problem/symptom* seeking root causes + intervention points.
- **Causal**: Question framed around *drivers of an outcome/relationship* (not necessarily a problem).

**Mapping vs Ecosystem/Landscape:**
- **Mapping**: Focus is inventory + attributes.
- **Ecosystem/Landscape**: Focus is inventory + relationships/flows/power dynamics.

### Hybrid Classification

When questions span multiple types:

1. **Identify primary type**: What is the question *mainly* asking? This determines the core component set.
2. **Identify secondary type(s)**: What additional angle does the question require?
3. **Merge rules**:
   - Add only minimum necessary components from secondary type
   - If types share similar components (e.g., "variation drivers" and "contributing factors"), merge into one rather than duplicating
   - Cap total components: 5-7 for `light`/`standard`, up to 9 for `strict`
4. **Label clearly**: Mark as `Hybrid: [Primary] + [Secondary]` in the spec

**Light strictness preference:** If strictness is `light`, prefer single-type classification unless the question is clearly hybrid.

**If classification is uncertain**: Output the spec labeled `Hybrid (tentative)` and note the assumptions.

**If no type matches**: If a question does not match any defined type, classify as the closest fit and label it `[approximate match — no exact type]`. Use the closest type's component template as a starting point and adapt components to fit the actual question. Flag the classification for user review.

## Workflow

### Step 1: Parse Input

Extract from Research Plan context:
- Research questions with metadata (scope, depth, completion criteria)
- Research posture (confirmatory / exploratory / mixed)
- Overall research objective
- Any explicit strictness or output preferences

If metadata is missing for some questions, synthesize reasonable defaults and mark as `[inferred]`.

### Step 2: Classify Each Question

For each question:
1. Match to primary type using trigger patterns
2. Apply disambiguation rules if ambiguous
3. Check for secondary type signals
4. If hybrid, apply merge rules
5. Document classification rationale if non-obvious

### Step 3: Instantiate Components

1. Load base component set for primary type from `references/component-templates.md`
2. If hybrid, add minimal secondary components per merge rules
3. Assign Component IDs using format `Q[question#]-A[sequence#]` (e.g., Q1-A01, Q1-A02)
4. Customize based on:
   - Question-specific cues (unusual scope, specific actors, explicit exclusions)
   - Research Plan context (posture, downstream use, audience)
   - Cross-question consistency (batch mode: align terminology)

**Add components when implied:**
- Counterexamples (if question asks "what doesn't work")
- Boundary conditions (if scope is contested)
- Taxonomy definition (if categorization is core)
- Attribution handling (if research includes interviews/proprietary sources)

**Remove components when not applicable:**
- Prevalence signals (if purely definitional)
- Recommendation logic (if purely descriptive)

**Expected Claims calibration:**
Set a claim range per component based on its type and the question's strictness. The range tells downstream tools (prompt creator, extract verifier) how much evidence each component should produce — preventing flat aggregate targets that let easy components absorb all the claims.

| Component type | Typical range | Rationale |
|----------------|---------------|-----------|
| Inventory/catalog (e.g., activity inventory, entity inventory, pattern inventory) | 5–10 | One claim per item; count depends on how many items exist |
| Mechanics/process (e.g., pattern mechanics, process steps) | 3–6 | One claim per step or mechanism |
| Comparison/difference (e.g., key differences, variation drivers) | 3–5 | One claim per axis of difference |
| Analytical/evaluative (e.g., implications, trade-offs, contextual applicability) | 2–4 | Fewer but deeper claims; quality over quantity |
| Boundary/edge case (e.g., boundary conditions, failure modes) | 1–3 | Thin evidence expected; flag gaps rather than force volume |

Adjust ranges for strictness: `strict` uses upper end, `light` uses lower end, `standard` uses midpoint. For Optional components, set the lower bound to 0 (evidence may not exist).

Domain evidence density should also influence range selection within the strictness band. For evidence-sparse domains (emerging technologies, niche markets, practitioner tacit knowledge), use the lower end of ranges even at `standard` strictness. For evidence-rich domains (established industries, well-studied phenomena), the upper end is appropriate. If domain density is unknown, use midpoint and flag as `[inferred]`.

The answer-level `min_distinct_claims` gate is the sum of per-component lower bounds. Do not set it independently — derive it from the component ranges.

**Dimension priority rule:**
If the question asks for *variation across types*, set at least one segmentation dimension as **Required** by adding it to the relevant component's Description field (e.g., "**Segment by:** fund size (Required — state unknown if no evidence found)"). Excluded dimensions go in the Out of Scope list under Definitions & Boundaries.

### Step 4: Generate Full Spec

Produce complete Answer Spec using the per-question template below. Apply strictness level to determine section depth.

### Step 5: Self-Validate

Before output, verify each spec:

| Check | Validation |
|-------|------------|
| Component-question fit | Do components actually answer the question asked? |
| Evidence rules testable | Can each rule be objectively verified? |
| Completion gates measurable | Are all gates expressed as countable thresholds? |
| No gaps | Is there a component for every part of the question? |
| No overreach | Do components stay within stated scope? |
| Variation dimensions | If question asks for variation, is at least one dimension marked Required? |
| ID consistency | Do Component IDs follow Q[n]-A## format? |
| Claim range calibration | Does each component have an Expected Claims range? Is `min_distinct_claims` the sum of per-component lower bounds? |
| Cross-spec consistency | (Batch) Do related questions use consistent terms? |

If any check fails: auto-fix where the fix is unambiguous (e.g., missing Component ID, incorrect `min_distinct_claims` sum). For subjective failures (e.g., component-question fit), flag the issue in the refinement summary presented to the user before `RELEASE ARTIFACT`.

### Step 6: SOP Compatibility Validation

Run a batch-level validation pass after all specs are individually validated.

**When to run:** After Step 5 completes for all specs in the batch. Final check before output.

| # | Rule | Severity | Check | Action if fails |
|---|------|----------|-------|-----------------|
| V1 | Component IDs assigned | High | Every component has a `Q[n]-A##` ID, numbered sequentially starting A01 | **Auto-fix:** Assign IDs in component table order. Log. |
| V2 | Completion gates measurable | Medium | Each gate resolves to pass/fail without subjective judgment | **Flag for review:** Propose structural proxy rewrites (see Subjective gate rewrites). |
| V3 | Strictness explicit | Medium | Every spec has an explicit strictness value | **Auto-fix:** Apply inferred strictness, mark `[inferred]`. |
| V4 | Downstream format labeled | Low | Section labeled "Downstream Synthesis Format" (not "Output Format") | **Auto-fix:** Rename heading. |
| V5 | Evidence rules != SOP grading | Low-Med | Evidence rules specify scope/source requirements only; no duplication of SOP grading criteria. The preamble's Default Evidence Rule (source count thresholds) is a scope requirement, not a grading criterion. | **Flag for review:** Identify conflicting language. |
| V7 | Expected Claims present | Medium | Every component has an Expected Claims range. `min_distinct_claims` equals the sum of per-component lower bounds. | **Auto-fix:** Compute sum from component ranges. Log. |
| V6 | No silent cross-question dependencies | Low | Evidence rules do not reference other question IDs without flagging execution order | **Flag for review:** List dependencies. |

**Validation output:** Append a summary table after the specs:

```
## SOP Compatibility Validation Summary

| Question | V1 IDs | V2 Gates | V3 Strictness | V4 Format | V5 Evidence | V6 Dependencies | V7 Claims | Status |
|----------|--------|----------|---------------|-----------|-------------|-----------------|-----------|--------|
| Q1       | ✓      | ✓        | ✓             | ✓         | ✓           | ✓               | ✓         | Pass   |
```

If any High-severity auto-fix is applied, note it prominently. If any Medium+ flags remain unresolved, do not mark the batch as ready.

## Document Preamble

Write once per document. If adding questions to an existing document, skip the preamble.

```
# Answer Spec Document

## Conventions & Defaults

### ID Conventions
- **Component IDs:** Q[n]-A## (e.g., Q1-A01, Q1-A02)
- **Claim IDs:** Q[n]-C## (e.g., Q1-C01) — for Evidence Pack compatibility

### Independent Sources
Distinct originating organizations or primary research; excludes re-quotes, syndications, or sources citing each other.

### Default Evidence Rule
Each Required component needs ≥2 independent sources. Each Optional component needs ≥1 source. Per-question evidence rules only list deviations from this default.

### Evidence Labeling
- **Linkage type** (for mechanism/driver claims): Explicit / Associational / Inferred — record in Notes column
- **Source strength** (per row): High / Medium / Low — per Research Executor rubric

These are independent axes. A claim may have Associational linkage supported by a High-strength source.

### SOP Grading Boundary
Evidence rules specify scope and source requirements only. Quality grading — High/Medium/Low caps, date penalties, quantifier rules — is handled by the Research Executor's grading rubric (SOP §8). Do not duplicate or contradict grading criteria in evidence rules.

### Source Strength Labels
Tag each source row as: High (authoritative primary source) / Medium (credible secondary) / Low (single mention or uncertain provenance)

### Execution Mode
Default: per-question unless batch is explicitly requested.
```

## Per-Question Answer Spec Template

Each question gets one spec using this structure.

```
## Answer Spec: [Question ID]
Strictness: [light | standard | strict] [(batch default) or (override — [reason])]
Question type: [Type] or [Hybrid: Primary + Secondary]

### Question Context
Question: [Full question text]
Scope: [From Research Plan, or [inferred]]
Depth: [From Research Plan, or [inferred]]

### Definitions & Boundaries
**Key terms:**
- [Term]: [Definition]

**In scope:** [What's included]
**Out of scope:** [What's explicitly excluded — include Excluded dimensions here]
**Timeframe:** [Relevant period — Required if question includes "current"/"recent"/"today"]

### Answer Components
| ID | Component | Description | Expected Claims | Priority |
|----|-----------|-------------|-----------------|----------|
| Q[n]-A01 | [Name] | [What this component must contain. **Segment by:** dimension (Required/Optional) if applicable] | [range, e.g., 3–5] | Required / Optional |

### Claim-Level Evidence Rules

| Component ID | Evidence Rule |
|--------------|---------------|
| Q[n]-A01 | [Only if this component deviates from the default evidence rule] |

If all components follow the default evidence rule, replace the table with:
`All components follow default evidence rules.`

### Answer-Level Completion Gates

Express all gates as countable thresholds:

| Counter | Value |
|---------|-------|
| `min_distinct_claims` | [sum of per-component lower bounds] |
| `min_sources` | [number] |
| `min_independent_sources` | [number] |
| `min_high_sources` | [number or "n/a"] |
| `required_dimensions_coverage` | [list of required dimensions — "unknown" acceptable if stated] |
| `timeframe_required` | [yes/no] |

If Research Plan criteria are qualitative, translate to measurable proxies and mark as `[inferred]`.

**Subjective gate rewrites** — if a completion gate requires human judgment, rewrite as a structural proxy:

| Subjective gate | Structural proxy |
|----------------|------------------|
| "Can withstand follow-up questions" | "Logic chain has ≥2 levels of supporting evidence" |
| "Evidence presented with nuance" | "All claims include at least one qualifier or boundary condition" |
| "Passes plain-language test" | "All claims use terms defined in Key Terms; no unexplained jargon" |
| "Comprehensive coverage" | "All Required components meet their Expected Claims lower bound" |

The test: can the Research Executor resolve this gate to ✓/⚠/✗/○ without subjective interpretation? If not, rewrite.

### Downstream Synthesis Format
[Recommended structure for downstream writer/synthesizer. The Research Executor follows its own fixed Evidence Pack structure (SOP §11) — this section is not consumed by the executor.]
```

## Examples

### Pattern Question (Q4)

**Research question:** "What are the common approaches PE funds use for add-on sourcing in the Nordics?"
**Strictness:** standard (inferred — knowledge base entry)

> In a real batch, the Document Preamble would precede all per-question specs.

```
## Answer Spec: Q4
Strictness: standard
Question type: Pattern

### Question Context
Question: What are the common approaches PE funds use for add-on sourcing in the Nordics?
Scope: Nordic PE market, mid-market and large-cap funds, add-on acquisition sourcing specifically
Depth: Identify distinct approaches with enough detail to understand mechanics and trade-offs

### Definitions & Boundaries
**Key terms:**
- Add-on sourcing: Process by which PE funds identify and originate acquisition targets to bolt onto existing portfolio companies
- Nordic: Sweden, Norway, Denmark, Finland (Iceland excluded unless evidence surfaces)

**In scope:** Sourcing methods, channel usage, internal vs. external resources, process variations
**Out of scope:** Deal execution post-sourcing, valuation approaches, integration planning, sector focus (unless directly shapes sourcing approach)
**Timeframe:** Current practice (2020-present)

### Answer Components
| ID | Component | Description | Expected Claims | Priority |
|----|-----------|-------------|-----------------|----------|
| Q4-A01 | Pattern inventory | Distinct sourcing approaches identified (e.g., advisor-led, proprietary, hybrid) | 3–5 | Required |
| Q4-A02 | Pattern mechanics | How each approach works: channels used, resources involved, typical timelines | 3–5 | Required |
| Q4-A03 | Variation drivers | Factors explaining why different funds use different approaches. **Segment by:** fund size (Required — state unknown if no evidence found), geographic sub-region (Optional) | 2–4 | Required |
| Q4-A04 | Prevalence signals | Which approaches are common vs. niche in the Nordic context | 0–2 | Optional |

### Claim-Level Evidence Rules

| Component ID | Evidence Rule |
|--------------|---------------|
| Q4-A02 | Mechanics described with specificity (not just labels); acceptable: practitioner interviews, case studies, industry guides |
| Q4-A03 | Label linkage as Explicit, Associational, or Inferred |
| Q4-A04 | Quantitative data preferred; qualitative signals acceptable if source is credible |

> Q4-A01 follows the default evidence rule.

### Answer-Level Completion Gates

| Counter | Value |
|---------|-------|
| `min_distinct_claims` | 8 (sum of per-component lower bounds: 3+3+2+0) |
| `min_sources` | 8 |
| `min_independent_sources` | 4 |
| `min_high_sources` | 2 |
| `required_dimensions_coverage` | Q4-A01, Q4-A02, Q4-A03 addressed |
| `timeframe_required` | yes |

### Downstream Synthesis Format
Pattern catalog: table of approaches (name, mechanics summary, prevalence) + narrative detail per pattern with variation analysis.
```

### Comparison Question (Q7)

**Research question:** "How does boutique M&A advisory coverage of PE funds differ from large bank coverage?"
**Strictness:** strict (inferred — client deliverable, decision support)

```
## Answer Spec: Q7
Strictness: strict
Question type: Comparison

### Question Context
Question: How does boutique M&A advisory coverage of PE funds differ from large bank coverage?
Scope: Advisory coverage models for PE fund clients; boutique advisors vs. bulge bracket / large banks
Depth: Structural comparison across multiple dimensions with implications for PE fund decision-making

### Definitions & Boundaries
**Key terms:**
- Boutique advisor: Independent M&A advisory firm, typically <500 employees, fee-only model
- Large bank: Bulge bracket or large regional bank with integrated banking services
- PE coverage: Dedicated attention, deal origination, and execution support provided to PE fund clients

**In scope:** Coverage structure, team composition, service model, relationship dynamics, fee structures
**Out of scope:** Specific firm comparisons by name, historical evolution, regulatory differences, sector specialization (unless directly relevant)
**Timeframe:** Current state (2022-present)

### Answer Components
| ID | Component | Description | Expected Claims | Priority |
|----|-----------|-------------|-----------------|----------|
| Q7-A01 | Comparison dimensions | Axes on which boutiques and banks differ. **Segment by:** deal size focus (Optional), geographic focus Nordic vs. global (Optional) | 3–5 | Required |
| Q7-A02 | Boutique model | How boutique advisors typically structure and execute PE coverage | 3–5 | Required |
| Q7-A03 | Bank model | How large banks typically structure and execute PE coverage | 3–5 | Required |
| Q7-A04 | Key differences | Specific structural/operational differences with evidence | 4–6 | Required |
| Q7-A05 | Implications | What each difference means for PE funds (advantages/disadvantages) | 3–4 | Required |
| Q7-A06 | Contextual applicability | Conditions where each model is preferable | 0–3 | Optional |

### Claim-Level Evidence Rules

| Component ID | Evidence Rule |
|--------------|---------------|
| Q7-A01 | Dimensions must be verifiable, not assumed |
| Q7-A04 | Each difference supported by explicit comparison or contrasting sources |
| Q7-A05 | Label linkage: Explicit, Associational, or Inferred |
| Q7-A06 | Conditions tied to specific evidence, not speculation |

> Q7-A02 and Q7-A03 follow the default evidence rule.

### Answer-Level Completion Gates

| Counter | Value |
|---------|-------|
| `min_distinct_claims` | 16 (sum of per-component lower bounds: 3+3+3+4+3+0) |
| `min_sources` | 12 |
| `min_independent_sources` | 5 |
| `min_high_sources` | 4 |
| `required_dimensions_coverage` | Q7-A01, Q7-A02, Q7-A03, Q7-A04, Q7-A05 addressed |
| `timeframe_required` | yes |

### Downstream Synthesis Format
Side-by-side comparison table (dimension × boutique vs. bank) + narrative analysis of key differences and implications.
```

### All Default Evidence Rules (micro-example)

When no component deviates from the default rule:

```
### Claim-Level Evidence Rules

All components follow default evidence rules.
```

Most common in `light` strictness specs.

## Guardrails

**Do not:**
- Generate components that don't serve the question
- Set completion gates exceeding Research Plan's criteria (exception: `min_distinct_claims` is derived from per-component Expected Claims ranges and may differ from qualitative Research Plan criteria — this is correct behavior)
- Force dimensions that aren't relevant
- Over-specify when strictness is `light`
- Under-specify when strictness is `strict`
- Exceed component caps for hybrid questions
- Require "explicit" evidence when associational or inferential evidence (labeled) is acceptable
- Use component names instead of Component IDs in evidence rules
- Include cross-question dependencies in evidence rules without flagging execution order

**Always:**
- Preserve question scope from Research Plan
- Make evidence rules objectively testable
- Use linkage labels (Explicit/Associational/Inferred) for mechanism claims
- Use source strength grades (High/Medium/Low) for each source row
- Express completion gates as countable thresholds
- Assign Component IDs in Q[n]-A## format
- Specify Claim ID prefix convention (Q[n]-C##) for Evidence Pack compatibility
- Set variation dimensions as Required in component descriptions when question demands variation
- Include "state unknown" handling for Required dimensions
- Maintain cross-spec consistency in batch mode
- Label uncertain classifications as tentative
- Default to per-question execution mode unless batch is explicitly requested
- Run SOP Compatibility Validation (Step 6) before finalizing output
