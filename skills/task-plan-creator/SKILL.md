---
name: task-plan-creator
description: >
  Co-author comprehensive Task Plans for Axcion projects — foundational context
  documents that enable AI systems to produce effective workflow plans and
  research plans. Use when: (1) creating a new Task Plan from context documents
  or rough descriptions, (2) refining an existing Task Plan draft, (3)
  structuring project thinking into the standard 8-section Task Plan format
  (Background, Objective, Scope, Deliverables, Process, Resources, Success
  Criteria, Open Questions). Do not use for: creating workflow plans, research
  plans, or executing the work described in a Task Plan.
---

# Task Plan Creator

## Purpose

A Task Plan is a foundational context document. It gives AI systems everything needed to produce useful workflow plans and research plans without excessive iteration. It forces thorough upfront consideration and ensures critical elements (scope boundaries, success criteria, process stages) are explicitly documented rather than assumed.

After completion, a Task Plan feeds into **Workflow Plans** (step-by-step execution instructions) and **Research Plans** (information gathering specifications). The Task Plan provides foundational context, not operational detail.

## Task Plan Structure

Every Task Plan contains these sections in order:

| Section | Purpose |
|---------|---------|
| **Background** | Context: what prompted this, connection to broader objectives, prior work |
| **Objective** | What success looks like, the outcome and value delivered |
| **Scope** | What is in scope, what is out of scope, key assumptions |
| **Deliverables** | Concrete artifacts with descriptions and formats |
| **Process** | Staged workflow with dependencies between stages |
| **Resources** | People, tools, existing documents, external sources |
| **Success Criteria** | How we evaluate whether output meets required standard |
| **Open Questions** | Uncertainties, unresolved decisions, areas needing flexibility |

## Planning Protocol

Before drafting, provide:
1. Input type identified (draft refinement vs. creation from context)
2. Key assumptions being made about the project
3. Sections where information appears thin or missing
4. Questions only if answers would materially change the Task Plan structure or content

Proceed to drafting after the user confirms the approach.

## Workflow

### Step 1: Determine Input Type

Identify whether the input is:
- **Draft refinement** — An existing Task Plan draft is provided
- **Creation from context** — Context documents, notes, or verbal description are provided

### Step 2: Draft or Refine

**If draft refinement:**
- Preserve existing structure and content
- Fill gaps in underdeveloped sections
- Improve formulation and clarity
- Do not restructure unless the structure is fundamentally unclear
- Do not remove content unless explicitly approved

**If creation from context:**
- Synthesize information into Task Plan structure
- Impose logical organization on unstructured input
- Add section content that can be reasonably inferred
- Flag areas where inference was required

### Step 3: Confirm Coverage (Conditional)

Only provide post-draft confirmation if:
- Content was omitted
- Assumptions were made
- Areas need further development

If the Task Plan is complete and straightforward, state "Complete draft — no omissions or assumptions" and move on.

## Section-by-Section Guidance

### Background
Establish why this work exists. Answer:
- What situation or need triggered this task?
- What prior decisions or work does this build upon?
- How does this connect to broader Axcion objectives?

### Objective
Define the outcome, not the process. Answer:
- What will be true when this is complete that is not true now?
- What value does this create?
- What does success look like at the highest level?

### Scope
Draw explicit boundaries. Include:
- **In scope:** What this task will address
- **Out of scope:** What this task will not address (be specific)
- **Assumptions:** What we are taking as given

### Deliverables
List concrete artifacts. For each deliverable specify:
- What the artifact is called
- What it contains
- What format it takes

### Process
Map the staged workflow. Most Task Plans have 3-6 stages. For each stage:
- Name the stage clearly
- Describe what happens in that stage
- Identify what the stage produces that enables subsequent stages
- Note dependencies on prior stages

Stages should be logically sequenced. Later stages should build on earlier outputs.

### Resources
Identify:
- Who is working on this and their roles
- What tools (AI, software) will be used
- What existing documents or data are relevant
- What external sources will be consulted

### Success Criteria
Define how to evaluate the output. Criteria should be:
- Specific enough to assess objectively
- Tied to the stated objective
- Achievable given the scope and resources

Avoid vague criteria like "high quality" without specifying what that means.

### Open Questions
Capture uncertainties explicitly. Include:
- Decisions not yet made
- Areas where the approach may need to flex
- Questions that will be answered during the work

This section may be empty if everything is clear. That is acceptable.

## Writing Standards

### Tone and Register
Write in polished, executive-grade professional tone. Match McKinsey internal strategy documents: clear, direct, analytical.

- No casual language, colloquialisms, or contractions
- Precise, authoritative verb choices
- Deliberate sentence construction

### Readability
Optimize for non-native English speakers:
- Prefer shorter sentences (15-25 words)
- One idea per sentence where possible
- Common, direct words over sophisticated alternatives
- No em-dashes

### Formatting
- Use **bold** for key terms and concepts (1-3 per paragraph maximum)
- Use bullet points for lists of three or more items
- Do not use inline enumeration ("First... Second... Third...")

## Length Constraint

Task Plans should be **1,000-1,500 words** depending on complexity. This forces concision while allowing sufficient detail for complex projects.

If a project genuinely requires more detail, that detail belongs in downstream workflow plans or research plans, not in the Task Plan itself.

## Output Protocol

**Default mode: Refinement**

Before producing the full Task Plan, provide:
- Structural outline showing which sections have strong content vs. thin/inferred content
- Key assumptions being made
- Brief summary of what the final deliverable will contain

**Do not produce the full Task Plan until user says `RELEASE ARTIFACT`.**

When user says `RELEASE ARTIFACT`:
- Write the complete Task Plan to file in markdown format
- Label with version number (v0.1, v0.2, v1.0)
- Include all 8 sections in order
- Provide a brief summary of what was created

### Versioning
- v0.1 — initial draft from input
- v0.2 — refined after feedback
- v1.0 — ready for use

Flag underdeveloped areas and suggest improvements.

## Guardrails

If the provided information is insufficient to populate a section confidently, say so rather than inferring. It is acceptable to leave gaps rather than invent plausible-sounding detail. If the user's premise contains an error or questionable assumption, flag it constructively. Prioritize accuracy over comprehensiveness.

**Do not:**
- Hallucinate facts, figures, or context not provided or inferable
- Exceed ~1,500 words
- Skip sections without explicit approval
- Add substantive content not supported by the input
- Restructure existing drafts unless structure is fundamentally broken

**Always:**
- Determine input type (draft vs. context) before proceeding
- Preserve existing content when refining drafts
- Include all 8 sections unless specified otherwise
- Use bold for key terms and bullet points for lists
- When making assumptions, mark them with **[ASSUMPTION: ...]** and flag in post-draft confirmation

## Example Section Outputs

### Example: Scope Section

**In scope:**
- Researching how boutique PE funds manage deal sourcing processes
- Identifying and prioritizing pain points by impact
- Designing service model that addresses prioritized problems
- Producing documentation suitable for marketing strategy development

**Out of scope:**
- Marketing strategy and messaging (subsequent task)
- Pricing and commercial terms
- Implementation and operational setup
- Technology platform requirements

**Assumptions:**
- Target market is boutique PE funds with €200M-€2B capital
- Focus is Nordic market (Sweden, Norway, Denmark, Finland)
- Axcion has existing relationships to leverage for validation

### Example: Process Section

**Stage 1: Understanding PE Fund Fundamentals**

Build foundational knowledge of how private equity funds operate, with emphasis on boutique funds in the €200M-€2B range. Research organizational structures, decision-making processes, fund lifecycle, and investment strategies. Document the Nordic PE landscape across Sweden, Norway, Denmark, and Finland.

This stage produces a knowledge foundation that enables informed analysis in subsequent stages.

**Stage 2: Research Current Deal Sourcing Practices**

Map the complete deal sourcing workflow from the buy-side perspective. Document how funds receive opportunities, what information formats they expect, and how they process incoming deal flow. Identify specific pain points, inefficiencies, and gaps.

This stage produces a current-state assessment and initial pain point inventory.

**Stage 3: Prioritize Pain Points by Impact**

Assess each identified pain point for its impact on fund decision-making and willingness to engage. Categorize into impact tiers. Determine which pain points Axcion must address to create meaningful differentiation.

This stage produces a prioritized problem set that focuses subsequent solution design.
