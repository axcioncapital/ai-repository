---
name: section-directive-drafter
description: >
  Transforms refined cluster analytical memos into structured section directives
  for report prose synthesis. Use when all cluster memos are reviewed and approved
  and the user needs directives specifying what each report section should accomplish,
  its target length, narrative positioning, emphasis guidance, hedging requirements,
  and known gaps. Triggers on requests like "draft section directives," "create
  directives from memos," "what should each section do," or when analytical memos
  are provided with expectation of synthesis preparation. Takes cluster analytical
  memos (from cluster-analysis-pass, refined) as input. Do NOT use before cluster
  memos are refined and approved, for writing actual report prose (that's
  evidence-to-report-writer), for designing document architecture from scratch
  without a pre-existing section list (that's research-structure-creator or manual
  architecture work), for style/voice decisions (that's specifying-output-style),
  or when memos have not been through editorial review.
---

# Section Directive Drafter

Produce structured editorial directives — one per report section — from refined cluster analytical memos. Directives tell `evidence-to-report-writer` what each section must accomplish, which evidence to use, how to weight it, and what to hedge. This skill produces editorial instructions, not prose.

## Pipeline Position

```
cluster-analysis-pass → gap-assessment-gate → [this skill] → evidence-to-report-writer
```

The output serves as Inputs 2 (Document Architecture) and 3 (Editorial Annotations) for `evidence-to-report-writer`.

## Input Requirements

Three inputs, two required:

1. **Refined cluster analytical memos** (required) — post-editorial-review, from `cluster-analysis-pass`. Each must contain: Key Findings (with `[SOURCE-GROUNDED]`/`[ANALYTICAL]` tags), Evidence Strength Map, Cross-Question Tensions, Gaps That Matter, and So What sections.

2. **Report section list** (required) — at minimum: section titles in sequence. May include brief scope descriptions. Can come from a document architecture draft, a table of contents sketch, or user-provided outline.

3. **Gap Assessment Report** (optional, recommended) — from `gap-assessment-gate`. Used to identify Accepted Gaps each section must acknowledge and residual Weakening gaps requiring hedging.

### Validation

Before proceeding, verify:

- At least 2 cluster memos provided
- Memos contain identifiable findings with evidence strength indicators
- A section list with at least 2 sections exists
- If the section list exceeds 10 sections, flag that directive granularity may need to be reduced. Offer the user a choice: full directives for all sections (token-heavy), or full directives for priority sections + condensed directives for supporting sections.
- No unresolved **Blocking** gaps remain (check Gap Assessment Report if provided; if not provided, scan memo Gaps That Matter sections for anything that reads as Blocking-severity)

**Hard stop conditions:**
- Unresolved Blocking gap detected → Refuse. Direct user to `gap-assessment-gate`.
- No section list provided → Refuse. Request section list. Do not improvise a section structure.
- Memos appear unrefined (no editorial tags, raw cluster-analysis-pass output with unresolved tensions flagged for review) → Flag concern, ask user to confirm memos are final.

If findings across memos use inconsistent labeling (some use claim IDs, some use prose-only descriptions), flag the inconsistency and request standardization before proceeding.

## Procedure

### Step 1 — Build Claim Inventory

Extract every finding from all cluster memos into a flat inventory:

Per finding, capture:
- **Finding label** — short identifier (claim ID if available, or a generated tag like `C1-F3` = Cluster 1, Finding 3)
- **Content** — the finding statement
- **Tag** — `[SOURCE-GROUNDED]` or `[ANALYTICAL]`
- **Evidence strength** — Establishes / Suggests / Preliminary signal (from Evidence Strength Map)
- **Source cluster** — which cluster memo it comes from
- **Contributing questions** — which research questions feed this finding

Also extract from each memo:
- Cross-Question Tensions (for tension-aware allocation)
- Gaps That Matter (for gap acknowledgment mapping)
- So What recommendations (for emphasis guidance)

### Step 2 — Map Claims to Sections

Allocate each finding to exactly one **primary section** where it receives full or summary treatment. A finding may have **secondary mentions** in other sections (brief reference, not re-development).

Allocation principles:
- Match finding content to section scope based on section titles and descriptions
- Findings that address a section's core question → primary allocation to that section
- Findings that provide context for another section's argument → secondary mention
- Cross-Question Tensions → allocate to the section where the tension is most consequential
- So What recommendations → use as tiebreaker when a finding could serve multiple sections

**During allocation:** If a finding with Establishes or Suggests strength cannot be mapped to any section based on scope, flag it immediately as an allocation failure. Present the finding and ask the user whether to expand an existing section's scope or add a new section. Do not proceed to Step 3 until all Establishes/Suggests findings are allocated. Preliminary signal findings that don't fit may be deferred to the orphan check.

**Orphan check (post-allocation):** Verify every finding with Establishes or Suggests strength lands in at least one section. Preliminary signal findings may be deliberately excluded if peripheral — list these as intentional exclusions with rationale.

**Duplication check:** No finding should receive full development treatment in more than one section. If the same finding is essential to two sections, designate one as primary (full development) and the other as secondary (brief reference with forward/backward pointer).

### Step 3 — Assign Emphasis

For each section's allocated findings, classify treatment level:

| Evidence Strength | Cross-Question Support | Treatment |
|---|---|---|
| Establishes + convergent (multiple questions) | High | **Full development** (80-120 words in final prose) |
| Establishes, single question | Medium-High | **Full development** |
| Suggests + convergent | Medium | **Standard treatment** (40-80 words) |
| Suggests, single question | Medium-Low | **Summary treatment** (20-40 words) |
| Preliminary signal | Low | **Brief mention or footnote** (≤20 words) |
| Analytical (model-identified pattern) | Varies | **Supporting role only** — never the lead claim in a paragraph |

Override with So What recommendations from cluster memos: if a memo recommends foregrounding a Suggests-level finding, elevate to Standard or Full development and note the override.

**Override precedence:** So What overrides apply only to a finding's primary section allocation. If a So What recommendation points to a finding allocated as secondary in a given section, first consider whether primary allocation should shift to that section. If reallocation isn't appropriate, the So What override does not apply to the secondary mention — note the tension in the directive.

### Step 4 — Calculate Length Targets

Estimate per section using evidence density:

```
Target = Σ (allocated findings × treatment word estimate) + framing overhead (50-80 words per section)
```

Round to nearest 50. Present as a range (e.g., 350-450 words) rather than a false-precision number.

If total across all sections exceeds a reasonable report length (flag if >5000 words for a typical knowledge base entry, >10000 for a full report), note the total and ask user whether to compress globally or split sections.

User can override any length target.

**Balance check:** If the longest section's target length exceeds the shortest by more than 3x, flag the imbalance before proceeding. Present the specific sections and their targets. Recommend whether to compress the heavy section, split it, or supplement the thin section with additional evidence. Do not proceed to Step 5 until the user acknowledges the imbalance or overrides.

### Step 5 — Draft Directives

Produce one directive block per section with all components (see Directive Components below).

### Step 6 — Cross-Section Coherence Check

Verify:
- **Dependency logic** — if Section 3 assumes the reader knows something from Section 2, the dependency is noted in both directives
- **No circular dependencies** — Section A cannot depend on Section B while B depends on A
- **Emphasis consistency** — the same finding isn't marked "foreground" in one section and "compress first" in another
- **Tension handling** — cross-question tensions are allocated to a single section for resolution, not split across sections
- **Narrative arc** — sections in sequence tell a coherent story (problem → mechanism → evidence → implication, or similar)

## Directive Components

Each section directive contains the following components. **Iteration note:** If this section exceeds ~15 components in future versions, extract to `references/directive-components.md` and keep only the component list with one-line descriptions here.

### Section Objective
1-2 sentences: what this section must accomplish for the reader. Written as a reader-outcome statement: "After reading this section, the reader understands X and can Y."

### Reader Question
The single question this section answers (e.g., "Why does fund structure matter for investment strategy?"). Gives `evidence-to-report-writer` a framing anchor for the narrative opening.

### Claim Allocation
Compact list of finding labels allocated to this section with treatment level (e.g., `C1-F3 [Full], C2-F1 [Summary], C1-F7 [Brief]`). Full details (strength, tag, source cluster) live in the master Claim Allocation Summary — do not duplicate here.

### Target Length
Word count range. State the basis (evidence density calculation or user override).

### Narrative Positioning
Where in the report this section sits. Specify:
- What the reader already knows (from prior sections)
- What this section sets up for later sections
- Dependencies on other sections (explicit forward/backward references)

### Emphasis Guidance
- **Foreground** — findings to develop fully, with reasoning
- **Supporting** — findings for standard treatment
- **Compress first** — findings to sacrifice first if section runs long (pre-approved compression priorities for `evidence-to-report-writer`)

### Hedging Requirements
Findings requiring hedging language, mapped mechanically from Evidence Strength Map:

| Strength Label | Required Hedging |
|---|---|
| Establishes | None — state as firm ground |
| Suggests | Moderate hedging ("evidence suggests," "indicators point to") |
| Preliminary signal | Strong hedging ("early signals indicate," "tentative evidence") |
| Analytical (model pattern) | Frame as observation, not finding ("a pattern emerges across," "taken together, the evidence points toward") |

List each finding requiring hedging with its required level.

### Known Gaps
Gaps this section must acknowledge, pulled from cluster memo Gaps That Matter and/or Gap Assessment Report Accepted Gaps. For each:
- What is missing
- Recommended acknowledgment approach (brief caveat, explicit limitation statement, or scope boundary note)

### Cross-Section Dependencies
Explicit setup/payoff relationships:
- "Sets up [Section X] by establishing [concept]"
- "Assumes reader has encountered [concept] from [Section Y]"
- "Resolves tension introduced in [Section Z]"

## Output Structure

```markdown
# Section Directives: [Report Title]

## Narrative Arc
[3-5 sentences: how the sections connect as a whole argument]

## Claim Allocation Summary
[Master table: all findings, their primary section, treatment level — one glance view]

## Section Directives

### Section 1: [Title]
[All directive components]

### Section 2: [Title]
[All directive components]

[...repeat for each section]

## Orphan Check
[Findings not allocated to any section, with rationale for each exclusion]

## Dependency Map
[Which sections reference/set up which others — as a simple list or matrix]
```

## Completion Checklist

Before presenting directives (even in refinement mode), verify all of the following. Any failure is a hard stop requiring resolution before proceeding.

1. **Full allocation** — Every finding with Establishes or Suggests strength is allocated to exactly one primary section. Preliminary signal exclusions are listed with rationale in Orphan Check.
2. **No duplication** — No finding receives full development treatment in more than one section. Secondary mentions are brief references only.
3. **Complete directives** — Every section has all directive components populated (Section Objective, Reader Question, Claim Allocation, Target Length, Narrative Positioning, Emphasis Guidance, Hedging Requirements, Known Gaps, Cross-Section Dependencies). Components may state "None applicable" but cannot be omitted.
4. **No circular dependencies** — The Dependency Map contains no cycles (Section A → B → A).
5. **Balance acknowledged** — If the longest section exceeds the shortest by >3x, the imbalance is flagged and user has acknowledged or overridden.
6. **Hedging mapped** — Every Suggests, Preliminary signal, and Analytical finding has an explicit hedging requirement in its section directive matching the Hedging Requirements table.

## Evidence Integrity Rules

- Operate only from provided memos. Do not supplement with external knowledge about what the report "should" cover.
- Preserve evidence strength labels exactly as they appear in cluster memos. Do not upgrade or downgrade.
- If a memo's So What recommendation conflicts with evidence strength (e.g., recommends foregrounding a Preliminary signal finding), follow the recommendation but flag the override explicitly in the directive.
- Claim allocation must be traceable — every finding in the directive output must map to a specific finding in a specific cluster memo.
- Gaps in directives are acceptable. If a section's scope cannot be fully specified from available memos, say so. Do not invent editorial direction to fill the gap.

## Output Protocol

**Default mode: Refinement**

Present the Claim Allocation Summary table and Narrative Arc first. This lets the user redirect emphasis, adjust section scope, or override allocations before the full directive set is generated.

**Do not produce the full directive set until user says `RELEASE ARTIFACT`.**

When user says `RELEASE ARTIFACT`:
- Write the complete directive set to a file (e.g., `section-directives.md` in the active workflow directory)
- Provide a brief summary of what was created

## Edge Cases

**More sections than clusters:** Some sections may draw from a single cluster or a subset. This is normal — directives still specify all components.

**More clusters than sections:** Multiple clusters feed one section. The directive must be explicit about which cluster's findings take priority when emphasis conflicts arise.

**Section with no strong evidence:** If all allocated findings are Suggests or Preliminary signal, the directive should recommend a short section length, heavy hedging, and flag whether the section should be retained or merged into an adjacent section. Present as a recommendation, not an automatic decision.

**Findings that don't fit any section:** List in Orphan Check. Recommend either adding a section, expanding an existing section's scope, or explicitly excluding with rationale.

**User provides section list mid-conversation:** Accept and proceed. Do not require a separate invocation.
