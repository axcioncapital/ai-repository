# Component Templates by Question Type

Reference file for answer-spec-generator. Contains base component sets for each question type. Component IDs are assigned at generation time using format Q[n]-A##.

## Pattern

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Pattern inventory | Distinct approaches/models identified | Required |
| Pattern mechanics | How each pattern works: steps, decision points, timelines | Required |
| Variation drivers | Factors explaining why different actors use different patterns | Required |
| Prevalence signals | Which patterns are common vs. niche | Optional |

## Comparison

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Comparison dimensions | Axes on which subjects are compared | Required |
| Subject A model | How subject A operates/is structured | Required |
| Subject B model | How subject B operates/is structured | Required |
| Key differences | Specific points of divergence with evidence | Required |
| Implications | What differences mean in practice | Required |
| Contextual applicability | Conditions where each is preferable | Optional |

## Causal

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Causal mechanism | How the cause produces the effect | Required |
| Contributing factors | What influences the relationship strength/direction | Required |
| Evidence type | Indicators of causation vs. correlation | Required |
| Effect magnitude | Size/significance of impact | Optional |
| Boundary conditions | When the causal relationship holds/breaks | Optional |

## Forecasting

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Projection | The forecast itself (with timeframe) | Required |
| Underlying assumptions | What must hold for projection to be valid | Required |
| Scenarios | Alternative outcomes under different conditions | Required |
| Confidence indicators | Certainty level, range, or probability | Required |
| Leading indicators | Early signals to monitor | Optional |

## Definitional

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Core definition | Essential meaning | Required |
| Boundary cases | Edge cases, what's included/excluded | Required |
| Related concepts | Adjacent terms, how they differ | Optional |
| Common misconceptions | Frequent errors in understanding | Optional |

## Ecosystem/Landscape

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Actor inventory | Who operates in this space | Required |
| Actor categories | How actors group/segment | Required |
| Relationships and flows | How actors interact, what moves between them | Required |
| Power dynamics | Who has leverage, dependencies | Optional |
| Entry points | How new actors enter, barriers | Optional |

## Process/Workflow

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Process steps | Sequential stages | Required |
| Decision points | Where paths diverge | Required |
| Inputs and outputs | What each step requires/produces | Required |
| Variations | How process differs by context | Optional |
| Failure modes | Where process commonly breaks down | Optional |

## Diagnostics

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Symptom description | Observable problem | Required |
| Root causes | Underlying drivers | Required |
| Contributing factors | What amplifies or mitigates | Required |
| Causal chain | How root causes produce symptoms | Required |
| Intervention points | Where to act | Optional |

## Evaluation

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Evaluation criteria | Dimensions of assessment | Required |
| Performance assessment | How subject performs on each criterion | Required |
| Trade-offs | Where criteria conflict | Required |
| Comparative positioning | How subject ranks vs. alternatives | Optional |
| Recommendation logic | What evaluation implies for action | Optional |

## Recommendation

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Options inventory | Choices available | Required |
| Evaluation criteria | What matters for this decision | Required |
| Option assessment | Each option against criteria | Required |
| Constraints | What limits choices | Required |
| Recommended action | With rationale | Required |
| Implementation considerations | Next steps if recommendation adopted | Optional |

## Mapping

| Component | Description | Default Priority |
|-----------|-------------|------------------|
| Entity inventory | What exists | Required |
| Categorization scheme | How entities group | Required |
| Key attributes | Relevant characteristics per entity | Required |
| Gaps or white space | What doesn't exist but might | Optional |
