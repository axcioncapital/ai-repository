---
name: architecture-designer
description: >
  Designs Claude Code architecture for implementation projects. Takes a project plan, optional
  technical spec, and repo snapshot, then produces an architecture document defining what
  components to build, how they integrate with existing infrastructure, and key design decisions.
  Use when the /new-project pipeline advances to Stage 3b, or when the user says "design the
  architecture," "architect this," or provides project plans expecting a Claude Code architecture
  design. Do NOT use for writing implementation specs (file-level instructions — that's
  implementation-spec-writer) or for general project planning (use implementation-project-planner).
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

**Key distinction:** Architecture design is the "what and why" — which components exist, how they relate, why they're shaped this way. Implementation spec is the "how exactly" — file paths, content, configuration values.

---

## Input Expectation

Required inputs:
- **Project plan** (`project-plan.md` from Stage 2)
- **Repo snapshot** (`repo-snapshot.md` from Stage 3a)

Optional input:
- **Technical spec** (`technical-spec.md` from Stage 2.5) — present for complex projects, absent for simple ones

If the technical spec exists, it is the primary design reference. If absent, the project plan provides the design context.

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

### 5. Conflict Analysis

Check for and report:
- **Trigger overlaps** — new skill descriptions that could conflict with existing skill triggers
- **Naming collisions** — new component names that are too similar to existing ones
- **CLAUDE.md bloat** — whether the additions push cognitive load beyond the lean threshold
- **Permission conflicts** — settings.json entries that could interfere with existing permissions
- **Context window pressure** — skills that might be too large for comfortable subagent operation

For each conflict found: describe the conflict, assess severity, propose resolution.

### 6. Design Decision Log

For each significant design choice:

| # | Decision | Alternatives Considered | Rationale | Trade-offs |
|---|----------|------------------------|-----------|------------|
| 1 | ... | ... | ... | ... |

Focus on decisions where reasonable alternatives existed. Don't log obvious choices.

---

## Workflow

### Step 1: Read All Inputs

Read the project plan, technical spec (if present), and repo snapshot. Build a mental model of:
- What needs to be built (from project plan / technical spec)
- What already exists (from repo snapshot)
- Where the new components fit in the existing landscape

### Step 2: Map Requirements to Components

For each requirement or deliverable in the project plan:
- What Claude Code component type best serves it?
- Can an existing component be reused or extended?
- Does it need its own component or can it be part of something else?

Apply the principle of minimal new components — don't create a new skill when an existing one can be extended. But don't force unrelated concerns into a single component either.

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

### Step 6: Draft the Architecture Document

Produce the full document following the structure above.

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

1. **Reuse over creation** — extend an existing component before creating a new one
2. **Isolation over coupling** — components should be independently understandable and testable
3. **Lean over comprehensive** — fewer, well-designed components beat many thin ones
4. **Explicit over implicit** — all connections and dependencies are documented, not assumed
5. **Consistent over optimal** — follow existing repo patterns even if a "better" pattern exists, unless the existing pattern is actively harmful

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
