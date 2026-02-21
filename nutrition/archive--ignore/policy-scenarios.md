Policy Scenarios — Dry Run

Purpose: Run 6 scenarios through the model. At each decision point, ask: is this a Product principle, User-level policy, or Domain policy? Surface open questions.

⸻

Scenario 1: Cold Start — "I want to lose weight"

User opens app for the first time. Says "I want to lose weight."

What happens?

a) User has expressed an intent. The system knows: intent = lose_weight. It knows nothing else.

	Decision: Does the system force onboarding before doing anything?
	Or does it let the user act immediately?

	→ Q: Can the user go straight to "log a meal" without setting a target first?
	→ Q: Must the system collect attributes (age, sex, height) before it can help?
	→ Q: WHO decides what's required vs. optional? The product? The domain?

b) If the system needs a calorie target to support "lose weight," but the user hasn't set one:

	Decision: Does the system derive a suggestion? Block until user sets one? Operate without one?

	→ Q: Is "resolve dependencies for the user" a product principle or a domain behavior?

c) The system asks a few questions: dietary type, foods you avoid, how many meals.

	Decision: How much to ask? What's the threshold?

	→ Q: Is "don't collect data unless it serves the expressed intent" a product principle?
	→ Q: If the user said "lose weight" — is asking cuisine preference justified? It helps BuildPlan but doesn't serve "lose weight" directly.

⸻

Scenario 2: Week 3 — Adherence Dropping

User has been logging for 3 weeks. First 2 weeks: logged 6/7 days, close to target. Week 3: logged 3/7 days, over target by 400 kcal on logged days.

What happens?

a) Observations form: "Logging frequency dropped," "Average intake exceeded target."

	Decision: Does the system surface this proactively or wait for user to ask?

	→ Q: Is proactivity a user configuration, a domain policy, or a product principle?

b) The system could: alert the user, simplify the plan, ask if something changed, do nothing.

	Decision: What's the right response to declining engagement?

	→ Q: Is "don't nag" a product principle? Or does it depend on user traits (some users want accountability)?
	→ Q: Should the system infer a circumstance? ("Seems like a tough week — want to pause targets?")
	→ Q: Is inferring circumstances a product capability or overstepping?

c) If the system asks "is something going on?" and the user says "work is crazy":

	Decision: Does this become a declared circumstance? Does it modify policy automatically?

	→ Q: Can the system create circumstances from conversation, or must the user explicitly declare them?

⸻

Scenario 3: Medical — Diabetic User Wants Meal Suggestions

User has attribute: diabetes. Intent: "manage diabetes." They ask: "What should I eat for dinner?"

What happens?

a) The system needs to suggest a meal that's low-GI, within carb limits, respects food exclusions and preferences.

	Decision: How much safety constraint applies? Hard-block high-GI foods? Or suggest with a warning?

	→ Q: Is medical safety a product principle (always hard-block), a domain policy (nutrition-specific logic), or user-configurable?
	→ Q: What if the user explicitly asks for something the system considers risky? ("Suggest me a pasta dish")

b) The user hasn't set a carb target. But they have diabetes.

	Decision: Should the system auto-apply a conservative carb limit? Ask the user first? Operate without one?

	→ Q: Is "apply sensible defaults for known medical conditions" a product principle or domain policy?
	→ Q: Can a domain policy override user choice? (User sets carb target to 300g despite diabetes)

c) The user logs a high-sugar meal.

	Decision: Flag it? Silently note it? Suggest alternatives for next time?

	→ Q: Is post-action feedback a product behavior or domain policy?
	→ Q: Does the system have the right to editorialize on what the user ate?

⸻

Scenario 4: Circumstance Change — User Starts Traveling

User has been on a plan for 4 weeks. They declare: "I'm traveling next week."

What happens?

a) Circumstance enters: traveling (upcoming → active).

	Decision: What changes automatically vs. what requires user confirmation?

	→ Q: Does the system auto-relax plan adherence? Or ask "want me to adjust expectations?"
	→ Q: Is "circumstances modify policy automatically" a product principle? Or should the user always confirm?

b) During travel, logging drops. No meals logged for 2 days.

	Decision: Does the system remind? Stay quiet? Ask if they're okay?

	→ Q: Is logging frequency expectation a domain policy that should relax during circumstances?
	→ Q: Is "reduce notifications during difficult circumstances" a product principle or user configuration?

c) Travel ends. User is back home.

	Decision: Does the system automatically revert to pre-travel mode? Ask to confirm? Gradually transition?

	→ Q: Is circumstance expiry automatic, user-declared, or system-inferred?
	→ Q: Is the revert behavior a product principle or domain policy?

⸻

Scenario 5: Multi-Intent — "Lose weight + reduce snacking + plan meals"

User declares three intents across three categories: body_composition + behavioral + operational.

What happens?

a) Three intents suggest different transition loops:
	- Lose weight → Plan → Do → Analyze (target-driven)
	- Reduce snacking → Do → Analyze → Plan (pattern-driven)
	- Plan meals → Plan → Do (execution-focused)

	Decision: Which loop wins? Can they coexist? Does the system prioritize?

	→ Q: Is intent arbitration a product principle, user choice, or domain logic?
	→ Q: Should the user rank intents? Or should the system blend them?

b) Three intents suggest different primary tools:
	- Lose weight → SetTarget, ReviewPeriod
	- Reduce snacking → LogMeal (with triggers), DetectPatterns
	- Plan meals → BuildPlan, ShoppingList

	Decision: Surface all tools at once? Phase them?

	→ Q: Is "don't overwhelm the user" a product principle?
	→ Q: Is tool sequencing a domain policy or product UX principle?

c) The intents partially conflict: "plan meals better" wants structure, but "reduce snacking" needs pattern detection first (to know what to fix).

	Decision: Which takes priority?

	→ Q: Does the system detect conflicts between intents?
	→ Q: Is conflict resolution a product capability or domain logic?

⸻

Scenario 6: Direct State Entry — User Goes Straight to Analyze

User opens app and says "How am I doing?" — entering Analyze directly, without logging today.

What happens?

a) User has 10 days of meal logs. No explicit review requested until now.

	Decision: Can the user enter Analyze freely, or must they be guided there by the system?

	→ Q: Is "user can enter any state freely" a firm product principle?
	→ Q: Does the system need to do anything special when the user enters a state out of the expected loop?

b) The system runs ReviewPeriod. But the user hasn't logged today yet.

	Decision: Include today (partial data) or exclude? Mention the gap?

	→ Q: Is handling partial data a domain policy or product behavior?

c) The review shows "protein consistently under target." The natural next transition is Analyze → Plan.

	Decision: Does the system suggest "want to adjust your plan?" or wait for the user to ask?

	→ Q: Is suggesting the next transition a product behavior, domain policy, or user configuration (proactivity level)?

⸻

Questions Grouped by Scope

After all scenarios, here are the questions that surfaced, grouped by where they MIGHT belong:

PRODUCT LEVEL (apply to all domains)
	•	Can the user enter any state at any time?
	•	Should the system resolve dependencies silently?
	•	Should data collection only happen when it serves the user's expressed intent?
	•	Is "don't overwhelm the user" a design principle?
	•	Can the system infer circumstances from conversation?
	•	Does the system have the right to editorialize on user actions?
	•	Is intent conflict resolution a product capability?
	•	How does circumstance lifecycle work? (auto-detect, user-declared, system-inferred, auto-expire?)

USER LEVEL (cross-domain, shaped by user context)
	•	Proactivity — does the system surface insights and suggestions, or wait to be asked?
	•	Notification behavior during difficult circumstances
	•	How much accountability vs. gentleness
	•	Does the user rank intents or does the system blend?
	•	Should the system auto-apply medical defaults, or ask first?

DOMAIN LEVEL (nutrition-specific)
	•	What's a sensible default carb limit for a diabetic user?
	•	When is there "enough data" for a first review? (7 days? 5 logs?)
	•	How much should plan adherence relax during travel?
	•	What foods to hard-block vs. warn about for medical conditions?
	•	How to phase tool exposure for different intents?
	•	What observation thresholds trigger a transition suggestion?
