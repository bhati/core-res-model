Services Architecture

Tech stack decisions applied to backend services.

⸻

Tech Stack

  Client:       React (web) + iOS + Android
  Data + Auth:  Supabase (PostgreSQL + PostgREST + Auth + Realtime)
  Custom:       Orchestrator + LLM Service (svc-orchestra)
  Events:       Supabase Edge Functions + pg_cron + DB triggers

⸻

Service Diagram

  ┌──────────────────────────┐
  │  Clients                 │
  │  React · iOS · Android   │
  ├────────────┬─────────────┤
  │            │             │
  │  Direct    │  Domain     │
  │  reads     │  requests   │
  │            │             │
  ▼            ▼             │
  ┌──────────────────────┐   │
  │  Supabase            │   │
  │  ┌────────────────┐  │   │
  │  │ Auth           │  │   │
  │  │ PostgREST API  │  │   │
  │  │ PostgreSQL     │  │   │
  │  │ Realtime       │  │   │
  │  │ Edge Functions │  │   │
  │  └────────────────┘  │   │
  └────────┬─────────────┘   │
           │                 │
           │  webhook /      │
           │  function call  │
           ▼                 │
  ┌──────────────────────┐   │
  │  svc-orchestra       │   │
  │  ┌────────────────┐  │   │
  │  │ Orchestrator   │  │   │
  │  │ LLM Service    │  │   │
  │  └────────────────┘  │   │
  └──────────────────────┘   │
                             │
  Events: DB triggers + Edge Functions + pg_cron

⸻

1. Supabase (replaces Gateway + Data Service)

What Supabase provides:

Auth:
- User authentication, session management, JWT tokens
- Row Level Security (RLS) on all tables — user can only see their own data
- Social auth + email/password

PostgREST API:
- Auto-generated REST API from PostgreSQL schema
- Direct reads for Browse and Timeline (client → Supabase, no Orchestrator needed)
- Filtering, pagination, search built-in

PostgreSQL:
- All entities (Food, Recipe)
- All artifacts (MealPlan, MealLog, NutritionGoal, NutritionReview, ShoppingList, CookingPlan)
- User context (FactAttributes, ProseAttributes, Circumstances, Intents)
- Domain context (Events, Observations, Memories)
- Event log (immutable append table)

Realtime:
- WebSocket subscriptions for composition session updates
- WYLO card updates pushed to client
- Plan adaptation notifications

Edge Functions:
- Event handlers (DB trigger → Edge Function → calls Orchestrator if needed)
- WYLO container assembly logic
- Lightweight computation that doesn't need LLM

⸻

2. svc-orchestra (custom backend — Orchestrator + LLM Service)

Single deployable service. Two logical concerns, one deployment.

Orchestrator responsibilities:
- Intent classification (Notes: "had coffee" → LogMeal)
- Workflow execution (deterministic tool flows with LLM judgment)
- Composition session management (HP05a multi-turn state)
- Side effect coordination (Goal → config + memories + intent + plan recompute)
- Validation gate enforcement (HP05b pass/warn/block)

LLM Service responsibilities:
- Context assembly (HP03: reads from Supabase, scopes per trigger)
- Prompt construction (expertise spec + context + policy)
- LLM API calls (provider abstraction, retries, fallback)
- Structured output parsing
- Cost tracking

Workflows:
  NoteDispatch   → classify intent → route to workflow below
  LogMeal        → LLM extract → write MealLog to Supabase → emit event
  SetGoal        → LLM compose (multi-turn) → validate → write to Supabase → emit event
  BuildMealPlan  → LLM generate → write to Supabase → emit event
  ReviewPeriod   → read from Supabase → LLM analyze → write to Supabase

Session state: composition sessions stored in Redis or in-memory (ephemeral, not in Supabase).

⸻

3. Event Processing (Supabase-native)

Built on PostgreSQL triggers + Edge Functions + pg_cron.

DB triggers (immediate):
  INSERT on meal_logs   → trigger Edge Function → evaluate plan adaptation
  INSERT on goals       → trigger Edge Function → cascade config + recompute plan
  UPDATE on circumstances → trigger Edge Function → adapt plan

Edge Functions (event handlers):
  Plan adaptation handler → calls svc-orchestra if LLM needed
  WYLO assembly → reads current state, computes priority cards
  Notification handler → push notification to client

pg_cron (scheduled):
  Daily: plan recalculation (if reactivity: daily)
  Weekly: review generation trigger → calls svc-orchestra
  Periodic: observation recomputation (HP02 reports)

⸻

Communication Patterns

  Client reads (no LLM needed):
    Client → Supabase PostgREST (direct, fast, RLS-secured)
    Browse, Timeline rendering, meal detail, user context

  Client actions (LLM needed):
    Client → Supabase Edge Function → svc-orchestra → LLM → write to Supabase
    Notes dispatch, composition turns, plan generation

  Event-driven (async):
    DB trigger → Edge Function → evaluate → maybe call svc-orchestra
    Background processing, plan adaptation, review generation

  Real-time:
    Supabase Realtime → Client (subscription on relevant tables)
    Composition updates, WYLO cards, plan changes

⸻

Data Flow: "had coffee" through the system

  1. User types "had coffee" in Notes tab
  2. Client → Supabase Edge Function (authenticated via JWT)
  3. Edge Function → svc-orchestra /dispatch endpoint
  4. Orchestrator → LLM Service: classify intent (Tool Judgment call)
     LLM returns: { tool: "LogMeal", params: { items: ["coffee"] } }
  5. Orchestrator → LLM Service: extract food details (Content Fill call)
     LLM returns: { food: "coffee, black", kcal: 5, protein: 0, ... }
  6. Orchestrator → Supabase: INSERT into meal_logs
  7. DB trigger fires → Edge Function evaluates plan adaptation
  8. Supabase Realtime → Client: meal_log row appears
  9. Client renders outcome card: "✓ Coffee · 5 kcal · logged to breakfast"

⸻

Client Architecture

  React (web):      Primary development platform, PWA-capable
  iOS:              Native or React Native — TBD
  Android:          Native or React Native — TBD

All clients share:
- Supabase client SDK (auth, realtime, PostgREST queries)
- Same business logic for rendering (surfaces, zoom, outcome cards)
- Offline queue for Notes (sync on reconnect)

⸻

Service Boundaries

  Component         Owns data?    Calls LLM?    Deployment
  Supabase          Yes           No            Managed (Supabase Cloud)
  svc-orchestra     No            Yes           Custom (Render / Fly / Railway)
  Edge Functions    No            Via orchestra  Supabase-managed
  pg_cron           No            Via edge fn    Supabase-managed

⸻

Open Questions

1. Orchestrator session storage. Composition sessions (multi-turn) need ephemeral state. Redis, or in-process memory with sticky routing?

2. LLM provider. Single provider (e.g. OpenAI/Gemini) or multi-provider routing?

3. iOS/Android strategy. React Native (shared code), native, or Expo?

4. Edge Function limits. Supabase Edge Functions have execution time limits. Long-running LLM calls may need direct client → svc-orchestra for composition flows.

5. Offline conflict resolution. Notes queued offline → synced → may conflict with server state. Supabase handles this? Or custom merge logic?
