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

4. Gaps — Resolved

Gap 1: States and Transitions — RESOLVED
States are not tracked as runtime state machines. They served as design scaffolding to discover artifacts and tools. At runtime, states dissolve into:
- Design output (artifacts, tools) → already in Data Modeling + Workflow Coordination
- Expertise methodology (LLM posture guidance) → already in LLM Pipeline (system prompt)
- UX context signal → where the user is in the app naturally carries a state tag (e.g., meal plan builder = Plan, viewing logs = Analyze). This tag flows to context composer for scoping (HP03) and to expertise as posture cue. No new block needed.

Gap 2: Engagement Level Detection — RESOLVED
Falls into HP02. Logging frequency, session frequency, tool usage are all event-derived metrics. System reports user metrics and summaries that can be turned into observations. Exact thresholds and qualitative dimensions are implementation detail. No new block.

Gap 3: Intent Activation — RESOLVED
Goals create intents as side effects (alongside config and memories). Within a domain, Goal → creates domain intent. Across domains, other domain Goals create user-level intents that are visible as cross-domain context. All relevant intents are injected as context. Expertise (LLM) reads intents and uses judgment — all domain judgments live in expertise, as it's the only mechanism with semantic understanding. No deterministic routing based on intent. No new block.

Gap 4: Proactivity — RESOLVED
Triggered by cron (scheduled jobs) and eventing (event-driven thresholds). Both feed into the same pipeline: trigger → context compose → LLM → output. The trigger source is system-initiated instead of user-initiated, but the pipeline is identical. Lives in Event Processing + Orchestration. No new block.

Gap 5: Cross-Domain Inputs — PROVISIONALLY RESOLVED
Treated as domain signals or user signals. Weight, blood sugar, workouts, stress enter the system through existing data layer mechanisms. Full cross-domain routing architecture is parked for multi-domain phase.
