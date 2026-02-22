Services Architecture

Mapping engineering blocks to backend services.

⸻

Service Inventory

  ┌──────────┐     ┌──────────────┐     ┌─────────────┐
  │  Client  │────▶│  API Gateway │────▶│ Orchestrator │
  └──────────┘     └──────────────┘     └──────┬──────┘
                                               │
                        ┌──────────────────────┼──────────────────────┐
                        ▼                      ▼                      ▼
                 ┌─────────────┐      ┌──────────────┐      ┌──────────────┐
                 │ LLM Service │      │ Data Service  │      │ Event Service│
                 └─────────────┘      └──────────────┘      └──────────────┘

⸻

1. API Gateway

Single entry point. Auth, rate limiting, routing.

  Client → Gateway → Orchestrator (for all domain requests)
  Client → Gateway → Data Service (for direct reads: Browse, Timeline rendering)

Responsibilities:
- Authentication and session management
- Request routing
- Rate limiting (token spend controls here)
- WebSocket support for real-time updates (composition sessions)

⸻

2. Orchestrator

The brain. Receives intents, runs workflows, coordinates services. Maps to engineering blocks: Workflow Coordination + Orchestration.

Responsibilities:
- Intent classification (for Notes: "had coffee" → LogMeal)
- Workflow execution (deterministic tool flows with LLM judgment at decision points)
- Composition session management (HP05a multi-turn: tracks state across turns)
- Side effect coordination (Goal → config + memories + intent + plan recompute)
- Validation gate enforcement (HP05b pass/warn/block)

Owns no data. Stateless except for active composition sessions.

Workflows it runs:
  LogMeal        → LLM Service (extract) → Data Service (write MealLog) → Event Service (emit)
  SetGoal        → LLM Service (compose, multi-turn) → LLM Service (validate) → Data Service (write) → Event Service (emit)
  BuildMealPlan  → LLM Service (generate) → Data Service (write MealPlan) → Event Service (emit)
  ReviewPeriod   → Data Service (read logs) → LLM Service (analyze) → Data Service (write Review)
  NoteDispatch   → LLM Service (classify) → routes to appropriate workflow above

⸻

3. LLM Service

Wraps all LLM interactions. Maps to engineering block: LLM Pipeline.

Responsibilities:
- Context assembly (HP03: scopes context per trigger/surface)
- Prompt construction (expertise spec as system prompt + scoped context + policy)
- LLM API call management (provider abstraction, retries, fallback)
- Structured output parsing and validation
- Cost tracking (token counts per call type)

Serves all 5 call types:
  Tool judgment   → one-shot, structured output
  Content fill    → one-shot, prose output
  Composition     → per-turn, structured output { status, structure, response, question, options }
  Escape hatch    → one-shot, structured output (mid-workflow clarification)
  Conversational  → one-shot, prose output (Notes: brief answer cards)

Does NOT manage multi-turn state. Orchestrator owns session state; LLM Service is called per-turn.

Context Composer lives here:
  Given: trigger type, surface, user_id
  Assembles: expertise spec + relevant context + applicable policy
  Returns: complete prompt payload

⸻

4. Data Service

Source of truth. All reads and writes. Maps to engineering block: Data Modeling.

Responsibilities:
- CRUD for all entities (Food, Recipe)
- CRUD for all artifacts (MealPlan, MealLog, NutritionGoal, NutritionReview, ShoppingList, CookingPlan)
- User context storage (Attributes, Traits, Circumstances, Intents, Configuration)
- Domain context storage (Events, Observations, Memories)
- Query support for Timeline rendering (meals by date range)
- Query support for Browse (entities by type, filter, search)

Data ownership:
  Entities          → Food, Recipe (user-scoped)
  Artifacts         → all artifact types (user + domain scoped)
  User Context      → FactAttributes, ProseAttributes, Circumstances, Intents
  Domain Context    → Events (immutable), Observations, Memories
  Plan Settings     → domain-scoped FactAttributes

⸻

5. Event Service

Async event processing. Maps to engineering blocks: Event Processing + part of Orchestration.

Responsibilities:
- Event emission (meal_logged, goal_set, plan_built, circumstance_changed, etc.)
- Event listeners and handlers
- Trigger evaluation (event → should we do something?)
- Scheduled jobs (daily plan recalculation, weekly review generation, observation recomputation)
- WYLO container assembly (reads current state → assembles priority-ordered cards)

Event-driven flows:
  meal_logged         → MealPlan adaptation (if plan_enabled + reactivity: on_log)
  goal_set            → MealPlan recompute, config cascade
  circumstance_changed → MealPlan recompute (all active slots)
  plan_built          → WYLO update
  review_generated    → WYLO card surfaced
  periodic: daily     → plan recalculation (if reactivity: daily)
  periodic: weekly    → review generation trigger

Observation Engine lives here:
  Events → metrics → reports (HP02)
  Reports → dual-rendered observations (numerical for code, prose for LLM)
  Observations → stabilized → memories (declared + observed paths)

⸻

Communication Patterns

  Sync (request/response):
    Client → Gateway → Orchestrator → LLM Service (per-turn)
    Client → Gateway → Data Service (reads)
    Orchestrator → Data Service (reads/writes during workflow)

  Async (event-driven):
    Orchestrator → Event Service (emit event after workflow completes)
    Event Service → Orchestrator (trigger new workflow: plan adaptation)
    Event Service → Data Service (write observations, update WYLO state)

  Real-time (WebSocket):
    Composition sessions: Orchestrator → Client (structure updates per turn)
    WYLO updates: Event Service → Client (new card available)

⸻

Service Boundaries

  Service       Owns data?    Calls LLM?    Manages state?
  Gateway       No            No            Session/auth only
  Orchestrator  No            Via LLM Svc   Composition sessions (ephemeral)
  LLM Service   No            Yes           No (stateless per call)
  Data Service  Yes           No            Persistent data
  Event Service Partial       Via Orch      Event log, scheduled jobs

⸻

Scaling Characteristics

  Gateway        → horizontal, stateless
  Orchestrator   → horizontal, sticky sessions for composition (or externalize to Redis)
  LLM Service    → limited by LLM API rate limits, queue-based for non-real-time calls
  Data Service   → standard DB scaling
  Event Service  → queue-based, can lag safely (async by nature)

⸻

Open Questions

1. Orchestrator session storage. Composition sessions need multi-turn state. In-memory (sticky sessions) or externalized (Redis)?

2. LLM provider abstraction. Single provider or multi-provider with routing? Cost vs quality tradeoffs.

3. Data Service granularity. One service or split (entity service, context service, artifact service)?

4. Event Service scope. Is WYLO container assembly part of Event Service or a separate service?

5. Offline support. If client goes offline, Notes queue locally and sync on reconnect. Where does conflict resolution live?
