---
model: sonnet
---

# /session-guide — Progress View Generator

Produce a state-aware, Notion-ready view of where the operator is in the current project and what they should do next. Runs at any point during execution — read current state from disk, surface the next session(s), and write a clean markdown file the operator can copy-paste into Notion.

This is **not** a full project playbook. Playbooks live in the project plan; this command renders a view onto that plan scoped to whatever the operator needs right now.

## Step 1: Locate the project

The command runs in the current working directory. The project directory is the CWD unless the operator has invoked the command from a parent workspace — in that case, ask which project (present the directories under `projects/` and let them pick).

## Step 2: Ask for scope

Ask the operator one question before spawning the agent:

> "What scope? (1) Next session only. (2) Next N sessions — I'll ask how many. (3) Rest of current phase. (4) Full remainder."

Default to option (1) if the operator presses enter without choosing. If they pick (2), ask "How many?" and accept an integer. If the integer exceeds the remaining session count, the skill collapses to whatever's left — no error.

Map the operator's answer to one of: `next-session`, `next-N` (with integer), `phase`, `full`.

## Step 3: Spawn the agent

Spawn the `session-guide-generator` agent with a minimal prompt:

- Project directory path.
- Scope selection (e.g., `scope=next-session`, `scope=next-3`, `scope=phase`, `scope=full`).

The agent handles everything else: state detection, plan reading, rendering, file write, and completion checks. Do not pass conversation history, reasoning, or extra context — the agent's contract is self-contained.

## Step 4: Report back

When the agent returns, relay its summary to the operator: file path, scope, session count, current phase, and any state-detection caveats. Do not echo the rendered guide into chat — the operator reads the file directly.

## Notes

- **Output file is overwritten on each run.** Repeat invocations always replace the file with a fresh render. No versioning, no timestamped append. The local file is a current-state render; Notion is the distribution surface.
- **No plan = brief fallback.** If no project plan exists, the agent produces a short kickoff-orientation output pointing the operator to `/new-project`. It does not generate a full playbook.
- **Optional Pipeline Stage 6.** The same agent is used by `/new-project` at Stage 6. No changes needed to `/new-project` — state detection at project kickoff (all pending) naturally produces a `scope=full` kickoff view.
