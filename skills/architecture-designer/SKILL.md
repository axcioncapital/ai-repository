---
name: architecture-designer
description: >
  Designs Claude Code architecture for implementation projects. Takes a project plan, optional
  technical spec, and repo snapshot, then produces an architecture document defining what
  components to build, how they integrate with existing infrastructure, and key design decisions.
  Use when the /new-project pipeline advances to Stage 3b, or when the user says "design the
  architecture," "architect this," "what components do I need," "how should this be structured
  in Claude Code," or provides a project plan expecting a component breakdown and integration
  design. Do NOT use for writing implementation specs (file-level instructions — that's
  implementation-spec-writer), for general project planning (use implementation-project-planner),
  or for writing technical specifications (use spec-writer).
---

# Architecture Designer

## Role + Scope

**Role:** You are a Claude Code architecture designer. You make the creative and analytical decisions about how a project's requirements translate into Claude Code infrastructure — which components to build, how they connect to existing infrastructure, and what design tradeoffs to make.

**What this skill does:**
- Reads project plan, technical spec, and repo snapshot
- Decides what Claude Code components are needed (skills, agents, commands, CLAUDE.md changes, @imports)
- Designs how new components integrate with existing infrastructure
- Identifies conflicts, overlaps, and risks
- Documents design decisions with rationale and alternatives

**What this skill does NOT do:**
- Write line-level implementation details (exact file contents, CLAUDE.md text — that's implementation-spec-writer)
- Plan the project (that's implementation-project-planner)
- Write technical specifications (that's spec-writer)
- Execute builds (that's project-implementer)

**Key distinction:** Architecture design is the "what and why" — which components exist, how they relate, why they're shaped this way. Implementation spec is the "how exactly" — file paths, content, configuration values. For example, this skill decides "we need a new validation agent that loads the evaluator skill and runs as a subagent" — the implementation spec then defines the exact agent file content, YAML frontmatter, and settings.json entries.

---

## Input Expectation

Required inputs:
- **Project plan** (`project-plan.md` from Stage 2)
- **Repo snapshot** (`repo-snapshot.md` from Stage 3a)

Optional inputs:
- **Technical spec** (`technical-spec.md` from Stage 2.5) — present for complex projects, absent for simple ones
- **Project baseline template** (`templates/project-baseline/manifest.md` in ai-resources) — read this when designing a new project setup to understand what baseline components and optional modules are available before designing custom components

If the technical spec exists, it is the primary design reference. If absent, the project plan provides the design context.

**Incomplete inputs:** If the project plan or repo snapshot exists but lacks sufficient detail to make architecture decisions, ask the user for the minimum information needed: what's being built and what already exists. Do not attempt architecture design without understanding both the target and the current state.

**Contradictory inputs:** If the project plan references components or capabilities not present in the repo snapshot, or if requirements within the project plan contradict each other, flag the discrepancy to the user before designing around assumptions. Surface both interpretations and ask the user to resolve.

---

## Architecture Document Structure

### 1. Architecture Summary
- One paragraph: what's being built and the high-level approach
- Total component count: "{N} new components, {M} modifications to existing"

### 2. Component List

For each new component:

| Field | Description |
|-------|-------------|
| **Name** | Following repo naming conventions |
| **Type** | Skill / Slash Command / Subagent / @import / CLAUDE.md section |
| **Purpose** | What it does — one to two sentences |
| **Rationale** | Why it needs to exist as a separate component (not merged into something else) |
| **Model** | For agents: which model and why (opus for reasoning, sonnet for mechanical) |
| **Skill dependencies** | Other skills it loads via `skills:` frontmatter or references |
| **Estimated complexity** | Low / Medium / High — how much design thinking the implementation spec needs |

### 3. Modification List

For each existing component that needs changes:

| Field | Description |
|-------|-------------|
| **Component** | Name and type |
| **Change summary** | What changes and why |
| **Risk** | What could break (downstream dependencies, trigger overlap) |

### 4. Integration Map

How new components connect to existing ones:
- **Invocation chains** — which commands invoke which agents, which agents load which skills
- **Data flow** — what artifacts move between components and where they're stored
- **Shared references** — components that reference common files (CLAUDE.md, settings.json)

Present this as a structured description or table. The goal is that someone reading the integration map understands the full wiring without looking at individual component details.

**Example integration map entry:**

> `/run-analysis` (slash command) → spawns `analysis-runner` (agent, opus) → loads `data-validator` skill + `report-formatter` skill → writes `analysis-report.md` to project directory → consumed by `report-reviewer` agent in the next pipeline stage.
>
> Shared references: both `analysis-runner` and `report-reviewer` read `CLAUDE.md` for project-level conventions. `data-validator` reads a bundled schema file in its own `references/` directory for field definitions.

### 5. Conflict Analysis

Check for and report:
- **Trigger overlaps** — new skill descriptions that could conflict with existing skill triggers
- **Naming collisions** — new component names that are too similar to existing ones
- **CLAUDE.md bloat** — whether the additions push cognitive load beyond the lean threshold
- **Permission conflicts** — settings.json entries that could interfere with existing permissions
- **Context window pressure** — skills that might be too large for comfortable subagent operation
- **Agent budget** — whether the total number of agents and their model assignments (opus vs. sonnet) create practical cost or latency concerns for the project's scale

For each conflict found: describe the conflict, assess severity, propose resolution. If a conflict has no clean resolution, document it as an unresolved risk with your best-available mitigation and flag it prominently in Step 7.

### 6. Design Decision Log

For each significant design choice:

| # | Decision | Alternatives Considered | Rationale | Trade-offs |
|---|----------|------------------------|-----------|------------|
| 1 | ... | ... | ... | ... |

Focus on decisions where reasonable alternatives existed. Don't log obvious choices — a choice is "obvious" if a competent designer would reach the same conclusion without weighing alternatives.

**Example decision log entry:**

| # | Decision | Alternatives Considered | Rationale | Trade-offs |
|---|----------|------------------------|-----------|------------|
| 1 | Separate validation into its own agent rather than embedding in the main pipeline agent | (a) Validation as a step within the pipeline agent, (b) Validation as a skill loaded by the pipeline agent | Validation needs fresh context to avoid self-evaluation bias (per QC Independence Rule). A separate agent enforces this structurally. Option (b) loads the skill in the same context, defeating the purpose. | Adds one more agent to manage; slightly slower due to agent spawn overhead. |

---

## Workflow

### Step 1: Read All Inputs

Read the project plan, technical spec (if present), and repo snapshot. Build a mental model of:
- What needs to be built (from project plan / technical spec)
- What already exists (from repo snapshot)
- Where the new components fit in the existing landscape

### Step 2: Map Requirements to Components

If the project baseline template manifest is available, start here:
- Which baseline components apply to this project? (Most do — they're universal.)
- Which optional modules should be included? Read each module's README.md for "when to include" guidance.
- Record module selections as design decisions in the Design Decision Log.
- Only after establishing the baseline + modules, identify what custom components are still needed.

**Directory structure decision:** Determine whether the project is flat (single working directory) or multi-level (root directory with subprojects inside).

Signals that indicate multi-level:
- The project has distinct operational phases that don't share a pipeline
- The project plan describes separable tools or workflows
- The context pack mentions multiple deliverables with different infrastructure needs

If multi-level: the root gets a navigation CLAUDE.md (use `baseline/root-claude.md` template) with project description, subproject listing, and spec file locations. Each subproject gets the full baseline. No `.claude/` directory at root — sessions are opened in the subproject. Record this as a design decision.

For each remaining requirement or deliverable in the project plan:
- What Claude Code component type best serves it?
- Can an existing component be reused or extended?
- Does it need its own component or can it be part of something else?

Apply the principle of minimal new components — don't create a new skill when an existing one can be extended. But don't force unrelated concerns into a single component either.

If a requirement doesn't map naturally to any Claude Code component type (skill, agent, command, @import, CLAUDE.md section), flag it to the user rather than forcing it into an ill-fitting category. Some requirements may need external tools, manual steps, or capabilities outside Claude Code's scope.

### Step 3: Design Integration

For each new component, work out:
- How is it invoked? (slash command, agent delegation, direct skill reference)
- What inputs does it need and where do they come from?
- What outputs does it produce and who consumes them?
- How does it connect to existing infrastructure?

### Step 4: Check for Conflicts

Systematically compare new components against the repo snapshot:
- Read every existing skill description — check for trigger overlap with new skills
- Check naming conventions — does the new name fit the pattern?
- Estimate CLAUDE.md impact — how many lines are being added?
- Review settings.json — are new permissions needed?

### Step 5: Document Decisions

For every non-obvious choice made in Steps 2–4, record:
- What was decided
- What alternatives were considered
- Why this option was chosen

When you cannot confidently choose between alternatives based on available inputs, mark the decision as **open** in the Design Decision Log with a clear description of what information would resolve it. Present open decisions prominently to the user in Step 7. Do not silently commit to a choice you're uncertain about — architecture is the cheapest place to surface ambiguity.

Note: The orchestrating agent may maintain a `decisions.md` file for the project. Architecture decisions recorded here should be consistent with that log, but the architecture document's Design Decision Log is self-contained — readers should not need to cross-reference `decisions.md` to understand the architecture.

### Step 6: Draft the Architecture Document

Produce the full document following the structure above. The output artifact is typically saved as `architecture.md` in the project directory, though the orchestrating agent or user controls the exact path.

### Step 7: Review with User

Present the draft. Specifically ask:
- "Does the component list match what you expected? Anything over-engineered or missing?"
- "Do the integration points make sense?"
- "Are there conflicts I haven't spotted?"

**This is the most critical review point in the pipeline.** Push the user to challenge the architecture — it's much cheaper to change the design now than to rebuild after implementation.

Incorporate feedback and finalize.

---

## Design Principles

When making architecture decisions, apply these principles in order of priority:

1. **Baseline first** — start from the project baseline template (`templates/project-baseline/`). Custom components layer on top — don't reinvent patterns the template already provides
2. **Reuse over creation** — extend an existing component before creating a new one
3. **Isolation over coupling** — components should be independently understandable and testable
4. **Lean over comprehensive** — fewer, well-designed components beat many thin ones
5. **Explicit over implicit** — all connections and dependencies are documented, not assumed
6. **Consistent over optimal** — follow existing repo patterns even if a "better" pattern exists, unless the existing pattern is actively harmful

When Reuse (2) and Isolation (3) conflict — e.g., extending an existing component would increase coupling — prefer the option that keeps each component independently understandable and testable.

---

## Quality Criteria

A good architecture document:
- Every project requirement maps to at least one component
- No component exists without a clear requirement driving it
- Integration map has no dead ends (every output has a consumer, every input has a source)
- Conflict analysis is thorough — at minimum checks trigger overlap, naming, and CLAUDE.md impact
- Design decisions explain *why*, not just *what*

A bad architecture document:
- Components listed without rationale ("we need this because the spec says so")
- Integration described vaguely ("these components work together")
- No conflict analysis or a superficial "no conflicts found"
- Over-engineered — more components than the project needs
- Under-engineered — critical concerns collapsed into one overloaded component
