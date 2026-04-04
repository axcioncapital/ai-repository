# Quality Standards

## Core QC Principles

- QC checks are deterministic — evaluate against stated criteria, not subjective quality judgments
- QC is separated from remediation — identify problems first, fix separately
- Every finding carries severity (BLOCKING / NON-BLOCKING) and a proposed fix
- Cross-context verification: QC runs in a fresh sub-agent to avoid self-evaluation bias

## Verdict Definitions

| Verdict | Meaning | Action |
|---------|---------|--------|
| **PASS** | All criteria met | Proceed to next stage |
| **CONDITIONAL PASS** | Minor issues only, none blocking | Proceed after applying non-blocking fixes |
| **FAIL** | One or more blocking issues | Fix blocking issues and re-run QC |

## Finding Format

Each QC finding must include:
- **Criterion:** Which evaluation criterion it relates to
- **Status:** MET / PARTIALLY MET / UNMET
- **Severity:** BLOCKING / NON-BLOCKING
- **Description:** Specific description of what is wrong or missing
- **Proposed fix:** What should change to resolve it

## QC Independence Rule

Evaluation and QC must happen with fresh context to avoid self-evaluation bias. Run evaluators as sub-agents — separate Claude instances that receive only the relevant instructions and the artifact under review, with no knowledge of the creation conversation.
