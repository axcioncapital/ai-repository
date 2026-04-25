---
model: sonnet
---

Run an independent refinement pass on the work you just produced.

## Why a subagent?

You produced the work — you're anchored to your own phrasing and structure. The refinement reviewer runs as a separate agent with fresh eyes, no knowledge of your drafting process.

## Steps

1. **Identify the artifact.** State in one line what you are refining.

2. **Prepare the handoff.** Gather:
   - One-line description of the artifact
   - The file path(s) of the artifact, or the content if it hasn't been written to file yet
   - The intended audience (e.g., "another Claude instance", "a human operator", "a technical team")

3. **Launch the `refinement-reviewer` subagent.** Pass it the three items above. Do NOT pass conversation history, your reasoning, or creation context.

4. **Present the results.** Show the subagent's review to the operator exactly as returned. Do not filter or soften findings.

5. **Wait for direction.** The operator decides which refinements to apply.
