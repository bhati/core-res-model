Domain Context

(Design-Level Specification — Domain Scoped)

⸻

1. Purpose

The Domain Context defines the context space of a domain.

If the Domain Model defines structure — what exists, what can happen, and how engagement occurs —

Then the Domain Context defines reality — what has happened, what is true now, and what has been learned.

The Domain Context takes signals produced by domain activity and composes them into context.

This context is what governance reads to shape how the domain operates.

This model is domain-scoped.
It excludes cross-domain user context.

⸻

2. Core Components

The Domain Context consists of four categories:
	1.	Events
	2.	Configuration
	3.	Observations
	4.	Memories

These represent four forms of context, differing in how they are produced and how stable they are.

⸻

3. Events

Definition

Events are atomic occurrences within the domain.

They are:
	•	Time-bound
	•	Factual
	•	Non-interpretive
	•	Immutable

Events represent what happened. They are the raw inputs to the context space.

⸻

Sources

Events are produced by domain activity:
	•	Tool invocations (e.g., meal_logged, plan_created)
	•	Artifact instantiation (e.g., plan_created, target_set)
	•	User declarations (e.g., exception_declared, signal_reported)
	•	State transitions (e.g., moved from Do to Analyze)

⸻

Examples (Nutrition Domain)
	•	meal_logged
	•	snack_logged
	•	plan_created
	•	plan_modified
	•	reflection_submitted
	•	exception_declared

⸻

Role

Events are the ground truth of the domain.

All interpretation and stabilization must ultimately trace back to events.

Events describe action.
They do not explain it.

⸻

4. Configuration

Definition

Configuration consists of structured, declarative facts that define how the domain operates for this user.

It is:
	•	Explicit
	•	Non-inferred
	•	Structured (not prose)
	•	Operable

Configuration is declared context — stated by the user or set during onboarding, not derived from events.

⸻

Examples (Nutrition Domain)
	•	dietary_type: vegetarian
	•	calorie_target: 1800
	•	fasting_window: 16:8
	•	macro_split: 30/40/30

⸻

Role

Configuration constrains and shapes planning and execution inside the domain.

It defines operational parameters.

Configuration is not memory in the interpretive sense.
It is context the user declares rather than context the system derives.

⸻

5. Observations

Definition

Observations are composed context — computed or interpreted outputs derived from events and configuration.

They represent the processed understanding of the domain.

Observations may be:
	•	Quantitative summaries
	•	Comparisons
	•	Correlations
	•	Pattern statements
	•	Deviations
	•	Behavioral tendencies

They are:
	•	Domain-scoped
	•	Evidence-linked
	•	Context-sensitive
	•	Provisional by default

⸻

Examples (Nutrition Domain)
	•	"Average protein intake last 7 days: 68g."
	•	"Late dinners occurred 4 times this week."
	•	"Higher protein breakfasts coincide with reduced snacking."
	•	"Plan adherence decreased during travel."

Some observations are descriptive.
Some are interpretive.

Structurally, they are the same class:

Composed context derived from events.

⸻

Role

Observations:
	•	Inform Analyze mode
	•	Suggest plan adjustments
	•	Surface meaningful patterns
	•	Serve as candidates for stabilization

They are provisional.

They become durable only when promoted.

⸻

6. Memories

Definition

Memories are stabilized context within a domain.

They are:
	•	Durable
	•	Domain-scoped
	•	Interpretive
	•	Behavior-shaping

Memories arrive via two paths:

Declared memories — the user states a truth directly. “I avoid eggs.” “I don’t cook on weekdays.” These go straight into memories with no observation period. The user is the evidence. Declared memories are the primary cold start mechanism — they populate the context space before any events exist.

Observed memories — the system derives a truth through the lifecycle. Events accumulate → observations form → repeated observations stabilize into memories. These require evidence and time.

Both are memories. Both are durable. Both shape policy. They differ only in how they arrive.

⸻

Examples (Nutrition Domain)
	•	“Avoids eggs.”
	•	“Prefers high-protein breakfast.”
	•	“Does best with fixed meal timing.”
	•	“Heavy lunches usually stabilize my energy.”
	•	“Spicy dinners often cause discomfort.”
	•	“I skip breakfast when stressed.”

⸻

Role

Memories influence:
	•	Planning structure
	•	Reflection framing
	•	Tool usage
	•	Transition shaping (via policy)

They personalize the domain without relying on cross-domain user identity.

⸻

7. Context Composition

Within a domain, context evolves through two paths:

Observed path:
Events → Observations → Memories

Declared path:
User states a truth → Memories (directly)

Configuration operates alongside both paths as operational parameters.

The result is the domain’s accumulated understanding — the context that policy reads.

⸻

8. What This Model Does Not Include

The Domain Context does not include:
	•	Cross-domain user identity
	•	Global user memory
	•	Governance rules
	•	Entity definitions
	•	Artifact definitions
	•	Cross-domain arbitration

It remains strictly domain-scoped.

⸻

9. One-Line Definition

The Domain Context is the context space of a domain: taking events from domain activity, composing them into observations, and stabilizing them into memories — producing the accumulated reality that governance reads.
