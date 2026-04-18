# Required Sections Checklist

Every well-formed resource should include these sections. Mark N/A with brief justification when a section genuinely does not apply.

| Section | Purpose | Applies To |
|---------|---------|------------|
| **Known Pitfalls** | Failure modes specific to the domain or Claude's behavior | All resources |
| **Validation Loop** | How to verify the resource produces correct output | Skills with complex outputs |
| **Runtime Recommendations** | Model, effort, context, companion hooks guidance | Skills |
| **Examples** | Input/output pairs showing desired behavior | Output-dependent resources |
| **Failure Behavior** | What to do when blocked, uncertain, or missing input | All resources |
| **Bias Countering** | Instructions to counter default model tendencies | Analytical/generative resources |

These sections are the implementation mechanism for several evaluation layers (Failure Behavior, Output Contract, Reasoning Constraints). Designing with them in mind produces resources that score well on evaluation.
