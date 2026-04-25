---
model: sonnet
---

The operator is telling you to proceed using your own judgment rather than waiting for their answers. Apply this procedure:

1. **Answer your own questions.** For each clarifying question you asked (or each open decision you surfaced in your previous turn), state the answer the operator would most likely give — reasoned from the stated goal, conversation context, prior session decisions, project CLAUDE.md, and operator preferences in memory. Be specific; do not hedge.

2. **Confirm or revise assumptions.** Restate each assumption from your previous turn, marking it as kept or revised. If revised, state the replacement.

3. **State the final operating premise.** One short paragraph: "Based on the above, I will proceed as follows…" — name the work, the sequence, and anything you are explicitly skipping. This is the operator's last chance to interject before execution begins.

4. **Execute.** Run the work. As each material defaulted decision comes up during execution, announce it in chat so the operator can still course-correct mid-flight.

**Guardrails**

- All Autonomy Rules pause-triggers in workspace CLAUDE.md still apply. This command does not override any of them.
- If one specific open question is genuinely load-bearing — the answer would materially change the output and cannot reasonably be guessed from context — pause on that one question and proceed on everything else. Do not use this as a general-purpose excuse to keep asking.
- Scope: this command responds to Claude-initiated pauses (clarifying questions, assumption lists, mid-plan forks). It does not grant permission to skip the `[AMBIGUOUS]` guardrail when the operator's original instruction genuinely lacks load-bearing specifics.
