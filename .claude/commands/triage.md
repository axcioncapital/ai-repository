You just proposed changes or suggestions. Before the operator approves anything, run an independent triage.

## Why a subagent?

You generated these suggestions — you're biased toward your own recommendations. The triage reviewer runs as a separate agent that evaluates consequence and risk without that bias.

## Steps

1. **Collect the suggestions.** Gather all changes or recommendations you just proposed into a numbered list.

2. **Prepare the handoff.** Gather:
   - The numbered list of suggestions
   - One-line context about what work they relate to

3. **Launch the `triage-reviewer` subagent.** Pass it the two items above. Do NOT pass conversation history, your reasoning, or why you think each suggestion matters.

4. **Present the results.** Show the subagent's Do/Park table to the operator exactly as returned. Do not filter, reorder, or add commentary.

5. **Wait for direction.** The operator decides what to implement.
