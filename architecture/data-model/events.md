Events

Immutable log of all domain activity. Architecture (event bus, subscribers, async processing) to be designed once full functional requirements are known.

⸻

Schema

- id
- user_id
- domain
- event_type
- timestamp
- payload (type-specific structured data)
- artifact_ref (which artifact was created/modified)

⸻

Work Scope — Functional Requirements

Catalog of trigger → effect relationships that will flow through the event system. Architectural design deferred until requirements are complete.

Core loop:
- MealLog created → daily view recomputes
- MealLog refined → daily totals update
- Food/Recipe updated → active MealPlan recomputes (surfaced to user)
- Goal created → config effects written, ProseAttributes updated (intent echoed)
- Goal revised → config targets cascade, active MealPlan flagged
- MealPlan created → ShoppingList + CookingPlan generated
- MealPlan superseded → derived artifacts recompute

Data integrity:
- ProseAttribute mutated → previous version archived

Important:
- FactAttribute updated (weight, activity) → potential target reassessment flag
- Circumstance declared/resolved → MealPlan staleness check

Scheduled:
- Weekly cron → MacroReview + MealReview generated
- Monthly cron → monthly reviews generated

Engagement:
- Milestone reached (100 meals, 30 days) → milestone review/notification

Enhancement:
- Pattern detected → observation surfaced to user
