Stop and run an independent QC pass on the work you just produced or proposed.

## Why a subagent?

You produced the work — you cannot objectively evaluate it. The QC reviewer runs as a separate agent with no access to your conversation, ensuring independent assessment per the QC Independence Rule.

## Steps

1. **Identify the artifact.** State in one line what you are QC'ing (a plan, a drafted file, an edit, a set of changes).

2. **Prepare the handoff.** Gather:
   - One-line description of the artifact
   - The file path(s) of the artifact, or the content if it hasn't been written to file yet
   - The original operator request (what was asked for — quote or paraphrase)

3. **Launch the `qc-reviewer` subagent.** Pass it the three items above. Do NOT pass conversation history, your reasoning, or creation context.

4. **Present the results.** Show the subagent's review to the operator exactly as returned. Do not filter or soften findings.

5. **Wait for direction.** The operator decides whether to act on findings.
