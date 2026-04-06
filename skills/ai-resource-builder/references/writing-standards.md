# Writing Standards & Anti-Patterns

## Table of Contents

1. [Degrees of Freedom](#degrees-of-freedom)
2. [Anti-Railroading](#anti-railroading)
3. [Capability vs. Preference Skills](#capability-vs-preference-skills)
4. [Bias Countering](#bias-countering)
5. [Time-Sensitive Information](#time-sensitive-information)
6. [Skills vs. MCP Servers](#skills-vs-mcp-servers)
7. [Skill Composition](#skill-composition)
8. [Anti-Patterns](#anti-patterns)

## Degrees of Freedom

Match specificity to the task's fragility and variability:

- **High freedom** (text instructions): Multiple valid approaches. Use for analysis, recommendations, style guidance.
- **Medium freedom** (pseudocode/parameterized): Preferred pattern with some variation. Use for workflow steps, data processing.
- **Low freedom** (exact scripts, few params): Fragile operations requiring strict consistency. Use for API calls, migrations, deployments.

## Anti-Railroading

If you find yourself writing ALWAYS or NEVER in all caps, or enforcing super-rigid structures, reframe and explain the reasoning instead. Claude works better understanding *why* a constraint matters than following rote rules.

**Skill obsolescence risk:** As models improve, skills that over-specify can degrade output. The skill constrains Claude to follow steps written for a less capable version. Periodically compare skill output vs. no-skill output. If raw Claude wins, simplify or retire the skill.

## Capability vs. Preference Skills

- **Capability skills** extend what the base model can do (complex PDF extraction, specialized transforms). Need more procedural detail but may become obsolete as models improve.
- **Preference skills** encode how you want work done (your formatting, review process, brand voice). Durable because preferences don't change when models do. Most skills worth building are preference skills.

## Bias Countering

For analytical/generative skills: permit "I don't know," accept gaps over invention, encourage pushback on flawed premises, prioritize accuracy over comprehensiveness.

## Time-Sensitive Information

Don't embed information that will become outdated. If historical context is useful, isolate it in a collapsible "old patterns" section with a date stamp.

## Skills vs. MCP Servers

Skills provide procedural knowledge (how to use tools). MCP servers provide tool access (connecting to external systems). They are complementary. When an MCP server primarily provides guidance rather than tool connectivity, a skill may serve the same purpose with the advantage of transparency.

## Skill Composition

When skills form natural chains (research -> analysis -> document production):
- Design compatible output formats between pipeline stages
- Keep each skill independently invocable — even in a pipeline, each should work standalone
- Don't build monolithic orchestrator skills that just call other skills in sequence

## Anti-Patterns

| Anti-Pattern | Why It Fails | Instead |
|---|---|---|
| Over-specifying with rigid MUSTs/NEVERs | Makes output rigid, degrades as models improve | Explain the *why*, use flexible templates |
| Vague descriptions | Skill never triggers | Include specific trigger phrases and file types |
| Trigger phrases past 250 characters | Claude never sees them — descriptions truncated | Front-load key use case within first 250 chars |
| No negative triggers on overlapping skills | Wrong skill fires | Add "Do NOT use for..." to delineate boundaries |
| Not using `paths` field | Every skill burns context every session | Scope skills to relevant directories |
| Deeply nested references (>1 level) | Claude partially reads or misses content | Keep all references one level from SKILL.md |
| Mixing multiple jobs in one skill | Hard to trigger, hard to maintain | One skill, one job |
| Skills >500 lines without splitting | Context bloat, important rules lost | Split into reference files |
| Deterministic checks in skill body | Not guaranteed to run, wastes reasoning | Convert to hooks |
| "Voodoo constants" in scripts | Claude can't determine the right value | Document why every constant is what it is |
| Inconsistent terminology | Confuses Claude's understanding | Pick one term per concept |
| Keeping dead skills | Consume description budget, risk false triggers | Retire skills that haven't triggered in weeks |
| Offering too many options | Confuses Claude, wastes tokens | Provide a default with an escape hatch |
| Teaching Claude what it already knows | Token waste, may constrain better default behavior | Only add non-obvious context |
