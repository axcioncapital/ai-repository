---
model: opus
---

Run a deep review of the work you just produced: QC + refinement in parallel, then triage the combined findings.

## Why this command?

This orchestrates three independent review subagents in one invocation. QC checks correctness, refinement checks writing quality, and triage prioritizes the combined findings — so the operator gets a single, actionable report instead of running three separate commands.

## Steps

1. **Identify the artifact.** State in one line what you are reviewing (a plan, a drafted file, an edit, a set of changes).

2. **Gather inputs.** You need four items:
   - **Artifact description** — one-line summary of what was produced
   - **Artifact location** — file path(s) or the content if not yet written to file
   - **Original request** — what the operator asked for (quote or paraphrase)
   - **Intended audience** — who will consume this artifact (e.g., "another Claude instance", "a human operator", "a technical team")

3. **Launch QC and refinement in parallel.** Spawn both subagents in a single message:

   - **`qc-reviewer`** — pass it: artifact description, artifact location, original request. Do NOT pass conversation history, your reasoning, or creation context.
   - **`refinement-reviewer`** — pass it: artifact description, artifact location, intended audience. Do NOT pass conversation history, your reasoning, or creation context.

4. **Check for clean result.** If QC verdict is **GO** and refinement verdict is **CLEAN**, present both reviews and stop — there is nothing to triage.

5. **Build the suggestion list.** Extract every actionable finding from both reviews into a single numbered list. For each item, note its source (QC or Refinement). Do not filter, reword, or reinterpret — use the reviewers' original findings.

6. **Launch triage.** Spawn the **`triage-reviewer`** subagent. Pass it:
   - The numbered suggestion list from step 5
   - One-line context: "QC + refinement findings for {artifact description}"
   
   Do NOT pass conversation history or the original reviews in full.

7. **Present the unified report.** Show all three sections to the operator:

   ```
   ## Deep Review: {artifact description}

   ### QC Review
   {qc-reviewer output, exactly as returned}

   ### Refinement Review
   {refinement-reviewer output, exactly as returned}

   ### Triage
   {triage-reviewer output, exactly as returned}
   ```

   Do not filter, soften, or add commentary between sections.

8. **Wait for direction.** The operator decides what to implement.
