# Core Model

The foundational architecture for a behavioral product space.

## Architecture

```
Product Principles (constrain)
    ↓
User Context + Domain Context (inform)
    ↓
Domain Policies (solve)
```

**Product Principles** define non-negotiable behavioral constraints — universal across all domains.

**User Context** describes the person — attributes, traits, circumstances, intents, configuration. Cross-domain.

**Domain Model** defines the structure of a behavioral domain — states, transitions, entities, artifacts, tools.

**Domain Context** captures the accumulated reality of a domain — events, configuration, observations, memories.

**Domain Policy** operates within product constraints, reads both contexts, and determines what should happen.

## Files

### Horizontal (domain-agnostic)

| File | Role |
|---|---|
| [product-principles.md](horizontal/product-principles.md) | Non-negotiable behavioral constraints |
| [domain-model.md](horizontal/domain-model.md) | 5 primitives: States, Transitions, Entities, Artifacts, Tools |
| [domain-context.md](horizontal/domain-context.md) | 4 context categories: Events, Configuration, Observations, Memories |
| [user-context.md](horizontal/user-context.md) | 5 components: Attributes, Traits, Circumstances, Intents, Configuration |
| [domain-policy.md](horizontal/domain-policy.md) | Policy framework placeholder |

### Nutrition (first vertical)

| File | Role |
|---|---|
| [nutrition-model.md](nutrition/nutrition-model.md) | 3 entities, 5 artifacts, 7 tools |
| [nutrition-context.md](nutrition/nutrition-context.md) | Nutrition-specific events, config, observations, memories |
| [user-context-nutrition.md](nutrition/user-context-nutrition.md) | How User Context activates within nutrition + intent taxonomy |
| [policy-scoping-notes.md](nutrition/policy-scoping-notes.md) | Scenario-based policy scoping notes |

## Key Design Decisions

- **Artifacts are domain imperatives** — they exist as domain needs before any tool creates them
- **Memories have two paths** — declared (cold start primer) and observed (events → observations → stabilized)
- **Product constrains, context informs, domain solves** — no separate user policy layer
- **Circumstances are soft context** — suggestions, not hard overrides
