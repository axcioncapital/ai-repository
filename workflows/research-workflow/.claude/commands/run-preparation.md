---
friction-log: true
---
Execute the Stage 1 preparation pipeline.

The task plan draft is already in context (loaded via @ reference). Use its file name to derive the section identifier and name all outputs consistently (e.g., if the input is `task-plan-draft-1.1.md`, outputs use `1.1` as the section identifier).

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 1: Create Task Plan [delegate]

1. Read `/ai-resources/skills/task-plan-creator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content and the task plan draft content. Task: execute the skill logic against the draft. Write output to `/preparation/task-plans/{section}-task-plan-v1.md`. Return: output file path, key scope decisions.
3. Write checkpoint to `/preparation/checkpoints/{section}-step-1-checkpoint.md` from the sub-agent's returned summary.
4. ▸ /compact — skill content and draft no longer needed; checkpoint carries forward.

---

### Step 1b: QC Task Plan [delegate-qc]

1. Read the task plan from the path in `/preparation/checkpoints/{section}-step-1-checkpoint.md`.
2. Launch a qc-gate sub-agent. Pass it: the task plan content and the original task plan draft content. Task: evaluate the task plan for structural completeness (all 8 sections present and substantive), internal consistency (scope-objective-deliverable alignment), downstream enablement (can research-plan-creator and answer-spec-generator operate from this?), and draft fidelity (no substantive content dropped). Return: verdict (APPROVED / REVISE) with findings.
3. If REVISE: note findings for operator.
4. PAUSE — Present the Task Plan and QC verdict to the operator for review. Wait for approval or revision instructions.

---

### Step 2: Update Project Context

1. Update the Project Context section of CLAUDE.md with the approved Task Plan's objective, scope, constraints, and audience.

---

### Step 3: Create Research Plan [delegate]

1. Read `/ai-resources/skills/research-plan-creator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content and the approved Task Plan content. Task: execute the skill logic against the Task Plan. Write to `/preparation/research-plans/{section}-research-plan-v1.md`. Return: output file path, research question inventory (question IDs and summaries).
3. Write checkpoint to `/preparation/checkpoints/{section}-step-3-checkpoint.md` from the sub-agent's returned summary. Include: output file path, question count, question-to-cluster mapping.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.
5. GATE — Present the Research Plan to the operator for review. Summarize the research questions produced and ask the operator to confirm they are correct. Do NOT proceed to step 4 until the operator explicitly approves the research questions. If the operator requests changes, revise the Research Plan and re-present for approval.

---

### Step 4: Generate Answer Specs [delegate]

1. Read `/ai-resources/skills/answer-spec-generator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content and the approved Research Plan content. Task: execute the skill logic per chapter cluster. Write to `/preparation/answer-specs/{section}/chapter-NN-specs.md`. Return: list of spec files produced (file paths, question coverage per file).
3. Write checkpoint to `/preparation/checkpoints/{section}-step-4-checkpoint.md` from the sub-agent's returned summary. Include: spec file inventory (file path → questions covered).
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5: QC Answer Specs [delegate-qc]

1. Read the checkpoint from `/preparation/checkpoints/{section}-step-4-checkpoint.md` for the spec file inventory.
2. Read the `answer-spec-qc` skill (`/ai-resources/skills/answer-spec-qc/SKILL.md`). Extract its evaluation criteria.
3. For each answer spec file, delegate to a qc-gate sub-agent, passing: the skill's evaluation criteria and the answer spec content. Write verdicts to `/preparation/answer-specs/{section}/answer-specs-qc.md`.
4. Write checkpoint to `/preparation/checkpoints/{section}-step-5-checkpoint.md`. Include: per-spec verdict (PASS / FAIL), any failure details.
5. ▸ /compact — QC skill and spec content no longer needed; checkpoint carries forward.
6. If any spec receives FAIL: present the failures and ask the operator whether to regenerate or manually revise.
7. PAUSE — Present approved answer specs for final review before Stage 2.

---

### Step 6: Log Completion

1. Log completion to `/logs/qc-log.md`.
