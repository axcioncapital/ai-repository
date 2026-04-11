---
name: intake-processor
description: >
  Two-stage intake processing for the macro knowledge base. Stage A: decompose
  raw notes into atomic content units (claims, observations, questions). Stage B:
  route each unit to a primary theme, assign cross-theme tags, assign confidence
  levels, and output proposed entries + batch manifest to _staging/. Trigger when
  the /kb-ingest command is run. Do NOT use for theme population runs (those use
  /kb-populate which has its own source discovery step) or for direct filing of
  entries (that is /kb-review).
---

# Intake Processor Skill

## 1. Role + Scope

You decompose raw, unstructured notes into atomic knowledge base entries and route them to themes.

**Reads:**
- `macro-kb/_meta/taxonomy.md` — theme slugs, names, tiers, clusters, scope descriptions
- `macro-kb/_meta/confidence-rubric.md` — confidence level definitions
- `macro-kb/_meta/templates/atomic-entry-template.md` — entry format

**Writes:**
- `macro-kb/_staging/` only — proposed entry files + one batch manifest YAML

**Hard constraint:** You NEVER write to theme folders. All output goes to `_staging/`.

---

## 2. Stage A — Decomposition

Parse the raw input (which may be messy, multi-theme, multi-source notes) and identify distinct content units.

**Rules:**

- **Entry boundary rule:** One entry = one coherent idea with a single dominant theme. If a paragraph contains two distinct analytical claims about different structural dynamics, it becomes two entries. If two paragraphs develop the same idea from different angles, they stay as one entry.
- Identify distinct content units — separate ideas, claims, or questions within the input.
- Separate content into three types per entry:
  - **Claims:** Factual assertions and analytical observations from sources
  - **Questions Raised:** Open questions prompted by the material
  - **Personal Notes:** Patrik's own thinking, reactions, hypotheses, skepticism
- Preserve source attributions — author names, publication names, links. Attribute as specifically as the raw notes allow. Never strip attribution.
- Do NOT make routing decisions in Stage A. Only structural decomposition.

**Output of Stage A:** A list of candidate content units, each with content type labels and attribution. No routing decisions yet.

---

## 3. Stage B — Routing

For each candidate unit from Stage A:

1. Read `macro-kb/_meta/taxonomy.md` for available themes, their slugs, tiers, clusters, and scope descriptions.

2. **Primary theme rule:** The primary theme is determined by where the decision-making impact lies, not where the topic is mentioned most. A claim about energy prices causing industrial relocation routes to `energy-crisis` if the analytical weight is on energy dynamics, or to `european-deindustrialization` if the weight is on industrial consequences.

3. Assign cross-theme tags — other themes this entry touches. Reference taxonomy.md to ensure all cross-theme slugs are valid.

4. Assign confidence levels using the confidence rubric (`macro-kb/_meta/confidence-rubric.md`):
   - `high`: specific, sourced claim from credible authority with identifiable evidence base
   - `medium`: sourced claim or established analytical position, indirect evidence
   - `low`: personal observation, loosely attributed, conventional wisdom without specific evidence
   - `speculative`: forward-looking projection, hypothesis, explicit uncertainty

5. **Uncertain routing rule:** When you cannot confidently assign a primary theme, set `theme: uncertain` rather than guessing. Uncertain entries are surfaced prominently during review for manual resolution. This prevents silent misrouting — the single most damaging failure mode.

6. Assign a `routing_confidence` field (high/medium/low) indicating how confident the routing is.

7. Flag entries with `multi-theme-ambiguity` when the entry touches 3+ themes.

8. Flag entries with `low-confidence-routing` when routing_confidence is low.

**Additional field assignment rules:**

- Never route to a theme that doesn't exist in taxonomy.md.
- `bootstrap` field: set based on the `ingest_mode` parameter passed by the calling command. Set `true` only when `ingest_mode` is `bootstrap`.
- `source_type`: infer from the content — `youtube`, `podcast`, `book`, `article`, `news`, `research`, or `personal-analysis`.
- `source_mode`: set based on context — `training-data` (if Claude is generating from training knowledge), `web-research` (if from web sources), `personal-notes` (if from Patrik's own notes).

---

## 4. Output Format

For each entry, write a markdown file to `macro-kb/_staging/` following the atomic entry template format. Filename format: `YYYY-MM-DD-source-slug-topic-slug.md`.

Write one batch manifest YAML to `macro-kb/_staging/` following the batch manifest schema. Filename format: `batch-YYYY-MM-DD-NNN.yaml` where NNN is a zero-padded sequence number (start at 001, increment by checking existing manifests in `_staging/`).

The batch manifest must include:
- `batch_id`: matching the filename (e.g., "2026-04-10-001")
- `source_input`: path to the original input (relative to macro-kb/)
- `ingest_mode`: as provided by the calling command (personal-intake, theme-population, bootstrap)
- `created`: ISO 8601 timestamp
- `status`: "pending_review"
- `entries[]`: one entry per proposed file with:
  - `filename`: proposed filename
  - `proposed_theme`: primary theme slug
  - `cross_themes`: array of cross-theme slugs
  - `confidence`: high | medium | low | speculative
  - `routing_confidence`: high | medium | low
  - `source`: source attribution string
  - `title`: descriptive title
  - `flags`: array of flag strings (multi-theme-ambiguity, low-confidence-routing, etc.)
- `unresolved[]`: entries with uncertain routing or notable ambiguities, each with:
  - `entry`: filename reference
  - `issue`: description of the ambiguity

---

## 5. Routing Summary

After writing all files, produce a routing summary for the operator:

```
Intake processed: N entries from [source description]

-> theme-slug: Entry title [confidence level]
-> theme-slug: Entry title [confidence level]
...

! Attention required:
-> [uncertain] Entry X — could route to theme-a or theme-b
-> [low-confidence routing] Entry Y — routed to theme-c but weak fit
-> [3+ cross-themes] Entry Z touches N themes — verify primary theme assignment

Themes with new cross-references: theme-a, theme-b, theme-c

Review? [confirm / edit / reject]
```

Entries with uncertain or low-confidence routing are surfaced in the "Attention required" section. This creates friction only where routing is likely wrong.

---

## Key Behaviors

- Never merge distinct analytical claims into one entry — always split.
- Never route to a theme that doesn't exist in taxonomy.md.
- Always flag uncertainty rather than guessing.
- Source attribution must be as specific as the raw notes allow — never strip attribution.
- Very large note dumps (20+ distinct ideas) should be flagged to the operator with a suggestion to split the input before processing.
