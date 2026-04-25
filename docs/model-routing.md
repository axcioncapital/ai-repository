# Model Routing

Single source of truth for which Claude model to use for which task in the Axcíon AI workspace. All CLAUDE.md files, the `model-classifier.sh` hook, `/prime`, and `/new-project` reference this document instead of restating the rule.

## The three-tier rule

> **Haiku scans. Sonnet executes. Opus judges.**

| Tier | Use for | Where invoked |
|------|---------|---------------|
| **Haiku** (`claude-haiku-4-5-20251001`) | Mechanical measurement: counts, file-existence checks, format compliance, structural inventory, link-checking. The answer is a number, a boolean, or a structured list — not interpretation. | Agent frontmatter only (`model: haiku`). Never `/model haiku` at the session level. |
| **Sonnet** (`claude-sonnet-4-6[1m]`) | Execution and structured factual work: routine edits, drafting from clear instructions, summarization, orchestration, repo operation, log appends, applying already-decided changes, following SOPs. | Session-level default (per project), command frontmatter (`model: sonnet`), agent frontmatter. |
| **Opus** (`claude-opus-4-7`) | Judgment: architecture decisions, plan review, debugging, QC and refinement, synthesis, strategic evaluation, ambiguity resolution, multi-step trade-off analysis. | Session-level via `/model opus`, command frontmatter (`model: opus`), agent frontmatter. |

## The decision question

Before choosing the model, ask:

> **Is the hard part deciding what should be done, or doing what has already been decided?**

If the hard part is **deciding** → Opus. If the hard part is **doing** → Sonnet. If the work is purely mechanical and answer-shaped → Haiku (agent only).

## Examples (Axcíon task types)

| Task | Tier | Why |
|------|------|-----|
| Apply an approved plan to files | Sonnet | Execution; decision already made. |
| Draft a research memo from notes | Sonnet | Structured drafting; quality bar is template-level. |
| Final critique of a research memo | Opus | Judgment about strategic soundness. |
| Run `/repo-dd` factual audit | Sonnet (orchestrator) + Opus (judgment subagents) | Mixed by stage. |
| `/token-audit` mechanical-section measurement | Haiku | Counts, sizes, structural facts. |
| Architectural decision: should X be a command, agent, or hook? | Opus | Judgment; mistakes compound. |
| Routine repo edits, log appends, session ops | Sonnet | Execution-tier orchestration. |
| Cluster analysis of audit findings | Opus | Pattern recognition; judgment about priority. |
| Counting CLAUDE.md tokens, listing broken refs | Haiku | Pure measurement. |

## Project-default architecture

The workspace has no global default model. Each project declares its own default in its `CLAUDE.md` Model Selection section:

- **Heavy execution → Sonnet default.** Most repo work, knowledge-base ops, operational projects.
- **Heavy judgment → Opus default.** Plan/spec drafting, identity drafting, strategic projects.
- **Mixed → Sonnet default with Opus opt-ins.** Most projects; commands/agents declare `model: opus` where judgment is needed.

**Sessions outside any project (workspace root) default to Sonnet for execution work; explicitly invoke `/model opus` for cross-project judgment work.**

The `model-classifier.sh` hook fires once per session on the first free-form prompt, classifies the task tier, compares against the active project's declared default, and recommends `/model` switch only when the gap is clear. Slash-command prompts skip the hook (the command's frontmatter declares its own tier).

## Session-level vs agent-level routing

Two layers, with different scopes:

- **Session-level** (`/model`) — the model the main agent runs on. Set by the operator at session start, recommended by the classifier hook, defaulting to the project's declared default. **Binary at session level: Sonnet or Opus.** Haiku is never recommended at the session level.
- **Agent-level** (`model:` in agent frontmatter) — the model a subagent runs on, independent of the session model. **All three tiers available.** Haiku is invoked only here.

The agent tier table at `ai-resources/docs/agent-tier-table.md` lists tier assignments for every agent in `ai-resources/.claude/agents/`.

## Mid-session escalation pattern

When work doesn't converge on the operating model, escalate via the **Model Escalation rule** in workspace `CLAUDE.md`. Triggers:

- Same task fails twice with similar errors.
- Output is plausible but shallow.
- Multiple constraints can't be reconciled.
- Operator says "this isn't converging" or "switch to Opus."

**Action:** Stop. Spawn an Opus subagent for diagnosis (root cause + correct target state + minimum next step; no implementation). Apply the diagnosis. Decide whether to continue on the current tier or escalate the session via `/model`.

**De-duplication:** Escalation does NOT fire while a QC → Triage Auto-Loop is in progress — the loop's existing Opus subagent passes are themselves the escalation.

## Cost ratios (for routing intuition)

| Tier | Input ($/MTok) | Output ($/MTok) | Relative cost vs Sonnet |
|------|---------------:|----------------:|------------------------:|
| Haiku | $1 | $5 | 0.33× / 0.33× |
| Sonnet | $3 | $15 | 1× / 1× |
| Opus | $5 | $25 | 1.67× / 1.67× |

Use the expensive tier where superior judgment changes the outcome. Default to Sonnet where execution is the bottleneck. Reach for Haiku where the answer is a number and the prompt is large.

## Identifier forms

Two forms in use, not interchangeable:

- **Short form** (`haiku` / `sonnet` / `opus`) — used in agent and slash-command frontmatter (`model:`). The harness resolves to the current model in that tier.
- **Full form** (`claude-opus-4-7`, `claude-sonnet-4-6[1m]`, `claude-haiku-4-5-20251001`) — used in project CLAUDE.md Model Selection sections and `.claude/settings.local.json` defaults, which need a harness-resolvable identifier.

Update full-form identifiers when Anthropic releases new model versions; the agent tier table and this doc are the canonical references for the current strings.
