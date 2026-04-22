---
friction-log: true
---
Format prose for: $ARGUMENTS

Apply formatting, H3 placement/refinement, and document-level integration QC to one section's reviewed and decontaminated prose. Chains four skills across two delegated phases: prose formatting + H3 pass (prose-formatter + h3-title-pass, merged) and two-stage formatting + editorial integration QC (formatting-qc + document-integration-qc). Operates on prose that has already passed `/produce-prose-draft` (review + decontamination).

Per-section run: 2 subagent launches, target ~6–10 min wall time.

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. Parse $ARGUMENTS to identify the target section (e.g., "2.4", "2.8", "3.1")
2. Determine paths:
   - Set `prose_output_dir`: Part 2 → `output/part-2-prose/`, Part 3 → `output/part-3-prose/`
3. Locate the prose file at `{prose_output_dir}/{section}-*.md` (most recent if multiple match)
   - If no matching prose file exists: PAUSE — "No prose file found for {section}. Run `/produce-prose-draft {section}` first."
4. **Decontamination check:** Verify `{prose_output_dir}/decontamination-log.md` exists and contains an entry for this section.
   - **If yes:** Proceed.
   - **If no:** WARN — "Decontamination log shows no entry for {section}. The prose may not have passed Phase 5 of `/produce-prose-draft`. Options: proceed anyway (formatting will still run), or cancel and run `/produce-prose-draft {section}` first to ensure decontamination has been applied."

Present the plan: prose file path, decontamination status, output overwrites the prose file in place. Wait for operator approval before proceeding.

---

## Phase 2 — Formatting + H3 Full Pass [delegate, sonnet]

Merged formatting, H3 placement, and H3 refinement in a single sonnet agent. KEEP/RENAME/REMOVE verdicts auto-apply mid-pipeline; all REMOVE verdicts are reported in Phase 4 (handoff) with rationale and reversal instructions so the operator can catch structural deletions at the end.

1. Read the prose file located in Phase 1
2. Read `/ai-resources/skills/prose-formatter/SKILL.md`
3. Read `/ai-resources/skills/h3-title-pass/SKILL.md`
4. Resolve the absolute path to the style reference: `{prose_output_dir_abs}/style-reference.md` (do NOT read it into main-agent context — subagents read reference files directly per the research-workflow CLAUDE.md "Context Isolation Rules" exception for large read-only references)
5. Launch a general-purpose sub-agent with `model: "sonnet"`. Pass it:
   - The prose-formatter skill content
   - The h3-title-pass skill content
   - The prose file content
   - The absolute path to the style reference: `{prose_output_dir_abs}/style-reference.md` — the subagent reads it directly before applying the skills
   - Output path: same file (overwrite — override the prose-formatter skill's versioning default; intermediate files are not needed)
   - Task: Execute in this order as a single continuous pass:
     0. **Run the Mechanical Triggers pre-scan per the prose-formatter skill.** Scan the full document for the five mandatory triggers (5+ parallel items in prose; category comparison across repeated dimensions; subsection with multiple internal blocks; bold on labels but not on named frameworks; paragraph carrying framework + exceptions + implications). Record which triggers fire and at which locations. Produce the trigger-hit list — it feeds Steps 1–3 and is returned to the main agent. Trigger hits are MANDATORY decisions, not interpretive calls; when a trigger fires, the mapped operation applies and the "when uncertain, defer" fallback does NOT override it.
     1. Run all formatting operations per the prose-formatter skill (bold/italic, lists, tables, paragraph length, horizontal rules, spacing). Record a formatting change log. Operation 1 may detect additional pseudo-heading bold labels that belong on the trigger #3 hit list — add them, do NOT bold them.
     2. Run H3 title pass Step 1 (placement) per the h3-title-pass skill, consuming the trigger #3 hit list as candidate SPLIT verdicts. Record a verdict per heading: KEEP / RENAME / REMOVE / SPLIT with rationale.
     3. Run H3 title pass Step 2 (refinement) per the skill. Apply KEEP/RENAME/REMOVE verdicts. For RENAME, apply the refined wording. For REMOVE, delete the heading. **Do NOT auto-apply SPLIT verdicts** — they are operator-gated and surfaced at Phase 4 for approval.
     4. Write the final formatted file.
   - **Return values (required for Phase 4 reporting — do not omit):**
     - Mechanical Trigger pre-scan results: which triggers fired, document locations, brief description of each hit
     - Formatting change log (per-operation summary)
     - H3 decisions table: every heading processed, with verdict (KEPT / RENAMED / REMOVED / SPLIT), original text, final text (for RENAMED), rationale, and for REMOVED a one-line reversal instruction ("to restore, add `### {original text}` before paragraph starting '{first few words}'")
     - SPLIT verdicts (if any): for each, (a) subsection being split, (b) proposed insertion line reference, (c) proposed new H3 title, (d) block-boundary rationale naming the two resulting blocks. SPLIT verdicts are returned in the H3 decisions table AND as a separate summary list for Phase 4 surfacing.
     - Final H3 count
     - Any flagged items
6. ▸ /compact — skill content no longer needed.

---

## Phase 3 — Merged Formatting + Editorial Integration QC [delegate-qc]

Merged two-stage QC. One qc-reviewer subagent runs both checks in explicit sequence: formatting-qc first (including any mechanical fixes), then document-integration-qc on the post-fix prose. The merge preserves the editorial pass's dependency on the formatting pass — the editorial pass explicitly receives the formatting pass's output as "already addressed" context.

1. Read the prose file (post-Phase 2 — final formatted version with H3 applied)
2. Read `/ai-resources/skills/formatting-qc/SKILL.md`
3. Read `/ai-resources/skills/document-integration-qc/SKILL.md`
4. Read the architecture at `{prose_output_dir}/architecture.md` (if exists) — provides document structure context for completeness checks
5. Resolve the absolute path to the style reference: `{prose_output_dir_abs}/style-reference.md` (do NOT read it into main-agent context — the qc-reviewer subagent reads it directly)
6. Collect from Phase 2: the formatting change log and any deferred/flagged items
7. Gather any cross-section integration findings carried forward from `/produce-prose-draft` Phase 4 (if available in the session context)
8. Launch a qc-reviewer sub-agent. Pass it:
   - The formatting-qc skill content (labeled: "STAGE 1 SKILL — formatting mechanics")
   - The document-integration-qc skill content (labeled: "STAGE 2 SKILL — editorial quality")
   - The prose file content
   - The formatting change log from Phase 2
   - Any deferred items list from Phase 2 (items flagged during formatting that should not be re-flagged in Stage 1)
   - Cross-section integration findings from `/produce-prose-draft` Phase 4 (if available)
   - Module identifier: "{section ID} — {section title}" and position in the document (e.g., "Section 2.4 of 9 in Part 2"). Derive position from the architecture's processing order if available, otherwise from section numbering.
   - The architecture content (if exists)
   - The absolute path to the style reference: `{prose_output_dir_abs}/style-reference.md` — the subagent reads it directly before running formatting-qc
   - **Two-stage execution instructions (critical — execute strictly in this order):**
     - **STAGE 1 — Formatting QC:** Run all five checks per the formatting-qc skill (Formatting Integrity, Visual Rhythm, Standalone Coherence, Footnote Integrity, Mechanical Trigger Compliance). Produce a Stage 1 findings list with severity ratings. For mechanical formatting fixes (broken list structure, missing table caption, orphaned sentence fragment, spacing errors): apply them directly to the prose file and record in a "Stage 1 fixes applied" log. For fixes that affect standalone coherence (missing orientation, vague cross-references) or Mechanical Trigger Compliance findings (named framework in prose, category comparison without table, bold class inconsistency, multi-block subsection, multi-job paragraph): flag them as bright-line candidates and do NOT apply — these are substantive formatting decisions that should surface to the operator rather than auto-apply. Write the post-fix prose to the output path.
     - **STAGE 2 — Editorial Integration QC:** Only begin after Stage 1 is complete and the post-fix prose is written. Read the post-fix prose. Run all four check categories per the document-integration-qc skill (Narrative Structure, Consistency, Redundancy & Contradiction, Completeness). Draft transition passages where transitions are weak. **Do NOT re-flag any item from the Stage 1 findings, Stage 1 fixes applied log, the Phase 2 deferred items list, or the cross-section integration findings.** Focus redundancy/contradiction checks on issues internal to this module only. The `RELEASE ARTIFACT` protocol in the document-integration-qc skill is overridden — produce the full QC report directly.
   - Adaptation notes:
     - "This module has already passed prose quality review and AI prose decontamination via `/produce-prose-draft`, plus formatting + H3 (Phase 2 of this command). Decontamination removed AI-pattern prose (ornamental language, repetition, over-argumentation, flat rhythm) without changing analytical content. If you find an abrupt section ending or a transition that feels missing, check whether it may be a decontamination artifact rather than a pre-existing issue."
   - Task summary: Execute Stage 1 then Stage 2 as described above. Return a structured report with: Stage 1 findings (formatting), Stage 1 fixes applied log, Stage 1 bright-line candidates, Stage 2 findings (editorial) grouped by check category, transition drafts (if any), and an overall verdict.
9. Route on findings:
   - **No SUBSTANTIVE findings in either stage:** Note results and any NON-SUBSTANTIVE items. Proceed to Phase 4 (handoff).
   - **Stage 1 bright-line candidates:** Present to the operator before applying. These are formatting fixes that cross into prose changes.
   - **Stage 2 SUBSTANTIVE findings without transition drafts:** Present findings to the operator. Apply bright-line rule — SUBSTANTIVE narrative or consistency issues likely require prose changes. Proceed to Phase 4 after the operator reviews.
   - **Stage 2 transition drafts produced:** Present transition drafts to the operator. The operator decides which to incorporate. Approved transitions are inserted into the prose file. (Transition passages of 1–3 sentences are not bright-line items. If a transition draft exceeds one paragraph, apply the bright-line rule check before inserting.) Proceed to Phase 4.
   - **Findings that suggest issues in other sections:** Log to `logs/decisions.md` as cross-section revision notes per the existing cross-section rule. Do not modify other sections' prose.
10. ▸ /compact — skill content no longer needed.

---

## Phase 4 — Handoff (main session)

1. Read the final formatted prose file
2. Present to the operator:
   - **Final prose file path** + final word count
   - **Mechanical Trigger pre-scan results** (from Phase 2 Step 0): which triggers fired, document locations, brief description of each hit. So the operator sees which categories of format were caught and which were judged non-applicable.
   - **Formatting change log** (from Phase 2)
   - **H3 decisions table** (from Phase 2): present the full verdict table. **Highlight every REMOVED heading explicitly at the top** with its original text, rationale, and the reversal instruction from Phase 2. This is the operator's opportunity to reverse any structural deletion; REMOVED verdicts were auto-applied mid-pipeline to eliminate the mechanical pause, so they must surface here for review.
   - **SPLIT verdicts** (from Phase 2, if any): list each with (a) the subsection being split, (b) proposed insertion line reference, (c) proposed new H3 title, (d) block-boundary rationale. SPLIT verdicts are NOT auto-applied; they are surfaced here for operator decision. **Application path:** if the operator approves a SPLIT, the main agent applies it directly as a post-handoff edit — insert the approved H3 at the specified line, read the file back to confirm, log the change to `logs/decisions.md`. The operator's Phase 4 approval of the specific SPLIT constitutes the required operator approval for the project bright-line rule; no additional bright-line pause is needed for the insertion. If the operator declines a SPLIT, leave the subsection unchanged and record the declined verdict for traceability.
   - **Phase 3 Stage 1 (formatting-qc) findings** + auto-fixes applied. Note: formatting-qc now runs five checks (Formatting Integrity, Visual Rhythm, Standalone Coherence, Footnote Integrity, Mechanical Trigger Compliance). MTC findings flag miss patterns the Mechanical Triggers were designed to prevent — if present, the pre-scan did not fire on the corresponding pattern.
   - **Phase 3 Stage 2 (document-integration-qc) findings** + transition drafts produced (and disposition)
   - **Bright-line items deferred for operator decision** (any unresolved items from Phase 2 or Phase 3)
3. Suggest next step: prose is formatted and integration QC has passed. The operator decides whether to accept or route to further review per project rules.

   > **Mandatory reminder for Part 2 sections:** Per project rules, Part 2 and Working Hypotheses content requires three review layers before moving to `parts/part-2-service/approved/`: `/review` (QC), `/challenge` (strategic), and `/service-design-review` (experiential). `/review` runs first; `/challenge` and `/service-design-review` can run in either order after `/review` passes. If these have not yet run for this section, surface this requirement explicitly in the handoff.
