Domain Context

⸻

Configuration

Nutrition-specific constraints. Only safety-critical fields that can't live anywhere else.

| Field | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| dietary_exclusions | Enum[] | Yes | Stable | User only |
| allergy_exclusions | Enum[] | Yes | Stable | User only |

dietary_exclusions vocabulary: no_meat, no_beef, no_pork, no_fish, no_eggs, no_dairy, no_gluten, no_onion_garlic (jain).
allergy_exclusions vocabulary: peanuts, tree_nuts, shellfish, dairy, eggs, soy, wheat, fish, sesame, mustard, celery, lupin, mollusks, sulfites (FDA/EU Big 14).

Both are safety-critical. Plans and suggestions must never violate these.

Calorie targets, macro splits → Goal.targets.
Fasting window → Memory (dietary_notes or meal_routines).
Meal structure → MealPlan builder decides from context.
Tracking granularity → User Configuration.

⸻

Memories

Structured profile sections for the nutrition domain. Each memory type is a single prose blob — a living document that captures a facet of the user's relationship with food.

Mutation model: when new information arrives, the system takes the original memory + the change and the LLM merges them into a new prose document. The original is versioned, never silently overwritten.

Memory inventory:

| Memory Type | Criticality | Entropy | Who Writes | Description |
|---|---|---|---|---|
| dietary_notes | High | Stable | LLM + user | How the user eats — cuisine, lifestyle, soft intolerances. e.g., "Vegetarian, North Indian household. Lactose sensitive but eats yogurt. Prefers home-cooked meals." |
| food_avoidances | Medium | 30 days | LLM + user | Soft nos — taste/preference-based. Not allergies (config), not dietary exclusions (config). e.g., "Doesn't like bitter gourd. Avoids raw onion. Gets bored of oats quickly." |
| food_preferences | Medium | 30 days | LLM + user | Positive affinities — foods they enjoy. e.g., "Loves paneer in any form. Enjoys South Indian breakfast. Likes smoothies after workouts." |
| meal_routines | Medium | 30 days | LLM + user + system | Typical eating patterns by occasion. e.g., "Light breakfast around 8am. Heavy lunch. Dinner by 8pm. Snacks mid-afternoon at work." |
| cooking_habits | Medium | 30 days | LLM + user | How the user relates to cooking. e.g., "Only cooks on weekends. Meal preps Sunday evenings. Uses air fryer. Partner cooks weekday dinners." |

Criticality: High = used in every plan/suggestion. Medium = enrichment, improves quality.
Entropy: Stable = rarely changes. 30 days = may evolve as system learns more about the user.
Who writes: LLM can update from observations (MealLog patterns, conversation), user can declare/correct.

Memory retrieval: the context composer selects relevant memories by type when assembling prompts. MealPlan builder reads dietary_notes + food_avoidances + food_preferences + meal_routines + cooking_habits. Review reads meal_routines. Expertise reads all.
