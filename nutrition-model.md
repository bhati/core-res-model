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

3. Transition Gravity

The nutrition domain's natural loop is:

Do → Analyze → Plan

Primary transitions:
	•	Do → Analyze — "I ate, now what happened?"
	•	Analyze → Plan — "Given what I see, what should I change?"
	•	Plan → Do — "I have a plan, now execute."

Learn is available on-demand. It is not part of the primary loop but supports it — a user enters Learn when they need to understand something that Plan or Analyze surfaced.

⸻

4. Entities

Entities are the domain-specific nouns. In nutrition:

Food — A single edible item with nutritional properties.
Examples: chicken breast, brown rice, almond milk, banana.

Meal — A structured eating occasion composed of foods.
Examples: breakfast (oats + banana + coffee), lunch (rice + dal + salad).

These are the atomic nouns of the nutrition domain. All tools, artifacts, and context are ultimately about Food and Meals.

⸻

5. Artifacts

Artifacts are the structured forms the nutrition domain demands exist.

MealPlan — A temporal arrangement of intended meals. The domain cannot function in Plan without this. It defines what the user intends to eat over a period.

MealLog — A record of what was actually eaten. The domain cannot function in Analyze without this. It captures the lived reality of eating.

Target — A quantitative or qualitative nutrition goal. Gives Plan direction and Analyze a benchmark.
Examples: "1800 kcal/day," "130g protein," "eat more vegetables," "no snacking after 9pm."

Review — A structured analysis output. Gives Analyze its tangible form — without it, reflection is ephemeral.
Examples: weekly intake summary, plan vs actual comparison, pattern statement.

⸻

Artifact → Tool Mapping

Artifact	Instantiated By
MealPlan	BuildPlan
MealLog	LogMeal
Target	SetTarget
Review	ReviewPeriod, DetectPatterns

⸻

6. Tools

Tools instantiate artifacts and enable states and transitions.

BuildPlan — Create or modify a meal plan.
Acts on: Food, Meal entities.
Produces: MealPlan artifact.

LogMeal — Record what was eaten.
Acts on: Food, Meal entities.
Produces: MealLog artifact.

SetTarget — Define or adjust a nutrition target.
Produces: Target artifact.

ReviewPeriod — Summarize intake over a time range.
Reads: MealLog, Target artifacts.
Produces: Review artifact.

DetectPatterns — Surface recurring behaviors or correlations.
Reads: MealLog artifacts.
Produces: Review artifact.

Explain — Answer a nutrition question with context.
Acts on: Food entities, domain knowledge.
No artifact produced — enables Learn state.

⸻

7. One-Line Definition

The Nutrition Model defines Food and Meals as its entities, MealPlans, MealLogs, Targets, and Reviews as the forms it demands, and a tool set that instantiates those forms — all gravitating around a Do → Analyze → Plan loop.
