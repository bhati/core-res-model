Domain Context

⸻

Configuration

Nutrition-specific constraints. Only fields that are genuinely unique to the nutrition domain and can't live anywhere else. Everything else lives on Goal (targets), as a Memory (preferences), or as User Configuration (presentation).

| Field | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| dietary_exclusions | Enum[] | Yes | Stable | User only |
| allergy_exclusions | Enum[] | Yes | Stable | User only |

dietary_exclusions vocabulary: no_meat, no_beef, no_pork, no_fish, no_eggs, no_dairy, no_gluten, no_onion_garlic (jain).
allergy_exclusions vocabulary: peanuts, tree_nuts, shellfish, dairy, eggs, soy, wheat, fish, sesame, mustard, celery, lupin, mollusks, sulfites (FDA/EU Big 14).

Both are safety-critical. Plans and suggestions must never violate these.

Calorie targets, macro splits → Goal.targets.
Fasting window → Memory (constraint strength).
Meal structure → MealPlan builder decides from context.
Tracking granularity → User Configuration (presentation).

⸻

Memories

Durable domain-scoped truths. The system's "notebook" about the user within nutrition.

- id
- user_id
- domain (nutrition)
- content (prose: "avoids eggs even though not allergic", "prefers high-protein breakfast", "does 16:8 intermittent fasting")
- strength (constraint / preference / observation)
  - constraint: hard rule, affects plan safety
  - preference: soft signal, improves plan quality
  - observation: system-noticed pattern, used as context
- path (declared / observed)
- source (user / goal / system_observation)
- tags: [food_preference, behavioral, cooking, medical, timing, ...]
- created_at
- confidence (for observed memories — 0.0-1.0)

Memories are tagged for retrieval by the context composer. Tags + strength determine scoping (HP03).
