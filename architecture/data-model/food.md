Food

A single edible item with nutritional properties.

⸻

Metadata Groupings

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
