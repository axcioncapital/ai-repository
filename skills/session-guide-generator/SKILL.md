---
name: session-guide-generator
description: >
  Generates a state-aware, scope-flexible, Notion-ready progress view for a Claude Code project.
  Reads the project plan as the spine and scans the project directory to detect current state, then
  renders what the operator should do next. Use when the operator says "session guide," "what's next,"
  "where are we," "create a session guide," or runs /session-guide. Also used as optional Stage 6 of
  /new-project. Do NOT use for project planning (use implementation-project-planner), testing
  (use project-tester), or post-session token analysis (use session-usage-analyzer).
---

# Session Guide Generator

## Role + Scope

**Role:** You are a progress narrator, not a playbook author. Your job is to answer "where is the operator in this project, and what do they need to do next?" — producing a clean markdown view that pastes directly into Notion.

**What this skill does:**
- Reads the project plan as the spine (phases, sessions, prep items).
- Scans the project directory to detect current state — leanly, stopping at the first reliable signal.
- Reads only the in-scope portion of the plan based on the operator's chosen scope.
- Renders a Notion-ready view: "Where You Are" → "What's Next" → "After This Scope."

**What this skill does NOT do:**
- Author a full execution playbook (the current project-plan or `/new-project` does that).
- Re-estimate session counts or boundaries (trust the plan's existing decomposition).
- Map plan components to available infrastructure (skip the repo-state scan — not load-bearing for progress narration).
- Plan the project (that's implementation-project-planner).
- Analyze token usage from past sessions (that's session-usage-analyzer).

**Key distinction from `session-usage-analyzer`:** That skill analyzes *completed* sessions for token efficiency. This skill narrates *current and upcoming* sessions for execution. Complementary — run this before each session, session-usage-analyzer after.

---

## Input Expectation

### From the caller

The spawning command or agent passes:
- **Project directory path** (required).
- **Scope selection** (required): one of `next-session`, `next-N` (with N), `phase`, or `full`.

### Files the agent reads

**Project plan (spine, required):**
- Canonical location: `{project}/pipeline/project-plan.md`.
- Fallback: `Glob` for plan-shaped files at project root (names containing `plan` or `spec`) if no `pipeline/` directory. If multiple matches, prefer `project-plan.md`, then `plan.md`, then the alphabetically first.
- Read strategy is **bounded by scope** — see Workflow Step 3.

**CLAUDE.md** (project context) — read once, typically short.

**State detection files** — scanned via the cascade in Workflow Step 2.

### Files the agent does NOT read

- `skills/`, `.claude/commands/`, `.claude/agents/` directories — repo-state scan is skipped. The plan already describes what's next; mapping components is not load-bearing.
- Reference artifacts (`architecture.md`, `implementation-spec.md`, `test-results.md`, etc.) — read **only** if the in-scope session's "Before you start" / prerequisites block in the plan explicitly names them. Not inferred — named. Avoids circular "read to know what to read."

---

## Workflow

Progress: [ ] Receive scope [ ] Detect state [ ] Read plan slice [ ] Render output [ ] Write + verify

### Step 1: Receive scope

The caller passes scope. Accept:
- `next-session` → produce exactly one session block.
- `next-N` with a count → produce N session blocks.
- `phase` → produce all remaining sessions in the current phase.
- `full` → produce all remaining sessions to the end of the project.

### Step 2: Detect state (token-lean cascade)

Scan in priority order. **Stop at the first confident read.** Never exceed 2–3 files for state determination.

1. **`{project}/pipeline/pipeline-state.md`** — if present, read in full (small). Parse the stage status table. This is the authoritative completion signal. If this tells you where you are, stop.
2. **`{project}/pipeline/implementation-log.md`** — read only if pipeline-state.md showed an implementation stage is `in_progress` and you need finer granularity. Use `Grep` for the latest status line, then `Read` with offset/limit around it. Do not read the whole log.
3. **`{project}/logs/session-notes.md`** — rolling append-only log. Read only the latest entry:
   - `Grep -n "^## \d{4}-\d{2}-\d{2}"` to list all date headers with line numbers. (Regex assumes ISO `YYYY-MM-DD` headers; other formats fall through to later tiers.)
   - Take the last match.
   - `Read` with `offset = that line` and `limit = 80` (a generous but bounded slice).
   - Extract the `### Next Steps` block if present.
   - Do not read the whole log file.
4. **Status markers in the plan** — fallback only if no `pipeline/` or `logs/` exists. During the plan read (Step 3), watch for `- [x]`, `✅`, or "Session N — complete" style markers.
5. **Ask the operator** — single short question: "Looks like you're at {best guess} — is that right?" Only if tiers 1–4 yielded nothing confident.

Emit one line of state-detection output to your working memory for Step 4 rendering: current phase name, last completed session/work unit, next session identifier.

### Step 3: Read the in-scope plan section(s)

Build a heading index first — cheap, no full read:
- `Grep -n "^## "` and `Grep -n "^### "` to locate phase and session headings with line numbers.

Then read only what scope requires:

| Scope | Read |
|-------|------|
| `next-session` | The in-scope session's block only (from its `### ` heading to the next sibling heading). Use `Read` with `offset` + `limit`. |
| `next-N` | The blocks for the N in-scope sessions. If they span phases, cross phase boundaries. |
| `phase` | The full in-scope phase section (one phase heading through the next). |
| `full` | The full plan (unavoidable at this scope). |

**Reference artifacts:** scan the in-scope "Before you start" / prerequisites block for named references. Read those files (and only those files). If a named reference is missing from disk, note it in the rendered output — do not search for substitutes.

### Step 4: Render the output

Use the template in the "Output Template" section below. Fill each placeholder with content drawn from the state-detection output (Step 2) and the in-scope plan section (Step 3).

- **Prep items come from the plan verbatim.** Copy the plan's "Before you start" bullets — do not paraphrase, summarize, or infer.
- **Objective is one sentence from the plan.** If the plan's objective is longer, select the most informative single sentence; do not invent one.
- **Steps and checkpoints** are compressed from the plan — keep them short but faithful. No invention.
- **Where You Are** is populated from Step 2's state-detection output.
- **After This Scope** is one short paragraph summarizing what's left beyond the covered sessions.

### Step 5: Write to disk, verify, return summary

**Save path:**
- `{project}/pipeline/session-guide.md` if a `pipeline/` directory exists.
- `{project}/session-guide.md` at project root otherwise.

**Overwrite** any existing file at that path — repeat runs always replace. This is operator-confirmed; no timestamping, no versioning.

**Completion checks before announcing success:**
1. Output file exists at the declared path.
2. Output file contains **no** Claude-Code wrapper content: no frontmatter, no preamble ("Here's the guide..."), no conversation artifacts, no closing signoff.
3. Scope-appropriate session count: matches what the operator asked for.
4. "Where You Are" section is populated from detection, not placeholder text.

If any check fails, report it explicitly and do not announce success.

**Summary to main session** (Subagent Contract compliance, <30 lines):
- Output file path.
- One line: scope + session count (e.g., "scope=next-session, 1 session rendered").
- Current phase identified.
- Any state-detection caveats (e.g., "pipeline-state.md not found; used session-notes fallback").

---

## Output Template

The rendered file contains only this content — nothing else.

```markdown
# Session Guide — {project-name}

**Generated:** {YYYY-MM-DD}
**Scope:** {next session / next N / rest of current phase / full remainder}

## Where You Are

- **Current phase:** {phase name}
- **Last completed:** {session or work unit, from state detection}
- **Up next:** {one-line description of what's immediately ahead}

## What's Next

### Session {N}: {title from plan}

**Objective:** {one sentence from the plan}

**Before you start:**
- {Prep items surfaced verbatim from the plan}

**What you'll do:**
1. {Step from plan}
2. {Step from plan}

**You'll know it worked when:** {one-line checkpoint from the plan}

---

{Repeat the session block for each session in scope. Separator between sessions is `---`.}

## After This Scope

{One short paragraph: "After these sessions, you'll be at {point in arc}. Full remainder: {N sessions across M phases}." Give macro context without restating the plan.}
```

**Tone:** Informative and operator-facing. Minimize Claude-Code jargon. Keep slash commands literal only when instructing the operator to run something specific (e.g., "run `/wrap-session` when done").

**Deliberately removed** vs. the old playbook template: troubleshooting tables, Definition of Done, detailed per-session steps, "If something goes wrong" sections, top-of-file journey map. These belong in the underlying project plan, not in a progress view.

---

## No-Plan Fallback

If no project plan is found (no `pipeline/project-plan.md`, no plan-shaped files at project root), produce a **brief kickoff-orientation output** — not the old skill's full playbook:

```markdown
# Session Guide — {project-name or directory name}

**Generated:** {YYYY-MM-DD}
**Status:** No project plan found.

## Before you plan sessions

This project doesn't have a plan yet. A real session guide needs a plan as its spine.

## Next step

{One short paragraph based on what's in the directory — e.g., "You have a spec at {path}. Next step: run /new-project to produce a project-plan.md, then re-run /session-guide here." Or if the directory is empty: "Start by running /new-project from an outline or brief."}
```

Ask **one short question** only if the directory is completely empty: "What does this project deliver? (one sentence)" — use the answer to fill the "Next step" paragraph. Do not ask multiple structured questions.

---

## Failure Behavior

- **No project plan, no directory contents:** Ask one question, produce the no-plan fallback. Do not halt.
- **No project plan, directory has other files:** Produce the no-plan fallback referencing the files found. Do not halt.
- **State detection ambiguous** (tiers 1–4 inconclusive): Ask one short question at runtime. Do not guess silently.
- **Scope exceeds plan** (e.g., `scope=full` but only one session remains): Collapse to available sessions. Note in "After This Scope": "This covers the final session."
- **Plan and `pipeline-state.md` disagree on session count or order:** Flag in the output ("State note: pipeline-state shows X completed, plan has Y sessions — investigate"). Treat `pipeline-state.md` as authoritative for completion status, plan as authoritative for content.
- **Reference artifact named in plan but missing from disk:** Note in the output's "Before you start" block ("referenced doc `{path}` not found"). Do not search for substitutes.
- **Primary document appears incomplete or draft:** Flag in the output. Proceed only if the operator's scope request can be satisfied from what's present.

---

## Runtime Recommendations

- **Model:** No specific requirement — the agent definition pins `sonnet` for this skill's structured factual work.
- **Context:** The skill is designed to run in a small context. The state-detection cascade + bounded plan reads should rarely exceed a few thousand tokens of file input.
- **Pipeline position:** Optional Stage 6 of `/new-project`. When invoked there, `pipeline-state.md` will show setup stages completed and all session work pending — produces a `scope=full` kickoff view in the new leaner template.

---

## Quality Criteria

A good session guide produced by this skill:
- **Notion-paste-ready.** Output file contains only the rendered guide — no frontmatter, no preamble, no scaffolding.
- **Token-scaled to scope.** `scope=next-session` mode reads materially fewer files than `scope=full`.
- **Prep items verbatim from the plan.** Not inferred, not rephrased.
- **"Where You Are" is accurate** against the detected state — not placeholder text, not guessed.
- **Tone is informative, not cautionary.** No "be careful to check X" hedging. The plan has the details; the guide is a view.
- **Scope-appropriate session count.** `scope=1` produces one session block, not three.

A bad session guide:
- Includes Claude-Code frontmatter, preamble, or trailing commentary in the output file.
- Reads every artifact in the project directory regardless of scope.
- Paraphrases prep items instead of copying them verbatim.
- Shows placeholder text in "Where You Are" because state detection was skipped.
- Reproduces the old playbook structure (troubleshooting tables, Definition of Done per session).
- Asks the operator a structured multi-question interrogation when tiered state detection could have answered.
