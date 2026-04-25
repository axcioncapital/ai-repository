# Risk Check — 2026-04-24

## Change

Add a new "Chat Communication Style" section (~12 lines, ~120 tokens per turn) to workspace CLAUDE.md between the existing "Working Principles" and "File Write Discipline" sections. The section instructs future Claude sessions to write chat output (running updates, end-of-turn summaries, questions) in plain B2 English, while preserving workspace-specific vocabulary the operator already knows; deeper technical or domain jargon should be glossed or rephrased on first use; structured tags like `[CITATION NEEDED]`, `[EVIDENCE GAP]`, `[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]` must remain verbatim. The rule explicitly does NOT apply to file content (skills, commands, CLAUDE.md, reports, commit messages) or structured skill outputs (e.g., /repo-dd, /audit-repo, /token-audit, and other command-defined report formats).

Full proposed section content (verbatim):

```markdown
## Chat Communication Style

Chat text I send you — running updates, end-of-turn summaries, questions —
uses plain B2 English: short sentences, everyday words, no fancy connectors
like "furthermore" or "consequently".

Workspace terms are fine as-is — subagent, QC pass, guardrail, hook, slash
command, permission prompt, auto-loop, plan mode. You know these.

For deeper technical terms (e.g., git internals, shell mechanics, model APIs,
file-format quirks, statistics, finance, legal, research methodology), either
rephrase, or use the term with a short plain-English gloss the first time it
appears in a response.

Structured tags stay verbatim — `[CITATION NEEDED]`, `[EVIDENCE GAP]`,
`[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]`, etc. Don't paraphrase them
into prose.

Does NOT apply to file content (skills, commands, CLAUDE.md, reports, commit
messages) or structured skill outputs (e.g., `/repo-dd`, `/audit-repo`,
`/token-audit`, and other command-defined report formats). Those keep current
style.
```

Operator context: Patrik is a non-developer; the change is motivated by his self-reported difficulty understanding Claude's chat output. This is a workspace-level CLAUDE.md edit (loads on every turn of every project under this workspace).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A small but always-loaded section added to a heavily-loaded CLAUDE.md; design is well-scoped (clear carve-outs, verbatim-tag clause aligns with existing structured-tag system) but the per-turn token cost is non-trivial in a file already flagged in prior audits as oversized, so it warrants a paired tighten-on-merge mitigation.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The change adds content to workspace CLAUDE.md, which is always loaded on every turn of every project session under this workspace. Evidence: workspace `CLAUDE.md` line 5 ("This file covers principles and conventions that apply across all projects.") and `ai-resources/audits/token-audit-2026-04-18-project-buy-side-service-plan.md:128` confirms the workspace CLAUDE.md is auto-loaded via `additionalDirectories`.
- The proposed section, as quoted in CHANGE_DESCRIPTION, is ~20 lines including blank lines, ~155 words. At a rough 1.3 tokens/word that is ~200 tokens/turn — slightly above the operator's stated estimate of ~120 tokens/turn but in the same band.
- Per the workspace heuristic in this rubric, ">150 tokens to always-loaded files" is High; the change sits just over that line. The mitigating factor is that the section is structurally simple prose (no `@import`, no hook), so it does not compound: the cost is a flat per-turn add.
- Workspace CLAUDE.md is already 175 lines / 2,665 words (`wc` evidence). Prior audits have flagged the file as oversized: `ai-resources/audits/claude-md-audit-2026-04-20-project-buy-side-service-plan.md:14` notes "Total always-loaded cost (workspace + project) is ~7,600 tokens/turn — roughly 12× the external best-practice budget of ~600 tokens/turn for root CLAUDE.md". Adding ~150–200 tokens to an already-oversized file is meaningful at the margin even if individually small.
- Net: Medium rather than High because the section is simple, scoped, and pay-once-per-turn (no cascading load).

### Dimension 2: Permissions Surface
**Risk:** Low

- The change is a text-only edit to `CLAUDE.md`. It introduces no `allow`, `ask`, or `deny` entries; no new tool families; no new `Bash`/`Write` patterns; no settings-file scope changes. CHANGE_DESCRIPTION contains no permission-relevant language.

### Dimension 3: Blast Radius
**Risk:** Low

- Single-file edit: only `CLAUDE.md` at the workspace root is touched.
- No contract change. The new section adds a behavioral norm; it does not modify any structured input/output schema, command frontmatter, hook output shape, or subagent contract.
- The verbatim-tag clause names existing tags from existing systems and does not redefine them. Cross-checked against workspace `CLAUDE.md` lines 109–112 (Session Guardrails: `[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]`) and line 35 (Design Judgment Principles: `[CITATION NEEDED]`, `[EVIDENCE GAP]`) — the new section explicitly preserves all of them, no semantic drift.
- Grep enumeration: searched for sections that reference `Working Principles` and `File Write Discipline` as cross-links. Three matches found, all in audit-archive files (`ai-resources/audits/repo-due-diligence-2026-04-12.md:325, 671`; `repo-due-diligence-2026-04-06.md:279, 569`; `repo-due-diligence-2026-04-11.md:442, 752`; `claude-md-audit-2026-04-20-project-buy-side-service-plan.md:32, 142, 260`; `cleanup-worktree.md:45`). Of these, only one is a live cross-link from an active command: `ai-resources/.claude/commands/cleanup-worktree.md:45` references "workspace `CLAUDE.md → Working Principles` → pre-compact checkpoint". Inserting a new section *between* Working Principles and File Write Discipline does not displace either heading and does not break that cross-link.
- Grep for `B2 English`, `chat output`, `chat text`, `chat communication`, `communication style` across the repo (excluding project content) returned zero conflicting prior chat-style rules in workspace or ai-resources CLAUDE.md. The closest precedent is `ai-resources/CLAUDE.md:22` ("I am Patrik, a non-developer. Explain technical details in plain language.") — same direction, no conflict, the new section is a more specific elaboration.

### Dimension 4: Reversibility
**Risk:** Low

- A clean `git revert` on the single workspace CLAUDE.md commit fully restores prior state. No sibling files are created. No log file is mutated. No external state propagates.
- One small caveat: the operator may already mentally rely on the new style after a few sessions; reverting the file would not retrain operator expectations. This is operator-facing rather than system-facing reversibility, and is below the threshold for Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- One implicit dependency: the section's "Workspace terms are fine as-is" clause depends on a finite list — `subagent, QC pass, guardrail, hook, slash command, permission prompt, auto-loop, plan mode`. New workspace vocabulary added later (e.g., a new ritual, a new hook, a new flag class) will not automatically be on this list, so future sessions may either over-gloss familiar terms or assume newer terms are familiar when they are not. This is a minor maintenance contract — the list will need updating as the workspace grows.
- One functional-overlap concern: existing rule at `ai-resources/CLAUDE.md:22` ("Explain technical details in plain language") covers a similar concern at the ai-resources project level. The new workspace section subsumes and expands it; both will fire in ai-resources sessions. Not a contradiction (both push the same direction), but two rules now address the same concern. Whether to dedupe (collapse the ai-resources line into a pointer to the workspace section) is an operator choice; keeping both is not load-bearing.
- The section names commands `/repo-dd`, `/audit-repo`, `/token-audit` in its scope-carve. These commands exist in the repo (verified by repeated audit references). Should any of these be renamed or removed, the carve list in this section becomes stale — a small documentation-drift risk, mitigated by the `and other command-defined report formats` clause.
- No silent auto-firing: the rule is a behavioral instruction read by Claude on each turn, not a hook or trigger. It does not run in unexpected contexts.

## Mitigations

- **Dimension 1 (Usage Cost) — paired trim.** Before landing, tighten the proposed section by ~30%. Concrete cuts: (a) drop the example list of "fancy connectors" (`like "furthermore" or "consequently"`) — the B2 instruction is enough; (b) collapse the "Workspace terms are fine as-is" paragraph from a list into a one-line statement ("Workspace vocabulary in CLAUDE.md and SKILL.md is already known — no glossing needed."); (c) shorten the "deeper technical terms" paragraph to one sentence with one or two example domains, not five. Target post-trim size: ~10 lines, ~80–100 tokens/turn. Brings this dimension to Low without losing the rule's load-bearing content.
- **Dimension 5 (Hidden Coupling) — drop or generalize the workspace-vocabulary list.** The enumerated list (`subagent, QC pass, guardrail, ...`) is what creates the maintenance debt. Replace with a generalization: "Vocabulary that already appears in workspace CLAUDE.md or any loaded SKILL.md is fine as-is." This is self-maintaining — as the workspace grows, the included-vocabulary set grows automatically. Also consider folding the duplicate ai-resources/CLAUDE.md:22 sentence into a one-line pointer ("See workspace CLAUDE.md → Chat Communication Style.") to remove the functional overlap. Brings this dimension to Low.

## Recommended redesign

(Section omitted — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
