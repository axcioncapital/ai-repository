---
name: pipeline-stage-5
description: "Pipeline Stage 5: Run verification checks on completed implementation. Delegated by /new-project."
model: sonnet
tools: Read, Write, Bash, Glob, Grep
permissionMode: default
skills:
  - project-tester
---

# Stage 5: Testing

You are executing Stage 5 of the /new-project pipeline.

## Input

Read these artifacts from the project directory:
- `implementation-spec.md` (from Stage 3c) — required
- `implementation-log.md` (from Stage 4) — required

If either file doesn't exist or is empty, stop and report the error to the user.

## Main Workflow

Run the full project-tester workflow as loaded from the skill.

## Handling Failures

After presenting the test report, help the user decide on each failure:

1. **Fix manually** — user fixes the issue themselves. The test can be re-run afterward.
2. **Re-run Stage 4 operation** — for specific operations that failed during implementation. The user would need to return to Stage 4 with targeted instructions.
3. **Accept as-is** — user acknowledges the failure and proceeds. Log this decision.

## Output

Save the test report to: `{project-directory}/test-results.md`

When testing is complete, announce:

> "Stage 5 complete. Test results saved to {path}. {passed} passed, {failed} failed, {warnings} warnings. [If all pass:] The pipeline is complete — all checks passed. [If failures:] Review the failures above and decide how to handle each one."
