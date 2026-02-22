Data Model

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

Propagation Rules

When user updates their food/recipe (bowl size, nutritional variant, name):

MealLog (past): never propagate. Immutable snapshot. Historical accuracy.
Active MealPlan: copy at build, trigger recomputation event on user food update. Surfaced change — not silent.
Superseded MealPlan: never propagate. Historical, like past logs.
ShoppingList: recompute if plan recomputes (derived).
Review: never propagate. Snapshot of analysis at review time.
Future MealLogs: use updated values from next log onward.

Exception — Safety: allergen and safety flags always resolve live from user_food_ref. Safety over historical consistency.

⸻

Entity Resolution (prose → entity_id)

When user input is prose, the system must resolve extracted names to entity IDs.

Pipeline: LLM extraction + entity resolution.

Step 1: LLM extracts entity info from prose → { name, quantity, description }
Step 2: Entity resolution → search user table first, then global catalog
Step 3: High confidence → auto-resolve. Low confidence → clarify. No match → create standalone user entity (LLM estimates data).
Step 4: If resolved from global → fork to user table (first-use flow).

MVP: text search + fuzzy matching + alias lookup.
Enhancement: vector search (not mandatory scope).

This pattern applies to all base entities (Food, Recipe) across all domains.

⸻

Catalog

Base Entities:
- food.md — Food (single edible item with nutritional properties)
- recipe.md — Recipe (structured preparation method)

Artifacts:
- goal.md — Goal (tagged commitment, one per domain)
- meal-plan.md — MealPlan (temporal arrangement of intended meals)
- meal-log.md — MealLog (load-bearing artifact — record of what was eaten)
- nutrition-review.md — NutritionReview (MacroReview + MealReview, extensible)
- shopping-list.md — ShoppingList (derived from MealPlan)
- cooking-plan.md — CookingPlan (derived from MealPlan + Recipes)

Context & Infrastructure:
- domain-context.md — Configuration, Memories
- events.md — Events (immutable log)
- user-context.md — User Context (cross-domain)
