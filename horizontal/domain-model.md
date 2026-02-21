Domain Model

(Design-Level Introduction)

⸻

1. Purpose

The Domain Model defines the structure of a behavioral product space.

It answers:
	•	What exists in this domain?
	•	What can a person do?
	•	In what modes do they operate?
	•	How does meaningful movement occur?

It is independent of:
	•	Governance
	•	Personalization
	•	Data storage
	•	Technical implementation

The Domain Model describes the shape of the human activity space the product inhabits.

2. Core Components

The Domain Model consists of five primitives:
	1.	States
	2.	Transitions
	3.	Entities
	4.	Artifacts
	5.	Tools

These are sufficient to describe any behavioral domain.


The 4 Core States (Behavioral OS)

1️⃣ Learn

Acquire knowledge.
External models, frameworks, science, technique, explanations.

Output: Understanding.

⸻

2️⃣ Plan

Convert intention into structure.
Targets, constraints, sequencing, scheduling, rules.

Output: Commitment architecture.

⸻

3️⃣ Do

Execute behavior in the real world.
Eat, cook, lift, log, capture, meditate, sleep, apply skincare.

Output: Lived action.

⸻

4️⃣ Analyze

Observe outcomes and interpret signals.
Reflect, detect patterns, evaluate feasibility.

Output: Insight.

⸻

The 16 Transitions (From → To)

Each cell is a movement of cognitive mode.

Diagonals (Mode Intensification)
	•	Do → Do: Pure execution momentum
	•	Analyze → Analyze: Deep patterning (risk: rumination)

⸻

High-Value Product Loops
	•	Do → Analyze: Capture feedback
	•	Plan → Do: Execute structured intention

⸻

What We Discovered Across Domains

The matrix works everywhere:
	•	Nutrition
	•	Fitness
	•	Mindfulness
	•	Body care
	•	Health routines

Because all behavior change requires:
	•	Knowledge
	•	Structure
	•	Action
	•	Feedback

⸻

What Changes by Domain

Different domains emphasize different loops:
	•	Nutrition: Do → Analyze → Plan
	•	Fitness: Plan → Do → Analyze
	•	Mindfulness: Do-heavy, light Analyze
	•	Body care: Plan → Do → light Analyze

The structure holds; gravity shifts.

5. Entities

Entities are the meaningful nouns of the domain.

They are:
	•	Concrete or conceptually stable
	•	Recognizable to the user
	•	The objects of action
	•	Domain-specific

Examples:
	•	Nutrition: Food, Meal
	•	Fitness: Exercise, Workout

Entities define what the domain is "about."

If entities are unclear, the domain feels incoherent.

⸻

6. Artifacts

Artifacts are the structured forms that a domain demands exist.

They are domain imperatives — persistent objects that give states meaning and make transitions possible. A MealPlan exists as a domain need before any tool creates it. A MealLog is something the domain requires in order to function.

They are:
	•	Structured and persistent
	•	Referencable objects within the domain
	•	Inputs into future transitions
	•	Evidence of movement across states

Artifacts can create side effects in the context layer. A Goal artifact (a commitment) may set Configuration values and create declared memories.

⸻

Role of Artifacts in the Domain Model

If:
	•	Entities define what exists,
	•	States define how a person engages,

Then:

Artifacts are the structured forms the domain demands be produced.

Artifacts allow continuity across transitions.

They make behavior accumulative rather than ephemeral.

⸻

Examples (Nutrition Domain)

Artifact	Instantiated By	Type
MealPlan	BuildMealPlan	Structured plan
MealLog	LogMeal	Event record
Goal	SetGoal	Commitment (creates context side effects)
Review	ReviewPeriod	Snapshot
ShoppingList	BuildShoppingList	Derived

Artifacts persist beyond the immediate transition and can:
	•	Be referenced in later planning
	•	Be analyzed further
	•	Be revised or replaced
	•	Contribute to pattern formation

⸻

7. Tools

Tools are structured capabilities that instantiate artifacts and enable states and transitions.

They are verbs made usable.

Two types:

Artifact tools — artifact-scoped, one tool per artifact. The artifact defines the tool's shape. Each artifact tool produces exactly one artifact type.
Examples: BuildMealPlan → MealPlan, LogMeal → MealLog, SetGoal → Goal.

State enablers — domain-scoped, no artifact produced. They operate across all entities and concepts within the domain to enable a state.
Examples: Explain (enables Learn state across all nutrition entities).

Tool granularity is handled via parameters, not proliferation. BuildMealPlan with a single-meal parameter, not a separate RecommendMeal tool.

Tool reuse across domains is a product-space concern, not a domain model concern.

⸻

8. How the Pieces Relate

The Domain Model can be summarized as:

A person, in a given state of intent, uses tools to act on entities and instantiate artifacts, moving between states via transitions.

More structurally:
	•	Entities are what exists.
	•	Artifacts are the structured forms the domain demands.
	•	States are modes of engagement.
	•	Tools instantiate artifacts and enable states and transitions.
	•	Transitions describe movement between states.

Everything else in the product derives from this structure.

⸻

9. What the Domain Model Is Not

The Domain Model does not include:
	•	Personalization
	•	Safety policies
	•	Optimization rules
	•	Data schemas
	•	Memory systems
	•	Cross-domain arbitration

Those belong to other layers.

The Domain Model defines capability and movement only.

⸻

10. Design Principles

A coherent domain model:
	•	Has a small, clear set of entities
	•	Has recognizable states
	•	Has meaningful transitions
	•	Has artifacts that give states meaning
	•	Has tools that cleanly enable states and transitions
	•	Forms a natural loop

If the loop feels forced, the domain is mis-specified.

⸻

11. One-Line Definition

The Domain Model is:

The structured space in which a person, through tools, acts on domain entities and instantiates domain artifacts while moving between intent states via recognizable transitions.