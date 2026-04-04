---
friction-log: true
---
Analyze one cluster of Stage 3.

Input: $ARGUMENTS should specify the cluster number (e.g., "01" or "1").

Prerequisite check: Read the QC log. Verify that research extracts for this cluster's questions exist in `/execution/research-extracts/{section}/` and have APPROVED verdicts. If any are missing or flagged, abort and report.

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 1: Load Cluster Inputs

1. Read the research extracts for this cluster from `/execution/research-extracts/{section}/`.
2. Read the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists). Flag any scarcity items relevant to this cluster.

---

### Step 2: Cluster Analysis [delegate]

1. Read `/ai-resources/skills/cluster-analysis-pass/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, the cluster's research extracts, and any relevant scarcity register entries. Task: execute the skill logic against the extracts. Write memo to `/analysis/cluster-memos/cluster-$ARGUMENTS-memo.md`. Return: output file path, key analytical themes, evidence gaps noted.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-cluster-$ARGUMENTS-step-2-checkpoint.md` from the sub-agent's returned summary.
4. ▸ /compact — skill content and extract content no longer needed; checkpoint carries forward.

---

### Step 3: Memo Refinement [delegate]

1. Read the cluster memo from `/analysis/cluster-memos/cluster-$ARGUMENTS-memo.md`.
2. Read `/ai-resources/skills/cluster-memo-refiner/SKILL.md`.
3. Launch a general-purpose sub-agent. Pass it: the skill content and the cluster memo content. Task: execute the six-check refinement pass. Write refined memo to `/analysis/cluster-memos/cluster-$ARGUMENTS-memo-refined.md`. Return: output file path, per-check outcomes, changes made.
4. Write checkpoint to `/analysis/checkpoints/{section}/{section}-cluster-$ARGUMENTS-step-3-checkpoint.md` from the sub-agent's returned summary.
5. ▸ /compact — skill content and unrefined memo no longer needed; checkpoint carries forward.
6. PAUSE — Present refined memo to the operator for review.

---

### Step 4: Log Completion

1. Log to `/logs/qc-log.md`.

After this cluster completes, run /compact before starting the next cluster to keep context window clean.
