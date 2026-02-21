Nutrition Context — Stress Test Against User Intents

⸻

Method: Take each intent category, trace it through the 4 context categories.
Question: Do the current Events, Configuration, Observations, and Memories hold?

⸻

1. Body Composition — "Lose weight"

Events needed:
	•	meal_logged ✅ (tracking calories)
	•	target_set ✅ (calorie deficit target)
	•	plan_created ✅
	•	review_completed ✅

Configuration needed:
	•	calorie_target ✅ (essential for deficit)
	•	macro_split ✅ (protein preservation during deficit)
	•	tracking_granularity ✅ (exact tracking matters for weight loss)

Observations generated:
	•	"Average daily intake: 1,720 kcal (target: 1,800)" ✅
	•	"Weekly calorie trend: declining" ✅
	•	"Logged 5 of 7 days" ✅

Memories formed:
	•	"Tends to overeat on weekends" (observed) ✅
	•	"Craves sweets after 8pm" (observed) ✅

Gaps:
	•	Weight tracking — cross-domain input (body measurements), not a nutrition event. Nutrition reads it but doesn't own it. ✅ Already noted in cross-domain inputs.
	•	TDEE/BMR calculation — derived from User Context attributes (age, sex, height, weight). Not a nutrition context concern. ✅

Verdict: Holds. No gaps.

⸻

2. Performance — "Train for an event"

Events needed:
	•	meal_logged ✅ (with timing context)
	•	target_set ✅ (macro targets for performance)
	•	plan_created ✅ (fueling plan)

Configuration needed:
	•	calorie_target ✅ (higher for performance)
	•	macro_split ✅ (carb/protein heavy)
	•	meal_count ✅ (more frequent meals)

Observations generated:
	•	"Pre-workout meals averaged 450 kcal" — requires correlating meal timing with workout timing
	•	"Post-workout protein: 35g average"

Memories formed:
	•	"Performs better with carb-heavy breakfast before training" (observed)

Gaps:
	•	Meal timing relative to workouts — meal_logged captures time, but the system needs workout schedule from fitness domain to correlate. This is a cross-domain input dependency. No new event type needed — just enriched observation capability.
	•	No event for "pre-workout meal" vs "post-workout meal" — these are inferred from meal_logged timing + workout schedule, not separate events. ✅ Correct.

Verdict: Holds. Cross-domain input dependency (workout schedule) already noted.

⸻

3. Medical — "Manage diabetes"

Events needed:
	•	meal_logged ✅ (with carb detail)
	•	target_set ✅ (carb limits)
	•	signal_reported ✅ (blood sugar readings — user-declared health signal)

Configuration needed:
	•	calorie_target ✅
	•	macro_split ✅ (carb-restricted)
	•	allergens ✅

Observations generated:
	•	"Average carb intake: 180g/day (target: 150g)" ✅
	•	"Low-GI meals: 60% of total" ✅
	•	"Blood sugar elevated after high-carb dinners" — requires cross-domain health data

Memories formed:
	•	"Blood sugar spikes after rice-heavy meals" (observed)
	•	"Best glucose control with consistent 4-hour meal spacing" (observed)

Gaps:
	•	Medical dietary restrictions vs allergens — allergens covers allergy-based safety exclusions. But "avoid high-potassium foods" (kidney disease) or "limit sodium" (blood pressure) are medically mandated restrictions, not allergies. Currently these would be declared memories ("Avoids high-potassium foods"). But they're safety-critical — closer to allergens than preferences.
	•	PROPOSAL: Broaden allergens to safety_exclusions — covers both allergens and medically mandated dietary restrictions. Or keep allergens and add medical_restrictions as a separate configuration field.

Verdict: Mostly holds. One gap: safety-critical medical dietary restrictions need a home. Configuration field "allergens" may need broadening.

⸻

4. Behavioral — "Reduce snacking"

Events needed:
	•	meal_logged ✅ (with meal_type: snack, plus context/trigger)
	•	signal_reported ✅ ("had a craving," "felt hungry at 3pm")
	•	exception_declared ✅ ("snacked despite plan")

Configuration needed:
	•	meal_count ✅ (defines expected eating occasions)
	•	tracking_granularity ✅

Observations generated:
	•	"Snacking frequency: 3.2 instances/day" ✅
	•	"Snacking increases on WFH days" ✅
	•	"Most snacking between 3-5pm" ✅
	•	"Top snack foods: chips, biscuits, chai" ✅

Memories formed:
	•	"Snacks when bored" (observed) ✅
	•	"Afternoon energy dip triggers snacking" (observed) ✅

Gaps:
	•	Context/trigger capture on meal_logged — already noted in model stress test. The event schema must support WHY (trigger) not just WHAT (food). Current event definition includes "context/trigger" field. ✅

Verdict: Holds. No gaps beyond what model stress test already flagged.

⸻

5. Operational — "Plan meals better"

Events needed:
	•	plan_created ✅
	•	plan_modified ✅
	•	shopping_list_generated ✅
	•	meal_logged ✅ (tracking adherence to plan)

Configuration needed:
	•	meal_count ✅
	•	tracking_granularity ✅

Observations generated:
	•	"Plan adherence: 75%" ✅
	•	"Most swaps happen at dinner" ✅
	•	"3 of 5 shopping list items purchased" — requires shopping completion tracking

Memories formed:
	•	"Follows plan better with Sunday prep" (observed) ✅
	•	"Consistently swaps Friday dinner" (observed) ✅

Gaps:
	•	No event for shopping_completed or meal_prepped — can't track operational follow-through beyond plan creation and meal logging. If someone generates a shopping list but doesn't shop, or preps meals on Sunday, there's no signal.
	•	PROPOSAL: Add meal_prepped and shopping_completed as optional user-declared events. Not critical, but needed for deep operational intent tracking.

Verdict: Mostly holds. Optional events for operational follow-through would strengthen it.

⸻

Summary

EVENTS

Current events hold for all intents. Two optional additions for operational depth:
	•	meal_prepped — user declares they prepped meals
	•	shopping_completed — user declares they completed shopping

These are low-priority — useful for operational intents but not blocking.

CONFIGURATION

Current 7 fields hold for most intents. One refinement:
	•	allergens → broaden to safety_exclusions (covers both allergens and medically mandated dietary restrictions)

Or add a separate medical_restrictions field alongside allergens.

OBSERVATIONS

All intents generate relevant observations with current framing. ✅
Cross-domain inputs (weight, blood sugar, workout schedule) enrich observations but are already noted as external dependencies.

MEMORIES

Declared memories as cold start work for all intents. ✅
Observed memories emerge naturally across all intent categories. ✅
The declared/observed two-path model is validated — every intent benefits from early declared memories.

⸻

Verdict

The nutrition context holds. Two minor additions:
	1.	Broaden allergens → safety_exclusions in Configuration
	2.	Optional operational events (meal_prepped, shopping_completed)

No structural changes needed. The four-category model (Events, Configuration, Observations, Memories) with two-path memory intake covers all intents.
