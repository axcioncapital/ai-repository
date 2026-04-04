---
friction-log: true
---
Execute the Stage 2 research pipeline for the current section.

Research execution happens in the Research Execution GPT (primary) and Perplexity (secondary), both operated manually by the operator. This command handles manifest creation (Step 2.0), prompt creation (Step 2.1), extract creation (Step 2.3), and extract verification (Step 2.4). Step 2.2 is manual.

Prerequisite check: Answer spec QC must run in a fresh sub-agent window for QC independence.

1. Read all Answer Specs from `/preparation/answer-specs/{section}/`.
2. Read the `answer-spec-qc` skill (`/ai-resources/skills/answer-spec-qc/SKILL.md`).
3. Launch a qc-gate sub-agent. Pass it: the skill content and all Answer Spec content. Task: apply the QC checks and return per-spec verdicts.
4. Write verdict to `/preparation/answer-specs/{section}/answer-specs-qc.md`.
5. Verify that ALL answer specs show APPROVED. If ANY spec shows REVISE or ESCALATE, abort and report which specs failed.

Skill loading: For each skill step below, read the skill file from the ai-resources repo at `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 2.0: Create Execution Manifest [delegate]

1. Read the Research Plan from `/preparation/research-plans/`.
2. Read all approved Answer Specs from `/preparation/answer-specs/{section}/`.
3. Read the `execution-manifest-creator` skill (`/ai-resources/skills/execution-manifest-creator/SKILL.md`).
4. Launch a general-purpose sub-agent. Pass it: the skill content, the Research Plan content, and all Answer Spec content. Task: execute the skill logic to route each question to an execution tool (Research Execution GPT or Perplexity), design session groupings, and plan execution waves. Write output to `/execution/manifest/{section}/{section}-execution-manifest.md`.
   Return: routing table (question ID → tool → rationale), session groupings, execution wave plan.
5. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.0-checkpoint.md`. Include: routing decisions, session count, wave plan.
6. ▸ /compact — skill content no longer needed; checkpoint carries forward.
7. PAUSE — Present the routing table and budget summary to the operator for approval. He may override individual routing decisions before proceeding.

---

### Step 2.1: Create Execution Prompts [delegate]

1. Read the approved Execution Manifest from `/execution/manifest/{section}/{section}-execution-manifest.md`.
2. Read the Research Plan from `/preparation/research-plans/`.
3. Read all approved Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `research-prompt-creator` skill (`/ai-resources/skills/research-prompt-creator/SKILL.md`).
5. Launch a general-purpose sub-agent. Pass it: the skill content, the Research Plan content, the Answer Spec content, and the Execution Manifest content. Task: execute the skill logic to create session prompts for all routed questions, following the manifest's session groupings. Research Execution GPT sessions: target 2 questions per session (1 or 3 acceptable with justification), no hard session cap. Each prompt must include an inline context pack (compact summary of the Research Plan — project background, section objective, scope boundaries — NOT individual question listings). Write output to `/execution/research-prompts/{section}/` as individual files:
   - `session-plan.md` — How to Use, Session Plan table (including tool assignment per session), Dependency Map, Recommended Execution Order, Post-Execution Notes.
   - One `session-{letter}.md` per session — each self-contained with: session title, questions covered, **execution tool** (Research Execution GPT or Perplexity), Settings (site restrictions, recency), Execution Prompt (code-fenced), and Steering Notes.
   Return: the session plan table (session letters, question assignments, tool assignment, rationale).
6. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.1-checkpoint.md` from the sub-agent's returned summary. Include: session count by tool, question-to-session mapping, output folder path.
7. ▸ /compact — skill content and raw inputs no longer needed; checkpoint carries forward.

### Step 2.1b: QC Execution Prompts [delegate-qc]

1. Read all prompt files from `/execution/research-prompts/{section}/` (session-plan.md and all session-{letter}.md files).
2. Read all approved Answer Specs from `/preparation/answer-specs/{section}/`.
3. Read the Research Plan from `/preparation/research-plans/`.
4. Read the `research-prompt-qc` skill (`/ai-resources/skills/research-prompt-qc/SKILL.md`).
5. Launch a qc-gate sub-agent. Pass it: the skill content, the prompts content, the Answer Specs content, and the Research Plan content. Task: run the five check dimensions and return per-session verdicts and a batch verdict.
6. Write verdict to `/execution/checkpoints/{section}/{section}-step-2.1b-prompt-qc.md`.
7. If APPROVED: proceed to PAUSE below.
8. If REVISE with only Moderate findings: apply fixes to the prompt files, re-run QC (one retry). If second pass APPROVED, proceed. If still FLAG, pause for operator.
9. If REVISE with any Critical findings: pause for operator review before proceeding.
10. ▸ /compact — QC context no longer needed.
11. PAUSE — Present the session plan table to the operator, organized by execution tool. **Explicitly flag any inter-session dependencies** (e.g., "Session D depends on Session A — do not run D until A completes"). List each dependency clearly so execution order is unambiguous. Note which sessions run in Research Execution GPT vs Perplexity. He will execute sessions manually (Step 2.2) and return with raw reports.

---

### Step 2.2b: Intake Raw Reports [Claude Code]

**Trigger:** The operator returns with raw research output (from Research Execution GPT or Perplexity), pasted directly into the chat. This may happen multiple times (once per wave or per session).

1. Read the session plan from `/execution/research-prompts/{section}/session-plan.md` to recover the session letters, question assignments, and dependency map.
2. For each pasted report, identify which session it belongs to by matching its content against the session plan's question assignments (look for the research questions addressed, topic alignment, and any session identifiers in the output).
3. Present the proposed mapping to the operator for confirmation: list each report with its assigned session letter and the questions it covers.
4. After confirmation, write each report to `/execution/raw-reports/{section}/{section}-session-[letter]-raw-report.md`.
5. Report back: which files were written, which sessions are now complete, and — per the dependency map — which downstream sessions are now unblocked.

---

### Step 2.2a: Inject Dependency Outputs into Downstream Prompts [optional]

**Trigger:** The operator returns with raw report(s) from session(s) that have downstream dependents (per the session plan's dependency map). **Skip this step if no dependencies exist** for the completed sessions, or if the operator chooses to run downstream sessions without injection.

1. Read the session plan from `/execution/research-prompts/{section}/session-plan.md` to identify which completed sessions have dependents.
2. For each completed session that has dependents:
   a. Read the raw report.
   b. Extract the key structural output — the artifact that downstream sessions need as input (e.g., the chain structure from Q1, the framework from a foundational question). Focus on: the core model/framework/taxonomy produced, its key structural features, and any terminology or numbering that downstream sessions should anchor to.
   c. Draft a `PRIOR RESEARCH OUTPUT` block formatted as a dependency injection prompt. Structure:
      - Header identifying the source session and question
      - The extracted artifact (structured, numbered where applicable)
      - Key structural features that downstream sessions must respect
      - Instruction to map findings to this structure rather than inventing alternatives
   d. Present the drafted block to the operator for review before injection.
3. After operator approval, for each dependent session prompt file:
   a. Read the session prompt from `/execution/research-prompts/{section}/session-{letter}.md`.
   b. Insert the approved `PRIOR RESEARCH OUTPUT` block into the Execution Prompt, immediately after the opening of the code-fenced prompt (before the session's own instructions).
   c. Write the updated prompt file.
4. Confirm to the operator which session files were updated. The operator then runs the next wave.

**Note:** This step may run multiple times if execution happens in waves. Each time the operator returns with reports from sessions that have dependents, repeat this process.

---

### Step 2.3: Create Research Extracts [delegate]

1. Read all raw reports from `/execution/raw-reports/`.
2. Read the checkpoint from `/execution/checkpoints/{section}/{section}-step-2.1-checkpoint.md` to recover the question-to-session mapping.
3. Read the corresponding Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `research-extract-creator` skill (`/ai-resources/skills/research-extract-creator/SKILL.md`).
5. For each session report, launch a general-purpose sub-agent. Pass it: the skill content, the raw report content, the Answer Specs for the questions in that session, and the question-to-session mapping. Task: produce one Research Extract per question covered. Write each to `/execution/research-extracts/{section}/{section}-Q[N]-extract.md`. Return: list of extracts produced (question ID, file path, brief quality note).
   - If multiple session reports are independent, launch sub-agents in parallel.
6. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.3-checkpoint.md`. Include: full extract inventory (question ID → file path → session letter), any quality flags from sub-agents.
7. ▸ /compact — skill content and raw report content no longer needed; checkpoint and extract files carry forward.

---

### Step 2.4: Review Research Extracts [delegate-qc]

After all extracts are produced:

1. Read the checkpoint from `/execution/checkpoints/{section}/{section}-step-2.3-checkpoint.md` for the extract inventory.
2. Read the `research-extract-verifier` skill (`/ai-resources/skills/research-extract-verifier/SKILL.md`). Extract its verification checks and verdict logic.
3. For each session's extracts, delegate to qc-gate agent, passing as content: (a) the raw research report, (b) the Research Extracts produced from it, and (c) the corresponding Answer Specs. The qc-gate agent applies the skill's five verification checks.
   - Launch qc-gate agents in parallel for independent sessions.
4. Write verification report to `/execution/extract-verification/{section}/{section}-extract-verification-[session-letter].md`.
5. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.4-checkpoint.md`. Include: per-extract verdict (APPROVED / FLAG), flagged extract details and re-extraction instructions.
6. ▸ /compact — verification context no longer needed.
7. If all APPROVED: Stage 2 complete for this section.
8. If FLAG — RE-EXTRACT on any extract: present the re-extraction instructions to the operator. Route flagged extracts back to Step 2.3 for re-extraction using the specific instructions from the verification report. Do NOT re-extract automatically — only when the operator requests it.

---

### Subworkflow 2.S — Supplementary Research (Optional)

**Trigger:** After all extracts are APPROVED (Step 2.4 gate passed), operator reviews coverage verdicts across extracts and judges that THIN or MISSING components warrant supplementary research before entering Stage 3. Skip this subworkflow if coverage is acceptable.

Skill loading: For each skill step below, read the skill file from the ai-resources repo at `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

**Step 2.S0 — Extract Failed Components [Claude Code]**
Parse all approved Research Extracts from `/execution/research-extracts/{section}/` and extract every component with THIN or MISSING coverage verdict. Output structured list grouped by Question ID to `/execution/supplementary/{section}/{section}-failed-components.md`. Extraction only — no query drafting.

**Step 2.S1 — Draft Supplementary Query Brief [delegate]**
1. Read the failed components extraction from Step 2.S0.
2. Read all Research Extracts from `/execution/research-extracts/{section}/`.
3. Read all Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `supplementary-query-brief-drafter` skill.
5. Launch a general-purpose sub-agent. Pass it: the skill content, failed components, Research Extracts, and Answer Specs. Task: execute the skill logic (pass 1 or pass 2 as appropriate). Write output to `/execution/supplementary/{section}/{section}-query-brief-pass-[1/2].md`.
   Return: number of groups, number of queries, any components routed out.
6. GATE: Operator reviews query brief before execution.

**Step 2.S2 — Execute Queries in Perplexity [Operator]**
Present the query brief's Section B (Execution Sheet) to the operator. He runs queries manually in Perplexity Pro Search. Prefix each query with: `I'm researching Nordic mid-market private equity for a professional advisory report.` The operator pastes raw Perplexity output back into Claude Code. Write raw output to `/execution/supplementary/{section}/{section}-perplexity-raw-pass-[1/2].md`.

**Step 2.S3 — QC Perplexity Results [delegate-qc]**
1. Read the raw Perplexity output from Step 2.S2.
2. Read all Research Extracts from `/execution/research-extracts/{section}/`.
3. Read the Query Brief Section A from Step 2.S1.
4. Read the `supplementary-research-qc` skill.
5. Launch a qc-gate sub-agent. Pass it: the skill content, raw Perplexity output, Research Extracts, and Query Brief Section A. Task: run the three checks per query and return per-query verdicts.
6. Write QC report to `/execution/supplementary/{section}/{section}-supplementary-qc-pass-[1/2].md`.
7. GATE: Operator confirms merge summary before proceeding.

**Step 2.S4 — Merge Supplementary Evidence [delegate]**
1. Read all Research Extracts from `/execution/research-extracts/{section}/`.
2. Read the QC-approved supplementary results (MERGE/PARTIAL items from Step 2.S3).
3. Read all Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `supplementary-evidence-merger` skill.
5. Launch a general-purpose sub-agent. Pass it: the skill content, Research Extracts, QC-approved results, and Answer Specs. Task: execute the skill logic. Write updated extracts to `/execution/research-extracts/`, replacing originals.
   Return: per question, which components changed verdict, claim count before/after, remaining THIN/MISSING.
6. ▸ /compact — supplementary pass context no longer needed.

**Step 2.S5 — Re-verify and Close**
Re-run Step 2.4 verification on affected extracts only. If still insufficient after pass 1: repeat Steps 2.S0–2.S5 as pass 2.

**Two-pass maximum (hard constraint):** Before initiating a supplementary pass, check `/execution/supplementary/` for existing pass files for this section. If pass 2 files exist, do NOT initiate another pass.

**Scarcity handling:** After 2 passes, any remaining gaps are classified as confirmed evidence scarcity. For each:
- Append an entry to `/execution/scarcity-register/{section}/{section}-scarcity-register.md` with: Question ID, missing component, research attempted (both passes summarized), and editorial instruction (HEDGE / SCOPE CAVEAT / PROXY FRAMING — operator selects).
- PAUSE for operator to select the editorial instruction for each scarcity item.

**Outputs:**
- `/execution/supplementary/{section}/{section}-*.md` (per-step supplementary artifacts)
- Updated Research Extracts in `/execution/research-extracts/{section}/`
- Updated `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if scarcity confirmed)

---
