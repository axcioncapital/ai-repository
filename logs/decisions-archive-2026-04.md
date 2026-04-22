# Decision Journal — Archive 2026-04

## 2026-04-18 — Retrofit pipeline-stage-4 to sonnet (clear the deferral)
- **Context:** Morning session (commit `feaf614`) retrofitted most agents but left `pipeline-stage-4` as `inherit` with note "Candidate: declare sonnet (deferred 2026-04-18 — gate behind end-to-end /new-project validation run)."
- **Decision:** Flip to `model: sonnet` now, without waiting for a `/new-project` validation run.
- **Rationale:**
  - Tier rule is explicit: spec-following implementation → sonnet. Stage 4's job description ("Execute the approved implementation spec — create files, update configurations, wire components") is the canonical sonnet use case.
  - Judgment is upstream: Stage 3b (opus) does architectural design; Stage 3c (opus) does line-level spec. By Stage 4 the decisions are made.
  - `inherit` leaves model non-deterministic across sessions; every other agent in the table is declared. Stage 4 was the sole holdout.
  - Cost of being wrong is low: one-line revert if a real run surfaces inadequacy.
- **Alternatives considered:**
  - Keep the deferral (rejected — thin gate, no plan for when the validation run would happen, leaves tier table permanently inconsistent).
  - Flip to opus per operator's initial challenge (rejected — Stage 4 is spec-following, not judgment; escalating to opus would collapse the tiering logic across the pipeline; if Stage 4 needs opus, the fix is to tighten 3c's spec, not escalate 4).
- **Follow-up:** First real `/new-project` run is the empirical validation. Revert to opus if sonnet underperforms.

---

## 2026-04-18 — Pure relocation as the canonical-pipeline-compatible refactor pattern

- **Context:** Trimming 3 oversized skills (ai-prose-decontamination, ai-resource-builder, prose-compliance-qc) from the 2026-04-18 token-audit HIGH list. Two paths originally offered: full `/improve-skill` pipeline runs (slow, 3 sequential multi-hour sessions) or ad-hoc direct trims (quality risk). Operator asked for "a better solution that won't compromise quality." Initial v1 plan included "compress inline by ~20 L" and "tighten by ~6 L" line items. Plan-QC flagged: workspace CLAUDE.md says "Always use the canonical pipelines… for modifications" — semantic edits without /improve-skill = bright-line rule violation. Triage cascade established the load-bearing decision was whether to bypass /improve-skill.
- **Decision:** Adopt pure structural relocation as the refactor pattern. Cut blocks verbatim from SKILL.md, paste into sibling `references/` files, leave a pointer behind. Zero rewording, zero compression, zero semantic editing. This stays inside the canonical-pipeline rule because the rule governs *content modifications*, not structural relocation. Each refactored SKILL.md still gets a mandatory post-edit qc-reviewer pass.
- **Rationale:**
  - Reconciles the operator's quality constraint with the canonical-pipeline rule. Quality is preserved because nothing changes about *what is said*; only *where it lives* changes.
  - The pattern is canonical — `ai-resource-builder/SKILL.md` itself prescribes progressive disclosure (folder structure, references/ subfolder, on-demand loading).
  - Faster than 3 sequential `/improve-skill` runs while still safer than ad-hoc trims (because the operational core can't be touched).
  - Discipline is checkable: post-edit QC can verify no operational instruction was lost or weakened, just by diffing the relocated reference files against the original SKILL.md and confirming the pointers fire at the right moments.
  - Generalizable: this pattern can trim the remaining 5 oversized skills without invoking /improve-skill. Token-budget gain is durable; quality risk is contained.
- **Alternatives considered:**
  - Full `/improve-skill` per skill (rejected — operator-blocked on time; 3 sequential pipeline runs is a multi-hour session and the audit flagged 8 skills, not 3).
  - Direct trims with semantic editing (rejected — bright-line rule on canonical pipelines applies; would set precedent that "refactor" laundering bypasses QC gates).
  - Mixed approach: pure relocation + small inline tightening with explicit operator approval of the bypass (rejected — adds operator-decision overhead per skill; pure relocation is cleaner and still hits ~85% of the trim opportunity).
- **Follow-up:**
  - Apply same pattern to remaining 5 oversized skills in a future session.
  - Empirical verification of ai-resource-builder relocations comes from the first real `/create-skill` or `/improve-skill` invocation (smoke test deliberately skipped).
  - If pure relocation proves insufficient for any skill (e.g., skill is genuinely all operational logic with no relocatable reference content), revisit per case — that's the real signal to use `/improve-skill`.

## 2026-04-21 — prose-refinement-writer: new skill vs. update-existing, and scope placement

- **Context:** operator diagnosed two residual weaknesses in current `produce-prose-draft` pipeline output (unclear logical relationships between adjacent sentences; underdeveloped hardest claims). Provided a full refinement-writer instruction. Target artifact was ambiguous — the feedback could have landed in any of four places.
- **Decision (via AskUserQuestion gate):** create a new shared skill `prose-refinement-writer` in `ai-resources/skills/`. Not an update to ai-prose-decontamination (voice cleanup, different axis), decision-to-prose-writer (structural conversion, not refinement), evidence-prose-fixer (fidelity patches only), document-optimizer (word-level tightening), or a project-local artifact.
- **Rationale:** the operator's two named weaknesses — sentence-to-sentence logical linkage and hardest-claim development — are a prose-quality axis none of the four adjacent skills operate on. Folding into an existing skill would either dilute that skill's scope or force the new work into a misfit frame. Applicability is cross-project (any prose workflow), so shared scope is correct.
- **Alternatives considered:**
  - Fold into `ai-prose-decontamination` (rejected — decontamination is voice cleanup; the refinement rules treat banned openers as constraints, not primary scope).
  - Update `decision-to-prose-writer` to produce better initial output (rejected — converter runs on decision docs, not already-narrative prose; the weaknesses are an iteration problem, not a conversion problem).
  - Update `context/prose-quality-standards.md` in the buy-side-service-plan project (rejected — operator scope is shared, not project-local).
- **Pipeline wiring deferred:** position in `produce-prose-draft.md` (post/pre/reorganize relative to decontamination) held open for a follow-up session. Operator confirmed Document 1 is post-full-pipeline output but did not choose the wiring position. Skill content is wiring-independent.
- **Within-skill design defaults (Claude-proposed, operator to review on first real invocation):**
  - External QC rather than internal revise-test-revert loop (matches QC Independence Rule).
  - Size-of-change cap as judgment latitude per operator instruction's phrasing, not a hard abort at four sentences.
- **Process deviation flagged:** brief authored directly at workspace level rather than via `/request-skill` from a project session (no project session exists for this workspace-level request). Deliberate, documented in brief.
- **Follow-up:**
  - Pipeline wiring in a dedicated session.
  - Batch frontmatter-conformance pass (`disable-model-invocation` / `allowed-tools` / `paths`) across all skills rather than one-off on this skill.

## 2026-04-21 — produce-prose-draft refactor: path-based reference passing + governance carve-out

- **Context:** 2026-04-21 usage-log entry (first work block's wrap) rated produce-prose-draft as Wasteful. Primary recommendation: stop inlining style-reference.md and prose-quality-standards.md; pass absolute paths. Estimated savings ~30–34K tokens/run, ~300K–700K over 10–20 runs. During planning, Explore surfaced that `ai-resources/workflows/research-workflow/CLAUDE.md` line 62 mandates content-passing — the recommendation directly conflicts with that rule.
- **Decision:** Apply path-based passing for style-reference.md and prose-quality-standards.md only (operand artifacts stay content-passed). Update four skill input contracts. Add a narrow Context Isolation Rules carve-out to the workflow CLAUDE.md explicitly permitting path-passing for the two named large reference files, while preserving content-passing as the default for operand artifacts and skill content.
- **Rationale:** The cost-saving recommendation is sound (~30K tokens/run) and the governance rule's intent (isolation) is preserved by explicitly scoping the exception to read-only reference material. The skill-contract update is necessary because three of four skills block on missing style-reference content. Command-first commit order chosen so that the intermediate-state failure mode is the familiar "missing content" flag (skill halts cleanly) rather than a new "missing path" error.
- **Alternatives considered:**
  - All inlined content converted to paths (rejected: operand artifacts changing hands would break the clean boundary; diminishing returns).
  - Only prose-quality-standards converted (rejected: captures ~60% of savings at ~60% of work; style-reference is nearly as large).
  - Skills accept path OR content during a transition window (rejected: added complexity for a refactor with no external callers).
  - Keep the rule, skip the refactor (rejected: operator explicitly prioritized the token savings).
- **Follow-up:**
  - Smoke-test both `/produce-prose-draft` (measure token delta) and `/run-report` (surface run-report contract change; operator picks mitigation).
  - Token-savings measurement: baseline is 2026-04-20 Wasteful entry; post-refactor usage-log entry is the comparison.
