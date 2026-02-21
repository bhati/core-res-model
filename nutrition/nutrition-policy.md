Nutrition Policy

(Vertical Instantiation of Domain Policy)

⸻

1. Purpose

Nutrition Policy reads User Context and Domain Context, operates within Product Principles, and determines how the nutrition domain should behave for this user right now.

Product Principles constrain.
Context informs.
This document solves.

⸻

2. Inventory

Entities: Food, Meal, Recipe
Artifacts: MealPlan, MealLog, Goal, Review, ShoppingList, CookingPlan
Tools (artifact): BuildMealPlan, BuildShoppingList, BuildCookingPlan, LogMeal, SetGoal, ReviewPeriod, DetectPatterns
Tools (state enabler): Explain
States: Learn, Plan, Do, Analyze
Intents: Body Composition, Performance, Medical, Behavioral, Operational

⸻

3. Transition Map (4×4)

From\To	Learn	Plan	Do	Analyze

Learn	—	TBD	TBD	TBD
Plan	TBD	—	TBD	TBD
Do	TBD	TBD	—	TBD
Analyze	TBD	TBD	TBD	—

Each cell: what triggers this transition? Which tools/artifacts are involved? Which intents favor it?

⸻

4. Tool × State Map

Tool	Type	Primary State	Enables Transition
BuildMealPlan	Artifact	Plan	Plan → Do
BuildShoppingList	Artifact	Plan	Plan → Do
BuildCookingPlan	Artifact	Plan	Plan → Do
LogMeal	Artifact	Do	Do → Analyze
SetGoal	Artifact	Plan	(intent activation)
ReviewPeriod	Artifact	Analyze	Analyze → Plan
DetectPatterns	Artifact	Analyze	Analyze → Plan / Learn
Explain	State enabler	Learn	Learn → Plan / Do

⸻

5. Artifact × Tool × Lifecycle

Artifact	Created By	Read By	Lifecycle
MealPlan	BuildMealPlan	BuildShoppingList, BuildCookingPlan, LogMeal	Active → superseded
MealLog	LogMeal	ReviewPeriod, DetectPatterns	Immutable event record
Goal	SetGoal	ReviewPeriod, BuildMealPlan	Active → revised or retired
Review	ReviewPeriod, DetectPatterns	(user, Explain)	Snapshot
ShoppingList	BuildShoppingList	(user)	Derived from active MealPlan
CookingPlan	BuildCookingPlan	(user)	Derived from active MealPlan

⸻

6. Safety Policies

TBD — hard constraints from medical conditions + allergens.

⸻

7. Intent Activation Policies

TBD — how each intent shapes state emphasis, artifact priority, tool exposure.

⸻

8. Onboarding Policies

TBD — what to collect per intent, defaults when context is missing.

⸻

9. Artifact Shaping Policies

TBD — how traits and configuration shape artifact construction.

⸻

10. Tool Behavior Policies

TBD — exposure, intensity, defaults per context.

⸻

11. Transition Guidance Policies

TBD — which transitions to suggest, when, based on context.

⸻

12. Circumstance Response Policies

TBD — soft modulation per circumstance type.
