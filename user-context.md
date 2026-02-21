User Context

(Design-Level Specification — Cross-Domain)

⸻

1. Purpose

The User Context defines the cross-domain context of the person interacting with the system.

If:
	•	The Domain Model defines capability space,
	•	The Domain Context defines evolving domain reality,
	•	The Governance Layer configures domain behavior,

Then the User Context defines:

Who the person is, what is true about them, what is happening around them, what they are trying to achieve, and how they want the system to behave.

The User Context is cross-domain.
It is independent of any single domain.

⸻

2. Core Components

The User Context consists of five components:
	1.	Attributes
	2.	Traits
	3.	Circumstances
	4.	Intents
	5.	Configuration

These are sufficient to describe the user at design level.

⸻

3. Attributes

Definition

Attributes are structured, declarative facts about the person.

They are:
	•	Stable or slowly changing
	•	Non-interpretive
	•	Explicit
	•	Cross-domain

Attributes represent structural reality.

⸻

Examples
	•	sex
	•	age
	•	height
	•	chronic health conditions (e.g., diabetes)
	•	baseline physiological constants

⸻

Role

Attributes:
	•	Constrain domain behavior
	•	Inform governance boundaries
	•	Provide structural context

They are not interpretive and are not derived from patterns.

⸻

4. Traits

Definition

Traits are durable characteristics of the person.

They describe:
	•	Behavioral tendencies
	•	Identity patterns
	•	Emotional baselines
	•	Motivational style

Traits are:
	•	Cross-domain
	•	Semi-stable or long-term
	•	Often prose-based
	•	Behavior-shaping

⸻

Examples
	•	Prefers flexibility over rigid plans
	•	Over-optimizes when stressed
	•	Responds well to structured routines
	•	Easily discouraged by negative feedback
	•	Competitive and goal-driven
	•	High anxiety sensitivity
	•	Strong need for encouragement

Traits shape how governance configures intensity and feedback.

⸻

5. Circumstances

Definition

Circumstances are time-bound contextual conditions that affect how domains should operate.

They are:
	•	Temporary or phase-based
	•	Cross-domain
	•	Behavior-modifying
	•	Expirable

Circumstances represent the user's current or near-future reality.

⸻

Temporal Phases

Circumstances may be:
	•	Upcoming
	•	Active
	•	Resolving

⸻

Examples
	•	Currently sick
	•	Traveling next week
	•	High workload sprint
	•	Injury recovery
	•	Exam period
	•	Currently stressed
	•	Feeling overwhelmed
	•	Low energy

These influence governance intensity and transition shaping.

⸻

6. Intents

Definition

Intents are active directional commitments.

They describe what the user is currently trying to move toward.

Intents are:
	•	Time-bound
	•	Prioritized
	•	Mutable
	•	Cross-domain or domain-specific

⸻

Examples
	•	Lose 5kg
	•	Train for marathon
	•	Improve glucose stability
	•	Feel calmer during workdays
	•	Build consistent morning routine
	•	Feel more in control
	•	Feel energized

Intents define direction, not identity.

⸻

7. Configuration

Definition

Configuration defines how the user wants the system to behave.

It governs interaction style and system agency.

Configuration is:
	•	User-controlled
	•	Structured or semi-structured
	•	Cross-domain
	•	Interaction-focused

⸻

Examples
	•	Notification frequency
	•	Proactivity level
	•	Data density (numbers vs qualitative summaries)
	•	Tone (direct vs gentle)
	•	Planning rigidity preference
	•	Level of autonomy vs guidance

⸻

Role

Configuration does not describe the person.

It describes:

How the product should interact with the person.

It directly affects governance behavior and UX exposure.

⸻

8. What the User Context Does Not Include

The User Context does not include:
	•	Domain events
	•	Domain artifacts
	•	Domain observations
	•	Domain memories
	•	Governance rules
	•	Cross-domain arbitration logic

It remains purely person-centered.

⸻

9. Relationship to Governance

Governance reads:
	•	Attributes → structural constraints
	•	Traits → behavioral shaping
	•	Circumstances → temporary modulation
	•	Intents → directional priority
	•	Configuration → interaction exposure and system agency

The User Context does not execute behavior.
It informs how behavior should be shaped.

⸻

10. One-Line Definition

The User Context defines the person's structural facts, durable traits, temporary circumstances, active intentions, and interaction configuration that collectively shape how domains should operate for them.
