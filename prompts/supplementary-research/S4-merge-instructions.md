# S.4 — Merge Supplementary Evidence into Research Extracts

> **Sub-workflow step:** S.4 — Merge Supplementary Evidence
> **Execution environment:** Claude (project)
> **Required inputs:** Research Extracts (current versions); QC-approved supplementary results (MERGE items from S.3 verdicts); Answer Specs for affected questions
> **Output:** Updated Research Extracts — one per affected question, complete and self-contained, replacing the previous version

---

You are integrating QC-approved supplementary research results into existing Research Extracts. The goal is to produce updated Research Extracts where original and supplementary evidence are combined into a single coherent artifact, with supplementary sources clearly tagged.

**Inputs required:**

1. Research Extracts for all affected questions (current versions)
2. QC-approved supplementary results (the MERGE items from the S.2-QC verdicts, with the specific claims identified for merging)
3. Answer Specs for the affected questions (needed for coverage verdict recalculation)

**Step 1: Add supplementary claims**

For each MERGE item from the QC results:

- Create new claims under the appropriate Answer Spec component in the Research Extract.
- Assign Claim IDs that continue the existing sequence for that question (e.g., if the last existing claim is Q3-C08, new supplementary claims start at Q3-C09).
- For each new claim:
  - Write the claim statement in your own words (do not copy verbatim from Perplexity output)
  - **Sources:** carry over source name(s) and URL(s) from the Perplexity results
  - **Source locator:** "Supplementary research, Pass [1/2], Query [#]"
  - **Strength:** assign H/M/L per the standard rubric
  - **Independence:** count independent sources, including assessment of independence from sources already in the extract
  - **Notes:** include `[SUPPLEMENTARY]` tag. Add linkage type and caveats as normal.

For PARTIAL items from QC: merge only the specific claims approved. Skip the claims marked for exclusion.

**Step 2: Recalculate coverage verdicts**

For each component that received new claims, recalculate the coverage verdict using the threshold rubric applied to the full claim set (original + supplementary):

- **COVERED:** ≥2 claims with ≥1 at High strength, OR ≥3 claims at Medium strength with ≥2 independent sources
- **THIN:** 1 claim at any strength, OR 2+ claims but all Low, OR only sources with shared editorial origin
- **MISSING:** No claims for this component

Update the Coverage Verdicts table. In the Notes column, indicate what changed: e.g., "THIN → COVERED after supplementary pass 1 (added 2 Medium-strength claims from independent Nordic sources)."

**Step 3: Update component syntheses**

For each component that received new claims, rewrite the Component Synthesis paragraph to reflect the combined evidence. The updated synthesis must:

- Integrate supplementary findings naturally — do not write a separate "supplementary findings" paragraph
- Accurately reflect the updated strength distribution across all claims (original + supplementary)
- Not overstate what the supplementary evidence adds — if it moved a component from THIN to COVERED on the strength of two Medium sources, the synthesis should reflect moderate confidence, not strong confidence

**Step 4: Update Gaps and Conflicts**

- **Gaps:** remove or downgrade any gaps that were closed by supplementary evidence. If a gap moved from MISSING to THIN, update the gap entry to reflect remaining weakness rather than total absence.
- **Conflicts:** if supplementary evidence introduces a new source that conflicts with existing claims, add it to the Conflicts section with the standard format (both positions, relative support, recommended handling).

**Step 5: Update Extraction Metadata**

Set `Supplementary research: Yes` and list which components were supplemented and in which pass.

**Output:**

Updated Research Extracts — one per affected question. The updated extract is a complete, self-contained artifact that replaces the previous version. It should be indistinguishable in structure from an extract that was produced in a single pass — the only markers of supplementary evidence are the `[SUPPLEMENTARY]` tags on individual claims and the metadata field.

Deliver as a markdown file containing all updated extracts.

[paste Research Extracts]

[paste QC-approved supplementary results]

[paste Answer Specs]
