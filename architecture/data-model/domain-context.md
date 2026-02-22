Domain Context

⸻

Configuration

Nutrition-specific operational parameters. Some set at onboarding, most set by Goal side effects.

Each field has metadata: criticality, expiry, who-writes.

| Field | Value Type | Criticality | Expiry | Who Writes | Description |
|---|---|---|---|---|---|
| dietary_exclusions | Enum[] | Critical | Stable | User only | Hard ingredient exclusions. no_meat, no_beef, no_pork, no_fish, no_eggs, no_dairy, no_gluten, no_onion_garlic (jain). Safety — never violated by plan or suggestion. |
| allergy_exclusions | Enum[] | Critical | Stable | User only | FDA/EU Big 14 allergens. peanuts, tree_nuts, shellfish, dairy, eggs, soy, wheat, fish, sesame, mustard, celery, lupin, mollusks, sulfites. Safety-critical — blocks at plan build and food suggestion. |
| calorie_target | Numeric | High | Until goal revision | Goal (LLM-derived) | kcal/day target. Computed from weight, height, sex, activity, goal. |
| macro_split | Object | Medium | Until goal revision | Goal (LLM-derived) | { protein_pct, carb_pct, fat_pct }. Derived from goal tags and expertise judgment. |
| meal_count | Numeric (1-6) | Medium | Stable | User + LLM | Meals per day. User declares preference, LLM may suggest adjustments. |
| fasting_window | String | Low | Stable | User only | e.g., "16:8". Optional. Affects meal timing in plans. |
| tracking_granularity | Enum | Low | Stable | User + LLM | exact / approximate. Sets default logging surface. LLM may suggest adjustment based on user behavior. |

Criticality:
- Critical: must collect at onboarding. Safety-affecting — plans and suggestions must respect these unconditionally.
- High: needed before plan building. Affects nutritional calculations.
- Medium: improves plan quality. System can default if missing.
- Low: optional enrichment.

Who writes:
- User only: system never sets or overrides. User declares directly.
- Goal (LLM-derived): side effect of Goal creation. LLM computes from user attributes + goal statement.
- User + LLM: user declares, LLM may suggest changes based on observed patterns.

⸻

Memories

Durable domain-scoped truths. The system's "notebook" about the user within nutrition.

- id
- user_id
- domain (nutrition)
- content (prose: "avoids eggs even though not allergic", "prefers high-protein breakfast", "cooks only on weekends")
- strength (constraint / preference / observation)
  - constraint: hard rule, affects plan safety ("no eggs" — not a declared allergy, but a firm no)
  - preference: soft signal, improves plan quality ("prefers South Indian breakfast")
  - observation: system-noticed pattern ("tends to eat late dinners on weekdays")
- path (declared / observed)
- source (user / goal / system_observation)
- tags: [food_preference, behavioral, cooking, medical, timing, ...]
- created_at
- confidence (for observed memories — 0.0-1.0)

Memories are tagged for retrieval by the context composer. Tags + strength determine which memories are scoped into which surfaces (HP03).

Constraint memories are treated as hard rules by the planner. Preference memories are optimization inputs. Observation memories are context for the expertise narrative.
