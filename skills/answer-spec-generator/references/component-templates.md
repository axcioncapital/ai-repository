# Component Templates by Question Type

Reference file for answer-spec-generator. Contains base component sets for each question type. Component IDs are assigned at generation time using format Q[n]-A##.

The Default Claims column shows the standard expected range. Adjust for strictness: `strict` uses upper end, `light` uses lower end, `standard` uses midpoint. For Optional components, the lower bound is always 0 (evidence may not exist).

## Pattern

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Pattern inventory | Distinct approaches/models identified | 3–6 | Required |
| Pattern mechanics | How each pattern works: steps, decision points, timelines | 3–5 | Required |
| Variation drivers | Factors explaining why different actors use different patterns | 2–4 | Required |
| Prevalence signals | Which patterns are common vs. niche | 0–2 | Optional |

## Comparison

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Comparison dimensions | Axes on which subjects are compared | 3–5 | Required |
| Subject A model | How subject A operates/is structured | 3–5 | Required |
| Subject B model | How subject B operates/is structured | 3–5 | Required |
| Key differences | Specific points of divergence with evidence | 3–6 | Required |
| Implications | What differences mean in practice | 2–4 | Required |
| Contextual applicability | Conditions where each is preferable | 0–3 | Optional |

## Causal

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Causal mechanism | How the cause produces the effect | 2–4 | Required |
| Contributing factors | What influences the relationship strength/direction | 3–5 | Required |
| Evidence type | Indicators of causation vs. correlation | 2–3 | Required |
| Effect magnitude | Size/significance of impact | 0–3 | Optional |
| Boundary conditions | When the causal relationship holds/breaks | 0–2 | Optional |

## Forecasting

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Projection | The forecast itself (with timeframe) | 2–4 | Required |
| Underlying assumptions | What must hold for projection to be valid | 3–5 | Required |
| Scenarios | Alternative outcomes under different conditions | 2–4 | Required |
| Confidence indicators | Certainty level, range, or probability | 2–3 | Required |
| Leading indicators | Early signals to monitor | 0–3 | Optional |

## Definitional

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Core definition | Essential meaning | 2–3 | Required |
| Boundary cases | Edge cases, what's included/excluded | 2–4 | Required |
| Related concepts | Adjacent terms, how they differ | 0–3 | Optional |
| Common misconceptions | Frequent errors in understanding | 0–2 | Optional |

## Ecosystem/Landscape

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Actor inventory | Who operates in this space | 5–10 | Required |
| Actor categories | How actors group/segment | 3–5 | Required |
| Relationships and flows | How actors interact, what moves between them | 3–5 | Required |
| Power dynamics | Who has leverage, dependencies | 0–3 | Optional |
| Entry points | How new actors enter, barriers | 0–3 | Optional |

## Process/Workflow

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Process steps | Sequential stages | 5–10 | Required |
| Decision points | Where paths diverge | 3–5 | Required |
| Inputs and outputs | What each step requires/produces | 3–6 | Required |
| Variations | How process differs by context | 0–3 | Optional |
| Failure modes | Where process commonly breaks down | 0–3 | Optional |

## Diagnostics

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Symptom description | Observable problem | 2–3 | Required |
| Root causes | Underlying drivers | 3–5 | Required |
| Contributing factors | What amplifies or mitigates | 2–4 | Required |
| Causal chain | How root causes produce symptoms | 2–4 | Required |
| Intervention points | Where to act | 0–3 | Optional |

## Evaluation

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Evaluation criteria | Dimensions of assessment | 3–5 | Required |
| Performance assessment | How subject performs on each criterion | 3–6 | Required |
| Trade-offs | Where criteria conflict | 2–4 | Required |
| Comparative positioning | How subject ranks vs. alternatives | 0–3 | Optional |
| Recommendation logic | What evaluation implies for action | 0–3 | Optional |

## Recommendation

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Options inventory | Choices available | 3–6 | Required |
| Evaluation criteria | What matters for this decision | 3–5 | Required |
| Option assessment | Each option against criteria | 3–6 | Required |
| Constraints | What limits choices | 2–4 | Required |
| Recommended action | With rationale | 2–3 | Required |
| Implementation considerations | Next steps if recommendation adopted | 0–3 | Optional |

## Mapping

| Component | Description | Default Claims | Default Priority |
|-----------|-------------|----------------|------------------|
| Entity inventory | What exists | 5–10 | Required |
| Categorization scheme | How entities group | 3–5 | Required |
| Key attributes | Relevant characteristics per entity | 3–6 | Required |
| Gaps or white space | What doesn't exist but might | 0–3 | Optional |
