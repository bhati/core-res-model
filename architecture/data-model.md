Data Model — Entity and Artifact Catalog
Design principles:
- Reference for identity, clone for context.
- Two-table pattern for all base entities: global (system-curated) + user-scoped (personal).

⸻

Base Entity Storage Pattern

All base entities (Food, Recipe) follow the same two-table pattern:

Global table — system-curated catalog. Never directly referenced by user data. Serves as the upstream source that user records are forked from. May be LLM-seeded and refined over time based on usage importance.

User table — user-scoped. The single referencing target for all artifacts and user data. Two modes:
- Standalone: user-created entity with no global equivalent ("mom's rajma", "my protein shake")
- Override: forked from a global entity, inherits all fields, patches specific overrides ("my version of paneer — different fat content"). An override with zero overrides is a thin pointer — a bookmark that inherits dynamically.

Referencing rule: all artifacts (MealPlan, MealLog, ShoppingList, etc.) reference user_food.id or user_recipe.id. Never global IDs. This gives one foreign key pattern, self-contained user data, and clean deletion/export.

First-use flow: when a user logs or references a food for the first time, the system creates a user-scoped record forked from the global catalog (override mode, no overrides). From that point on, the user's record is the reference.

Global updates flow through: override mode inherits dynamically from global. If global updates chicken breast nutrition, users see it — unless they've overridden that specific field.

This pattern applies to all base entities across all domains.

⸻

Base Entities (Reference Data)

These are canonical, shared. Artifacts reference them by identity and clone their context at point of use.

⸻

Food

A single edible item with nutritional properties.

Metadata groupings:

Identity (stable, objective, mandatory)
- id
- display_name ("Chicken Breast", "Paneer", "Brown Rice")
- slug (chicken-breast, paneer, brown-rice)
- aliases / regional_names
- Source: global catalog or user-created. Confidence: high.

Nutritional (stable, objective, mandatory)
- nutrition_per_100g: { kcal, protein_g, carbs_g, fat_g, fiber_g }
- micronutrients: { iron_mg, calcium_mg, vitamin_c_mg, folate_mcg, ... }
- glycemic_index (low / medium / high)
- Source: food databases (USDA, IFCT) for global; LLM-estimated for user-created. Confidence: high (database), medium (LLM), low (user-guessed).

Safety / Dietary (stable, objective, mandatory)
- allergen_tags: [gluten, dairy, nuts, peanuts, shellfish, eggs, soy]
- dietary_flags: [vegetarian, vegan, jain, halal, kosher]
- safety_flags: [raw_fish, unpasteurized, high_caffeine, high_mercury]
- Source: global catalog (curated, lab-tested). Confidence: high.

Practical (mutable, subjective, mandatory for logging)
- typical_serving: { quantity, unit }
- common_units: [piece, cup, tablespoon, slice, handful, bowl]
- Source: conventions (global), user overrides. Confidence: medium.

Categorical (stable, mostly objective, enrichment)
- food_group (protein, grain, vegetable, fruit, dairy, legume, nut, oil_fat, spice, beverage)
- sub_category (poultry, red_meat, fish; leafy, root, cruciferous)
- Source: nutritional science taxonomy. Confidence: high.

Cultural / Culinary (stable, interpretive, enrichment)
- cuisine_associations: [indian_north, indian_south, mediterranean, east_asian, ...]
- common_preparations: [grilled, fried, steamed, raw, boiled, roasted]
- Source: global catalog, LLM-suggested. Confidence: medium (interpretive).

Source / Meta (mutable, objective, operational)
- source (system_database / user_created)
- status (active / deprecated)
- created_at, updated_at

⸻

Food Across Four Layers

Global Food — complete canonical record, all groupings.

User Food — user-scoped. Thin by default (override mode, no overrides = bookmark). Enriched over time with overrides and behavioral data (first_used_at, last_used_at, usage_count).

MealPlan food item (embedded within plan):
- user_food_ref — reference for traceability
- display_name — copied at build time
- quantity, unit, preparation — plan-specific
- computed_nutrition — copied at build time

MealLog food item (embedded within log):
- user_food_ref — reference for traceability
- display_name — copied at log time
- quantity, unit, preparation — what was actually eaten
- computed_nutrition — copied at log time, immutable

⸻

Propagation Rules

When user updates their food (bowl size, nutritional variant, name):

MealLog (past): never propagate. Immutable snapshot. Historical accuracy.
Active MealPlan: copy at build, trigger recomputation event on user food update. Surfaced change — not silent. System can notify: "Paneer changed. Plan's daily total moved from 1800 to 1830 kcal."
Superseded MealPlan: never propagate. Historical, like past logs.
ShoppingList: recompute if plan recomputes (derived).
Review: never propagate. Snapshot of analysis at review time.
Future MealLogs: use updated values from next log onward.

Exception — Safety: allergen and safety flags always resolve live from user_food_ref. If a food is later flagged with an allergen, all references (including past logs) can surface this retroactively. Safety over historical consistency.

⸻

Food Entity Resolution (prose → food_id)

When user input is prose ("I had poha for breakfast"), the system must resolve the extracted food name to a food_id.

Pipeline: LLM extraction + entity resolution.

Step 1: LLM extracts food info from prose → { name, quantity, meal_type, description }
Step 2: Entity resolution → search user food table first, then global catalog
Step 3: High confidence match → auto-resolve. Low confidence or ambiguous → clarify with user. No match → create standalone user food (LLM estimates nutrition).
Step 4: If resolved from global → fork to user table (first-use flow).

MVP resolution: text search + fuzzy matching + alias lookup. Handles exact matches and common variations.

Enhancement: vector search. Pre-compute embeddings for all foods (name + aliases + description). At resolution time, embed the extracted description, search vector space. Handles semantic matching ("flattened rice thing" → "poha"), regional variations, and novel descriptions. Not mandatory scope — treat as progressive enhancement over text search.

This pattern applies to all base entities (Food, Recipe) across all domains.

Recipe

A structured preparation method that transforms foods into a meal.

- id
- name ("dal tadka", "overnight oats", "chicken stir-fry")
- ingredients: [{ food_ref, quantity, unit, preparation }]
- method (prose — cooking steps)
- cooking_time_minutes
- serves
- computed_nutrition (derived from ingredients)
- cuisine_tags: [indian_north, mediterranean, east_asian, ...]
- dietary_flags (derived from ingredient flags)

⸻

Artifacts

These are structured forms the domain produces. They have lifecycles, reference entities, and are scoped to a user.

⸻

Goal

A commitment the user makes. Creates side effects in config, memories, and intents.

- id
- user_id
- statement (prose: "Lose weight at 1800 kcal/day")
- intent_category (body_composition / performance / medical / behavioral / operational)
- targets: [{ metric, value, unit, timeframe }]
  e.g., [{ calorie_target, 1800, kcal/day, ongoing }, { protein_target, 130, g/day, ongoing }]
- side_effects:
  - config_updates: [{ key, value }]
  - memories_created: [{ content, type }]
  - intent_created: { category, sub_intent }
- status (active / revised / retired)
- predecessor_id (if revised, which Goal it replaced)
- created_at, revised_at, retired_at

⸻

MealPlan

A temporal arrangement of intended meals.

- id
- user_id
- period (day / week)
- start_date, end_date
- goal_ref (which Goal this serves)
- config_snapshot: { calorie_target, macro_split, dietary_type, meal_count, allergens }
- days: [
    {
      date,
      meals: [
        {
          meal_type (breakfast / lunch / dinner / snack),
          items: [{ food_ref, recipe_ref, quantity, unit, preparation }],
          computed_nutrition: { kcal, protein, carbs, fat }
        }
      ]
    }
  ]
- status (active / superseded)
- created_at, superseded_at, superseded_by

⸻

MealLog

A record of what was actually eaten. Immutable.

- id
- user_id
- date, time
- meal_type (breakfast / lunch / dinner / snack)
- items: [
    {
      food_ref,                    ← identity reference
      food_name,                    ← cloned (snapshot)
      quantity, unit, preparation,
      computed_nutrition: { kcal, protein, carbs, fat }  ← cloned at log time
    }
  ]
- plan_ref (if a plan was active — links to planned meal for comparison)
- context (optional prose: "ate out", "craving", "cooked at home")
- source (manual_entry / quick_capture / structured_input)

⸻

Review

A structured analysis output. Snapshot.

- id
- user_id
- period: { start_date, end_date }
- type (summary / comparison / pattern)
- goal_ref (benchmarked against which Goal)
- metrics_snapshot (the report data at review time — numerical)
- narrative (LLM-generated prose — the observation layer)
- observations: [{ content, type, evidence_count }]
- created_at

⸻

ShoppingList

Derived from an active MealPlan.

- id
- user_id
- plan_ref
- items: [{ food_ref, food_name, total_quantity, unit, category }]
- categories (grouped: produce, protein, dairy, pantry, etc.)
- created_at

⸻

CookingPlan

A preparation strategy derived from a MealPlan.

- id
- user_id
- plan_ref
- prep_sessions: [
    {
      date,
      tasks: [{ recipe_ref, recipe_name, prep_steps, batch_quantity }]
    }
  ]
- assembly_guide (how to assemble meals from prepped components)
- created_at

⸻

Domain Context

Configuration (structured operational parameters)
- user_id
- dietary_type (omnivore / vegetarian / vegan / pescatarian / ...)
- calorie_target (kcal/day)
- macro_split: { protein_pct, carb_pct, fat_pct }
- meal_count (meals per day)
- fasting_window (e.g., 16:8)
- allergens: [list]
- tracking_granularity (exact / approximate)

Memories (durable domain-scoped truths)
- id
- user_id
- domain (nutrition)
- content (prose: "avoids eggs", "prefers high-protein breakfast")
- path (declared / observed)
- source (user / goal / system_observation)
- tags: [food_preference, behavioral, cooking, medical, ...]
- created_at
- confidence (for observed memories)

⸻

Events (immutable log)

- id
- user_id
- domain (nutrition)
- type (meal_logged / plan_created / plan_modified / target_set / target_revised / review_completed / pattern_detected / shopping_list_generated / exception_declared / signal_reported)
- timestamp
- payload (type-specific structured data)
- artifact_ref (which artifact was created/modified)

⸻

User Context (cross-domain)

Attributes
- user_id
- age, sex, height, weight
- chronic_conditions: [diabetes_type1, diabetes_type2, pcos, kidney_disease, heart_disease, thyroid, ...]
- pregnancy_status (none / pregnant_trimester_1/2/3 / breastfeeding)

Traits
- user_id
- traits: [{ content, source (declared / observed) }]
- engagement_level (browsing / goal_setting / committed) — computed metric

Circumstances
- user_id
- active_circumstances: [{ type, status (upcoming / active / resolving), start_date, expected_end }]

Intents
- user_id
- active_intents: [{ category, sub_intent, goal_ref, domain }]

User Configuration
- user_id
- notification_frequency
- proactivity_level
- data_density (numbers / qualitative)
- tone (direct / gentle)
- planning_rigidity (precise / loose)
- autonomy_vs_guidance
