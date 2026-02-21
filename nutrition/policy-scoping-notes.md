Policy Scoping Notes

Notes from scenario walkthroughs. Each decision tagged as [PRODUCT], [USER], or [DOMAIN].

⸻

Scenario 1: Cold Start — "I want to lose weight"

1a. Entry and onboarding

[PRODUCT] "Enter from any state" is not a blanket policy. If beginning work on an intent requires something (attributes, configuration, declared memories), the system asks for it. Asking is justified when it serves the expressed intent.

[PRODUCT] "Onboarding" should be thought of primarily as attribute/configuration collection or declared memory intake. It is not tool sequencing.

[PRODUCT] A tool should not be gated by another tool. If "LogMeal" requires "SetTarget" to have been run first, that's a product policy problem — not a domain policy. Tools are independent capabilities.

1b. Missing dependencies (e.g., calorie target for "lose weight")

Covered by 1a. If a dependency is needed for the intent, it's collected as configuration during onboarding. The system can derive suggestions from attributes. But no tool is gated by another tool.

1c. How much to collect during onboarding

[PRODUCT] Only collect what serves the current action. Intent setting is an atomic action — collect what IT needs. MealPlan is a transition — collect what IT needs when it happens. Don't pre-collect for future transitions.

⸻

Scenario 2: Week 3 — Adherence Dropping

2a. Should the system proactively surface declining adherence?

[PRODUCT] The product should not create burden of adherence. It helps the user follow through — it does not guilt or nag. Proactive surfacing (alerts, deviation warnings) happens only if the user has explicitly opted in (e.g., reminders via User Configuration).

2b. Right response to declining engagement?

Covered by 2a. The system does not respond to declining engagement with alerts or interventions unless invited. When the user returns — or enters Analyze — the context is there, ready to be surfaced on demand.

2c. Can the system create circumstances from conversation?

[TBD] There is a need for a circumstance creation policy — how circumstances are created (user-declared, system-inferred, conversational). Exact policy to be defined later.

⸻

Scenario 3: Medical — Diabetic User Wants Meal Suggestions

3a–c. Medical safety, defaults, and post-action feedback

[PRINCIPLE] Policy layers have different roles:
	•	Product + User policies → CONSTRAIN (set boundaries, overrides, non-negotiables)
	•	Domain policies → SOLVE (operate within those constraints to serve the user)

[PRODUCT] Respect user attributes. Medical conditions are non-negotiable constraints on domain behavior. Product ensures safety can never be bypassed.

[DOMAIN] The domain proactively bakes in medical awareness — it has the domain-specific knowledge. For diabetic users: carb-aware suggestions, glycemic index awareness, conservative defaults. The domain does not wait for the product to tell it to be careful.

[DOMAIN] Auto-apply sensible medical defaults (e.g., conservative carb limit for diabetes). This is the domain solving within the constraint.

[PRODUCT] In safety-critical cases, domain policy cannot be overridden by user preference.

⸻

Scenario 4: Circumstance Change — User Starts Traveling

4a–c. How circumstances affect domain behavior

[PRODUCT] The user should not feel the adherence burden — the system should absorb that burden internally.

[PRODUCT] Circumstances are soft context, not hard overrides of domain policy. They lead to soft backoff — suggestions to relax, adjusted framing, lighter tool exposure — but they don't flip policy switches automatically.

[USER] Circumstances suggest adjustments to the user. They do not dictate them. The user retains control.

(4b — logging drops during travel. Covered by Scenario 2: no adherence nagging unless invited.)

(4c — travel ends. Since circumstances are soft, there's no hard revert. The system gradually normalizes as the circumstance resolves.)

⸻

Scenario 5: Multi-Intent — "Lose weight + reduce snacking + plan meals"

5a–c. Multiple intents, different loops, potential conflicts

[PRODUCT] Work within the constraints of ALL expressed intents. Suggest the best plan that satisfies the combined intent space.

[PRODUCT] If intents conflict, surface the conflict to the user. Tie-breaking is a user intervention, not a system decision. The system does not silently resolve intent conflicts.

[DOMAIN] The domain can blend non-conflicting intents (e.g., "lose weight" + "reduce snacking" are complementary — snacking reduction supports calorie deficit). Only surface conflict when intents genuinely pull in opposite directions.

⸻

Scenario 6: Direct State Entry — User Goes Straight to Analyze

6a. Can the user enter Analyze freely, even with zero data?

[PRODUCT] Yes. User can freely enter any state — even Analyze with zero context. The system uses probing questions as data points. "What did you eat today?" is both analyzing and creating context. Zero state is not a blocker — it's an onboarding opportunity.

6b. What transition does the system suggest after Analyze?

[DOMAIN] Transition out of Analyze is context-dependent, not fixed. "Protein under target" could lead to:
	•	Plan — "Want to adjust your plan?"
	•	Learn — "Want to understand why protein matters?"
	•	Do — "Want to try a high-protein meal now?"

The next state depends on what the observation suggests and what the user's context supports.

⸻

Summary: Policy Scoping Principles

[PRODUCT] principles surfaced:
	1.	Onboarding = attribute/config/declared memory collection — not tool sequencing
	2.	Tools are not gated by other tools
	3.	Only collect what serves the current action — don't pre-collect for future transitions
	4.	No adherence burden — the system helps follow through, doesn't guilt
	5.	Proactive surfacing only when user has opted in
	6.	Product + User policies CONSTRAIN; Domain policies SOLVE
	7.	Medical safety: product ensures it's non-negotiable; domain defines the specifics
	8.	Circumstances are soft context — suggestions, not hard overrides
	9.	Intent conflicts surfaced to user — tie-breaking is user intervention
	10.	User can enter any state freely — zero state is onboarding opportunity, not blocker

[TBD]:
	•	Circumstance creation policy (declared, inferred, conversational?)
