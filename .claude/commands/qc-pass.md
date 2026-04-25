---
model: sonnet
---

Stop and run an independent QC pass on the work you just produced or proposed.

## Why a subagent?

You produced the work — you cannot objectively evaluate it. The QC reviewer runs as a separate agent with no access to your conversation, ensuring independent assessment per the QC Independence Rule.

## Steps

1. **Identify the artifact.** State in one line what you are QC'ing (a plan, a drafted file, an edit, a set of changes).

2. **Prepare the handoff.** Gather:
   - One-line description of the artifact
   - The file path(s) of the artifact, or the content if it hasn't been written to file yet
   - The original operator request (what was asked for — quote or paraphrase)
   - **Scope / artifact purpose** — one line stating what this artifact is supposed to be or do. Derive from the artifact itself + the last operator turn. This is distinct from the request: the request says "what the operator asked," scope says "what the artifact's job is." If you cannot derive confidently, state your best guess and mark it `(derived — please confirm)`.

3. **Launch the `qc-reviewer` subagent.** Pass it the four items above. Do NOT pass conversation history, your reasoning, or creation context. If the artifact is a substitution-shaped edit to a repo-infrastructure file (settings, command/agent definitions, SKILL.md, CLAUDE.md, hooks, prompts, analogous infra) — e.g., a string/typo fix, value edit, permission entry, path/key rename, reference update, or small wording correction — add `mechanical-mode: suggested` to the handoff. Do NOT add the hint when the artifact is a new file, introduces new sections/steps/rules, or involves structural reorganization or multi-paragraph prose rewrites. When in doubt, omit the hint and let the reviewer decide.

4. **Present the results.** Show the subagent's review to the operator exactly as returned. Do not filter or soften findings.

4a. **Confirm scope visibility.** The subagent's output includes the scope line it QC'd against in the header. If the operator disagrees with the scope as stated, they will re-invoke /qc-pass with a corrected scope; do not attempt to self-correct.

5. **Wait for direction.** The operator decides whether to act on findings.
