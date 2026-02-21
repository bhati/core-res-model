Nutrition Model — Stress Test Against User Intents

⸻

Method: Take each intent category, trace it through the 5 domain model primitives.
Question: Do the current Entities, Artifacts, and Tools hold? Do States and Transitions behave as expected?

⸻

1. Body Composition — "Lose weight"

	•	Learn: Understand caloric deficit, TDEE, macro balance → Explain tool ✅
	•	Plan: Set calorie target → SetTarget ✅. Build deficit-based meal plan → BuildPlan ✅
	•	Do: Log meals → LogMeal ✅. Follow plan.
	•	Analyze: Review intake vs target → ReviewPeriod ✅. Track trend over weeks → DetectPatterns ✅

	Transition emphasis: Plan → Do → Analyze (target-driven execution)

	Gaps found:
	•	Weight tracking — not a nutrition entity. It's a body measurement (cross-domain). Nutrition needs to READ it but doesn't own it.
	•	TDEE estimation — a calculation tool? Or part of Explain? Currently unclear.

⸻

2. Performance — "Train for an event"

	•	Learn: Fueling strategies, carb loading, hydration → Explain ✅
	•	Plan: Higher calorie plan, macro timing around workouts → BuildPlan ✅, SetTarget ✅
	•	Do: Log meals with timing context → LogMeal ✅
	•	Analyze: Correlate nutrition with energy/recovery → ReviewPeriod ✅

	Transition emphasis: Plan → Do → Analyze (structured execution)

	Gaps found:
	•	Meal TIMING relative to workouts — MealPlan needs to handle timing, not just composition. Is timing MealPlan metadata or Configuration?
	•	Workout schedule — comes from fitness domain. Nutrition reads it as cross-domain context.
	•	Suggest tool — "What should I eat before a long run?" is not Explain (education) or BuildPlan (full plan). It's an in-moment suggestion. MISSING TOOL.

⸻

3. Medical — "Manage diabetes"

	•	Learn: Glycemic index, carb counting, insulin response → Explain ✅
	•	Plan: Low-GI meal plan, carb-restricted targets → BuildPlan ✅, SetTarget ✅
	•	Do: Log meals with carb detail → LogMeal ✅
	•	Analyze: Review carb intake, correlate with blood sugar → ReviewPeriod ✅, DetectPatterns ✅

	Transition emphasis: Learn → Plan → Do (safety-first, education-heavy)

	Gaps found:
	•	Blood sugar readings — cross-domain health measurement. Not a nutrition entity. Nutrition correlates meals with readings but doesn't own the readings.
	•	Safety policy — critical. Must not suggest fasting for diabetics. This is a POLICY concern, not a model gap. Validates need for nutrition-policy.md.

⸻

4. Behavioral — "Reduce snacking"

	•	Learn: Why snacking happens — hunger vs habit vs emotion → Explain ✅
	•	Plan: Define snack boundaries, meal spacing to prevent hunger → BuildPlan ✅, SetTarget ✅ (e.g., "< 2 snacks/day")
	•	Do: Log snacks, note triggers/context → LogMeal ✅
	•	Analyze: Review snacking patterns — when, what, why → DetectPatterns ✅

	Transition emphasis: Do → Analyze → Plan (pattern-driven behavior change)

	Gaps found:
	•	Snack as entity? No — a snack is a Meal with meal_type: snack. Not a separate entity. ✅
	•	Trigger/context capture — "I snacked because I was bored" — this is metadata on MealLog, not a new entity. But does LogMeal currently support context/trigger capture? Needs to.

⸻

5. Operational — "Plan meals better"

	•	Learn: Meal prep strategies, batch cooking, time-saving techniques → Explain ✅
	•	Plan: Build a weekly plan → BuildPlan ✅ (this IS the primary tool)
	•	Do: Follow plan, shop, cook, log → LogMeal ✅
	•	Analyze: Review adherence — which meals followed, swapped, skipped → ReviewPeriod ✅

	Transition emphasis: Plan → Do (plan-heavy, execution-focused)

	Gaps found:
	•	ShoppingList — natural artifact for operational intents. "I have a MealPlan, now what do I buy?" Currently MISSING from artifacts.
	•	Recipe — "Cook more at home" needs recipes. Is Recipe an entity (exists in the world, like Food) or an artifact (user creates/saves)? Probably an entity — recipes exist independently.
	•	Suggest tool again — "What can I make with what I have?" is a suggestion, not a plan or an explanation.

⸻

Summary

ENTITIES

Current: Food, Meal
Proposed addition: Recipe

Food and Meal hold across all intents. Recipe is needed for operational/cooking intents — it's a domain noun that exists independently (like Food), not something the system produces.

ARTIFACTS

Current: MealPlan, MealLog, Target, Review
Proposed addition: ShoppingList

The four artifacts hold. ShoppingList is a natural derivation from MealPlan for operational intents. It's a form the domain demands when planning is execution-oriented.

TOOLS

Current: BuildPlan, LogMeal, SetTarget, ReviewPeriod, DetectPatterns, Explain
Proposed addition: Suggest

Suggest fills a gap across performance ("What should I eat before a run?"), behavioral ("What's a good snack alternative?"), and operational ("What can I make with these ingredients?"). It's different from Explain (education) and BuildPlan (structured planning). It's in-moment, contextual, actionable.

Also: LogMeal needs to support context/trigger capture (not just food + quantity, but also why/when/context).

STATES

All four states exercised across all intents. ✅
Different intents shift the gravity:
	•	Body composition: Plan + Analyze heavy
	•	Performance: Plan + Do heavy
	•	Medical: Learn + Plan heavy
	•	Behavioral: Do + Analyze heavy
	•	Operational: Plan heavy

TRANSITIONS

Do → Analyze → Plan primary loop holds for all intents. ✅
Medical shifts toward Learn → Plan (education before action).
Behavioral shifts toward Do → Analyze (catch patterns first).

⸻

Verdict

The current nutrition model holds structurally. Three additions surfaced:
	1.	Recipe (entity)
	2.	ShoppingList (artifact)
	3.	Suggest (tool)

No states or transitions need to change. The model's gravity shifts per intent, which is exactly what policy should configure.
