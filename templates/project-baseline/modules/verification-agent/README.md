# Module: Verification Agent

## When to Include

Projects with high-stakes outputs that need independent verification — where the cost of an incorrect conclusion or unsupported claim is significant. The verification agent reads source material independently, forms its own conclusions, and flags discrepancies with the main session's output.

Skip for projects where all outputs are low-stakes drafts or where QC gate reviews provide sufficient verification.

## What It Adds

1. **Agent definition** — A verification sub-agent that performs independent re-derivation and comparison

## How to Adapt

- The agent's tools (Read, Glob, Grep) are sufficient for most verification tasks. Add Write if the agent should save its analysis.
- The model defaults to sonnet (fast, cost-effective). Use opus for verification of complex analytical claims.
- The main agent controls when verification runs — there's no automation. Wire it into the project's workflow at appropriate checkpoints.
