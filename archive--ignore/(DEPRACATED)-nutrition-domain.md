Nutrition Domain — Vertical Specification

(Concretization of core-model into the Nutrition domain)

⸻

1. Preamble

This document translates the four horizontal layers (Domain Model, Domain Data, Governance, User Layer) into a fully specified nutrition vertical.

It also resolves — within the nutrition context — the structural and semantic concerns identified in the core-model review:
	•	Attribute overloading → resolved via explicit naming
	•	Artifact ↔ Domain Data relationship → resolved via concrete mappings
	•	Memory ambiguity → resolved via a defined composite
	•	Cold start → resolved via default governance profiles
	•	User agency → resolved via override model
	•	Trajectory → resolved via arc tracking
	•	Action trace → provided as a worked example

Where the horizontal model left a gap, this vertical fills it. Where the horizontal model was abstract, this vertical is concrete.

⸻

2. Nutrition Domain Model

2A. States (as expressed in nutrition)

Learn
	•	Explore nutritional science, food properties, macros, dietary approaches.
	•	Understand what foods do, why certain patterns help, what the body needs.
	•	Examples: reading about protein timing, learning about glycemic index, understanding fiber.
	•	Expressed as: educational content, explainers, "why" answers, contextual knowledge cards.

Plan
	•	Structure eating intention: what to eat, when, how much, in what sequence.
	•	Commit to targets, constraints, weekly shapes, meal templates.
	•	Examples: setting a calorie target, building a weekly meal template, choosing a fasting window.
	•	Expressed as: meal plans, daily targets, constraint rules, shopping lists.

Do
	•	Execute behavior: eat, cook, order, prep, snack, skip.
	•	Live action in the real world.
	•	Examples: logging a meal, declaring an exception ("ate out, couldn't track"), confirming plan adherence.
	•	Expressed as: meal logging, quick capture, real-time plan reference.

Analyze
	•	Observe outcomes, detect patterns, reflect on what worked.
	•	Examples: reviewing weekly intake, comparing plan vs actual, noticing energy patterns after meals.
	•	Expressed as: summaries, pattern statements, comparisons, reflections.

⸻

2B. Transition Emphasis (Nutrition-Specific Gravity)

The nutrition domain's natural loop is:

Do → Analyze → Plan → Do (with Learn available on-demand)

Primary transitions (high-frequency, product should strongly support):
	•	Do → Analyze — "I ate, now what happened?"
	•	Analyze → Plan — "Given what I see, what should I change?"
	•	Plan → Do — "I have a plan, now execute it."

Secondary transitions (moderate frequency):
	•	Learn → Plan — "I learned about protein timing, let me adjust my plan."
	•	Analyze → Learn — "I see a pattern I don't understand, explain it."
	•	Learn → Do — "I just learned something, let me try it now."

Dampened transitions (governance should moderate):
	•	Analyze → Analyze — Risk of rumination ("Am I eating well enough?" spiraling)
	•	Plan → Plan — Risk of over-planning without doing
	•	Learn → Learn — Risk of analysis paralysis

⸻

2C. Entities

The meaningful nouns of the nutrition domain:

Entity — Definition — Examples

Food — A single edible item with nutritional properties — "Chicken breast," "Brown rice," "Almond milk"

Meal — A structured eating occasion composed of foods — "Breakfast: oats + banana + coffee"

MealPlan — A temporal arrangement of intended meals — "This week's plan: Mon-Fri templates"

NutritionTarget — A quantitative or qualitative goal — "1800 kcal/day," "130g protein," "eat more vegetables"

Routine — A recurring behavioral pattern around eating — "Intermittent fasting 16:8," "Meal prep on Sundays"

Signal — An observable bodily or behavioral indicator — "Energy level," "Satiety," "Bloating," "Cravings"

Exception — A declared deviation from plan — "Ate out at a restaurant," "Skipped lunch due to meeting"

⸻

Entity Relationships

MealPlan contains Meals.
Meals contain Foods.
NutritionTargets constrain MealPlans.
Routines shape Meal timing and composition.
Signals are observed after Meals and over time.
Exceptions modify plan adherence tracking.

⸻

2D. Tools

Tools are the product capabilities available within each state.

Learn State Tools

	•	ExplainConcept — Answer a nutrition question with science-backed context.
		Input: question or topic.
		Output: educational content (ExplainerNote artifact).

	•	CompareFoods — Side-by-side nutritional comparison.
		Input: two or more Foods.
		Output: comparison card (ComparisonCard artifact).

	•	SuggestReading — Recommend relevant learning based on current plan/goals.
		Input: user context.
		Output: curated content link or summary.

Plan State Tools

	•	BuildMealPlan — Create or modify a weekly/daily meal plan.
		Input: targets, preferences, constraints.
		Output: MealPlan artifact.

	•	SetTarget — Define or adjust a nutrition target.
		Input: metric + value + timeframe.
		Output: NutritionTarget artifact.

	•	DefineRoutine — Establish a recurring eating pattern.
		Input: pattern description + schedule.
		Output: Routine artifact.

	•	GenerateShoppingList — Derive a shopping list from a MealPlan.
		Input: MealPlan.
		Output: ShoppingList artifact.

Do State Tools

	•	LogMeal — Record what was eaten.
		Input: foods + quantities + time + context.
		Output: MealLogEntry artifact + meal_logged event.

	•	QuickCapture — Lightweight logging (photo, voice, shorthand).
		Input: unstructured capture.
		Output: MealLogEntry (partial) artifact + meal_logged event.

	•	DeclareException — Mark a deviation from plan.
		Input: reason + context.
		Output: ExceptionEntry artifact + exception_declared event.

	•	ReferencePlan — View today's plan in context.
		Input: none (contextual).
		Output: rendered MealPlan view (no artifact produced).

Analyze State Tools

	•	ReviewPeriod — Summarize intake over a time range.
		Input: date range.
		Output: PeriodSummary artifact.

	•	CompareToTarget — Show plan vs actual against targets.
		Input: target + date range.
		Output: TargetComparison artifact.

	•	DetectPatterns — Surface recurring behaviors or correlations.
		Input: signal type + date range.
		Output: PatternStatement artifact.

	•	Reflect — Guided self-reflection on recent eating.
		Input: prompt or open-ended.
		Output: ReflectionNote artifact + reflection_submitted event.

⸻

2E. Artifacts (Complete Registry)

Artifact — Produced by — State — Persistence

ExplainerNote — ExplainConcept — Learn — Saved if bookmarked
ComparisonCard — CompareFoods — Learn — Session-scoped unless saved
MealPlan — BuildMealPlan — Plan — Durable, versioned
NutritionTarget — SetTarget — Plan — Durable until revised
Routine — DefineRoutine — Plan — Durable until revised
ShoppingList — GenerateShoppingList — Plan — Ephemeral per plan cycle
MealLogEntry — LogMeal / QuickCapture — Do — Immutable, permanent
ExceptionEntry — DeclareException — Do — Immutable, permanent
PeriodSummary — ReviewPeriod — Analyze — Saved, can be regenerated
TargetComparison — CompareToTarget — Analyze — Saved, can be regenerated
PatternStatement — DetectPatterns — Analyze — Candidate for Domain Memory promotion
ReflectionNote — Reflect — Analyze — Saved, feeds Domain Memory

⸻

2F. Artifact ↔ Domain Data Relationship (Resolving the Review Gap)

Every artifact maps to at least one Domain Data category:

	•	Immutable artifacts (MealLogEntry, ExceptionEntry) are also Events.
	•	Durable plan artifacts (MealPlan, NutritionTarget, Routine) are also Domain Configuration.
	•	Derived artifacts (PeriodSummary, TargetComparison, PatternStatement) are Derived Observations.
	•	Stabilized PatternStatements and ReflectionNotes can be promoted to Domain Memory.

Rule: Artifacts are the user-facing shape. Domain Data categories are the system-facing classification. They are not parallel systems — artifacts are instances categorized by the data model.

⸻

3. Nutrition Domain Data

3A. Events

	•	meal_logged — timestamp, foods, quantities, meal_type, source (manual/photo/voice)
	•	snack_logged — subset of meal_logged for between-meal intake
	•	exception_declared — timestamp, reason, plan_reference
	•	plan_created — timestamp, plan_id, targets_referenced
	•	plan_modified — timestamp, plan_id, change_description
	•	target_set — timestamp, metric, value, timeframe
	•	target_revised — timestamp, old_value, new_value, reason
	•	routine_defined — timestamp, routine_id, pattern
	•	reflection_submitted — timestamp, content, triggers
	•	signal_reported — timestamp, signal_type, value, context
	•	override_requested — timestamp, governance_rule, user_reason (NEW — addresses agency concern)

⸻

3B. Domain Configuration (renamed from "Domain Attributes" to resolve overloading)

	•	dietary_type — e.g., vegetarian, vegan, omnivore, pescatarian
	•	calorie_target — daily kcal target
	•	macro_split — protein/carb/fat percentage
	•	meal_timing — number of meals, spacing, fasting window
	•	allergens — list of allergens to exclude
	•	food_exclusions — specific foods the user avoids (preference, not allergy)
	•	cuisine_preferences — preferred cuisine types
	•	cooking_capacity — how much the user cooks vs. orders/eats out
	•	tracking_granularity — how precise the user wants logging to be (exact grams vs. rough portions)

⸻

3C. Derived Observations

Quantitative:
	•	"Average daily intake this week: 1,720 kcal"
	•	"Protein averaged 62g/day (target: 130g)"
	•	"Logged 5 of 7 days"

Pattern-based:
	•	"Late dinners (after 9pm) occurred 4x this week"
	•	"Snacking increases on work-from-home days"
	•	"Higher protein breakfasts correlate with lower afternoon snacking"

Deviation-based:
	•	"Plan adherence dropped from 80% to 45% this week"
	•	"Exception rate doubled during travel"

Observations are recomputed on-demand or periodically. They are not persisted permanently — they are derived from events.

⸻

3D. Domain Memory

Domain Facts (stable, behavior-shaping):
	•	"Avoids eggs (taste preference, not allergy)"
	•	"Prefers high-protein breakfasts"
	•	"Doesn't cook on weekdays"
	•	"Best adherence with meal prep on Sundays"

Domain Patterns (stabilized interpretive truths):
	•	"Skips lunch when stressed"
	•	"Over-eats carbs in the evening when tired"
	•	"Responds well to weekly summaries, not daily"
	•	"Energy is best when eating 4 smaller meals vs 3 large ones"

Promotion criteria:
	•	A Derived Observation becomes a Domain Memory candidate when it appears ≥ 3 times across ≥ 2 weeks, OR when the user explicitly confirms it.
	•	Candidates are surfaced to the user for confirmation before stabilization.
	•	Domain Memory carries a last_validated timestamp and can be deprecated if contradicted by new evidence (≥ 3 counter-observations).

⸻

3E. Domain Trajectory (NEW — addresses arc/momentum concern)

Trajectory is a higher-order Derived Observation that tracks state over time horizons.

Tracked dimensions:
	•	Consistency — logging frequency, plan adherence rate over rolling 14-day window
	•	Direction — is the user moving toward or away from their NutritionTargets?
	•	Momentum — is engagement increasing, stable, or declining?
	•	Phase — onboarding | building | maintaining | recovering | disengaging

Phase definitions:
	•	Onboarding — first 14 days, sparse data, exploring
	•	Building — actively setting targets, logging regularly, plans being refined
	•	Maintaining — stable adherence, low plan churn, steady logging
	•	Recovering — after a disruption (travel, illness), re-engaging
	•	Disengaging — declining logging, no plan updates, no reflections

Trajectory informs Governance. A user in "recovering" phase gets lighter governance than one in "building."

⸻

4. Nutrition Governance

4A. Governance Context (the resolved "memory blackbox")

Governance reads a composite input formed from:

From User Layer:
	•	Attributes — age, sex, health conditions (e.g., diabetes → constrains macro advice)
	•	Traits — planning preference, stress response, feedback tolerance
	•	Circumstances — traveling, sick, high workload, postpartum
	•	Intents — "Lose 5kg," "Improve energy," "Build consistent eating habits"
	•	Configuration — notification frequency, tracking granularity, tone

From Domain Data:
	•	Domain Configuration — calorie target, dietary type, exclusions
	•	Domain Memory — known patterns and facts
	•	Domain Trajectory — current phase, momentum, direction

This composite is the Governance Context. It is read-only from governance's perspective.

⸻

4B. State Modulation

State — Default Expression — Governance Adjustments

Learn — On-demand, user-initiated — Depth limited if user has "information overload" trait. Broadened during onboarding. Focused on gaps if Domain Memory reveals misconceptions.

Plan — Structured, target-driven — Rigidity reduced if user prefers flexibility (Trait). Simplified during recovery phase. Range-based targets instead of precise ones for anxiety-sensitive users.

Do — Capture-focused — Logging granularity matched to Configuration. Simplified during travel/illness (Circumstance). Frequency of prompts reduced during disengaging phase.

Analyze — Moderate depth — Dampened if user has rumination tendency (Trait). Depth increased during building phase. Comparison scope limited during onboarding (not enough data).

⸻

4C. Transition Shaping

Transition — Default — Governance Modulation

Do → Analyze — Encouraged (primary loop) — Lightweight version during maintaining phase. Suppressed if user logs < 3 meals/week (not enough signal).
Analyze → Plan — Encouraged — Delayed during recovery (don't revise plan while unstable). Simplified: one change at a time if user is overwhelmed.
Plan → Do — Encouraged — Extra support (plan reference, reminders) during building phase. Reduced friction during maintaining.
Analyze → Analyze — Dampened — Hard-cap at 2 consecutive Analyze cycles without action for anxiety-sensitive users.
Plan → Plan — Dampened — Minimum 7-day plan stability period before revision allowed (unless exception-triggered).
Learn → Learn — Neutral — Redirected toward Plan if user has spent > 3 Learn sessions without setting a target.

⸻

4D. Tool Boundaries

Tool — Governance Constraints

BuildMealPlan — Max 1 active plan. Revision requires reflection justification if changed < 7 days ago. Complexity capped based on cooking_capacity.
SetTarget — No more than 3 concurrent targets. Range-based targets enforced for users with perfectionism trait.
LogMeal — Granularity matches tracking_granularity config. Quick capture always available as fallback.
DetectPatterns — Lookback window limited to 14 days during onboarding. Maximum 3 patterns surfaced per review to prevent overwhelm.
Reflect — Prompt tailored to tone configuration. Never surfaces weight/body-image language unless user has explicitly opted in.

⸻

4E. Override Model (NEW — addresses user agency concern)

When governance dampens, restricts, or modifies a tool or transition, the user can:

	1.	See that governance is active — "We're keeping your plan stable for this week because you changed it 3 days ago."
	2.	Request an override — "I want to change my plan anyway."
	3.	Provide a reason — free text or structured (e.g., "circumstances changed," "I have new information").
	4.	Governance yields — the override is granted. An override_requested event is logged.
	5.	System learns — if overrides on a specific rule accumulate (≥ 3), governance weakens that rule for this user.

Overrides are never blocked. Governance is advisory, not authoritarian.

Exception: If a User Attribute indicates a medical condition (e.g., diabetes) and the override would conflict with a safety boundary, the system explains the risk but still permits the action. It never locks the user out.

⸻

5. Cold Start Protocol (NEW — addresses onboarding gap)

Phase 1: Minimal Viable Context (First Session)
	•	Collect: dietary_type, any allergens, primary intent (free text or structured).
	•	Set defaults: calorie_target = estimated from age/sex/height if provided, else deferred. tracking_granularity = "rough" (user can upgrade later).
	•	Governance profile: "Onboarding" — light plan, generous logging flexibility, no pattern analysis (not enough data).

Phase 2: Progressive Profiling (Days 1–14)
	•	After 3 logged meals: prompt for meal_timing preference.
	•	After 7 days of logging: surface first Derived Observation ("Here's what we noticed").
	•	After first Analyze session: offer to set a structured NutritionTarget.
	•	Traits are inferred from behavior, not asked directly:
		-	If user revises plan > 2x in first week → may prefer flexibility
		-	If user logs with exact grams → high tracking granularity
		-	If user ignores Analyze prompts → prefers Do-heavy loop
	•	Inferred traits are provisional until confirmed by ≥ 2 weeks of data.

Phase 3: Stabilization (Week 3+)
	•	Governance transitions from "Onboarding" to "Building."
	•	First Domain Memory candidates are surfaced for user confirmation.
	•	Full tool suite is unlocked.

⸻

6. Surface Model (NEW — addresses outward feedback gap)

The Surface is the set of outputs the domain presents to the user. It bridges internal model richness and user-visible value.

6A. Proactive Surfaces (system-initiated)

	•	Daily Nudge — lightweight reference to today's plan or a contextual prompt. Governed by notification frequency config.
	•	Weekly Summary — a PeriodSummary artifact surfaced at user-configured time. Includes: adherence, notable patterns, one suggested adjustment.
	•	Pattern Alert — when a new PatternStatement is generated, surface it once for user reaction (confirm, dismiss, override).
	•	Phase Transition Notification — when Trajectory detects a phase change (e.g., building → maintaining), inform the user and explain what shifts.

6B. Reactive Surfaces (user-initiated)

	•	Plan View — current MealPlan + today's meals + progress against targets.
	•	History View — meal log timeline with filtering by date, meal type, food.
	•	Insight View — all current Derived Observations + Domain Memory items, editable by user.
	•	Memory View — what the system "knows" about the user within this domain. User can confirm, edit, or delete any item.

6C. Transparency Principle

The user should always be able to answer:
	•	"What does this system know about me?" → Memory View
	•	"Why is it doing this?" → Governance explanations on any modulated action
	•	"What has it noticed?" → Insight View
	•	"How am I doing over time?" → Trajectory View (momentum, direction, phase)

⸻

7. Cross-Layer Action Trace (Resolving the Review Gap)

Concrete example: User logs a meal.

Step 1 — Do State / LogMeal Tool
	•	User inputs: "Lunch — grilled chicken, brown rice, salad, 1pm"
	•	Artifact produced: MealLogEntry (immutable, permanent)

Step 2 — Domain Data / Event Layer
	•	Event emitted: meal_logged (timestamp, foods, quantities, meal_type: lunch)
	•	This is the same action. The MealLogEntry artifact IS the user-facing shape of the meal_logged event.

Step 3 — Domain Data / Derived Observations (async)
	•	System recomputes rolling observations:
		-	"Daily intake so far: 1,200 kcal (target: 1,800)"
		-	"Protein at lunch: 42g (above average)"
	•	If a PatternStatement is triggered: "3rd consecutive high-protein lunch" → candidate for Domain Memory.

Step 4 — Governance (async, background)
	•	Governance checks Trajectory: user is in "building" phase, logging consistently.
	•	No modulation needed. If user were in "disengaging" (low logging), governance might surface a lighter Do prompt next time.

Step 5 — Surface
	•	Immediate: confirmation of logged meal, today's running totals.
	•	Deferred: any pattern alerts queued for next Analyze session or weekly summary.

One action flows through all layers. No ambiguity about where data lives or who owns what.

⸻

8. What This Document Does NOT Define

	•	Cross-domain orchestration (e.g., nutrition ↔ fitness interaction)
	•	Specific UI/UX implementation
	•	Technical data schemas or API contracts
	•	AI/LLM prompt design
	•	Food database or nutritional data sourcing

These are implementation concerns. This document defines the semantic and structural contract that implementation must satisfy.

⸻

9. One-Line Definition

The Nutrition Domain Vertical is the concrete instantiation of the behavioral OS for eating: defining what foods, meals, plans, and signals exist, what tools operate on them, how information evolves from logged meals to stabilized memory, how governance shapes the experience per user, and how the domain surfaces its understanding back to the person.
