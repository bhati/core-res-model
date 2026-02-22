Data Model — Entity and Artifact Catalog
Design principles:
- Reference for identity, clone for context.
- Two-table pattern for all base entities: global (system-curated) + user-scoped (personal).

⸻

Base Entity Storage Pattern

All base entities (Food, Recipe) follow the same two-table pattern:

Global table — system-curated, shared, immutable by users. Canonical reference data. May be LLM-seeded and refined over time based on usage importance.

User table — user-scoped. Two modes:
- Standalone: user-created entity with no global equivalent ("mom's rajma", "my protein shake")
- Override: references a global entity, patches specific fields ("my version of paneer — different fat content")

Resolution: merge(global, user_overrides) → effective entity. Check user table first, fall back to global. Override mode stores only changed fields — like CSS inheritance.

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

Nutritional (stable, objective, mandatory)
- nutrition_per_100g: { kcal, protein_g, carbs_g, fat_g, fiber_g }
- micronutrients: { iron_mg, calcium_mg, vitamin_c_mg, folate_mcg, ... }
- glycemic_index (low / medium / high)

Safety / Dietary (stable, objective, mandatory)
- allergen_tags: [gluten, dairy, nuts, peanuts, shellfish, eggs, soy]
- dietary_flags: [vegetarian, vegan, jain, halal, kosher]
- safety_flags: [raw_fish, unpasteurized, high_caffeine, high_mercury]

Practical (mutable, subjective, mandatory for logging)
- typical_serving: { quantity, unit }
- common_units: [piece, cup, tablespoon, slice, handful, bowl]

Categorical (stable, mostly objective, enrichment)
- food_group (protein, grain, vegetable, fruit, dairy, legume, nut, oil_fat, spice, beverage)
- sub_category (poultry, red_meat, fish; leafy, root, cruciferous)

Cultural / Culinary (stable, interpretive, enrichment)
- cuisine_associations: [indian_north, indian_south, mediterranean, east_asian, ...]
- common_preparations: [grilled, fried, steamed, raw, boiled, roasted]

Source / Meta (mutable, objective, operational)
- source (system_database / user_created)
- status (active / deprecated)
- created_at, updated_at

⸻

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
