---
model: opus
---

Produce a faithful, information-dense summary of a long document.

Arguments: $ARGUMENTS

## Execution

1. Parse `$ARGUMENTS` into a source path (required) and optional flags (`--target`, `--output`, `--force`).
2. Read `skills/summary/SKILL.md` for the full methodology (fidelity rules, execution workflow, failure behavior, validation checklist).
3. Execute the skill against the parsed arguments. Follow the workflow in order; do not skip the verification pass before writing.
4. Deliver the completion report in the format shown in the skill's Example section.

## When to stop

- Source path missing or not readable → abort with a clear error; do not infer a path.
- Requested target below 2% of source word count → abort with a feasibility message.
- Output path exists and `--force` not set → abort; state the path.

## Notes

- This command is the thin invocation surface for the `summary` skill. All methodology lives in `skills/summary/SKILL.md`.
- Not for code files, reference data, analytical reframing, or trivially short inputs.
