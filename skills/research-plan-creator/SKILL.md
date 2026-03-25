---
name: research-plan-creator
description: >
  Transform Task Plans into Research Plans — structured documents of sequenced,
  answerable research questions with depth calibration, tool assignments, source
  requirements, and completion criteria. Use when: (1) a Task Plan exists and
  needs to be operationalized into research questions, (2) converting strategic
  objectives into concrete queries an AI researcher can execute, (3) structuring
  inquiry across confirmatory and exploratory research postures. Do not use for:
  creating Task Plans (upstream — see task-plan-creator), executing research
  (downstream), or synthesizing findings into deliverables.
---

# Research Plan Creator

## Research Plan Purpose

A Research Plan bridges strategy and execution:

1. **Operationalize intent** — converts "what we need to know" into "what to search for"
2. **Structure inquiry** — sequences questions so foundational knowledge informs specific investigation
3. **Define completion** — specifies when each question is adequately answered
4. **Enable delegation** — produces a document an AI researcher can execute without additional context

## Research Posture

Every Research Plan operates in one of two postures, determined by Task Plan maturity:

**Confirmatory posture** (well-defined Task Plan):
- Objective is clear and specific
- Research validates, quantifies, or details known areas
- Questions are precise: "What is X?" "How does Y work?"
- Completion means sufficient evidence to proceed with confidence

**Exploratory posture** (directional Task Plan):
- Objective is directional but not fully specified
- Research discovers patterns, opportunities, risks, or unknowns
- Questions are open: "What patterns exist in...?" "What tends to drive...?"
- Completion means sufficient signal density to form hypotheses or refine scope

Most Research Plans blend both postures. Foundational areas tend toward exploratory; later areas toward confirmatory. The Task Plan's maturity determines the mix.

**Exploratory question patterns:**
- "What are the primary factors that influence...?"
- "What patterns emerge in how [actors] approach [activity]?"
- "What risks or failure modes exist in...?"
- "What adjacent opportunities might exist if...?"
- "What do industry participants disagree about regarding...?"

## Depth Calibration Framework

Every research question requires an explicit depth level. Depth levels are defined by the Task Plan and inherited by the Research Plan.

### Default Depth Levels

| Level | Label | What It Means | Completion Standard |
|-------|-------|---------------|---------------------|
| L1 | Conversational fluency | Can define, explain, compare, and ask informed follow-up questions | Can explain to a non-specialist; can answer basic questions without hesitation |
| L2 | Operational fluency | Understands how it works in practice: steps, documents, incentives, typical terms, key parameters | Can describe the process with specifics; knows the numbers practitioners cite |
| L3 | Execution competency | Can perform or directly support the activity; knows edge cases, failure modes, and decision criteria | Can walk through execution steps; can identify what would go wrong |

### Calibrating to the Task Plan

If the Task Plan defines its own depth rubric, use that instead of the default. Map the Task Plan's levels to the Research Plan's depth labels explicitly.

### Depth Assignment Rules

1. **Start with the Task Plan's default depth.** If the Task Plan specifies "L1 is default unless otherwise noted," most questions should be L1.
2. **Elevate depth when the Task Plan requires it.** Look for explicit markers: "[L2]" tags, language like "understand at operational level," topics flagged as requiring practitioner-level knowledge.
3. **Elevate depth when the question type implies it:** questions about key parameters (numbers, ranges, benchmarks), relationship dynamics and tensions, regional/market-specific variations, decision processes and criteria — these typically require L2.
4. **L3 is rare.** Include only when the Task Plan explicitly requires execution competency.

### Depth Distribution Check

Before finalizing, verify:
- Most questions at the Task Plan's default depth (usually L1)
- L2 questions justified by Task Plan requirements or question type
- L3 questions rare and explicitly justified
- If >50% of questions are elevated above default, either the default is miscalibrated or scope creep has occurred

## Research Plan Structure

Every Research Plan contains these sections:

| Section | Purpose |
|---------|---------|
| **Assumptions** | (If Task Plan incomplete) What was inferred; must be confirmed before execution |
| **Research Context** | Task Plan objective, what research must accomplish, research posture |
| **Research Questions** | Numbered questions organized by area, each with inline scope/depth/completion/source/recency |
| **Intelligence Paths** | For each question: whether web search is viable or other sources required |
| **Search Strategy Notes** | Terminology, query patterns, source preferences, time frames |
| **Dependencies** | Which questions must be answered before others; note potential overlaps |
| **Consolidation Log** | (If consolidation applied) What was merged, absorbed, or dropped and why |
| **Thin Results Protocol** | What to do when questions yield sparse results, including scarcity classification |
| **Scope Revision Triggers** | Signals that findings suggest the Task Plan objective should change |
| **Key Terms for Execution** | (Conditional) Operational definitions for ambiguous domain terms |

## Workflow

### Step 1: Assess Task Plan and State Assumptions

Evaluate the Task Plan's completeness. A well-defined Task Plan has: clear objective, defined scope boundaries, process stages indicating what work will be done.

**If incomplete but workable:** Proceed with explicit assumptions. State them prominently:

```
## Assumptions (Confirm Before Execution)

The following were inferred from the Task Plan. If incorrect, the Research Plan requires revision:

1. [Assumption about objective]
2. [Assumption about scope]
3. [Assumption about constraints]
```

**If incoherent:** Stop only if no reasonable interpretation exists. Specify what is missing and what minimum clarification would allow progress. Default: proceed and be explicit about what you're assuming.

### Step 2: Extract Research Requirements

From the Task Plan, identify:
- What knowledge gaps must be filled
- What decisions the research must inform
- What deliverables the research supports

### Step 3: Determine Research Posture

Based on Task Plan maturity, determine the dominant posture:
- **Confirmatory:** specific hypotheses to validate or known areas to detail
- **Exploratory:** directional intent but undefined problem space
- **Mixed:** some areas well-defined, others require discovery

State the posture in the Research Context section.

### Step 4: Define Key Terms for Execution (Conditional)

**When to apply:** The Task Plan involves domain-specific terminology that could be interpreted multiple ways.

Identify ambiguous terms. Common categories: geographic scope, actor definitions, activity boundaries, time frames, size thresholds.

For each ambiguous term, specify: operational definition (included), explicit exclusions, edge case handling.

**Format:**

| Term | Operational Definition | Exclusions | Edge Case Handling |
|------|------------------------|------------|-------------------|
| Nordic | Sweden, Norway, Denmark, Finland | Iceland, Baltics | Include if HQ in scope country |
| PE funds | Buyout and growth equity funds | Pure VC, infrastructure, real estate | Include growth equity even if fund uses "venture" in name |

**Skip** if the Task Plan uses only standard, unambiguous terminology.

### Step 5: Decompose into Research Areas

Group related questions into 3-6 research areas. Each area should represent a coherent domain of inquiry.

Use the Task Plan's process stages as a starting point. Each stage requiring external information typically maps to one research area. Combine stages sharing the same knowledge domain. Split stages spanning multiple distinct domains.

### Actor & Relationship Coverage

When research involves multiple actors, apply this framework before formulating questions:

1. **Enumerate all actors:** List every actor type with a meaningful stake. Note whether their perspective is primary (must cover) or secondary (cover if relevant).
2. **Map key relationships:** For each actor pair with significant interaction — where do interests align/diverge? What governs the relationship? What tensions commonly arise? Include dedicated questions for key relationships if dynamics are material to the objective.
3. **Document exclusions:** If an actor or relationship is consciously excluded, state the rationale.

**Skip relationship mapping** if the research area involves a single actor or relationships are not material.

### Step 6: Formulate Research Questions

For each area, write questions at moderate granularity and assign depth levels.

**Confirmatory questions:**
- Too broad: "What is the Nordic PE market like?"
- Too narrow: "What was the exact EV/EBITDA multiple for Altor's Q3 2024 acquisitions?"
- Right level: "What are typical EV/EBITDA multiples for Nordic PE acquisitions in the €50-200M range over the past 2 years?"

**Exploratory questions:**
- "What patterns exist in how Nordic PE funds evaluate inbound deal flow?"
- "What factors most influence whether a PE fund engages with an advisor?"
- "What do PE funds and advisors disagree about regarding deal quality?"

#### Question Dimension Checklist

For each research area, consider whether questions should cover these dimensions:

| Dimension | Description | Typical Depth |
|-----------|-------------|---------------|
| **Definitional** | | |
| What is it? | Definition, boundaries, distinguishing features | L1 |
| What types exist? | Taxonomy, categories, variations | L1 |
| How does it compare? | Differentiation, relative positioning | L1 |
| **Operational** | | |
| How is it structured? | Organization, roles, components | L1-L2 |
| What are the key parameters? | Numbers, ranges, benchmarks | L2 |
| How do decisions get made? | Criteria, process, authority, timing | L2 |
| **Defensive** | | |
| What are common misconceptions? | Errors to correct, naive assumptions | L1 |
| What are common criticisms? | Challenges, known weaknesses | L1 |
| Where do experts disagree? | Contested areas, unresolved debates | L1-L2 |
| **Temporal** | | |
| How has this evolved? | Historical development, what changed and why | L1 |
| What is the current trajectory? | Trends, direction | L1 |
| What might disrupt the current state? | Emerging factors, potential shifts | L1 |

Not every dimension applies to every area. Use the checklist to ensure relevant dimensions are not overlooked. A well-formed area typically covers 4-6 dimensions.

Each question should be: answerable (via web search or identified alternative source), specific enough to know when answered, broad enough to allow useful synthesis.

#### Glossary Coverage (Conditional)

**When to apply:** The Task Plan includes terminology mastery, glossary compilation, or requires correct domain language use.

Tier the terms:
- **Tier 1 (must define precisely):** Cannot hold a conversation without these. Require dedicated questions.
- **Tier 2 (should be able to define):** Will likely arise. Addressed by questions or flagged for collection.
- **Tier 3 (awareness sufficient):** Might arise in deeper discussion. Note for opportunistic capture.

Before finalizing, verify all Tier 1 terms are explicitly addressed by at least one question.

**Skip** if the Task Plan has no terminology or fluency objectives.

### Step 7: Consolidate Questions

Hard ceiling: **12 questions.** If the total from Step 6 exceeds 12, consolidate before proceeding.

**Consolidation actions (in priority order):**

1. **Merge overlapping questions.** If two questions share a knowledge domain and their completion criteria overlap, combine them into one broader question. Preserve the higher depth level.
2. **Absorb narrow questions.** If a question is narrow enough that answering a related question would cover it, fold it into the broader question's scope line.
3. **Drop marginal questions.** Remove questions that add limited value relative to the Task Plan's objective. Stepping-stone questions and low-stakes definitional questions are the first candidates.
4. **Combine across areas.** If two research areas have only one question each after merging, consider whether they belong together.

**Consolidation log:** For each action taken, document:
- What was merged, absorbed, or dropped
- Which questions were affected
- Why (overlap, marginal value, absorbed by broader question)

Include the consolidation log in the Research Plan output, after the Dependencies section.

**Override:** The 12-question ceiling can be exceeded only if the Task Plan explicitly requires it (e.g., covers 6+ distinct domains with no overlap). State the justification in the consolidation log.

**Do not consolidate below 6 questions.** If the initial set is 6-12, no consolidation is required. If consolidation would reduce below 6, stop and keep the remaining questions.

### Step 8: Specify Completion Criteria

For each question, define what constitutes a sufficient answer using concrete, verifiable signals. Match to the assigned depth level.

**Confirmatory completion patterns:**
- "Found 3+ independent sources confirming the same finding"
- "Can list N specific examples with names/details"
- "Have quantitative data points (ranges, percentages, figures)"

**Exploratory completion patterns:**
- "Identified 3+ distinct patterns/themes across sources"
- "Found points of disagreement or tension worth investigating"
- "Surfaced 2+ hypotheses worth validating in later research"
- "Identified what is unknown and why (data doesn't exist vs. not public vs. contested)"

**Depth-specific completion:**

| Depth | Examples |
|-------|---------|
| L1 | "Can explain in 2-3 sentences"; "Can list 3+ characteristics"; "Can articulate the distinction between X and Y" |
| L2 | "Can describe the process with specific steps"; "Can state typical ranges with numbers"; "Can explain where interests align and diverge" |
| L3 | "Can walk through execution sequence"; "Can identify decision points and criteria"; "Can anticipate failure modes" |

**Avoid weak criteria:** "Understand the topic" (too vague), "Have enough information" (not verifiable).

### Step 9: Note Dependencies and Sequencing

Identify which questions depend on answers to other questions. Mark the logical order of investigation.

### Step 10: Assign Intelligence Paths

For each question, assess the likely information source:

**Web-searchable:** Public information exists and is findable via search. Most questions should be here.

**Requires alternative sources:** Mark questions where web search is unlikely to yield adequate results. Valid paths: expert interviews, paid databases (PitchBook, Capital IQ), conference materials, grey literature, operator blogs/podcasts, primary research.

For each alternative-source question, note which path is most likely to yield results.

### Step 11: Execution Tool Context

All web-searchable questions are executed via **GPT Deep Research** in Stage 2. The Research Plan does not assign tools per question — tool routing is handled by the execution pipeline:

- **Stage 2 (primary research):** All questions go to GPT Deep Research, clustered into sessions of 2-4 questions each.
- **Stage 3 (supplementary gap-filling):** Unresolved gaps route to Perplexity for lightweight factual retrieval (max 2 passes per question).

The Research Plan's job is to produce well-formed questions with clear completion criteria. Tool assignment is a downstream concern.

### Step 12: Assign Source Requirements

For each question, classify source requirements to enable downstream batching.

**Assess four factors:**

1. **Question role:** Foundational (errors cascade → strict), validation (depends on stakes), exploratory (seeking signal → light), stepping-stone (internal use → light)
2. **Stakes:** Cited externally → strict; internal understanding → lighter; wrong answer causes downstream problems → strict
3. **Topic characteristics:** Quantitative data → moderate-strict; contested topic → strict; stable consensus area → light-moderate; operational reality → moderate
4. **Depth level:** L1 → light-moderate; L2 → moderate; L3 → moderate-strict

**Classifications:**

| Classification | Criteria | Typical Use |
|----------------|----------|-------------|
| **Light** | 1-3 sources sufficient | Definitional with consensus; exploratory initial signal; stable topics; stepping-stone questions |
| **Moderate** | 2+ sources per claim OR 4-7 total | Operational reality; quantitative elements; informing decisions but not final word |
| **Strict** | 8+ sources OR 3+ high-authority OR exact citations required | Foundational questions; externally cited answers; contested topics; high-stakes validation |

**Quick decision tree:**
1. Cited externally OR foundational? → Strict
2. Quantitative OR operational reality? → Moderate
3. Exploratory OR definitional OR stepping-stone? → Light
4. Otherwise → Moderate (default)

### Step 13: Flag Recency-Sensitive Questions

**Recency-sensitive: yes** — market sizing, AUM, deal volume; personnel/leadership; regulatory status; pricing, rates, multiples; competitive landscape.

**Recency-sensitive: no** — industry structure; historical patterns; definitions, frameworks, taxonomies; relationship dynamics; process descriptions.

### Step 14: Define Thin Results Protocol

Specify what to do when web searches yield sparse results.

**Pivot threshold:** After 5+ varied queries yield <2 useful sources.

**Classify the scarcity:**

| Classification | Meaning |
|----------------|---------|
| **Proprietary** | Held by companies/individuals; requires interviews or paid access |
| **Emerging** | Topic too new for substantial coverage; accept partial data |
| **Niche** | Segment too small for mainstream coverage; seek specialist sources |
| **Fragmented** | Scattered across many small sources; aggregate from partials |
| **Gated** | Behind paywalls or logins; identify specific databases |
| **Opaque** | Intentionally not disclosed; note as structural limitation |

**Scarcity is insight.** "This information is proprietary and held internally" is more valuable than "we couldn't find anything."

**Fallback:** Document what was searched, what was found (even partial), classify the scarcity, flag for Patrik.

### Step 15: Define Scope Revision Triggers

Include conditions for pausing and reassessing:
- Research reveals the assumed problem doesn't exist or is already solved
- A more significant adjacent problem emerges
- Key Task Plan assumptions are contradicted by evidence
- The target market/segment is substantially different than assumed

**When triggered:** Pause research, document findings, present with recommendation: continue, revise scope, or abandon.

## Question Format

```
Q[n]: [Question text] [Depth tag if elevated above default]
- Scope: [What to include/exclude]
- Depth: [Level] — [What this level means for this question]
- Complete when: [Depth-appropriate criteria]
- Intelligence path: [Web search / Alternative: specify]
- Execution: GPT Deep Research (web-searchable) / Alternative: [specify]
- Source requirements: [Light / Moderate / Strict] — [brief rationale]
- Recency-sensitive: [yes/no] [if yes: brief reason]
```

Depth tag (e.g., "[L2]") appears in the question line only when elevated above default. Default-depth questions omit the tag.

### Granularity Calibration

Target questions answerable with 3-8 quality sources. If a question would require 20+ sources, break it down. If answerable with one source, it may be too narrow.

### Overlap Handling

Overlap is acceptable if each question has a distinct completion criterion and the overlap is acknowledged in Dependencies. Include: "If answering Q[x] also answers Q[y], consolidate findings and mark both complete."

## Objective Modifiers

### Conversational Fluency Modifier

**When to apply:** Task Plan objective is conversational fluency.

Additional filters:
1. **Anticipate challenges:** Include questions about misconceptions, criticisms, counterarguments
2. **Know the numbers:** Include questions about key parameters practitioners expect you to know
3. **Cover the cast:** Ensure all actors a practitioner might mention are covered
4. **Understand relationships:** Cover not just "who" but "how they interact"

Completion standard adjustment: requires defensive knowledge (what people argue about, where experts disagree) in addition to descriptive knowledge.

## Search Strategy Notes Guidelines

Include:
- **Terminology guidance:** industry terms, synonyms, jargon, terms to avoid
- **Query patterns:** 2-3 example queries per area, Boolean patterns if useful
- **Source preferences:** preferred source types, specific publications, sources to deprioritize
- **Time frame guidance:** relevant date range per question type

## Output

- Write to file in markdown format
- Label with version (v0.1, v0.2, v1.0)
- Include all sections from Research Plan Structure
- For a concrete example, see `references/example-output.md`

## Writing Standards

- Polished, executive-grade professional tone
- Clear, direct language
- Shorter sentences (15-25 words)
- No em-dashes

## Length Guideline

Target 1,000-2,000 words. Adjust based on number of research areas, decision criticality, uncertainty level, and search strategy complexity. A 12-question plan at the ceiling may reach 2,000+. A focused 6-question validation plan may be 800 words.

## Self-Validation Checklist

Before presenting, verify:

1. Assumptions stated if Task Plan was incomplete
2. Posture (confirmatory/exploratory/mixed) matches Task Plan maturity
3. Questions, if fully answered, provide what the Task Plan needs
4. Web-search questions are plausibly searchable; doubtful ones flagged or reassigned
5. Non-web questions marked with alternative sources
6. Key terms defined if Task Plan contains ambiguous domain terminology
7. "Complete when" criteria are unambiguously pass/fail
8. Foundational questions sequenced before dependent questions
9. Scope revision triggers defined
10. Question dimensions (definitional, operational, defensive, temporal) considered per area
11. All material actors enumerated; key relationships addressed; exclusions justified
12. Objective modifier applied if Task Plan has a specific objective type
13. Every question has depth level; elevated depths justified; distribution sensible (<50% elevated)
14. Web-searchable questions default to GPT Deep Research; alternative-source questions specify the path
15. Every question has source requirement classification with rationale; distribution sensible
16. Time-sensitive questions flagged recency-sensitive
17. Total question count is 12 or fewer (if exceeded, consolidation log justifies the override)

If any check fails, revise before presenting.

## Accuracy Standards

If the Task Plan provides insufficient information to formulate confident research questions, say so rather than inferring. It is acceptable to leave gaps or flag assumptions rather than inventing plausible-sounding questions. Prioritize accurate scoping over comprehensive coverage.

If the Task Plan's premise appears factually incorrect, state the concern and proceed with the plan as written, noting the assumption. If the premise is contradicted by well-established fact, flag it as a scope revision trigger and recommend confirmation before execution.

## Guardrails

**Do not:**
- Include questions answerable from the Task Plan itself
- Formulate questions so broad they cannot be completed
- Skip completion criteria
- Exceed 12 questions (hard ceiling — override only with explicit Task Plan justification)
- Assume all questions are web-searchable
- Invent information or over-extrapolate from weak sources

**Always:**
- State assumptions explicitly when Task Plan is incomplete
- Declare research posture
- Specify completion criteria for each question
- Assign intelligence path for each question
- Note dependencies between questions
- Define scope revision triggers
- Classify scarcity when results are thin (scarcity is insight)
- Assign and justify depth levels for all questions
