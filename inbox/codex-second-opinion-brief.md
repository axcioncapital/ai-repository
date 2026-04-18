---
name: Codex second-opinion auditor
status: draft — viability confirmed, pilot not yet built
created: 2026-04-13
type: build brief
---

# Codex as Independent Second-Opinion Auditor — Build Brief

## Problem statement

This workspace has a structural blind-spot risk: every audit, QC pass, and workflow review is executed by Claude (Opus 4.6). Subagent isolation gives fresh context, but it does not give a fresh *model*. Two Claude instances running the same framework against the same repo will tend to notice the same things and miss the same things, because they share training data, inductive biases, and failure modes. When Claude evaluates Claude-produced artifacts, systematic gaps can stay invisible across arbitrarily many review passes.

The hypothesis: a **different model family** executing the *same* evaluation framework against the *same* repo will diverge from Claude's findings in ways that matter. Agreement between the two increases confidence; disagreement reveals the actual blind spots on either side. The goal is not to replace Claude's audits — it's to run a second pass with a model that fails differently, so the union of findings is more complete than either alone.

## Viability verdict

**Yes, viable — narrow pilot recommended.**

OpenAI's Codex CLI is installed on this machine and ships a clean headless mode that makes it callable from Claude Code's Bash tool. It is structurally equivalent to a Claude subagent for this use case: a fresh-context agentic loop that can read the repo, execute an evaluation framework, and produce a findings report in a separate process. Independence is preserved by construction (separate process, no shared conversation state).

The pattern that works is not "Codex runs Claude's slash commands." Those command files are written for Claude Code's execution model (subagent launches, the Agent tool, etc.) and will confuse Codex. The pattern is: Codex reads the *framework files* those commands depend on (`audits/questionnaire.md`, `skills/ai-resource-builder/references/evaluation-framework.md`) and executes the audit natively, guided by a mechanical wrapper prompt that Claude writes.

## Key findings from the viability investigation

### Codex CLI surface

- Binary: `/usr/local/bin/codex`.
- Relevant subcommand: `codex exec` — non-interactive mode. Takes a prompt as argument or from stdin. Supports:
  - `-C <DIR>` — working directory.
  - `-s read-only` — sandbox mode appropriate for audits (never mutates the repo).
  - `-m <MODEL>` — model override.
  - `-p <PROFILE>` — named config profile.
- Separate subcommand: `codex review` — PR-diff review mode with `--base <BRANCH>`, `--uncommitted`, `--commit <SHA>`. Different use case (reviewing a diff, not auditing a workspace) — flagged as a secondary opportunity for reviewing changes Claude makes to shared resources.
- Authentication: `codex login` / `codex logout`. Confirm active session before first programmatic use.
- Concrete invocation shape for the pilot (starting template — adjust model and paths before running):

  ```bash
  codex exec \
    -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" \
    -s read-only \
    -m gpt-5 \
    "Read audits/questionnaire.md. Execute the full questionnaire against this repository. Write your findings to reports/codex-dd-YYYY-MM-DD.md using the same section and question structure as the questionnaire. Answer every question. Do not modify any files except the report you write."
  ```

  The prompt above is mechanical on purpose: framework path, execution instruction, output path, schema anchor, sandbox constraint. No editorial framing, no hints, no "pay attention to X." That mechanical tone is load-bearing — see the wrapper-prompt-contamination risk in the risks section.

- Model choice: start with `gpt-5` (Codex CLI's current flagship target). If cost or latency is prohibitive, fall back to a smaller Codex-family model. Do NOT pick a reasoning-optimized model that hides its chain of thought — audit findings should be traceable, and losing the intermediate agent messages defeats the second-opinion value.

### Existing workspace audit commands are all subagent-dependent

Every command in scope for Codex second-opinion treatment launches Claude subagents:

- `/repo-dd` → `repo-dd-auditor` subagent, reads fixed questionnaire at `audits/questionnaire.md`.
- `/audit-repo` → 8 subagent auditors in `skills/repo-health-analyzer/agents/`.
- `/analyze-workflow` → `workflow-analysis-agent` + `workflow-critique-agent` subagents.
- `/qc-pass` → `qc-reviewer` subagent, uses `skills/ai-resource-builder/references/evaluation-framework.md`.
- `/refinement-deep` → parallel `qc-reviewer` + `refinement-reviewer` + `triage-reviewer`.
- `/triage` → `triage-reviewer` subagent.

This is not a blocker. The *reason* those commands use subagents is to get fresh context and satisfy the QC Independence Rule. `codex exec` is already a fresh-context agentic loop when invoked — it replaces the subagent indirection entirely rather than having to emulate it. Codex does not need (or have) Claude's Agent tool; it is its own agent.

### Framework files are portable and model-agnostic

The content that actually drives the audits lives in framework files, not command wrappers:

- `audits/questionnaire.md` — the v2.0 Repo Due Diligence Questionnaire executed by `/repo-dd`. ~25 numbered questions grouped into sections (inventory, CLAUDE.md health, dependency references, consistency, context load, drift/staleness). Answers render as markdown tables; multi-repo audits include a Repo column. Skipped/inapplicable questions use `N/A — [reason]` rather than reinterpretation. Prior Claude-produced baseline audit lives at `audits/repo-due-diligence-2026-04-06.md` — read it to see the exact output shape Codex should match.
- `skills/ai-resource-builder/references/evaluation-framework.md` — the 8-layer evaluation framework used by `/qc-pass`, `/refinement-deep`, `/create-skill`, `/improve-skill`. Used for skill/command QC, not workspace audits.

These files are not Claude-specific. Codex can read and execute them unchanged. Reuse the existing frameworks — do not duplicate them for Codex.

### The existing execution-agent pattern does NOT transfer

There is an existing agent at `.claude/agents/execution-agent.md` that calls GPT-5 and Perplexity via HTTP. That pattern is request/response passthrough for one-shot research queries. Codex CLI is fundamentally different: a multi-turn agentic loop with its own tools and file access. Do not try to extend execution-agent to handle Codex — it is a new, parallel pattern (subprocess invocation, not HTTP).

### Greenfield

No existing references to "codex" anywhere in the workspace. No legacy integration to preserve or migrate from.

## The working pattern

```
Claude (main session)
  │
  ├── runs /repo-dd  ─────→ writes  audits/repo-dd-YYYY-MM-DD.md   (Claude's findings)
  │
  ├── constructs mechanical wrapper prompt  (framework path, repo path, output path, schema)
  │
  ├── shells out: codex exec -C <repo> -s read-only --prompt-file <wrapper>
  │                                    │
  │                                    ▼
  │                   Codex (separate process, fresh context)
  │                     • reads audits/questionnaire.md
  │                     • executes audit against repo
  │                     • writes  reports/codex-dd-YYYY-MM-DD.md
  │
  ├── reads both reports, diffs findings
  │
  └── surfaces divergences to operator for remediation
```

**Strict ordering rule:** Claude runs its audit *first*, Codex runs *second*, never reverse. If Codex runs first and Claude sees Codex's output before forming its own view, Claude is no longer independent. The entire value proposition depends on each model producing its findings without seeing the other's. Build this ordering into the pilot command's logic, not just the docs.

**Wrapper prompt contamination avoidance:** the wrapper prompt Claude hands to Codex must be mechanical. Framework path, repo path, output path, output schema. No "focus on these likely issues," no "pay special attention to X," no summary of what Claude already found. Editorializing the wrapper prompt leaks Claude's biases into Codex's evaluation and kills the independence guarantee.

## QC Independence Rule compatibility

The workspace's QC Independence Rule (in root `CLAUDE.md`) states: *"Evaluators receive only the artifact under review, the evaluation criteria/framework, and the artifact's declared purpose. Never pass conversation history, creation rationale, or operator feedback."*

Codex invoked via `codex exec` satisfies this by construction: it is a separate process with no conversation history, no operator feedback, and no access to Claude's session state. The only thing it sees is what the wrapper prompt hands it. If the wrapper prompt is kept mechanical (see above), the independence guarantee is stronger than for a Claude subagent, because process isolation is a harder boundary than subagent context isolation.

## Where the value actually lives

Not every audit benefits equally. The hypothesis (divergent blind spots between model families) only pays off on **judgment-heavy** evaluations. On mechanical checks (symlink validation, dead-reference detection, drift scans), two models will agree deterministically — running Codex there is wasted cost.

Priority candidates for Codex second-opinion treatment, highest value first:

1. **`/repo-dd`** — structural audit has interpretive edges (is this file stale? is this reference still load-bearing? is this directory intentionally empty?). Judgment-dense.
2. **`/qc-pass` on skills** — the 8-layer evaluation framework is behavioral, not syntactic. Two models will read "trigger conditions clear enough" differently.
3. **`/audit-repo`** — 8-dimension workspace health where dimensions compete for priority. Priority calls are where models diverge.
4. **`/analyze-workflow`** — the critique agent makes explicit priority calls on findings. Divergence signal should be strong.

De-prioritized (mechanical, low expected divergence): drift detection, symlink normalization, link validation.

## Recommended pilot

**Build one command: `/codex-dd`.**

Scope:
- Invoke `codex exec` with the existing `audits/questionnaire.md` and a read-only sandbox.
- Write Codex's report to `reports/codex-dd-YYYY-MM-DD.md` (parallel path to Claude's audit output).
- Do **not** automate the diff step in v1 — let the operator compare reports manually for the first run. The diff pattern will reveal itself only once we see what Codex's output actually looks like, and trying to template it in advance is premature.

Out of scope for v1:
- Porting any other command.
- Automated reconciliation of findings.
- Any changes to existing command files or framework files.
- Format enforcement on Codex's output beyond "markdown, sections for each questionnaire item."

**Run-then-decide logic:** one real pilot run. If Claude and Codex diverge on findings in ways that would change what the operator fixes → the hypothesis is confirmed and the pattern is worth expanding to `/codex-qc` and `/codex-audit-repo`. If they converge on roughly the same findings with trivial wording differences → the hypothesis is wrong for this workspace, document the negative result, and stop.

**Estimated build cost:** one command file (`.claude/commands/codex-dd.md`), one wrapper prompt template, a few lines of shell invocation. No new skills, no new agents, no framework modifications. Small.

**Estimated run cost:** unknown — Codex CLI hasn't been invoked from this workspace before. The throwaway probe in the kickoff notes (step 2) exists to produce a real per-turn cost and latency estimate before the first full run. Do not guess and run; measure first.

## Risks and open questions

1. **Format divergence.** Two models executing the same framework will produce similar-but-not-identical schemas. If the schemas diverge enough to make reconciliation manual, the diff step gets expensive. Mitigation: tighten `audits/questionnaire.md` to prescribe the output format (section headers, table shape, finding severity labels) rather than suggesting it. This is a framework-file change that benefits Claude's output too — worth doing regardless of Codex.

2. **Cost and latency.** Codex is agentic — a full `/repo-dd`-equivalent audit could involve thousands of internal API calls and take several minutes wall clock. Don't put this in a tight loop. Treat it as an explicit, budgeted operation, not a routine session-wrap step.

3. **Auth state.** Confirm `codex login` status before first programmatic invocation. A stale or missing login will fail silently from a Bash tool call in ways that are hard to debug.

4. **Wrapper prompt contamination.** See pattern section above. The single most dangerous failure mode is subtle: Claude writing a "helpful" wrapper prompt that narrates what it found or flags areas of concern. Hard rule: wrapper prompts for Codex are paths + schema only, no prose framing.

5. **Negative-result scenario.** If the pilot shows Claude and Codex agree on everything, the hypothesis is wrong for this workspace and the pattern has limited value. This is a valid outcome — document it, stop, don't force expansion. A clean no is more valuable than a forced yes.

6. **Second-order risk: differential trust.** If operators start trusting Codex's findings more than Claude's (or vice versa) based on one model's "style," the pattern becomes a new bias rather than a bias-cancelling one. Treat both outputs as equally weighted evidence for the operator to reconcile. Resist any impulse to have one model "grade" the other.

## Next-session kickoff notes (for the session that picks this up)

Run these in order:

1. **Verify Codex auth.** `codex login` status check. Make sure you know what account is active and whether credentials will work from a Bash tool call.
2. **Throwaway `codex exec` probe.** Run a tiny real invocation — something like `codex exec -C <small repo> -s read-only "List the top-level directories and one-line describe each."` Observe: how does output stream? Is it stdout only, or does it write session files? What does the agent message format look like? This tells us how Claude will read the result back.
3. **Decide on output schema.** Read `audits/questionnaire.md` with fresh eyes and decide whether its output format is prescriptive enough for cross-model consistency, or whether it needs tightening before the pilot.
4. **Draft `/codex-dd` command.** Follow the conventions of existing commands in `.claude/commands/`. Keep it minimal — no scope args, no depth levels, no subagent launches. Single-shot wrapper.
5. **Run the pilot.** One real audit. Cost and wall-clock time are unknown in advance — the throwaway probe in step 2 is there specifically to produce a per-turn cost and latency estimate before committing to a full-repo run. If the probe suggests the full audit will be expensive or slow, narrow scope to a single repo (e.g., `ai-resources` only) for the first real run.
6. **Compare outputs manually.** Operator reads both `audits/repo-dd-<date>.md` and `reports/codex-dd-<date>.md` side by side. Note divergences. Decide whether to expand or stop.

## Session artifact references

Investigation was conducted in a conversational session on 2026-04-13. No code was written during the investigation — this brief is the only artifact and is self-sufficient for a future build session. Nothing else from the 2026-04-13 session needs to be reloaded to pick this up.

Framework files the pilot will depend on (verify these still exist and haven't moved when picking this up):

- `ai-resources/audits/questionnaire.md`
- `ai-resources/skills/ai-resource-builder/references/evaluation-framework.md`

Existing command referenced by the pilot (for output-path parallelism, not execution):

- `ai-resources/.claude/commands/repo-dd.md`
