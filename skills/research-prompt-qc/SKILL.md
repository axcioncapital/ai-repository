---
name: research-prompt-qc
description: >
  Automated quality check on Research Execution Prompts before operator
  uses them in Research GPT. Verifies coverage, session integrity, prompt
  quality, dependency correctness, and format compliance. Run immediately after
  research-prompt-creator (Step 2.1) completes. Produces per-session
  verdicts (PASS / FLAG) and a batch verdict. Do NOT use for prompt creation
  (research-prompt-creator), answer spec QC (answer-spec-qc), or
  research extract verification (research-extract-verifier).
---

# Research Prompt QC

Automated gate between prompt creation (Step 2.1) and prompt execution (Step 2.2). Catches prompt defects before the operator pastes them into Research GPT — where errors are expensive (each session costs time and cannot be partially re-run).

**Position:** Step 2.1b — immediately after `research-prompt-creator`, before operator executes sessions.

## Inputs

All three required. Read from file paths or provided as content.

1. **Research Execution Prompts** — the output of `research-prompt-creator`
2. **Answer Specs** — the approved specs that the prompts must cover
3. **Research Plan** — for scope parameter verification

## Check Dimensions

Run all five dimensions. Findings accumulate before verdict assignment.

### Dimension 1: Coverage Completeness

Every Answer Spec component must appear as a research directive in exactly one session prompt.

| Check | What to look for |
|-------|-----------------|
| Component coverage | Every Q[n]-A## component from every Answer Spec has a corresponding research directive in a session prompt. List any missing components by ID. |
| Completion gate translation | Answer-level completion gates (min_sources, min_distinct_claims, etc.) are reflected in the prompt's source/depth instructions — not as literal gate language, but as research directives that would satisfy the gates. |
| Scope dimension coverage | All scope parameters from the Answer Specs (geography, timeframe, deal size, fund type) appear in at least one prompt. |
| Duplicate coverage | No component is addressed in multiple sessions (creates redundant research and conflicting outputs). Flag duplicates. |

### Dimension 2: Session Integrity

Sessions are well-formed and correctly bounded.

| Check | What to look for |
|-------|-----------------|
| Question count | No session exceeds 3 questions (hard ceiling). Default is 2 per session. |
| 3-question justification | Any session with 3 questions must have explicit justification citing dependency constraints or strong source overlap. Flag if no justification is provided. |
| Question assignment | Every research question appears in exactly one session. No orphaned questions, no duplicates. |
| Clustering rationale | Session plan table includes clustering logic for each session. Flag sessions without stated rationale. |
| Session balance | No session is overloaded (e.g., 4 complex questions with 5+ components each) while another has a single simple question. Flag imbalances with reasoning. |

### Dimension 3: Prompt Quality

Each execution prompt follows the construction rules from the skill and prompt-construction-guide.

| Check | What to look for |
|-------|-----------------|
| No Answer Spec terminology | Prompts must not contain: "evidence component," "completion gate," "answer spec," "claim ID," "Q[n]-A##," "min_sources," "min_distinct_claims," or similar spec-internal language. These terms are meaningless to the research executor. |
| Scope as literal values | Scope parameters are embedded as concrete values ("Nordic PE funds with EUR 50M–500M AUM"), not abstract references ("as defined in the Research Plan," "per scope parameters"). |
| Context pack block | Each prompt includes a context pack block delimited by `--- CONTEXT PACK ---` / `--- END CONTEXT PACK ---` markers, containing project background, section objective, content map, and scope boundaries. |
| Imperative verbs | Directives use action verbs (Find, Compare, Present, Trace, Identify), not passive descriptions. |
| Output shape specified | Structured/quantitative directives specify output format ("as a table with columns...," "as a numbered list"). Analytical/qualitative directives state the deliverable clearly but do NOT prescribe format — flag if qualitative directives are over-prescribed with rigid format instructions. |
| Depth/priority signals | Sessions with questions of unequal importance include priority signals. |
| Recency instructions | Questions marked as recency-sensitive in Answer Specs have corresponding recency preferences in the session header. |

### Dimension 4: Dependency and Ordering

Dependencies between sessions are correctly mapped and reflected.

| Check | What to look for |
|-------|-----------------|
| Cross-question dependencies | Answer Spec dependencies (e.g., Q2 references Q1 output) are reflected in the session dependency map. |
| Hard vs. soft classification | Dependencies are correctly classified — hard dependencies (B cannot run without A's output) vs. soft (B benefits from A but can run independently). |
| Parallel opportunities | Sessions without dependencies are identified as parallelizable. |
| Circular dependencies | No circular dependency chains exist. |

### Dimension 5: Format and Operational Compliance

The document follows the required structure and includes all operational elements.

| Check | What to look for |
|-------|-----------------|
| Document structure | All required sections present: How to Use, Session Plan table, per-session blocks (Settings, Execution Prompt, Steering Notes), Post-Execution Notes. |
| Session plan table | Table includes: Session, Questions, Cluster Logic, Dependencies columns. |
| Steering notes present | Every session has specific (not generic) steering notes addressing likely thin-results areas, alternative search angles, and acceptance criteria. |
| Site restriction guidance | Every session includes site restriction guidance (even if "Default — full web search"). |
| Code-fenced prompts | Execution prompts are in code fences (literal paste-ready text). |
| Post-execution notes | Post-execution section includes save instructions, cross-session review checklist, and downstream flags. |

## Finding Severity

| Severity | Definition | Verdict impact |
|----------|-----------|----------------|
| **Critical** | Missing component coverage, Answer Spec terminology in prompts, missing questions — would cause research gaps or executor confusion. | → FLAG |
| **Moderate** | Missing steering notes, scope as abstract reference instead of literal, missing output format spec — degrades prompt quality but won't cause total failure. | → FLAG |
| **Minor** | Formatting inconsistencies, minor balance concerns, optional improvements. | Noted. Does not block PASS. |

## Verdict Assignment

### Per-Session Verdict

- **PASS** — No Critical or Moderate findings for this session. Ready for execution.
- **FLAG** — One or more Critical or Moderate findings. Prompt needs revision before use.

### Batch Verdict

- **APPROVED** — All sessions PASS. Prompts are ready for operator execution.
- **REVISE** — One or more sessions FLAG. List specific fixes needed per session.

## Output Format

```
# Research Prompt QC Report

**Document reviewed:** [filename]
**Sessions reviewed:** [count]
**Batch verdict:** [APPROVED / REVISE]
**Results:** [n] PASS / [n] FLAG

## Coverage Summary
- Answer Spec components: [total] checked, [n] covered, [n] missing
- Missing components: [list Q[n]-A## IDs, or "None"]
- Duplicate coverage: [list, or "None"]

## Per-Session Results

### Session [A] — [PASS / FLAG]
**Questions:** [list]
| Dimension | Findings |
|-----------|----------|
| Coverage | [findings or "Clean"] |
| Session Integrity | [findings or "Clean"] |
| Prompt Quality | [findings or "Clean"] |
| Dependencies | [findings or "Clean"] |
| Format | [findings or "Clean"] |

[Repeat per session]

## Revision Instructions (if REVISE)

### Session [X] — Required Fixes
1. [Severity] — [Finding] → [Specific fix instruction]
2. ...
```

## Execution Mode

This QC runs as a **subagent** (delegate-qc pattern). The main agent:

1. Reads the research prompts file, answer specs, and research plan
2. Passes all content to the QC subagent along with this skill
3. Subagent runs checks, writes verdict to `/execution/checkpoints/{section}-step-2.1b-prompt-qc.md`
4. Returns batch verdict and any revision instructions

## Autonomy Rules

- **APPROVED verdict:** Proceed automatically to Step 2.2. Log the result.
- **REVISE verdict with only Moderate findings:** Apply fixes automatically, re-run QC. If second pass is APPROVED, proceed. If still FLAG after one fix iteration, pause for operator.
- **REVISE verdict with any Critical findings:** Pause for operator review.

## Stop Condition

Present results and stop. Do not rewrite prompts, create new sessions, or initiate downstream work. If REVISE, provide specific fix instructions that the main agent or operator can act on.

## Integrity Rules

- Operate only from provided prompts, answer specs, and research plan. Do not supplement with domain knowledge about what prompts "should" contain.
- Do not soften FLAG to PASS to avoid rework.
- Coverage check is mechanical — if a component ID from the answer specs has no corresponding directive, it's missing regardless of whether the prompt "probably covers it implicitly."
- Terminology check is literal — scan for forbidden terms in the code-fenced prompt blocks specifically.
