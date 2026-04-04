---
friction-log: true
---
Run fact verification on a chapter.

Input: $ARGUMENTS should specify the chapter file path or chapter number.

Confidentiality check: Before constructing the GPT-5 API call, verify the outbound message contains no deal-specific company names, financial terms, or confidential identifiers listed in CLAUDE.md Confidentiality Boundaries. If any are found, STOP and alert the operator.

Skill loading: Read skill files from `/ai-resources/skills/` as specified below.

---

### Step 1: Prepare Inputs

1. Read the chapter from the specified path (or `/report/chapters/chapter-$ARGUMENTS.md`).
2. Read the corresponding research extracts for this chapter's source material.

---

### Step 2: Execute Fact Verification

3. Construct GPT-5 API call: read fact verification prompt from `/reference/sops/`, use chapter prose + evidence table as input.
4. Delegate to execution-agent. Write verification report to `/report/chapters/{section}/{section}-chapter-NN-verification.md`.
5. Write checkpoint to `/report/checkpoints/{section}/{section}-chapter-NN-verification-checkpoint.md`. Include: output file path, discrepancy count, discrepancy summary, verdict.
6. ▸ /compact — verification prompt, raw chapter content, and evidence table no longer needed; checkpoint carries forward.

---

### Step 3: Apply Corrections (if discrepancies found)

7. If discrepancies found:
   a. Read `/ai-resources/skills/evidence-prose-fixer/SKILL.md`. Launch a general-purpose sub-agent **[delegate]**. Pass it: the skill content, the verification report, and the chapter prose. Task: generate corrections for each discrepancy. Return: correction list with per-item bright-line metadata.
   b. **Bright-line check on EVERY proposed correction:**
      - Does it span more than one paragraph? → Flag.
      - Does it alter an analytical claim or conclusion? → Flag.
      - Does it modify a sourced statement or claim-ID-attributed content? → Flag.
   c. PAUSE — Present all corrections to the operator. Separate into two groups: (1) corrections that passed bright-line checks (safe to apply), (2) corrections that triggered one or more bright-line flags (require explicit approval). For each flagged correction, state which trigger(s) fired.
   d. Apply only approved corrections.
   e. Log each correction decision (applied/rejected/deferred, which triggers fired) to `/logs/decisions.md`.
   f. Write checkpoint to `/report/checkpoints/{section}/{section}-chapter-NN-corrections-checkpoint.md`. Include: corrections applied (count + summary), corrections rejected, decision log path.
   g. ▸ /compact — correction context no longer needed; final chapter and logs carry forward.

---

### Step 4: Log Results

8. Log to `/logs/qc-log.md`.
