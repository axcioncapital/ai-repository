# Operator Principles

How to think about working with Claude — not what to do when, but how to get better at the collaboration over time. Re-read during the weekly improvement flush if it's been more than 2 weeks.

---

## Give feedback on the system, not just the output

When a draft needs 3 iterations, the instinct is to give feedback on the draft. The system question is: why did it take 3 iterations?

When you catch yourself giving the same type of feedback for the third time, that's not a draft problem — it's a drafter-instructions problem. Pause the content work. Fix the instruction. Then resume.

**Example:** You keep correcting evidence calibration in the same direction — downgrading claims from "Moderate" to "Low-Moderate" because the source is a single practitioner estimate, not industry consensus. The fix isn't better feedback on draft 4. The fix is adding a calibration rule to the drafter skill: "Single-source practitioner estimates cap at Low-Moderate unless corroborated."

The 10 minutes you spend updating the drafter now saves 30 minutes of feedback on every future section.

## Write prompts that transfer your mental model, not your instructions

Your best feedback moments share *why*, not just *what*.

| Directive (weak) | Mental model transfer (strong) |
|---|---|
| "Cut 30-40% repetition." | "The reader is a CEO scanning this in 10 minutes. If a point appeared in the executive summary, don't restate it — reference it. Repetition signals that you don't trust the reader to retain information." |
| "Make this section shorter." | "This section competes for attention with 2.4 and 2.6. If it's longer than either, the reader infers it's more important — and it isn't. Match the weight to the significance." |
| "Frame AI as an economic enabler." | "AI is what makes coverage choices economically viable at EUR 5-25M. Without AI-driven assessment, the unit economics don't work at that tier. Frame it as an economic enabler, not a capability list — the reader needs to see the business logic, not the feature set." |

Claude can apply a mental model to future sections without being told. It can't generalize from a directive.

## Develop your "when to intervene" intuition

Right now you intervene at every gate — read every draft, disposition every finding, approve every plan. But your value varies across these touchpoints.

- Your evidence calibration judgment ("downgrade this from Moderate to Low-Moderate") — irreplaceable.
- Your plan approval for a straightforward section ("yes, that structure looks right") — a rubber stamp.

**The practice:** After each intervention, ask: "Did my input change the outcome, or confirm what Claude would have done anyway?" After a week, the pattern emerges. Automate the confirmations. Keep the judgment calls.

**Example:** If you've approved 5 consecutive section plans without changing anything, that's a signal to set your autonomy level higher for plan approval: "Auto-approve plans unless the section touches pricing, exclusions, or competitive positioning."

## Classify failures, don't just correct outputs

When a draft misses the mark, describing *what type of failure* it is matters more than describing what's wrong.

| Failure type | What happened | The fix |
|---|---|---|
| **Context failure** | Claude didn't have information it needed | Add to drafter inputs |
| **Judgment failure** | Claude had the info but weighted it wrong | Add a constraint or design principle |
| **Instruction failure** | Claude followed instructions that produce wrong output | Rewrite the instructions |
| **Model limitation** | Claude can't do this regardless of instructions | Change the approach |

**Example:** A draft presents three competitor approaches as equally viable when one clearly dominates. Is that a context failure (Claude didn't know which dominates), a judgment failure (it had the data but played it safe), or an instruction failure (the skill says "present options neutrally")? Each diagnosis leads to a different fix. Correcting the output without classifying the failure means you'll correct it again next section.

## Use Claude as a thinking partner, not just an executor

The default session pattern: you decide → you tell Claude → Claude executes → you review. The missing mode: you're unsure → you think out loud with Claude → you reach a decision together.

**Example:** Before drafting a section on service boundaries, instead of jumping to "/draft-section 2.5," say: "I'm not sure where the boundary between 2.5 and 2.8 should be. 2.8 defines what the service *does*, 2.5 defines what it *doesn't do*. But some exclusions are implicit in 2.8's scope. Think with me about where to draw the line."

That conversation might be worth more than 3 draft iterations because it resolves ambiguity *before* drafting instead of discovering it *during* review.

**When to use this mode:**
- You're unsure where a boundary should be drawn
- Two sections or concepts overlap and you haven't decided how to separate them
- You have a strong intuition but can't articulate the reasoning yet
- You're about to make a structural decision that's expensive to reverse

## Read your own logs for pattern recognition

Session notes, decision logs, improvement logs — their highest value might be for your own pattern recognition, not for Claude's context.

When you read 5 session entries during a weekly scan, you notice things like:
- "I keep correcting evidence calibration in the same direction" → drafter-instructions problem
- "Every section takes 3 iterations — maybe 2 is achievable if I fix the inputs" → system problem
- "I spent 40 minutes on gate approvals that didn't change anything" → autonomy problem

**The practice:** 15 minutes per week reading your own logs. Not to action items — to notice patterns in how *you* work. The best operators improve themselves, not just their tools.

## Constraints over procedures

The instinct is to write detailed procedures — "read this file, launch this agent, pass these inputs." It works but it's brittle. If you add a skill or change a file path, you update the command.

The alternative: define constraints and let Claude figure out the procedure.

| Procedural (brittle) | Constraint-based (resilient) |
|---|---|
| "Read the drafter skill, read the WH, read the section plan, launch a subagent with these 4 inputs, validate against the 8-layer framework" | "Produce prose that passes these 4 quality criteria, using the decision-to-prose-writer skill for conversion and the chapter-prose-reviewer for validation" |
| "Run QC, then fix all Major findings, then run QC again" | "Iterate until QC returns no Major or Critical findings. Auto-fix Minor issues." |

Claude is good at figuring out *how*. Focus on specifying *what good looks like*. Your bright-line rule is the best example of this in your system — it defines a boundary, not a procedure.

**When procedures still earn their place:** When the sequence matters for correctness (pipeline stages that must run in order), when you need reproducibility across sessions, or when the procedure encodes hard-won lessons about what goes wrong if steps are skipped.
