Domain Context

⸻

Configuration

Nutrition-specific operational parameters. Some set at onboarding, most set by Goal side effects.

Field schema: each field has required (boolean), entropy, and who_writes.

| Field | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| dietary_exclusions | Enum[] | Yes | Stable | User only |
| allergy_exclusions | Enum[] | Yes | Stable | User only |
| calorie_target | Numeric | Yes | Changes on goal revision | Goal (LLM-derived) |
| macro_split | Object { protein_pct, carb_pct, fat_pct } | No | Changes on goal revision | Goal (LLM-derived) |
| meal_count | Numeric (1-6) | No | Stable | User + LLM |
| fasting_window | String (e.g., "16:8") | No | Stable | User only |
| tracking_granularity | Enum (exact/approximate) | No | Stable | User + LLM |

dietary_exclusions vocabulary: no_meat, no_beef, no_pork, no_fish, no_eggs, no_dairy, no_gluten, no_onion_garlic (jain).
allergy_exclusions vocabulary: peanuts, tree_nuts, shellfish, dairy, eggs, soy, wheat, fish, sesame, mustard, celery, lupin, mollusks, sulfites (FDA/EU Big 14).

Who writes:
- User only: system never sets or overrides.
- Goal (LLM-derived): side effect of Goal creation. LLM computes from user attributes + goal statement.
- User + LLM: user declares, LLM may suggest changes.

⸻

Memories

Durable domain-scoped truths. The system's "notebook" about the user within nutrition.

- id
- user_id
- domain (nutrition)
- content (prose: "avoids eggs even though not allergic", "prefers high-protein breakfast", "cooks only on weekends")
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
