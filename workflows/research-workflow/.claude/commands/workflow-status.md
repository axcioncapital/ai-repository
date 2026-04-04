Display a structured research workflow status view, then run a QC health check via subagent.

Both phases always run together — there is no display-only mode.

---

## Phase 1: Status View

1. Read the research workflow file at `/reference/stage-instructions.md`.
2. For each stage in the workflow, extract and display:

```
### Stage N: {Stage Name}

| Field | Value |
|-------|-------|
| **Steps** | {list of step IDs and titles} |
| **Inputs** | {what enters the stage} |
| **Outputs** | {artifacts produced} |
| **Executor** | {who/what runs each step — Claude Code, Operator, Sub-agent, etc.} |
| **Skills** | {skill names referenced in the stage} |
| **Gates** | {gate conditions, if any} |
| **Handoff** | {what passes to the next stage and how} |
```

3. If any field cannot be determined from the workflow text, show `[NOT SPECIFIED]` — do not silently skip it.
4. After all stages, show a summary line: total stages, total steps, total gates, total skills referenced.

---

## Phase 2: QC Health Check

5. Read the `workflow-evaluator` skill from `/ai-resources/skills/workflow-evaluator/SKILL.md`.
6. Read the skills directory listing from `/ai-resources/skills/` to get all available skill names.
7. Launch a **verification-agent** subagent in read-only mode. Pass it:
   - The full contents of `/reference/stage-instructions.md`
   - The full contents of the `workflow-evaluator` SKILL.md
   - The list of all skill directory names from `/ai-resources/skills/`
   - This task description:

   > Apply the workflow-evaluator skill in **Architecture only** mode against the research workflow.
   > Additionally, perform a **skill reference integrity check**: for every skill name mentioned in the workflow, verify it exists in the provided skill directory list. Flag any skill name that does not have an exact match.
   >
   > Produce the evaluation report in the format specified by the workflow-evaluator skill.
   > Classify each finding as CRITICAL, MODERATE, or MINOR per the skill's severity definitions.
   >
   > At the end, add a section:
   > ## Skill Reference Integrity
   > | Referenced Skill | Exists | Location |
   > |-----------------|--------|----------|
   > | {skill-name} | Yes/No | {path or "NOT FOUND"} |
   >
   > If the workflow file or skill repo cannot be found, report the issue and stop.

8. Display the subagent's findings report to the operator.
9. If any CRITICAL findings: highlight them at the top with a summary.
