---
model: sonnet
---

Routing advisor. Takes a proposed change description; reads the repo architecture map plus relevant CLAUDE.md layers; returns a structured placement recommendation in chat. **Non-mutating** — reads files only, writes nothing, executes no change.

Input: `$ARGUMENTS` — free-text description of the proposed change. May reference file paths, artifact types, or just describe intent.

Examples:
- `/route-change I want to add a skill that summarizes long PDFs into one-page briefs`
- `/route-change new hook to warn when a session opens with uncommitted changes from another session`
- `/route-change move the citation-fidelity audit logic from the research workflow into a shared agent`
- `/route-change add a permission for Bash(rg:*) so ripgrep stops prompting`

Use this command **before** invoking a creation pipeline (`/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`) when placement is non-obvious — e.g., when the artifact could plausibly live at multiple layers, or when you're unsure whether it's a skill vs. command vs. agent vs. doc. Skip when the home is already obvious from prior work.

This command is **not** auto-wired into `/create-skill` or any other pipeline. Operator-invoked only.

---

### Step 1: Input Validation

1. If `$ARGUMENTS` is empty, abort with:
   ```
   /route-change requires a description of the proposed change.
   Example: /route-change I want to add a skill that does X
   ```

2. Set `CHANGE` = `$ARGUMENTS` verbatim.

---

### Step 2: Load Architecture Context

3. Set `AI_RESOURCES` = absolute path to the nearest `ai-resources/` directory. Resolution: from the current working directory, walk upward until a directory named `ai-resources/` is found at or above (mirrors the upward-walk in `ai-resources/.claude/hooks/auto-sync-shared.sh`). If no upward match (operator invoking from outside the workspace), fall back to `~/Claude Code/Axcion AI Repo/ai-resources/`.

4. Read `{AI_RESOURCES}/docs/repo-architecture.md` in full. This is the primary source of truth for placement.

5. Read the following always-loaded rule files **only if** the change touches their scope. Decide by keyword in `CHANGE`:
   - Touches workspace-wide rules, autonomy, QC, model tier, commit behavior → `~/Claude Code/Axcion AI Repo/CLAUDE.md` (workspace).
   - Touches ai-resources repo conventions → `{AI_RESOURCES}/CLAUDE.md`.
   - Touches a specific project (`projects/<name>/`) → that project's `CLAUDE.md`.
   - Touches permissions / settings.json → `{AI_RESOURCES}/docs/permission-template.md`.
   - Touches model selection or tier → `{AI_RESOURCES}/docs/model-routing.md` and (for agents) `{AI_RESOURCES}/docs/agent-tier-table.md`.
   - Touches `/risk-check`, audit cadence, or change classes → `{AI_RESOURCES}/docs/audit-discipline.md`.
   - Touches resource creation pipelines → `{AI_RESOURCES}/docs/ai-resource-creation.md`.

6. Do **not** read project workspaces, skill libraries, or agent definitions exhaustively. The architecture map is the contract; deeper reads are only justified when `CHANGE` names a specific existing file the recommendation will modify.

---

### Step 3: Classify the Change

7. Walk the placement heuristics in `repo-architecture.md` § "Placement heuristics" (Q1–Q8) against `CHANGE`. Produce internal answers:
   - **Q1** Reusable across projects, or project-specific?
   - **Q2** Which artifact type (skill / command / agent / hook / doc / prompt / style-reference / log / audit / manifest)?
   - **Q3** If a slash command, which spawn shape (subagent vs. main-session vs. advisory)?
   - **Q4** If rule-shaped or prose-shaped, which layer?
   - **Q5** Does the change qualify as a structural class for `/risk-check`?
   - **Q6** Will it write a log? Which one?
   - **Q7** Is it a dated audit output?
   - **Q8** Is it a manifest, configuration, or template?

8. Identify the **canonical home** (single primary location where the artifact's source of truth lives).

9. Identify any **paired files** that must be edited or created in the same commit (e.g., a new command may need: command file + agent definition + entry in `audit-discipline.md` + reference in workspace CLAUDE.md).

10. Identify the relevant **creation pipeline**, if any:
    - New skill → `/create-skill`
    - Existing skill modification → `/improve-skill`
    - Skill arriving from Claude Chat → `/migrate-skill`
    - New project → `/new-project`
    - Graduation from project to ai-resources → `/graduate-resource`
    - Workflow deployment / sync → `/deploy-workflow` / `/sync-workflow`
    - Direct edit (no pipeline) → state "no pipeline; edit directly"

11. Determine whether `/risk-check` is required. Required iff `CHANGE` falls into one of the change classes listed in `{AI_RESOURCES}/docs/audit-discipline.md § Risk-check change classes` (the canonical source — do not maintain an inline copy of the list here). If required, note which gate fires (plan-time, end-time, or both — per the same doc's § When to fire (two-gate model)).

---

### Step 4: Produce Recommendation

12. Output exactly this structure in chat. No file writes.

```
## Routing recommendation

**Change:** {CHANGE first line, truncated to ~100 chars}

**Artifact type:** {skill | slash command | agent | hook | doc | prompt | style-reference | log entry | audit artifact | manifest | rule edit}

**Canonical home:** {absolute or repo-relative path}

**Files to touch (in one commit):**
- {path} — {create | edit} — {one-line purpose}
- {path} — {create | edit} — {one-line purpose}
{repeat as needed}

**Pipeline:** {/create-skill | /improve-skill | /migrate-skill | /new-project | /graduate-resource | /deploy-workflow | /sync-workflow | none — edit directly}

**Risk-check:** {not required | required: plan-time | required: end-time | required: both} — {one-line reason}

**Architecture-map sections consulted:** {section names from repo-architecture.md, e.g., "Q2 (artifact type), Q5 (risk-check classes)"}

**Notes:** {one short paragraph — flag ambiguities, alternative placements considered, or non-obvious coupling. Omit if no notes.}

**Alternative placement:** {include only when item 13 applies — present both candidate locations and the reason each might be preferred. Omit if the canonical home is unambiguous.}

**Architecture gap:** {include only when item 14 applies — describe what the architecture map does not yet cover and what would need to be added. Omit if the map covers the change.}
```

13. If multiple placements are genuinely plausible (e.g., a hook could live at workspace root or in ai-resources depending on scope), populate the `**Alternative placement:**` field with both candidates and the reason each might be preferred. Do not silently pick one — flag the ambiguity.

14. If the architecture map does not cover the proposed change (genuinely new artifact category, new top-level directory needed, novel coupling pattern), populate the `**Architecture gap:**` field with one paragraph describing what the map doesn't cover and what would need to be added. Recommend updating `docs/repo-architecture.md` in the same commit as the change.

---

### Step 5: No Commit, No Execution

15. `/route-change` is advisory only. It does not create files, edit settings, or invoke any pipeline. The operator reads the recommendation and decides whether to proceed (and via which pipeline).

16. If the operator approves the recommendation and proceeds with the named pipeline, that pipeline runs under its own rules (including its own `/risk-check` requirements and QC).
