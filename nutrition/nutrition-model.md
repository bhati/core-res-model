Nutrition Model

(Vertical Instantiation of Domain Model)

⸻

1. Purpose

This document instantiates the Domain Model for the nutrition domain.

It defines the domain-specific entities, artifacts, and tools that give the nutrition domain its shape. States and transitions are inherited from the horizontal model; this document specifies how they express within nutrition and where the domain's gravitational center lies.

⸻

2. States (Nutrition Expression)

The four states apply universally. In nutrition, they express as:

Learn — Explore nutritional science, food properties, dietary approaches. Understand what foods do and why certain patterns help.

Plan — Structure eating intention. Define what to eat, when, how much. Set targets, constraints, and weekly shapes.

Do — Execute: eat, cook, order, prep, log, capture. Live action in the real world.

Analyze — Observe outcomes, detect patterns, reflect on what worked.

⸻

3. Entities

Entities are the domain-specific nouns. In nutrition:

Food — A single edible item with nutritional properties.
Examples: chicken breast, brown rice, almond milk, banana.

Meal — A structured eating occasion composed of foods.
Examples: breakfast (oats + banana + coffee), lunch (rice + dal + salad).

Recipe — A structured preparation method that transforms foods into a meal.
Examples: dal tadka, chicken stir-fry, overnight oats.

These are the atomic nouns of the nutrition domain. All tools, artifacts, and context are ultimately about Food, Meals, and Recipes.

⸻

5. Artifacts

Artifacts are the structured forms the nutrition domain demands exist.

MealPlan — A temporal arrangement of intended meals. The domain cannot function in Plan without this. It defines what the user intends to eat over a period.

MealLog — A record of what was actually eaten. The domain cannot function in Analyze without this. It captures the lived reality of eating.

Goal — A commitment the user makes within the domain. Gives Plan direction and Analyze a benchmark. Goals are artifacts that create effects in the context layer — a Goal of "1800 kcal/day" sets calorie_target in Configuration; a Goal of "eat more vegetables" becomes a declared memory.
Examples: "Lose weight at 1800 kcal/day," "130g protein daily," "eat more vegetables," "no snacking after 9pm."

Review — A structured analysis output. Gives Analyze its tangible form — without it, reflection is ephemeral.
Examples: weekly intake summary, plan vs actual comparison, pattern statement.

ShoppingList — A derived list of what to acquire. Bridges MealPlan to real-world execution.

CookingPlan — A preparation strategy that defines how to execute a MealPlan. Batch cooking schedules, prep steps, assembly instructions.

⸻

Artifact → Tool Mapping

Artifact	Instantiated By
MealPlan	BuildMealPlan
MealLog	LogMeal
Goal	SetGoal
Review	ReviewPeriod, DetectPatterns
ShoppingList	BuildShoppingList
CookingPlan	BuildCookingPlan

⸻

6. Tools

Tools are either artifact tools (artifact-scoped, one per artifact) or state enablers (domain-scoped, no artifact produced).

Artifact Tools:

BuildMealPlan — Create or modify a meal plan.
Acts on: Food, Meal, Recipe entities.
Produces: MealPlan artifact.
Params: period (day/week), single meal mode (in-moment recommendation).

BuildShoppingList — Generate a shopping list from a meal plan.
Reads: MealPlan artifact.
Produces: ShoppingList artifact.

BuildCookingPlan — Generate a preparation strategy from a meal plan.
Reads: MealPlan, Recipe entities.
Produces: CookingPlan artifact.

LogMeal — Record what was eaten.
Acts on: Food, Meal entities.
Produces: MealLog artifact.

SetGoal — Define or adjust a nutrition goal.
Produces: Goal artifact.
Side effect: creates or updates Configuration and declared memories in the context layer.

ReviewPeriod — Summarize intake over a time range.
Reads: MealLog, Goal artifacts.
Produces: Review artifact.

DetectPatterns — Surface recurring behaviors or correlations.
Reads: MealLog artifacts.
Produces: Review artifact.

State Enablers:

Explain — Answer a nutrition question with context.
Domain-scoped: operates across all entities and concepts within nutrition.
No artifact produced — enables Learn state.

⸻

7. Tool Type Principle

Artifact tools are artifact-scoped — one tool per artifact. The artifact defines the tool's shape.
State enablers are domain-scoped — they operate across entities within the domain.
Tool reuse across domains is a product-space concern, not a domain model concern.

⸻

8. One-Line Definition

The Nutrition Model defines Food, Meals, and Recipes as its entities, MealPlans, MealLogs, Goals, Reviews, ShoppingLists, and CookingPlans as the forms it demands, and a tool set of artifact instantiators and state enablers.
