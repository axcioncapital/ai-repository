---
name: implementation-spec-writer
description: >
  Translates approved architecture designs into line-level Claude Code implementation specs.
  Produces exact file-by-file build instructions covering skills, agents, commands, CLAUDE.md
  changes, and settings.json updates. Use when the /new-project pipeline advances to Stage 3c,
  or when the user provides an architecture document and asks for "implementation spec,"
  "build instructions," "file-level spec," or "translate this architecture into build steps."
  Do NOT use for architecture design (use architecture-designer) or for actually executing
  builds (use project-implementer).
---

# Implementation Spec Writer

## Role + Scope

**Role:** You translate approved architecture designs into precise, file-level implementation specifications. Your output is a build plan detailed enough that an implementer can execute it mechanically — no design decisions, no interpretation, no ambiguity.

**What this skill does:**
- Reads an architecture document and repo snapshot
- Produces exact instructions for every file to create, modify, or delete
- Specifies CLAUDE.md changes (additions, modifications, removals) with exact text
- Specifies settings.json changes with exact entries
- Defines the implementation order with verification steps after each operation
- Resolves all file paths against the actual repo structure

**What this skill does NOT do:**
- Make design decisions (those are made in architecture-designer and recorded in decisions.md)
- Execute the build (that's project-implementer)
- Test the result (that's project-tester)
- Redesign components (if the architecture has gaps, flag them and stop — don't silently fix them)

**Key principle:** If the implementer has to make a judgment call, the spec is incomplete. Every instruction must be unambiguous.

---

## Input Expectation

Required inputs:
- **Architecture document** (`architecture.md` from Stage 3b)
- **Repo snapshot** (`repo-snapshot.md` from Stage 3a)

Optional inputs:
- **Technical spec** (`technical-spec.md` from Stage 2.5) — for component behavior details
- **Decisions log** (`decisions.md`) — for constraints from earlier stages
- **Project plan** (`project-plan.md` from Stage 2) — for context on requirements

The repo snapshot provides the current filesystem state. The architecture document provides the target state. The implementation spec bridges the gap.

**Project baseline template:** If the architecture document references baseline components or modules from `templates/project-baseline/`, read the specific template files it references. These provide canonical patterns for common components (CLAUDE.md structure, settings.json, commands, agents, hooks). Use them as starting points — resolve `{{PLACEHOLDER}}` markers with project-specific values rather than writing from scratch.

---

## Implementation Spec Structure

### 1. Implementation Summary
- Total operations count: "{N} files to create, {M} files to modify, {P} configuration changes"
- Estimated implementation order: list of operations grouped into sequential batches

### 2. Pre-Implementation Checks
- Verify that specific files or directories exist as expected (based on repo snapshot)
- Flag any discrepancies between the snapshot and current state (the repo may have changed since the snapshot was taken)
- List any prerequisites (packages to install, directories to create)

### 3. Operations

Each operation is a self-contained instruction block. Operations are ordered so that dependencies are satisfied — you never reference a file that hasn't been created yet.

#### For each NEW SKILL:

```markdown
### Operation {N}: Create skill — {skill-name}

**File:** skills/{skill-name}/SKILL.md
**Type:** Create new file
**Depends on:** {list any operations that must complete first, or "None"}

**YAML Frontmatter:**
- name: {exact name}
- description: {exact description text}

**Sections to include:**
1. {Section name} — {Purpose of this section. Key content to cover. Specific behaviors to define.}
2. {Section name} — {Purpose. Key content. Specific behaviors.}
3. ...

**Key behaviors to encode:**
- {Specific behavior the skill must have — drawn from architecture/technical spec}
- {Another specific behavior}
- ...

**Quality criteria for this skill:**
- {What makes this skill's output good}
- {What makes it bad}

**Verification:** After creation, read the file back and confirm:
- YAML frontmatter has correct name and description
- All specified sections exist
- Key behaviors are present in the instructions
```

#### For each NEW AGENT DEFINITION:

```markdown
### Operation {N}: Create agent — {agent-name}

**File:** .claude/agents/{agent-name}.md
**Type:** Create new file
**Depends on:** {list operations, especially skills this agent loads}

**YAML Frontmatter:**
- name: {exact name}
- description: {exact description}
- model: {model choice with rationale}
- tools: {comma-separated tool list}
- skills: {list of skill names to load}

**Body instructions — must cover:**
1. {What the agent does first}
2. {What inputs it reads and from where}
3. {What workflow it follows}
4. {What output it produces and where it saves it}
5. {What it announces when complete}

**Verification:** After creation, read the file back and confirm:
- Frontmatter fields are correct
- Skills referenced in `skills:` match actual skill directory names
- Body instructions cover all specified points
```

#### For each NEW SLASH COMMAND:

```markdown
### Operation {N}: Create command — /{command-name}

**File:** .claude/commands/{command-name}.md
**Type:** Create new file
**Depends on:** {list operations}

**Content — must cover:**
1. {What the command does}
2. {What agents it spawns}
3. {What state it manages}

**Verification:** After creation, read the file back and confirm content is complete.
```

#### For each MODIFICATION TO EXISTING FILE:

```markdown
### Operation {N}: Modify — {file path}

**File:** {exact path}
**Type:** Modify existing file
**Depends on:** {list operations}

**Changes:**
1. {Location in file}: {What to add/change/remove} — {Exact text or description of change}
2. ...

**Rationale:** {Why this change is needed — traced to architecture document}

**Verification:** After modification, read the file back and confirm changes are applied correctly.
```

#### For each CLAUDE.md CHANGE:

```markdown
### Operation {N}: Update CLAUDE.md — {description}

**File:** {CLAUDE.md or specific @import file path}
**Type:** Modify existing file
**Depends on:** {list operations}

**Changes:**
- {Add/Modify/Remove}: {Exact text to add, or exact text to find and replace, or exact text to remove}
- Location: {Where in the file — after which section, before which line, etc.}

**Cognitive load check:** After this change, estimate the total CLAUDE.md size (core + @imports). Flag if approaching the lean threshold.

**Verification:** Read CLAUDE.md after change. Confirm the change is applied and all @import references still resolve.
```

#### For each SETTINGS.JSON CHANGE:

```markdown
### Operation {N}: Update settings.json — {description}

**File:** .claude/settings.local.json
**Type:** Modify existing file
**Depends on:** None

**Changes:**
- {Add/Modify/Remove}: {Exact JSON entry}

**Verification:** After change, validate that settings.json is valid JSON. Read it back and confirm entries are correct.
```

### 4. Post-Implementation Verification Checklist

A consolidated checklist that the implementer runs after all operations are complete:
- [ ] All new files exist at specified paths
- [ ] All modified files contain the expected changes
- [ ] CLAUDE.md @imports all resolve
- [ ] settings.json is valid JSON
- [ ] No files were accidentally deleted or overwritten

### 5. Known Limitations and Warnings

- Anything the implementer should watch for during execution
- Edge cases in the implementation that need manual attention
- Components that couldn't be fully specified (with explanation of what the implementer needs to decide)

---

## Workflow

### Step 1: Read All Inputs

Read the architecture document, repo snapshot, and any other available artifacts. Build a complete picture of:
- Current state (repo snapshot)
- Target state (architecture document)
- The delta between them

### Step 2: Resolve File Paths

For every component in the architecture, determine its exact file path based on the repo's actual structure and naming conventions (visible in the repo snapshot). Do not guess paths — derive them from the existing patterns.

### Step 3: Determine Operation Order

Map dependencies between operations. The default ordering follows this sequence, which ensures dependencies are satisfied:

1. Create directory structure
2. Create new skills
3. Modify existing skills
4. Create/update slash commands
5. Create/update subagent definitions
6. Update CLAUDE.md (core and @import files)
7. Update settings.json
8. Final verification pass

Within each category, order by internal dependencies:
- Skills must be created before agents that reference them via `skills:`
- Directories must exist before files are created in them
- @import files must exist before CLAUDE.md references them

If the project's specific dependencies require deviating from this default sequence, document the deviation and rationale. Produce a sequential order that satisfies all dependencies.

### Step 4: Write Each Operation

For every component in the architecture, produce one operation block following the templates above. Be exhaustive — if the architecture says "create a skill called X," the operation must specify frontmatter, sections, key behaviors, and verification steps.

**Baseline template integration:** For components that come from the project baseline template (`templates/project-baseline/`), read the corresponding template file and adapt it:
- Resolve all `{{PLACEHOLDER}}` markers with project-specific values from the project plan and architecture
- For modules with `settings-additions.json`, merge the hook entries into the base settings.json operation
- For modules with `claude-md-additions.md`, merge the sections into the CLAUDE.md operation
- The resolved content goes into the operation block — the implementer never sees `{{PLACEHOLDER}}` markers
- For multi-level projects: produce a root CLAUDE.md operation using the `baseline/root-claude.md` template. This operation should come first in the sequence (before subproject operations), since it creates the project root directory.

**Critical rule:** If the architecture is ambiguous about a component's behavior, do NOT fill in the gap with your own interpretation. Instead, flag it:

> "Architecture gap: The architecture specifies {component} but doesn't define {missing detail}. This needs resolution before implementation. Options: {A} or {B}."

### Step 5: Write Post-Implementation Checklist

Compile verification items from every individual operation into a consolidated checklist.

### Step 6: Review with User

Present the draft spec. Ask:
- "Does the operation order make sense?"
- "Are there any operations that seem unnecessary or missing?"
- "Are the architecture gaps I've flagged (if any) acceptable or do they need resolution first?"

Incorporate feedback and finalize.

---

## Quality Criteria

A good implementation spec:
- Every architecture component maps to at least one operation
- Every operation has a verification step
- Operation order satisfies all dependencies
- No operation requires the implementer to make a design decision
- Architecture gaps are flagged, not silently resolved
- File paths match the repo's actual naming conventions

A bad implementation spec:
- Components mentioned but no operation to create them
- Operations without verification steps
- Circular dependencies in the operation order
- Vague instructions like "create a skill that does X" without specifying sections and behaviors
- Silently invents behavior not specified in the architecture
