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

### Nutrition (first vertical)

| File | Role |
|---|---|
| [nutrition-model.md](nutrition/nutrition-model.md) | 3 entities, 6 artifacts, 8 tools (7 artifact + 1 state enabler) |
| [nutrition-context.md](nutrition/nutrition-context.md) | Nutrition-specific events, config, observations, memories |
| [nutrition-expertise.md](nutrition/nutrition-expertise.md) | 8 expertise components instantiated for nutrition, tiered |
| [nutrition-policy.md](nutrition/nutrition-policy.md) | Base + 8 prior-specific governance profiles + circumstances |
| [nutrition-orchestration.md](nutrition/nutrition-orchestration.md) | Transition maps, tool/artifact maps (structural) |
| [user-context-nutrition.md](nutrition/user-context-nutrition.md) | How User Context activates within nutrition + intent taxonomy |

## Key Design Decisions

- **Artifacts are domain imperatives** — they exist as domain needs before any tool creates them
- **Artifacts can create context side effects** — Goal sets Configuration + declared memories
- **Memories have two paths** — declared (cold start primer) and observed (events → observations → stabilized)
- **Two tool types** — artifact tools (artifact-scoped, one per artifact) and state enablers (domain-scoped)
- **Product constrains, policy governs, expertise solves** — no separate user policy layer
- **Policy governs expertise per prior** — each known prior modulates expertise components
- **Expertise has 8 components** — knowledge, assessment, recommendation, communication, empathy, evidence, boundaries, adaptation
- **Expertise tiers** — core (judgment), base+auxiliary (competence + depth), auxiliary (reference)
- **Circumstances are soft context** — suggestions, not hard overrides
- **Design = implementation** — expertise spec is the agent system prompt in an LLM system
