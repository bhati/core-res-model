Services Architecture

Tech stack decisions applied to backend services.

⸻

Tech Stack

  Client:       React (web) + iOS + Android
  Data + Auth:  Supabase (PostgreSQL + PostgREST + Auth + Realtime)
  Queue:        pgmq (PostgreSQL-native message queue, Supabase extension)
  Orchestrator: svc-orchestra (FastAPI — workflows + LLM)
  Events:       svc-events (FastAPI — event processing + observations)

⸻

Service Diagram

  ┌──────────────────────────┐
  │  Clients                 │
  │  React · iOS · Android   │
  └────────┬─────────────────┘
           │
    reads  │  actions
           │
  ┌────────▼─────────────────────────────────────────┐
  │  Supabase                                        │
  │  ┌──────────┐ ┌──────────┐ ┌────────┐ ┌──────┐  │
  │  │ Auth     │ │ PostgREST│ │Realtime│ │ pgmq │  │
  │  └──────────┘ └──────────┘ └────────┘ └──┬───┘  │
  │                PostgreSQL                 │      │
  └──────────────────────────────────┬────────┘──────┘
                                     │
                          publishes   │   consumes
                                     │
              ┌──────────────────┐   │   ┌──────────────────┐
              │  svc-orchestra   │───┘───│  svc-events      │
              │                  │       │                   │
              │  Orchestrator    │◄──────│  Event evaluation │
              │  LLM Service     │       │  Observations     │
              │                  │       │  WYLO assembly    │
              └──────────────────┘       │  Scheduling       │
                                         └──────────────────┘

  svc-orchestra publishes events to pgmq after workflows complete.
  svc-events consumes from pgmq, evaluates, and acts.

⸻

1. Supabase

What Supabase provides:

Auth — JWT tokens, RLS, session management.
PostgREST — auto-generated REST API. Direct reads for Browse, Timeline.
PostgreSQL — all entities, artifacts, user/domain context.
Realtime — WebSocket push to clients (composition updates, WYLO cards).
pgmq — PostgreSQL-native message queue. Event bus between services.

pgmq usage:
  Queues created per event type or per concern:
    q_meal_events     — meal_logged, meal_skipped, meal_confirmed
    q_plan_events     — plan_built, plan_adapted, plan_superseded
    q_goal_events     — goal_set, goal_revised
    q_context_events  — circumstance_changed, attribute_updated
    q_scheduled       — daily_recalc, weekly_review, observation_recompute

  svc-orchestra publishes:
    SELECT pgmq.send('q_meal_events', '{"type": "meal_logged", "id": "...", "user_id": "..."}');

  svc-events consumes:
    SELECT pgmq.read('q_meal_events', vt := 30, qty := 10);
    -- processes batch, then:
    SELECT pgmq.delete('q_meal_events', msg_id);

  Benefits:
  - No external queue infrastructure
  - Transactional with data writes (publish in same transaction as INSERT)
  - Visibility timeout (vt) gives at-least-once delivery
  - Dead letter via pgmq.archive()

⸻

2. svc-orchestra (custom backend)

The brain. Workflows + LLM. Single deployable FastAPI service.

Orchestrator:
- Intent classification (Notes: "had coffee" → LogMeal)
- Workflow execution (deterministic flows with LLM judgment)
- Composition session management (HP05a multi-turn)
- Side effect coordination (Goal → config + memories + plan recompute)
- Validation gate enforcement (HP05b pass/warn/block)

LLM Service:
- Context assembly (HP03: reads from Supabase, scopes per trigger)
- Prompt construction (expertise spec + context + policy)
- LLM API calls (provider abstraction, retries)
- Structured output parsing
- Cost tracking

After workflow completion:
  1. Write result to Supabase (INSERT/UPDATE)
  2. Publish event to pgmq (in same transaction if possible, otherwise immediately after)

Workflows:
  NoteDispatch   → classify intent → route to workflow below
  LogMeal        → LLM extract → write MealLog → publish meal_logged
  SetGoal        → LLM compose (multi-turn) → validate → write → publish goal_set
  BuildMealPlan  → LLM generate → write MealPlan → publish plan_built
  ReviewPeriod   → read logs → LLM analyze → write Review → publish review_generated

Session state: composition sessions in Redis or in-process (ephemeral).

⸻

3. svc-events (custom backend)

Event processor. Consumes from pgmq, evaluates, acts. Separate FastAPI service.

Responsibilities:
- Event consumption (polls pgmq queues)
- Event evaluation (does this event require action?)
- Observation engine (HP02: events → metrics → reports → observations)
- WYLO container assembly (reads state → computes priority cards → writes to Supabase)
- Scheduled job handling (receives cron triggers from pg_cron)

Event-driven flows:

  meal_logged:
    1. Check plan_enabled + plan_reactivity
    2. If on_log → call svc-orchestra /adapt-plan
    3. Recompute daily calorie/macro observations
    4. Update WYLO state

  goal_set:
    1. Cascade config effects (write FactAttributes)
    2. Flag active MealPlan for recompute
    3. Call svc-orchestra /rebuild-plan
    4. Update WYLO state

  circumstance_changed:
    1. Call svc-orchestra /adapt-plan (all active slots)
    2. Update WYLO state

  daily_recalc (pg_cron → svc-events):
    1. For users with plan_reactivity: daily
    2. Call svc-orchestra /rebuild-plan
    3. Recompute observations

  weekly_review (pg_cron → svc-events):
    1. Call svc-orchestra /generate-review
    2. Surface review card in WYLO

Observation Engine:
  Events → aggregate metrics (SQL) → build reports (HP02)
  Reports → dual-render (numerical for code, prose for LLM)
  Observations → stabilize → become memories

Does NOT call LLM directly. Always goes through svc-orchestra for LLM needs.

⸻

Communication Patterns

  Client reads (no LLM):
    Client → Supabase PostgREST (direct, RLS-secured)
    Browse, Timeline, meal detail, user context

  Client actions (LLM needed):
    Client → svc-orchestra → LLM → write to Supabase → publish to pgmq
    Notes dispatch, composition turns, plan generation

  Event processing (async):
    pgmq → svc-events → evaluate → maybe call svc-orchestra
    Plan adaptation, observation updates, WYLO rebuild

  Scheduled (cron):
    pg_cron → svc-events endpoint → triggers batch work

  Real-time to client:
    Supabase Realtime → Client (table change subscriptions)
    WYLO card updates, plan changes, composition progress

⸻

Data Flow: "had coffee"

  1. User types "had coffee" in Notes tab
  2. Client → svc-orchestra /dispatch (authenticated via Supabase JWT)
  3. Orchestrator → LLM: classify intent → { tool: "LogMeal" }
  4. Orchestrator → LLM: extract → { food: "coffee", kcal: 5 }
  5. Orchestrator → Supabase: INSERT meal_log
  6. Orchestrator → pgmq: send('q_meal_events', { type: "meal_logged", ... })
  7. svc-events: consumes event → recompute observations → update WYLO
  8. Supabase Realtime → Client: meal_log row appears
  9. Client renders: "✓ Coffee · 5 kcal · logged"

⸻

Client Architecture

  React (web):  Primary development. PWA-capable.
  iOS:          TBD — native, React Native, or Expo
  Android:      TBD — native, React Native, or Expo

All clients share:
- Supabase client SDK (auth, realtime, PostgREST queries)
- Same rendering logic (surfaces, zoom, outcome cards)
- Offline queue for Notes (local queue → sync via svc-orchestra on reconnect)

⸻

Service Boundaries

  Component         Owns data?    Calls LLM?    Deployment
  Supabase          Yes           No            Managed (Supabase Cloud)
  svc-orchestra     No            Yes           Custom (Render / Fly / Railway)
  svc-events        No            Via orchestra  Custom (Render / Fly / Railway)

⸻

Open Questions

1. Orchestrator session storage. Composition sessions (multi-turn) — Redis or in-process?
2. LLM provider. Single provider or multi-provider routing?
3. iOS/Android strategy. React Native, Expo, or native?
4. pgmq transaction boundary. Can event publish be in same DB transaction as data write?
5. svc-events scaling. Single consumer or multiple workers per queue?
6. Offline conflict resolution. Notes queued offline → synced → merge strategy?
