# Extract Failed Components for Supplementary Research

> **Sub-workflow step:** S.0 — Extract Failed Components
> **Execution environment:** Claude (project)
> **Required inputs:** Evidence-Spec Verification Report
> **Output:** Structured list of all components that did not meet their completion gate, grouped by Question ID

---

Review the Evidence-Spec Verification Report below and extract every component that did NOT meet its completion gate. For each failed component, output:

Question ID + Component ID (e.g., Q3-A02)
Component description (from the Answer Spec)
Gate requirement (what was needed)
Current status (what the evidence actually delivered — cite Coverage Tracker numbers)
Gap type — classify as one of:

Missing coverage — no evidence found for this component
Insufficient independence — evidence exists but doesn't meet independence threshold
Grade deficit — sources exist but graded too low to satisfy gate
Partial coverage — some claims addressed, others missing


Specificity note — what exactly is missing (e.g., "need post-2023 regulatory data from a second independent source," not just "need more sources")

Output format: Structured list grouped by Question ID. Include CONDITIONAL PASS components only if the condition is unresolved.
Do not: Suggest search queries, draft briefs, or propose resolution strategies — extraction only.
