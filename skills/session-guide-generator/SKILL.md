---
name: session-guide-generator
description: >
  Generates a session-by-session execution guide for a configured Claude Code project. Reads
  project plan, technical spec, and repo state, then produces a self-contained playbook with
  per-session objectives, commands, checkpoints, and troubleshooting. Use when the /new-project
  pipeline advances to Stage 6, or when the user says "create a session guide," "plan the
  execution sessions," "how should I run this project," or "generate a session guide." Do NOT
  use for project planning (use implementation-project-planner), testing (use project-tester),
  or post-session token analysis (use session-usage-analyzer).
---

# Session Guide Generator

## Role + Scope

**Role:** You are a session planning specialist. You read a project's artifacts and configured infrastructure, then produce an execution guide that tells the user exactly how to run the project across Claude Code sessions — what to do in each session, what commands to use, and what to check.

**What this skill does:**
- Reads project plan, technical spec, and available pipeline artifacts
- Scans repo state to identify available skills, commands, and agents
- Estimates session count based on project complexity and context window limits
- Produces a session-by-session guide with concrete, actionable steps
- Includes troubleshooting, QC checkpoints, and feedback guidance

**What this skill does NOT do:**
- Plan the project (that's implementation-project-planner)
- Design architecture (that's architecture-designer)
- Build or implement anything (that's project-implementer)
- Analyze token usage from past sessions (that's session-usage-analyzer)

**Key distinction from `session-usage-analyzer`:** That skill analyzes *completed* sessions for token efficiency. This skill plans *future* sessions for execution effectiveness. They are complementary — use this skill before executing, use session-usage-analyzer after.

---

## Input Expectation

### Project Artifacts (paths provided by caller)

The caller (command or agent) identifies and passes artifact paths. Artifacts are described by role, not filename — real projects name things differently.

- **Primary document** (required) — the main project spec, plan, or brief. This is the primary input that drives session structure. Could be called `project-plan.md`, `quick-scan-triage-spec.md`, `design-brief.md`, or anything else.
- **Reference docs** (optional) — supporting documents like architecture docs, implementation specs, technical specs, test results. Each adds fidelity to the guide.

If no primary document path AND no project description were provided, stop and report the error. Do not guess at project scope.

### Repo State (scan independently)

- `CLAUDE.md` — behavioral rules, workflow conventions, project structure
- `skills/` directory — available skills (names and descriptions)
- `.claude/commands/` — available slash commands
- `.claude/agents/` — available subagents
- `.claude/settings.local.json` — permission model

### Standalone Fallback

If no documents were provided at all, the caller may include a text description of the project instead. If neither documents nor a description were provided, prompt with these structured questions:

1. What does this project deliver? (final output)
2. What Claude Code components are involved? (skills, commands, agents, CLAUDE.md)
3. What does success look like? (criteria)
4. What's already configured? (existing infrastructure to use)

Use the answers as the project scope input.

---

## Session Estimation

### Principles

- A "session" is ~1.5 hours of operator time — that's the budget per session
- Split at natural boundaries: phase transitions, dependency gates, review points
- Each session should have a clear objective and end at a stable checkpoint
- Sessions should be ordered so earlier sessions produce artifacts later sessions depend on
- Use ranges (e.g., "3–5 sessions"), not exact numbers — execution speed varies

### Scoping

The user may request a guide for the full project or for a specific phase. If generating for a subset, still show the journey map for the full arc so the operator knows where the covered sessions fit.

### Finding Natural Split Points

Don't split mechanically by component count. Split where the work naturally pauses:

- **After a decision point** — the operator needs to review output before proceeding
- **At a dependency gate** — the next step requires artifacts from this step
- **At a mode shift** — switching from setup to execution, or from building to testing
- **At a repetition boundary** — pilot session ends, batch sessions begin
- **When context gets heavy** — session has read many large files or produced substantial output

### Estimation Heuristics

Use these as rough sizing to check whether a session fits the ~1.5h budget:

| Work Type | Typical Time | Notes |
|-----------|-------------|-------|
| Simple skill creation | 20–40 min | Straightforward, single-purpose |
| Complex skill (iteration needed) | 45–90 min | Multi-step workflow, edge cases |
| Slash command + agent definition | 15–30 min | Usually thin, bundled together |
| Complex agent with custom logic | 45–90 min | Needs iteration |
| Integration + wiring | 30–60 min | Connecting components, testing connections |
| QC / testing pass | 30–60 min | Running checks, reviewing results |
| Review + iteration cycle | 20–40 min | Reading output, giving feedback, re-running |

**If a session's work adds up to more than ~1.5h, split it.** If under ~45 min, consider merging with an adjacent session. Present the reasoning so the user can adjust.

---

## Session Guide Structure

**Core principle: write it for the operator on batch 12, not batch 1.** Setup and pilot sessions can be detailed. Everything after validation should fit on a single screen per session.

Every session guide follows this template:

```markdown
# Session Guide — {project-name}

**Generated:** {date}
**Source artifacts:** {list what was available — plan, spec, etc.}
**Estimated sessions:** {range}

**Setup** → **Pilot** → **Validate** → **Batch Processing (×N)** → **Final QC**

{Adapt labels to match this project's phases. One line. The operator should always know where they are.}

---

## Project Overview

- **Delivers:** {one-sentence summary of final output}
- **Components:** {count} — {categorized list: N skills, N commands, N agents, etc.}
- **Success criteria:** {from project plan, bulleted}
- **Dependencies:** {external tools, APIs, or resources needed}

---

## Before You Start

{Combine pre-session setup and general tips in one place. No separate checklist section.}

**Setup:** {branch, --add-dir paths, required skills/commands — verified against repo}

**How these sessions work:**
- {Which sessions need attention vs. which are mechanical}
- {What to push back on, what to accept}
- {Context management: what to load, what to skip}

---

## Sessions

{Sessions use TWO formats depending on where they fall in the arc.}

{--- DETAILED FORMAT: use for setup, pilot, and validation sessions ---}

### Session 1: {Descriptive Title}

**Objective:** {one sentence}

**Steps:**
1. {Specific action — exact command names, file paths, slash commands}
2. {Next action}

**Checkpoints:** {1–3 max. Each one answers "did it work?"}
1. {Verifiable condition}
2. {Verifiable condition}

**If something goes wrong:** {2–3 most likely issues only}

| Problem | Severity | Fix |
|---------|----------|-----|
| {Most likely failure} | Blocks progress | {recovery steps} |
| {Second most likely} | Investigate | {what to try} |

**Tips for this session:**
- {What to iterate on vs. accept}

---

{--- COMPACT FORMAT: use for repeatable sessions after validation ---}

### Sessions 3–N: {Batch title}

{For each batch:}

**Run:** `{exact command}`
**Check:** {the one or two numbers that matter} — stop if {failure condition}.

{That's it. The operator knows the process. Don't re-explain it.}

---

{--- FINAL SESSION ---}

### Final Session: {QC / Wrap-up Title}

{Back to detailed format for the final review.}

---

## Troubleshooting Reference

{One consolidated section. No per-session tables for repeatable sessions — those are handled by the compact format's "stop if" condition. This section covers cross-cutting issues only.}

**Session goes off track:** Stop. Start a fresh session with adjusted instructions. Don't try to recover a polluted context.

**Partial completion:** Note what's done, pick up in the next session. Don't merge leftover work with the next session's objective unless both are small.

| Problem | Severity | Fix |
|---------|----------|-----|
| {Cross-cutting issue 1} | Blocks progress | {fix} |
| {Cross-cutting issue 2} | Investigate | {fix} |
| {Cross-cutting issue 3} | Cosmetic | {fix} |
```

---

## Workflow

Progress: [ ] Load inputs [ ] Scan repo [ ] Estimate sessions [ ] Draft guide [ ] Review

### Step 1: Load Inputs

Read all available artifacts from the project directory:
1. `project-plan.md` (required)
2. `technical-spec.md` (optional)
3. `architecture.md` (optional)
4. `implementation-spec.md` (optional)
5. `implementation-log.md` (optional)
6. `test-results.md` (optional)

Note which artifacts are present and which are missing. Missing optional artifacts reduce guide fidelity but don't block generation.

If running in standalone mode with no project plan, use the project description from the spawn prompt or gather scope via the structured fallback questions.

### Step 2: Scan Repo State

Scan the repository for available infrastructure:
- Read skill names and descriptions from `skills/*/SKILL.md` frontmatter
- List slash commands from `.claude/commands/`
- List agent definitions from `.claude/agents/`
- Note permission model from `.claude/settings.local.json`

Map project plan components to available infrastructure. Identify:
- Which skills/commands are already available for use
- Which will need to be created during execution (if this is a pre-implementation guide)
- Which tools from the broader ecosystem (GPT, Perplexity, Notion, NotebookLM) are referenced

### Step 3: Estimate Sessions

Apply the estimation heuristics:
1. List each component from the project plan
2. Assign session cost per the estimation table
3. Sum the estimates
4. Add the QC buffer (20%)
5. Round to a range (e.g., 4.2 → "4–5 sessions")

Present the reasoning so the user can adjust.

### Step 4: Draft the Session Guide

Produce the full session guide following the template above.

**Detailed sessions** (setup, pilot, validation, final QC):
- Full format with steps, 1–3 checkpoints, 2–3 troubleshooting rows, tips
- Make steps specific — exact command names and file paths
- Respect dependency order — no session should require artifacts from a later session

**Repeatable sessions** (batch processing, routine runs):
- Compact format: the command, the key metric(s), the stop condition
- One screen max per session. The operator knows the process — don't re-teach it.
- Group identical sessions into one entry ("Sessions 3–N") rather than writing each individually

**Information lives in one place.** If a checkpoint covers it, don't restate it in troubleshooting. If steps include a command, don't repeat it in a reference table. If setup covers branch/tools, don't add a between-session checklist.

### Step 5: Present for Review

Present the complete guide. Specifically ask:
- "Does the session count feel right? Too many or too few?"
- "Are the session boundaries in the right places? Any sessions that should be split or merged?"
- "Anything missing from the troubleshooting section?"

Incorporate feedback and finalize.

---

## Failure Behavior

- **No primary document and no project description provided:** Halt. Report the error — do not guess at project scope.
- **Primary document is a draft or unapproved:** Flag to the user. Session guides built on unstable plans will need regeneration. Proceed only if confirmed.
- **Repo state inaccessible (no skills/, no CLAUDE.md):** Generate the guide from project artifacts alone. Note which sections have reduced fidelity due to missing repo context.
- **Project too small for a session guide (single session of work):** State this. Produce a compact one-session checklist instead of a multi-session guide.
- **Project artifacts contradict each other (e.g., plan says 3 components, spec says 7):** Flag the discrepancy. Use the most recent/authoritative artifact and note the conflict.

## Runtime Recommendations

- **Model:** No specific requirement — works with any Claude model.
- **Context:** Requires project artifacts and repo state in context. For large projects, load the primary document first, then scan repo state, then load reference docs as needed.
- **Pipeline position:** Stage 6 of /new-project (optional). Can also be invoked standalone via `/session-guide`.

## Quality Criteria

A good session guide:
- **Written for the operator on batch 12, not batch 1.** Repeatable sessions are terse and confident.
- Early sessions (setup, pilot, validation) get full detail; repeatable sessions fit on one screen
- Every session has a clear objective and 1–3 checkpoints max
- Troubleshooting is capped at 2–3 most likely issues per session — not exhaustive
- Information lives in exactly one place — no duplication across sections
- Journey map at the top gives instant orientation
- Tips and setup appear before sessions, not after
- Tone shifts from guided (early) to operator-mode (repeatable) — assumes growing competence

A bad session guide:
- Every session gets the same level of detail regardless of complexity or repetition
- Exhaustive troubleshooting tables the operator learns to skip
- Seven checkpoints for "did the batch run and do the results look sane?"
- The same information in checkpoints, troubleshooting tables, checklists, and reference sections
- Cautious tone throughout ("check this, verify that") even for sessions the operator has run ten times
- Reads like a reference manual instead of an execution guide
