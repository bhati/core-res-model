Nutrition Context

(Vertical Instantiation of Domain Context)

⸻

1. Purpose

This document instantiates the Domain Context for the nutrition domain.

It defines the events, configuration, observations, and memories that form the nutrition domain's context space — the accumulated reality that policy reads.

⸻

2. Events

Events are the raw signals produced by nutrition domain activity.

Tool-produced events:
	•	meal_logged — food, quantity, meal_type, time, context/trigger
	•	plan_created — plan_id, targets_referenced, period
	•	plan_modified — plan_id, change_description
	•	target_set — metric, value, timeframe
	•	target_revised — old_value, new_value, reason
	•	review_completed — period, type (summary/comparison/pattern)
	•	pattern_detected — pattern_description, evidence_count
	•	shopping_list_generated — plan_id, item_count

User-declared events:
	•	exception_declared — reason, context (e.g., "ate out, couldn't track")
	•	signal_reported — signal_type, value, context (e.g., "felt sluggish after lunch")

⸻

3. Configuration

Configuration is declared context that defines how the nutrition domain operates for this user. It is structured operational parameters — not truths about the person.

	•	dietary_type: enum (omnivore, vegetarian, vegan, pescatarian, …)
	•	calorie_target: number (kcal/day)
	•	macro_split: ratio (protein % / carb % / fat %)
	•	meal_count: number (meals per day)
	•	fasting_window: range (e.g., 16:8)
	•	allergens: list (e.g., [peanuts, shellfish])
	•	tracking_granularity: enum (exact, approximate)

Configuration constrains how tools operate and how artifacts are shaped.

⸻

4. Observations

Observations are composed context — provisional understanding derived from events and configuration.

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

Observations are recomputed on demand or periodically. They are provisional — not persisted as durable truth.

⸻

5. Memories

Memories are stabilized context — durable understanding that shapes how the domain operates over time.

Memories arrive via two paths:

Declared — the user states a truth directly. These go straight into memories. They are the cold start primer — populating context before any events exist.

Observed — the system derives a truth through the lifecycle: events → observations → stabilized memory. These require evidence and time.

Examples:
	•	“Avoids eggs” (declared)
	•	“Prefers Indian food” (declared)
	•	“Doesn’t cook on weekdays” (declared)
	•	“Prefers high-protein breakfasts” (declared or observed)
	•	“Best adherence with meal prep on Sundays” (observed)
	•	“Skips lunch when stressed” (observed)
	•	“Over-eats carbs in the evening when tired” (observed)
	•	“Energy is best with 4 smaller meals vs 3 large ones” (observed)

Memories influence planning, reflection, and policy.

⸻

6. Context Composition (Nutrition)

Observed path:
meal_logged events accumulate → “Average protein: 62g” observation → “Consistently under-eats protein” memory

Declared path:
User states “I avoid eggs” → memory (immediately)

Configuration operates alongside: calorie_target and macro_split shape how observations are framed (e.g., “62g protein” is only meaningful because the target is 130g).

⸻

7. Cross-Domain Inputs

The nutrition context does not own these, but reads them when available:

	•	Weight / body measurements — from a body/health domain
	•	Blood sugar readings — from a health domain
	•	Workout schedule — from a fitness domain
	•	Stress / energy levels — from User Context (Circumstances)

These inputs enrich observations and memories but are not nutrition events.

⸻

8. One-Line Definition

The Nutrition Context is the accumulated reality of the nutrition domain: meals logged, configuration declared, patterns observed, and truths stabilized — forming the context that nutrition policy reads.
