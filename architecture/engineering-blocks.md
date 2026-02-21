Engineering Blocks

⸻

1. Overview

Six engineering problems to solve, derived from domain model + architecture decisions (HP01-HP04).

1. Data Modeling — schema for entities, events, memories, user context, config
2. Event Processing — async pipeline: events → metrics → observations
3. LLM Pipeline — context assembly + LLM call + structured output + validation
4. Client App — presentation, interaction, UX
5. Workflow Coordination — tool execution, flow management, triggers
6. Orchestration — catch-all coordination of the cycle

The cycle: Ingest → Store → Compute → Reason → Present → Ingest

⸻

2. Block Definitions

Data Modeling
Store structured ground truth. Entities (Food, Meal, Recipe), artifacts (MealPlan, MealLog, Goal, Review, ShoppingList, CookingPlan), events (immutable log), memories (declared + observed), user context (attributes, traits, circumstances, intents, config), domain config.
Difficulty: Standard engineering.

Event Processing
Async batch + eventing. Event fires (meal_logged) → triggers report recomputation → observations update. Periodic batch for weekly summaries. Reports produce dual-rendered observations: numerical for code paths, prose for LLM (HP02).
Difficulty: Standard data engineering.

LLM Pipeline
The blob. Context scoping + LLM integration are two phases of one pipeline:
- Scope: given a trigger, what data + metrics are relevant? (HP03 — determined by where the user is)
- Assemble: package into prompt (expertise spec as system prompt + scoped context + policy)
- Call: LLM API, structured output expected
- Validate: check output before writing to data layer
- Write: entity mutations, memory updates

Prompt construction, output schemas, validation rules, latency management, cost management.
Difficulty: Needs design work. Core engineering challenge.

Client App
Presentation and interaction. Hard shells with LLM-filled content (HP01). Interaction design fully TBD.
Difficulty: Needs design work.

Workflow Coordination
Deterministic paths for tool execution (BuildMealPlan, LogMeal, SetGoal, etc.) with LLM judgment injected at decision points. Side effect handling (Goal → config + memories). Flow management.
Difficulty: Needs design — step-by-step tool workflows not yet defined.

Orchestration
Catch-all. Coordinates the cycle — what triggers what, in what order. User actions, system events, scheduled jobs. Glue between all other blocks.

⸻

3. Coverage Map — Domain Files → Engineering Blocks

nutrition-model.md
- Entities (Food, Meal, Recipe) → Data Modeling ✓
- Artifacts (MealPlan, MealLog, Goal, Review, ShoppingList, CookingPlan) → Data Modeling ✓
- Tools (BuildMealPlan, LogMeal, SetGoal, etc.) → Workflow Coordination ✓
- Goal side effects (sets config + memories) → Workflow Coordination ✓

nutrition-context.md
- Events (10 types) → Event Processing ✓
- Configuration (7 params) → Data Modeling ✓
- Observations (quantitative, pattern, deviation) → Event Processing + LLM Pipeline ✓
- Memories (declared + observed) → Data Modeling ✓
- Context composition (observed + declared paths) → LLM Pipeline ✓

nutrition-expertise.md
- 8 expertise components → LLM Pipeline (system prompt) ✓
- Expertise tiers (core/base+aux/aux) → LLM Pipeline (prompt vs retrieval) ✓
- System prompt → LLM Pipeline ✓

nutrition-policy.md
- Base policies → LLM Pipeline (prompt input) ✓
- 8 prior-specific governance profiles → LLM Pipeline (conditional prompt) ✓
- Circumstance modulation → LLM Pipeline ✓

user-context-nutrition.md
- Attributes → constraints → Data Modeling + LLM Pipeline ✓
- Traits → behavioral shaping → LLM Pipeline ✓
- Circumstances → temporary modulation → LLM Pipeline ✓
- Configuration → interaction style → Client App + LLM Pipeline ✓
- Intent taxonomy (5 categories, 35+ sub-intents) → Data Modeling ✓

policy-scoping-notes.md
- 10 product-level principles → Design constraints (inform all blocks) ✓

⸻

4. Gaps — Domain Concepts Without a Clear Engineering Home

Gap 1: States and Transitions
States (Learn, Plan, Do, Analyze) and transitions (state → state) are defined in the domain model. But no block explicitly tracks "what state is the user in" or manages transitions. Is state tracked explicitly by the system, or inferred by the LLM from context each time?

Gap 2: Engagement Level Detection
Defined as an observed trait — derived from behavior (logging frequency, tool usage, session frequency). This is not user-declared. Is it a computed metric (event processing)? Or an LLM judgment? It influences expertise posture (browsing → friend, committed → advisor).

Gap 3: Intent Activation
Intents are defined and taxonomized. They shape state emphasis, artifact priority, and tool exposure. But who reads intents and configures the system accordingly? Is it the LLM reading intents as part of context? Or does the system deterministically route based on active intents?

Gap 4: Proactivity
The system reaching out — scheduled reviews, nudges, insight surfacing. This is system-initiated, not user-triggered. No block handles triggers that originate from the system rather than from a user action. Could be scheduled jobs (event processing), could be its own concern.

Gap 5: Cross-Domain Inputs
nutrition-context.md defines cross-domain inputs (weight, blood sugar, workouts, stress). These are parked with domain routing (future), but the domain files reference them.

⸻

5. Open Architectural Choice

Gaps 1 and 3 may be the same question: does the system explicitly track state + intent and deterministically configure behavior? Or does the LLM infer everything from context each time?

Option A: Explicit state tracking. The system tracks current state and active intents. Uses them to deterministically configure context scoping, tool exposure, and presentation. LLM receives state as input.

Option B: LLM-inferred. No explicit state tracking. The LLM reads context (entities, memories, recent events) and infers where the user is and what to prioritize. State is emergent, not tracked.

Option C: Hybrid. Some things are explicit (active intents, engagement level as computed metric), some are inferred (current state within a session).

Resolution: TBD.
