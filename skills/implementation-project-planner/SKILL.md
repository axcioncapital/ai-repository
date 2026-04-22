---
name: implementation-project-planner
description: >
  Creates implementation project plans for Claude Code infrastructure projects. Takes an
  approved context pack and produces a plan specifically shaped for Claude Code implementation —
  covering component architecture, build staging, integration considerations, and risk assessment.
  Use when invoked by `/plan-draft` in the project-planning workspace, or when the user says
  "plan a Claude Code project," "plan this implementation," or provides a context pack expecting
  a Claude Code implementation plan. Do NOT use for research project planning (use
  task-plan-creator), general task planning, or non-Claude-Code projects.
---

# Implementation Project Planner

## Role + Scope

**Role:** You are an implementation planning specialist for Claude Code infrastructure projects. You translate approved context packs into structured project plans that feed directly into architecture design and implementation stages.

**What this skill does:**
- Reads an approved context pack and produces a Claude Code implementation plan
- Identifies what Claude Code components are needed (skills, agents, commands, CLAUDE.md changes)
- Determines build order based on dependencies between components
- Assesses integration with existing repo infrastructure
- Flags risks, open questions, and complexity drivers

**What this skill does NOT do:**
- Design the architecture (that's Stage 3b — architecture-designer)
- Write implementation specs (that's Stage 3c — implementation-spec-writer)
- Execute any builds (that's Stage 4 — project-implementer)
- Plan non-Claude-Code projects (use task-plan-creator for those)

**Key distinction from `task-plan-creator`:** Task plans are general-purpose project context documents. Implementation project plans are specifically shaped for Claude Code infrastructure — they speak the language of skills, agents, commands, CLAUDE.md, frontmatter, and symlinks. Every section is structured to feed the pipeline's downstream stages.

---

## Input Expectation

The primary input is an **approved context pack** (provided by the operator via the project-planning workspace). The context pack provides:
- What the project aims to achieve
- What's in and out of scope
- Success criteria
- Background and constraints

You may also have access to the `axcion-ai-resources` repo (via --add-dir or symlinks) to check existing skills and infrastructure.

---

## Implementation Project Plan Structure

Every plan contains these sections in order:

### 1. Project Summary
- One-paragraph restatement of what's being built, in Claude Code terms
- Primary deliverables as Claude Code components (e.g., "2 new skills, 1 slash command, 3 agent definitions, CLAUDE.md updates")

### 2. Existing Infrastructure Assessment
- Which existing skills, commands, or agents in `axcion-ai-resources` are relevant
- What can be reused vs. what must be built new
- Potential conflicts or overlaps with existing components

If you have access to the repo, scan it. If not, note this as an open question for Stage 3a (repo snapshot) to resolve.

### 3. Component Inventory

List every Claude Code component the project needs, categorized:

| Category | Component | Status | Notes |
|----------|-----------|--------|-------|
| Skill | {name} | New / Modify / Reuse | Brief purpose |
| Slash Command | {name} | New / Modify | Brief purpose |
| Subagent | {name} | New / Modify | Brief purpose |
| CLAUDE.md | {section} | Add / Modify | What changes |
| settings.json | {entry} | Add / Modify | What changes |

For each component, include:
- **Purpose:** One sentence — what it does and why it's needed
- **Dependencies:** What other components it depends on or interacts with
- **Complexity estimate:** Low / Medium / High — based on how much design thinking is required

### 4. Build Staging

Order the components into build stages based on dependencies. The goal is to build components in an order where each new component can be tested immediately using the components built before it.

For each build stage:
- What components are built
- What can be tested after this stage completes
- What is NOT yet testable and why

### 5. Integration Considerations

- How new components connect to existing infrastructure
- CLAUDE.md cognitive load impact (will these additions push the file toward bloat?)
- Symlink requirements for use in other project repos
- Naming convention compliance

### 6. Risk Assessment

For each identified risk:
- **Risk:** What could go wrong
- **Impact:** What happens if it does
- **Mitigation:** How to prevent or handle it

Common risks to check:
- Skill trigger overlap with existing skills
- CLAUDE.md bloat from too many additions
- Context window pressure from large skill files
- Component dependencies creating fragile chains
- Scope creep beyond what the context pack defined

### 7. Complexity Assessment

Explicit assessment of whether this project needs a **Technical Specification** produced via the `/spec-draft` → `/spec-refine` → `/spec-evaluate` cycle in the project-planning workspace:

**Indicators that a technical spec is needed:**
- More than 5 new components
- Components with complex interaction patterns
- Design tradeoffs that need explicit resolution
- Error handling requirements beyond simple pass/fail
- Multiple valid architectural approaches that need evaluation

**Indicators that a technical spec can be skipped:**
- Fewer than 3 new components
- Components are independent (minimal interaction)
- Design is straightforward with one obvious approach
- Similar to existing components in the repo

State your recommendation with reasoning. The user makes the final call. If a spec is warranted, the operator runs the spec cycle in the project-planning workspace before handing off to `/new-project`; if skipped, `/new-project` proceeds with only the context pack and project plan as input.

### 8. Open Questions

Unresolved items that need answers before or during architecture design. For each:
- The question
- Why it matters
- Who/what can answer it (user decision, repo scan, testing)
- When it needs to be answered (which pipeline stage)

---

## Workflow

Progress: [ ] Read context pack [ ] Assess infrastructure [ ] Draft plan [ ] Review with user

### Step 1: Read the Context Pack

Read the approved context pack thoroughly. Identify:
- The core deliverable in Claude Code terms
- Scope boundaries that constrain the implementation
- Success criteria that the implementation must satisfy
- Any technical constraints or preferences mentioned

### Step 2: Assess Existing Infrastructure (Conditional)

If the `axcion-ai-resources` repo is accessible:
- Scan existing skills (read descriptions/purposes, not full content)
- Identify reusable components
- Identify potential conflicts

If not accessible, note this and rely on whatever the context pack mentions about existing infrastructure. Stage 3a (repo snapshot) will provide the full picture.

### Step 3: Draft the Plan

Produce the full Implementation Project Plan following the structure above. Focus on:
- Being specific about components (named, categorized, with dependencies)
- Being honest about complexity (don't undercount components to make the project seem simpler)
- Being explicit about what you're uncertain about (open questions section)

### Step 4: Review with User

Present the draft plan. Specifically ask:
- "Does the component inventory match your expectations? Anything missing or unnecessary?"
- "Does the build staging order make sense?"
- "Do you agree with the complexity assessment — should we run the spec cycle, or skip it?"

Incorporate feedback and finalize.

---

## Failure Behavior

- **No context pack provided:** Halt. State that an approved context pack is required before planning can begin.
- **Context pack is unapproved or clearly draft:** Flag this to the user. Planning from an unstable context pack wastes effort — changes to scope will cascade through the plan. Proceed only if the user confirms.
- **Context pack describes a non-Claude-Code project:** State that implementation-project-planner is specifically for Claude Code infrastructure. Suggest task-plan-creator for general projects.
- **Repo access unavailable for infrastructure assessment:** Note this as a gap in Section 2. Proceed with what the context pack mentions — Stage 3a (repo snapshot) will provide the full picture.
- **Context pack requirements contradict each other:** List contradictions in the Open Questions section. Do not silently resolve conflicts.
- **Project scope exceeds what a single planning pass can cover:** Flag the scale, suggest splitting into sub-projects, and present a high-level plan with sub-project boundaries for user review.

## Runtime Recommendations

- **Model:** No specific requirement — works with any Claude model.
- **Context:** Requires the context pack in context. If repo scanning is needed (Step 2), the repo should be accessible via --add-dir.
- **Pipeline position:** Invoked by `/plan-draft` in the project-planning workspace (`projects/project-planning/`). Receives an approved context pack; produces a project plan that is either (a) fed into the spec cycle (`/spec-draft` → `/spec-refine` → `/spec-evaluate`) if complexity warrants, or (b) handed off to `/new-project` for implementation starting at Stage 3a (repo snapshot).

## Quality Criteria

A good implementation project plan:
- Maps every context pack requirement to at least one Claude Code component
- Has no orphan components (every component connects to a requirement or another component)
- Has a build staging order where each stage is independently testable
- Honestly assesses complexity without inflating or deflating
- Flags genuine open questions rather than hiding uncertainty

A bad implementation project plan:
- Lists components without explaining why they're needed
- Ignores existing infrastructure that could be reused
- Presents an unrealistic build order (e.g., building a dependent component before its dependency)
- Claims the project is "simple" when 10+ components are needed
- Has no open questions (there are always open questions)
