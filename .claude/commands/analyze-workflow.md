---
model: opus
---

Analyze a workflow's deployed infrastructure end-to-end: inventory all commands, agents, hooks, and skills, trace the pipeline, and produce a prioritized findings report.

Input: $ARGUMENTS — workflow path (required), optional depth flag.
- Example: `workflows/research-workflow`
- Example: `workflows/research-workflow deep`

Depth levels:
- (default): Standard analysis + critique (infrastructure coherence, skill compatibility, pipeline continuity)
- "deep": Standard + friction correlation from deployed projects, project drift detection, skill staleness

---

### Step 1: Resolve Paths

1. Parse $ARGUMENTS. Extract the workflow path and optional depth flag ("deep").
2. Set AI_RESOURCES to the ai-resources repo root.
3. Set WORKFLOW_PATH to `{AI_RESOURCES}/{workflow path from arguments}`.
4. Validate WORKFLOW_PATH exists and contains a `.claude/` directory with at least one of: `commands/`, `agents/`, `hooks/`, or `settings.json`. A workflow with commands but no hooks is valid.
5. If $ARGUMENTS is empty or the path doesn't exist:
   - List available workflows under `{AI_RESOURCES}/workflows/`
   - Show the list and ask the operator to pick one
   - Stop here until the operator responds
6. Extract the workflow name from the path (last directory component, e.g., "research-workflow").
7. Set DEPTH to "deep" if $ARGUMENTS contains "deep", otherwise "standard".

---

### Step 2: Set Report Paths

8. Set AUDIT_DIR to `{AI_RESOURCES}/audits/`.
9. Set ANALYSIS_PATH to `{AUDIT_DIR}/workflow-analysis-{workflow-name}-YYYY-MM-DD.md` using today's date.
10. Set CRITIQUE_PATH to `{AUDIT_DIR}/workflow-critique-{workflow-name}-YYYY-MM-DD.md` using today's date.
11. Check for the workflow definition document. Look in order:
    - `{WORKFLOW_PATH}/reference/stage-instructions.md`
    - `{WORKFLOW_PATH}/stage-instructions.md`
    - `{WORKFLOW_PATH}/CLAUDE.md` (as fallback)
    Set STAGE_INSTRUCTIONS to the first found, or "None" if none found.
12. Set WORKFLOW_CLAUDE_MD to `{WORKFLOW_PATH}/CLAUDE.md` (or "None" if it doesn't exist).

---

### Step 3: Discover Deployed Projects (Deep Only)

13. If DEPTH is "deep":
    - Set WORKSPACE to the parent directory of AI_RESOURCES.
    - Scan `{WORKSPACE}/projects/` for directories that contain a `.claude/` directory.
    - For each found project, check if its CLAUDE.md or stage-instructions.md references the workflow name. Record matching project paths.
    - Set DEPLOYED_PROJECTS to the list of matching paths.
14. If DEPTH is "standard": set DEPLOYED_PROJECTS to empty.

---

### Step 4: Launch Phase 1 — Analysis

15. **Launch the `workflow-analysis-agent` subagent.** Pass it:
    - WORKFLOW_PATH
    - AI_RESOURCES path
    - ANALYSIS_PATH (where to save the analysis artifact)

    The subagent reads all infrastructure files, traces the pipeline, and saves a structured analysis artifact. This runs with fresh context for independent analysis.

16. When the subagent returns, read the saved analysis artifact at ANALYSIS_PATH. Verify it was written and contains at least Section 1 (Component Inventory).
17. If the subagent reports a partial analysis (context exhaustion), inform the operator and ask whether to proceed with partial data or stop.

---

### Step 5: Launch Phase 2 — Critique

18. **Launch the `workflow-critique-agent` subagent.** Pass it:
    - ANALYSIS_PATH (the analysis artifact from Phase 1)
    - STAGE_INSTRUCTIONS path (or "None")
    - WORKFLOW_CLAUDE_MD path (or "None")
    - CRITIQUE_PATH (where to save the critique report)
    - DEPTH
    - DEPLOYED_PROJECTS list
    - AI_RESOURCES path

    The subagent reads the analysis artifact, applies evaluation checks, and saves a findings report. This runs with fresh context — separate from both the main conversation and the analysis agent.

19. When the subagent returns, read the saved critique report at CRITIQUE_PATH. Verify it was written.

---

### Step 6: Present Findings [Operator Gate]

20. Display the critique report's Summary section:
    - Finding counts by severity
    - Top 3 recommendations

21. If there are Critical findings, highlight them first with the full finding details.

22. List all other findings grouped by severity.

23. Ask the operator: "Would you like to address any of these findings now, or commit the reports as-is?"

24. **Wait for operator direction.** The operator may:
    - Select specific findings to address now
    - Commit the reports as-is
    - Defer everything to a future session (reports are already saved)

---

### Step 7: Address Findings (If Requested)

25. For each finding the operator wants to address:
    - Show the exact change that will be made (file path + content)
    - Wait for operator confirmation
    - Apply the change
    - Record what was changed

26. If context usage is high, inform the operator — they can choose to stop and address remaining findings in a fresh session using the critique report as reference.

---

### Step 8: Commit

27. Show the diff of all changes (report files + any fix files from Step 7).
28. Stage the analysis artifact at ANALYSIS_PATH.
29. Stage the critique report at CRITIQUE_PATH.
30. If fixes were applied in Step 7, stage those files too.
31. Commit with message format: `audit: workflow-analysis — {workflow-name} YYYY-MM-DD, {N} findings`
    - Example: `audit: workflow-analysis — research-workflow 2026-04-07, 8 findings`
    - Example: `audit: workflow-analysis — research-workflow 2026-04-07, 3 findings, 2 fixed`
32. Do NOT push.

$ARGUMENTS
