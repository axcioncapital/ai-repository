---
friction-log: true
---
Execute the Stage 3 cluster synthesis pipeline (chapter drafting).

Prerequisite check: Verify that `/run-analysis` has completed — refined cluster memos and section directives exist, and the QC log shows operator approval of memos and directives.

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 1: Load Inputs

1. Read all refined cluster memos from `/analysis/cluster-memos/{section}/`.
2. Read all section directives from `/analysis/section-directives/{section}/`.
3. Read the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists).

---

### Step 2: Cluster Synthesis [delegate]

1. Read `/ai-resources/skills/cluster-synthesis-drafter/SKILL.md`.
2. For each cluster, launch a general-purpose sub-agent. Pass it: the skill content, the cluster's refined memo, the cluster's section directive, and any relevant scarcity register entries. Task: execute the skill logic. Write to `/analysis/chapters/{section}/{section}-cluster-NN-draft.md`. Return: output file path, chapter structure summary, evidence coverage notes.
   - Launch sub-agents in parallel for independent clusters. Run ▸ /compact between clusters if there are more than 3 clusters and running sequentially.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-3.7-synthesis-checkpoint.md`. Include: chapter draft file inventory (cluster → file path), completion status.
4. ▸ /compact — skill content and directive content no longer needed.

---

### Step 3: Log Completion

1. Log to `/logs/qc-log.md`.
