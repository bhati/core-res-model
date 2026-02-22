# Core Model

The foundational architecture for a behavioral product space.

## Architecture

```
Product Principles (constrain — universal)
    ↓
Domain Policy (govern — domain-specific)
    ↓
Domain Expertise (solve — domain-specific)

All layers read: User Context + Domain Context
```

**Product Principles** define non-negotiable behavioral constraints — universal across all domains.

**User Context** describes the person — attributes, traits (including engagement level), circumstances, intents, configuration. Cross-domain.

**Domain Model** defines the structure of a behavioral domain — states, transitions, entities, artifacts, tools (artifact tools + state enablers).

**Domain Context** captures the accumulated reality of a domain — events, configuration, observations, memories (declared + observed paths).

**Domain Expertise** is the domain expert's methodology — knowledge, assessment, recommendation, communication, empathy, evidence-based reasoning, boundaries, adaptation. Tiered: core (judgment, can't outsource), base+auxiliary (base competence + consulted depth), auxiliary (pure reference).

**Domain Policy** governs how expertise operates for known priors and foreseeable dangers — base policies (always active) + prior-specific policies (per condition × expertise components) + circumstance modulation.

## Files

### Horizontal (domain-agnostic)

| File | Role |
|---|---|
| [product-principles.md](horizontal/product-principles.md) | Non-negotiable behavioral constraints (9 dimensions) |
| [domain-model.md](horizontal/domain-model.md) | 5 primitives: States, Transitions, Entities, Artifacts, Tools |
| [domain-context.md](horizontal/domain-context.md) | 4 context categories: Events, Configuration, Observations, Memories |
| [user-context.md](horizontal/user-context.md) | 5 components: Attributes, Traits, Circumstances, Intents, Configuration |
| [domain-expertise.md](horizontal/domain-expertise.md) | 8 expertise components + 3 tiers (core, base+aux, aux) |
| [domain-policy.md](horizontal/domain-policy.md) | Policy as expertise governance for known priors |

### Architecture

| File | Role |
|---|---|
| [HP01-system-architecture.md](architecture/HP01-system-architecture.md) | Entity/memory-first, LLM for pathways and skill |
| [HP02-observation-computation.md](architecture/HP02-observation-computation.md) | Deterministic reports, dual-rendered observations |
| [HP03-context-scaling.md](architecture/HP03-context-scaling.md) | Surface-scoped context |
| [HP04-core-challenges.md](architecture/HP04-core-challenges.md) | Prose ↔ structure, context drift |
| [HP05-input-pattern.md](architecture/HP05-input-pattern.md) | Three-section composition surface (HP05a) + validation gate (HP05b) |
| [llm-pipeline.md](architecture/llm-pipeline.md) | 5 LLM call types: tool judgment, content fill, composition, escape hatch, conversational |
| [navigation.md](architecture/navigation.md) | 4-tab model: Where You Left Off, Timeline, Browse, You |
| [engineering-blocks.md](architecture/engineering-blocks.md) | 6 engineering blocks + coverage map |
| [open-questions.md](architecture/open-questions.md) | Tracked open questions |
| [data-model/](architecture/data-model/) | Entity schemas: food, recipe, meal-log, meal-plan, nutrition-goal, nutrition-review, events, user-context |

### Nutrition (first vertical)

| File | Role |
|---|---|
| [nutrition-model.md](nutrition/nutrition-model.md) | Entities, artifacts, tools (needs update) |
| [nutrition-context.md](nutrition/nutrition-context.md) | Nutrition-specific events, config, observations, memories |
| [nutrition-expertise.md](nutrition/nutrition-expertise.md) | 8 expertise components instantiated for nutrition, tiered |
| [nutrition-policy.md](nutrition/nutrition-policy.md) | Base + 8 prior-specific governance profiles + circumstances |
| [user-context-nutrition.md](nutrition/user-context-nutrition.md) | How User Context activates within nutrition (needs update) |

### User Journeys

| File | Role |
|---|---|
| [log-a-meal.md](user-journeys/log-a-meal.md) | Meal logging: two surfaces × two input methods |
| [set-a-goal.md](user-journeys/set-a-goal.md) | Goal setting: validation gate + composition |
| [build-a-plan.md](user-journeys/build-a-plan.md) | Meal planning: rolling event-driven suggestion layer |
| [day-view.md](user-journeys/day-view.md) | Living Document surface with zoom (Y-M-W-D) |

## Key Design Decisions

- **Artifacts are domain imperatives** — they exist as domain needs before any tool creates them
- **Artifacts can create context side effects** — Goal sets Configuration + declared memories
- **Memories have two paths** — declared (cold start primer) and observed (events → observations → stabilized)
- **Two tool types** — artifact tools (artifact-scoped, one per artifact) and state enablers (domain-scoped)
- **Product constrains, policy governs, expertise solves** — no separate user policy layer
- **Hard shells, LLM-filled content** (HP01) — deterministic structure, LLM for judgment and prose
- **Composition call pattern** (HP05a) — multi-turn structured output with code-enforced boundaries
- **Validation gate** (HP05b) — three-tier pass/warn/block for consequential artifacts
- **4-tab navigation** — Where You Left Off, Timeline, Browse, You
- **Onboarding = WYLO zero state** — not a separate journey
- **Weekly review = Timeline at ◉W zoom** — not a separate journey
- **MealPlan is a rolling suggestion layer** — event-driven, opt-in, scope: meal/day/week

