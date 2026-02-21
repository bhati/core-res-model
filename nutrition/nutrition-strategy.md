Nutrition Strategy

(Vertical Instantiation of Domain Strategy)

⸻

1. Purpose

Nutrition Strategy reads User Context and Domain Context, operates within Product Principles and Domain Policy, and determines how the nutrition domain actively serves the user's intent.

Product Principles constrain (universal).
Domain Policy constrains (domain-specific).
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

Each cell: what triggers this transition, which tools are involved, which intents favor it.

Learn → Plan
"Now that I understand carb counting, let me build a low-carb meal plan."
Tools: Explain → SetGoal, BuildMealPlan
Intents: Medical (education-first), Performance

Learn → Do
"Quinoa has great protein — let me try it for lunch today."
Tools: Explain → immediate action (LogMeal)
Intents: Behavioral (experiment with new approach)

Learn → Analyze
"What does my protein intake actually look like over the past week?"
Tools: Explain reading existing Reviews/MealLogs
Intents: Medical, Body Composition

Plan → Learn
"I'm building a meal plan but I don't know which fats are healthy — help me understand."
Tools: BuildMealPlan surfaces gap → Explain
Intents: Medical, Performance

Plan → Do
"My meal plan is ready — time to shop, cook, and eat."
Tools: BuildMealPlan → MealPlan ready → LogMeal
Intents: Operational, Body Composition

Plan → Analyze
"Before I commit to this plan, how does it compare to what I've actually been eating?"
Tools: BuildMealPlan → ReviewPeriod to validate
Intents: Body Composition (is this plan realistic?)

Do → Learn
"I just had paneer tikka — how much protein is in that?"
Tools: LogMeal → Explain
Intents: All (curiosity during action)

Do → Plan
"I keep winging dinner — I need a proper meal plan for weeknights."
Tools: LogMeal → realizes need → BuildMealPlan
Intents: Operational

Do → Analyze
"I've been logging all week — am I hitting my calorie target?"
Tools: MealLog accumulates → ReviewPeriod, DetectPatterns
Intents: Body Composition, Behavioral

Analyze → Learn
"My review shows I always overeat at dinner — why does that happen?"
Tools: DetectPatterns → Explain
Intents: Medical, Performance

Analyze → Plan
"I'm consistently under on protein — let me rebuild my meal plan around higher-protein meals."
Tools: ReviewPeriod → BuildMealPlan, SetGoal
Intents: Body Composition, Behavioral

Analyze → Do
"I can see I snack too much after 9pm — tonight I'll stop after dinner."
Tools: ReviewPeriod → immediate action
Intents: Behavioral

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

6. Intent Activation

TBD — how each intent shapes state emphasis, artifact priority, tool exposure.

⸻

7. Onboarding

TBD — what to collect per intent, defaults when context is missing.

⸻

8. Artifact Shaping

TBD — how traits and configuration shape artifact construction.

⸻

9. Tool Behavior

TBD — exposure, intensity, defaults per context.

⸻

10. Transition Guidance

TBD — which transitions to suggest, when, based on context.
