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

A structured preparation method that transforms foods into a meal. Follows the same two-table pattern as Food (global + user, entity resolution).

Metadata groupings:

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

Recipe across layers:
Global Recipe — complete canonical record, all groupings.
User Recipe — user-scoped. Override mode (patches on global) or standalone (user's own recipes — most common case for recipes).
MealPlan recipe item — user_recipe_ref + display_name (copied) + serves_used + computed_nutrition (copied at build time).

Propagation: same rules as Food. Copy at build/log time. Active MealPlan recomputes on recipe update (surfaced). Safety resolves live.

Entity resolution: same pipeline as Food. LLM extraction → text/fuzzy search (MVP) → vector search (enhancement) → user table first → global → create standalone.

⸻

Artifacts

These are structured forms the domain produces. They have lifecycles, reference entities, and are scoped to a user.

⸻

Goal

One active Goal per domain. All artifacts implicitly serve the active Goal — no artifact-level goal scoping needed.

A tagged commitment. The statement is prose (the user's words). Tags are structural anchors at two levels for policy activation and product behavior.

- id
- user_id
- domain (nutrition)
- statement (prose: "Manage diabetes through diet, lose weight, eat better")
- tags: { [primary]: [secondary, ...], ... }
  Primary tags activate policy sets. Secondary tags give granularity.
  e.g., { medical: [diabetes_management, medication_aware_diet], body_composition: [weight_loss, caloric_deficit], behavioral: [mindful_eating] }
- targets: [{ metric, value, unit }] — optional, LLM-derived from statement + assessment
  e.g., [{ calorie_target, 1800, kcal/day }, { protein_target, 130, g/day }]
- config_effects: [{ key, value }] — LLM determines from statement + assessment
  e.g., [{ calorie_target, 1800 }, { macro_split, { protein: 30, carb: 40, fat: 30 } }]
- status (active / revised / retired)
- predecessor_id (if revised, which Goal it replaced)
- created_at, revised_at, retired_at

Primary tag vocabulary:
- medical — activates medical safety policies, disclaimers, medication awareness
- body_composition — caloric assessment, minimum floors, timeline validation
- performance — performance-specific nutrients, training-load awareness
- behavioral — qualitative goals allowed, pattern-focused reviews
- operational — execution-focused, practical artifacts prioritized

Secondary tags are granular sub-intents under each primary. Multiple primaries and multiple secondaries per primary — all that fit, applied.

Goal revision: when revised, config effects cascade. Active MealPlan flagged for recomputation. Prior Goal preserved with predecessor chain.

Memories: Goal statement echoes as a cross-domain memory in user context ("user wants to manage diabetes and lose weight"). Readable by other domains.

⸻

MealPlan

A temporal arrangement of intended meals. Implicitly serves the active Goal (no goal_ref needed — one Goal per domain).

- id
- user_id
- period (day / week)
- start_date, end_date
- context_snapshot: {
    config: { calorie_target, macro_split, dietary_type, meal_count, allergens },
    circumstances: [traveling, fasting, ...],
    key_memories: [avoids_eggs, doesnt_cook_weekdays, ...],
    goal_tags: { medical: [...], body_composition: [...] }
  }
- days: [
    {
      date,
      meals: [
        {
          meal_type (breakfast / lunch / dinner / snack),
          items: [{ user_food_ref, user_recipe_ref, display_name, quantity, unit, preparation }],
          computed_nutrition: { kcal, protein, carbs, fat } — copied at build time
        }
      ]
    }
  ]
- status (active / superseded)
- created_at, superseded_at, superseded_by

Context snapshot enables staleness detection: "Plan was built for travel. You're home now — rebuild?"
Propagation: copy at build. User food update → trigger recomputation event (surfaced). Safety resolves live.

⸻

MealLog

The load-bearing artifact of the nutrition domain. Everything downstream (reports, observations, reviews, patterns) depends on MealLog data quality. One per eating occasion.

- id
- user_id
- date
- time (optional — null for unstructured logs like "had some almonds today")
- meal_type (optional — breakfast / lunch / dinner / snack / null)
- items: [
    {
      user_food_ref,                  ← identity reference (user-local)
      display_name,                    ← copied (snapshot, never changes)
      quantity, unit,                  ← as declared by user ("1 bowl", "200g", "some")
      resolved_quantity, resolved_unit, ← system's best estimate in standard units
      preparation,                     ← optional (grilled, fried, raw)
      computed_nutrition: { kcal, protein, carbs, fat },  ← copied at log time
      confidence                       ← per-item: 0.0-1.0
    }
  ]
- plan_ref (if plan active — links to planned meal for comparison)
- context (optional prose: "ate out", "craving", "cooked at home", "skipped")
- skipped (boolean — explicit declaration of not eating)
- source (structured_input / plan_confirmed / plan_modified / prose_extracted / binary_checkin)
- raw_input (preserved if prose — "had dal rice and salad for lunch")
- confidence (overall log confidence — min or avg of item confidences)
- initial_confidence (what confidence was at first log — for refinement tracking)
- last_refined_at (timestamp of last refinement, null if never refined)

⸻

Input Modes

All modes produce the same MealLog schema. Source field captures which mode was used.

Structured: user picks food from list, enters quantity. No LLM needed. Confidence: 0.9-0.95.
Plan-confirmed: user confirms planned meal with one tap. Items copied from active MealPlan. Confidence: 0.8.
Plan-modified: user starts from plan, swaps/adjusts items. Confidence: 0.8-0.85.
Prose-extracted: user types natural language. LLM extracts items + entity resolution. Confidence: 0.5-0.7.
Binary check-in: "I had breakfast." No items, no detail. Confidence: 0.3.

⸻

Granularity Spectrum

Granularity is per-entry, not per-user. The tracking_granularity config sets the default logging surface, but any log can be at any level.

Precise: quantity in grams, weighed. Confidence: 0.95. Athletes, medical tracking.
Serving-based: standard servings ("1 bowl", "2 rotis"). Confidence: 0.8. Most users.
Qualitative: natural language, estimated portions ("big plate of dal rice"). Confidence: 0.5-0.7.
Binary: existence only ("had lunch"). Confidence: 0.3. Behavioral tracking.
Food without occasion: food specified, no meal_type or time ("had some almonds"). Confidence: 0.5.

Reports and observations treat confidence as signal — estimates get "~" prefix, behavioral language ("your protein looks low" vs "your protein is 52% below target").

⸻

Refinement

Logs can be refined upward in granularity after initial creation.

Rules:
- Add detail (binary → items, missing time → specific time) → always allowed
- Change substance ("actually had pasta not dal") → correction, original noted
- Downgrade → not applicable
- Refinement updates confidence, preserves initial_confidence for tracking

Example flow:
12:30 PM log: "had lunch" → binary, confidence: 0.3
 8:00 PM refine: adds "dal rice and roti" → confidence: 0.65, initial_confidence: 0.3

⸻

Skipped Meals

Explicit declaration of not eating. Distinct from "no log exists" (which could mean forgot to log).

MealLog { meal_type: lunch, skipped: true, items: [], confidence: 1.0, source: manual_entry }

Skipped meals are valuable signal for the report engine — fasting patterns, irregular eating, etc.

⸻

Plan Comparison

plan_ref links to the active MealPlan's corresponding meal slot. Enables:
- Adherence tracking (planned vs actual)
- Deviation detection (swapped foods, different portions)
- Report: "you followed your plan 4/7 days this week"

If no plan active, plan_ref is null. Comparison is downstream (report engine), not stored in MealLog.

Safety: allergen and safety flags always resolve live from user_food_ref.

⸻

Review

A structured analysis output. Snapshot in time.

- id
- user_id
- period: { start_date, end_date }
- type (summary / comparison / pattern)
- metrics_snapshot (the report data at review time — numerical)
- narrative (LLM-generated prose — the observation layer)
- observations: [{ content, type, evidence_count }]
- created_at

Immutable once created. Captures what was true and what the LLM assessed at that point.

⸻

ShoppingList

Derived from an active MealPlan. Recomputes if plan recomputes.

- id
- user_id
- plan_ref
- items: [{ user_food_ref, display_name, total_quantity, unit, category }]
- categories (grouped: produce, protein, dairy, pantry, etc.)
- created_at

⸻

CookingPlan

A preparation strategy derived from a MealPlan + Recipes. Recomputes if plan recomputes.

- id
- user_id
- plan_ref
- prep_sessions: [
    {
      date,
      tasks: [{ user_recipe_ref, recipe_name, prep_steps, batch_quantity }]
    }
  ]
- assembly_guide (how to assemble meals from prepped components)
- created_at

⸻

Domain Context

Configuration (structured operational parameters — primarily set by Goal side effects)
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

Memories are tagged for retrieval by the context composer. Tags determine which memories are scoped into which surfaces (HP03).

⸻

Events (immutable log)

- id
- user_id
- domain (nutrition)
- type (meal_logged / plan_created / plan_modified / goal_set / goal_revised / review_completed / pattern_detected / shopping_list_generated / cooking_plan_generated / food_updated / exception_declared / signal_reported)
- timestamp
- payload (type-specific structured data)
- artifact_ref (which artifact was created/modified)

Events feed the report engine (HP02). Event-driven computation triggers report recomputation.

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
- engagement_level (browsing / goal_setting / committed) — computed metric (HP02)

Circumstances
- user_id
- active_circumstances: [{ type, description, status (upcoming / active / resolving), start_date, expected_end }]

Intents (created as Goal side effects, cross-domain readable)
- user_id
- active_intents: [{ primary_tag, secondary_tags, goal_ref, domain }]

User Configuration
- user_id
- notification_frequency
- proactivity_level
- data_density (numbers / qualitative)
- tone (direct / gentle)
- planning_rigidity (precise / loose)
- autonomy_vs_guidance

