User Context — Nutrition Activation

(How User Context influences the Nutrition Domain)

⸻

1. Purpose

The User Context is cross-domain — it describes the person, not any specific domain. This document defines how each User Context component activates within the nutrition domain: what is relevant, what it influences, and how it maps to nutrition model primitives and context.

⸻

2. Attributes → Structural Constraints

Attributes constrain what the nutrition domain can safely and effectively do.

Relevant attributes:
	•	age → affects caloric needs, metabolic rate, nutrient requirements
	•	sex → affects caloric needs, macro requirements, micronutrient needs
	•	height → input to TDEE/BMR calculation
	•	weight → input to TDEE/BMR calculation, baseline for body composition intents
	•	chronic health conditions → directly constrains nutrition guidance
		-	diabetes → carb management, glycemic index awareness
		-	PCOS → insulin sensitivity, anti-inflammatory focus
		-	thyroid → metabolic adjustment
		-	kidney disease → potassium/sodium restrictions
	•	pregnancy / breastfeeding → elevated nutritional requirements, safety restrictions

Activation: Attributes flow into Configuration (informing calorie_target, safety_exclusions) and into Policy (setting safety boundaries). They are read once and updated rarely.

⸻

3. Traits → Behavioral Shaping

Traits shape how the nutrition domain presents itself and how tools operate.

Relevant traits and their nutritional influence:

	•	"Prefers flexibility over rigid plans"
	→ MealPlan artifact: templates and ranges instead of exact daily plans
	→ BuildPlan tool: loose structure, easy swaps

	•	"Over-optimizes when stressed"
	→ Policy: simplify targets during high-stress circumstances
	→ SetTarget tool: limit concurrent targets

	•	"Easily discouraged by negative feedback"
	→ Review artifact: frame deviations as learning, not failure
	→ DetectPatterns tool: lead with positives

	•	"Responds well to structured routines"
	→ MealPlan artifact: detailed, time-blocked plans
	→ Suggest tool: reinforce routine adherence

	•	"High anxiety sensitivity"
	→ Policy: dampen Analyze → Analyze transitions
	→ ReviewPeriod tool: limit comparison depth

	•	"Competitive and goal-driven"
	→ Target artifact: precise, measurable targets
	→ Review artifact: progress metrics prominent

Activation: Traits modulate tool behavior, artifact presentation, and transition emphasis. They are the primary input to policy intensity decisions.

⸻

4. Circumstances → Temporary Modulation

Circumstances temporarily shift how the nutrition domain operates.

Relevant circumstances and their nutritional influence:

	•	Traveling
	→ Relax plan adherence expectations
	→ LogMeal: simplify to quick capture
	→ Suggest tool: focus on available options
	→ Observations: exclude travel period from trend analysis

	•	Currently sick
	→ Suspend active targets
	→ Simplify to hydration + comfort food guidance
	→ Policy: suppress plan deviation alerts

	•	High workload sprint
	→ Reduce cooking_capacity assumption
	→ Suggest tool: quick meals, ordering guidance
	→ LogMeal: simplified logging encouraged

	•	Injury recovery
	→ Adjust macro targets (protein for healing)
	→ May affect calorie needs (reduced activity)

	•	Currently stressed / feeling overwhelmed
	→ Lighten all tools
	→ Reduce notification frequency
	→ Policy: no new targets, maintain existing plan

	•	Fasting / religious observance
	→ Adjust meal_timing configuration temporarily
	→ MealPlan artifact: respect fasting windows

Activation: Circumstances act as temporary overrides. They modify tool exposure, artifact complexity, observation framing, and policy intensity. They expire — when the circumstance resolves, the domain returns to its baseline operating mode.

⸻

5. Intents → Directional Priority

Intents set the direction for the nutrition domain. They determine which tools, artifacts, and transitions are emphasized.

Full intent taxonomy: see Appendix A.

How intents activate nutrition:

	•	Intent selects primary transition loop
		-	Body composition intents → Plan → Do → Analyze (target-driven)
		-	Behavioral intents → Do → Analyze → Plan (pattern-driven)
		-	Medical intents → Learn → Plan → Do (safety-first)
		-	Operational intents → Plan → Do (execution-focused)

	•	Intent shapes artifact priority
		-	Body composition → Target and Review are primary artifacts
		-	Behavioral → MealLog (with triggers) and Review are primary
		-	Operational → MealPlan and ShoppingList are primary

	•	Intent influences Configuration defaults
		-	"Lose weight" → suggests setting calorie_target
		-	"Plan meals better" → suggests setting meal_count
		-	"Manage diabetes" → triggers safety_exclusions review

Activation: Intents are the strongest directional input. They determine what the domain prioritizes. Multiple intents can coexist — policy resolves conflicts and balances emphasis.

⸻

6. Configuration → Interaction Style

User Configuration shapes how the nutrition domain communicates and intervenes.

Relevant configuration and nutritional application:

	•	Notification frequency → meal logging reminders, plan reference prompts
	•	Proactivity level → passive (user initiates) vs active (system suggests meals, alerts to deviations)
	•	Data density → numbers and macros vs qualitative summaries ("you ate well today")
	•	Tone → strict accountability vs gentle encouragement
	•	Planning rigidity → precise daily plans vs loose weekly frameworks
	•	Autonomy vs guidance → self-directed tools vs step-by-step guided flows

Activation: Configuration does not change what the domain does — it changes how the domain presents itself. Same tool, same artifact, different surface expression.

⸻

7. Activation Summary

User Context Component	What It Affects	When It Changes
Attributes	Safety boundaries, caloric baselines	Rarely
Traits	Tool intensity, artifact presentation, policy mood	Slowly over time
Circumstances	Temporary overrides to all of the above	Days to weeks
Intents	Domain direction, transition priority, artifact emphasis	When user goals change
Configuration	Surface expression, communication style	User-controlled

⸻

8. One-Line Definition

The User Context activates within nutrition by constraining safety (attributes), shaping intensity (traits), temporarily overriding behavior (circumstances), setting direction (intents), and styling interaction (configuration) — all read by policy to configure the domain for this person right now.

⸻

Appendix A: Nutrition Intent Taxonomy

Each category represents a dimension of motivation. Users may hold intents across multiple categories simultaneously.

⚖️ Body Composition — "Change my body"

Question: What kind of change are you looking for?

	•	Lose weight
	•	Gain weight
	•	Reduce body fat
	•	Build muscle
	•	Lean out
	•	Tone / sculpt
	•	Lose fat and gain muscle

⸻

💪 Performance — "Improve performance"

Question: What does performing better mean to you?

	•	Build strength
	•	Increase endurance
	•	Improve stamina
	•	Improve recovery
	•	Train for an event
	•	Improve performance in a sport
	•	Improve overall fitness

Note: Performance intents are primarily fitness-domain concerns. The nutrition domain supports them — it does not own them. These intents arrive as cross-domain context that shapes how nutrition operates (e.g., fueling for endurance, recovery nutrition).

⸻

❤️ Medical — "Manage a health condition"

Question: What health concern would you like to address?

	•	Manage diabetes
	•	Lower cholesterol
	•	Manage blood pressure
	•	PCOS support
	•	Thyroid support
	•	Improve digestion
	•	Reduce acidity / reflux

Note: The condition itself (e.g., diabetes) is a User Attribute. The desire to manage it through nutrition is an Intent. Both inform the domain, but through different channels.

⸻

🌱 Behavioral — "Improve food habits"

Question: What does eating better mean to you?

	•	Reduce sugar
	•	Reduce snacking
	•	Eat more protein
	•	Eat more vegetables
	•	Control portions
	•	Stop late-night eating
	•	Fix inconsistent meal timing

⸻

📋 Operational — "Planning & organization"

Question: What would getting organized look like?

	•	Plan meals better
	•	Weekly food planning
	•	Plan groceries better
	•	Cook more at home
	•	Prepare quicker meals
	•	Reduce food waste
	•	Organize family meals

Note: Operational intents are process-oriented rather than outcome-oriented. They describe how the user wants to operate, not what health outcome they seek. These may influence tool exposure and Configuration more than they influence Targets or policy.

⸻

Open Questions

	•	Should a wellbeing/energy category exist? (e.g., "Feel more energized," "Improve sleep through diet," "Reduce brain fog," "Feel less sluggish after meals")
	•	Should dietary identity / life stage be a category? (e.g., "Go vegetarian," "Try keto," "Eat cleaner during pregnancy," "Post-surgery nutrition")
	•	How does multi-select across categories work? Can a user hold "Lose weight" + "Manage diabetes" + "Reduce snacking" simultaneously?
	•	Do performance intents live here or in a future fitness intent taxonomy?
