Recipe

A structured preparation method that transforms foods into a meal. Follows the same two-table pattern as Food (global + user, entity resolution).

⸻

Metadata Groupings

Identity (stable, objective, mandatory)
- id
- display_name ("Dal Tadka", "Overnight Oats", "Chicken Stir-Fry")
- slug
- aliases / regional_names
- Source: global catalog or user-created. Confidence: high.

Structural (stable, objective, mandatory)
- ingredients: [{ food_ref, quantity, unit, preparation }]
- method (prose — cooking steps)
- cooking_time_minutes
- serves
- Source: global catalog (curated) or user-created. Confidence: high (curated), medium (user/LLM-created).

Nutritional (stable, objective, mandatory — derived)
- computed_nutrition: derived from ingredient food refs + quantities
- per_serving_nutrition: computed_nutrition / serves
- Source: computed from ingredient foods. Confidence: inherits from ingredient food confidence.

Safety / Dietary (stable, objective, mandatory — derived)
- allergen_tags: union of all ingredient allergen tags
- dietary_flags: intersection of all ingredient dietary flags
- safety_flags: union of all ingredient safety flags
- Source: derived from ingredients. Confidence: inherits from ingredients. One flagged ingredient flags the recipe.

Categorical (stable, interpretive, enrichment)
- cuisine_tags: [indian_north, mediterranean, east_asian, ...]
- difficulty (easy / medium / advanced)
- meal_type_affinity: [breakfast, lunch, dinner, snack]
- Source: global catalog, LLM-suggested. Confidence: medium.

Source / Meta (mutable, objective, operational)
- source (system_database / user_created)
- status (active / deprecated)
- created_at, updated_at

⸻

Recipe Across Layers

Global Recipe — complete canonical record, all groupings.
User Recipe — user-scoped. Override mode (patches on global) or standalone (user's own recipes — most common case for recipes).
MealPlan recipe item — user_recipe_ref + display_name (copied) + serves_used + computed_nutrition (copied at build time).
