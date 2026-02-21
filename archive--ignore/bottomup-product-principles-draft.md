Product Principles

(Design-Level Specification — Universal)

⸻

1. Purpose

Product Principles define how the product behaves at a fundamental level — independent of any domain, user, or policy.

They constrain how domain policies can be written and how the system interacts with the user. Every domain policy must operate within these principles.

⸻

2. Policy Architecture

Product + User policies → CONSTRAIN (set boundaries, overrides, non-negotiables)
Domain policies → SOLVE (operate within those constraints to serve the user)

The product defines what is never acceptable. The user defines what is preferred. The domain defines how to act within both.

⸻

3. Principles

I. Tools Are Independent

A tool should not be gated by another tool. LogMeal does not require SetTarget to have been run first. Each tool is an independent capability. If a dependency exists, it is resolved through onboarding (attribute/configuration/memory collection) — not by forcing tool sequencing.

⸻

II. Onboarding Is Context Collection

Onboarding is attribute collection, configuration setting, and declared memory intake. It is not a funnel. It is not tool sequencing. It exists to give the system enough context to serve the user's expressed intent.

⸻

III. Collect Only What Serves the Current Action

Don't pre-collect for future transitions. Intent setting is an atomic action — collect what IT needs. MealPlan is a separate transition — collect what IT needs when it happens. Every ask must be justified by the action the user is performing right now.

⸻

IV. No Adherence Burden

The product helps the user follow through. It does not guilt, nag, or create burden of adherence. Proactive surfacing (alerts, deviation warnings, reminders) happens only when the user has explicitly opted in via Configuration.

⸻

V. Any State, Any Time

The user can enter any state freely — including Analyze with zero context. Zero state is not a blocker; it is an onboarding opportunity. The system uses probing questions as data points when context is thin.

⸻

VI. Medical Safety Is Non-Negotiable

User attributes related to medical conditions are hard constraints on domain behavior. The product ensures safety can never be bypassed — not by user preference, not by domain policy. The domain proactively defines how to handle medical conditions (it has the domain-specific knowledge), but the product ensures those constraints are always enforced.

⸻

VII. Circumstances Are Soft Context

Circumstances (traveling, sick, stressed) lead to soft backoff — suggestions, adjusted framing, lighter tool exposure. They do not hard-override domain policy. They do not flip switches automatically. The user retains control.

⸻

VIII. Intent Conflicts Surface to the User

When multiple intents conflict, the system surfaces the conflict to the user. Tie-breaking is a user intervention, not a system decision. The system can blend non-conflicting intents silently, but genuine tension is always shown.

⸻

IX. Proactivity Is Earned

The system does not proactively intervene by default. Proactive behavior (suggestions, alerts, nudges) is controlled by User Configuration. The default posture is: respond when asked, be ready when needed, don't interrupt.

⸻

X. Transitions Are Context-Dependent

The system does not prescribe a fixed sequence of states. Transitions out of any state depend on what the context suggests and what the user needs. Analyze might lead to Plan, Learn, or Do — depending on what was observed.

⸻

4. Relationship to Other Layers

These principles sit above all other policy layers:

Product Principles (this document)
    ↓ constrains
User-Level Policies (cross-domain, shaped by User Context)
    ↓ constrains
Domain Policies (domain-specific, solve within constraints)

⸻

5. Open Questions

	•	Circumstance creation policy: How are circumstances created? (User-declared, system-inferred, conversational?) To be defined.

⸻

6. One-Line Definition

Product Principles are the non-negotiable behavioral constraints that every domain policy must obey — ensuring tools are independent, context collection is purposeful, adherence is never a burden, safety is never bypassed, and the user always retains control.
