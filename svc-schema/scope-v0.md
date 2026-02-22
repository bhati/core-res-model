# svc-schema — Scope v0

What tables do we actually need for a working shell? Walk through each entity from the data model, decide: **in v0**, **deferred**, or **simplified**.

Cloud Supabase. Auth via Supabase Auth (`auth.users`). RLS on all user tables.

⸻

## Entity Decisions

### 1. Food

Source: [food.md](file:///Users/ankit/Documents/resonic/core-model/architecture/data-model/food.md)

Two-table pattern: `global_foods` (system catalog) + `foods` (user-scoped).

#### global_foods — ✅ LOCKED

```sql
CREATE TABLE global_foods (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  display_name           TEXT NOT NULL,
  slug                   TEXT NOT NULL UNIQUE,
  aliases                TEXT[] DEFAULT '{}',

  kcal                   NUMERIC NOT NULL,
  protein_g              NUMERIC NOT NULL,
  carbs_g                NUMERIC NOT NULL,
  fat_g                  NUMERIC NOT NULL,
  fiber_g                NUMERIC DEFAULT 0,

  allergen_tags          TEXT[] DEFAULT '{}',
  dietary_flags          TEXT[] DEFAULT '{}',
  safety_flags           TEXT[] DEFAULT '{}',

  standard_serving_qty   NUMERIC,
  standard_serving_unit  TEXT,
  common_serving_units   TEXT[] DEFAULT '{}',

  source                 TEXT NOT NULL DEFAULT 'system_database',
  status                 TEXT NOT NULL DEFAULT 'active',
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

**Deferred**: micronutrients, glycemic index, categorical (food_group, sub_category), cultural fields.

#### foods — ✅ LOCKED

```sql
CREATE TABLE foods (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                UUID NOT NULL REFERENCES auth.users(id),
  global_food_id         UUID REFERENCES global_foods(id),

  display_name           TEXT NOT NULL,
  aliases                TEXT[] DEFAULT '{}',

  kcal                   NUMERIC,
  protein_g              NUMERIC,
  carbs_g                NUMERIC,
  fat_g                  NUMERIC,
  fiber_g                NUMERIC,

  allergen_tags          TEXT[],
  dietary_flags          TEXT[],
  safety_flags           TEXT[],

  standard_serving_qty   NUMERIC,
  standard_serving_unit  TEXT,
  common_serving_units   TEXT[],

  first_used_at          TIMESTAMPTZ,
  last_used_at           TIMESTAMPTZ,
  usage_count            INTEGER DEFAULT 0,

  source                 TEXT NOT NULL DEFAULT 'user_created',
  status                 TEXT NOT NULL DEFAULT 'active',
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, global_food_id)
);
```

Override resolution: app-level `COALESCE(foods.col, global_foods.col)`. Null columns = inherit from global. No slug on foods.

⸻

### 2. Recipe — ⏸ DEFERRED

Not needed for core loop (Log a Meal). Bring in when MealPlan goes live.

### 3. User Context — ✅ LOCKED

Source: [user-context.md](file:///Users/ankit/Documents/resonic/core-model/architecture/data-model/user-context.md)

3 tables. EAV for facts, prose blobs for LLM context, circumstances. Intents deferred.

```sql
CREATE TABLE fact_attributes (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id),
  scope       TEXT NOT NULL,          -- user | account | domain
  domain      TEXT,                   -- null for user/account, 'nutrition' for domain
  key         TEXT NOT NULL,
  value       JSONB NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, scope, domain, key)
);

CREATE TABLE prose_attributes (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id),
  scope       TEXT NOT NULL,          -- user | domain
  domain      TEXT,
  type        TEXT NOT NULL,          -- dietary_notes, food_preferences, etc.
  content     TEXT NOT NULL,
  version     INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, scope, domain, type)
);

CREATE TABLE circumstances (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id),
  type          TEXT NOT NULL,
  description   TEXT,
  status        TEXT NOT NULL DEFAULT 'active',
  start_date    DATE,
  expected_end  DATE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Prose versioning deferred — overwrite with version bump for now.

⸻

### 4. NutritionGoal — ✅ LOCKED

Source: [nutrition-goal.md](file:///Users/ankit/Documents/resonic/core-model/architecture/data-model/nutrition-goal.md)

Flat tag arrays with dot-notation for secondaries.

```sql
CREATE TABLE nutrition_goals (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id),
  domain            TEXT NOT NULL DEFAULT 'nutrition',

  statement         TEXT NOT NULL,
  primary_tags      TEXT[] NOT NULL DEFAULT '{}',   -- ['medical', 'body_composition', 'behavioral']
  secondary_tags    TEXT[] NOT NULL DEFAULT '{}',   -- ['medical.diabetes_management', 'body_composition.weight_loss']
  targets           JSONB DEFAULT '[]',             -- [{ metric, value, unit }]
  config_effects    JSONB DEFAULT '[]',             -- [{ key, value }]

  status            TEXT NOT NULL DEFAULT 'active',
  predecessor_id    UUID REFERENCES nutrition_goals(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  revised_at        TIMESTAMPTZ,
  retired_at        TIMESTAMPTZ
);
```

⸻

### 5. Meals — ✅ LOCKED

Source: [meal-log.md](file:///Users/ankit/Documents/resonic/core-model/architecture/data-model/meal-log.md)

Two tables: `meals` (the eating occasion) + `meal_items` (what was eaten). Renamed from MealLog.

```sql
CREATE TABLE meals (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID NOT NULL REFERENCES auth.users(id),
  date                 DATE NOT NULL,
  time                 TIME,
  slot_key             TEXT,              -- breakfast | lunch | dinner | evening_snack | etc.
  slot_label           TEXT,              -- user display name snapshot: '☀ Breakfast', 'Morning Fuel'

  plan_ref             UUID,
  context              TEXT,
  skipped              BOOLEAN NOT NULL DEFAULT false,
  source               TEXT NOT NULL,
  raw_input            TEXT,

  confidence           NUMERIC NOT NULL DEFAULT 1.0,
  initial_confidence   NUMERIC,
  last_refined_at      TIMESTAMPTZ,

  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE meal_items (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_id              UUID NOT NULL REFERENCES meals(id) ON DELETE CASCADE,
  food_ref             UUID NOT NULL REFERENCES foods(id),

  display_name         TEXT NOT NULL,
  quantity             NUMERIC,
  unit                 TEXT,
  resolved_quantity    NUMERIC,
  resolved_unit        TEXT,
  preparation          TEXT,

  kcal                 NUMERIC,
  protein_g            NUMERIC,
  carbs_g              NUMERIC,
  fat_g                NUMERIC,

  confidence           NUMERIC NOT NULL DEFAULT 1.0,
  position             INTEGER NOT NULL DEFAULT 0
);
```

Also: two-table pattern for meal slots — `global_meal_slots` (system-defined with time ranges) + `meal_slots` (user-scoped overrides).

```sql
CREATE TABLE global_meal_slots (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slot_key       TEXT NOT NULL UNIQUE,
  label          TEXT NOT NULL,
  start_hour     INTEGER NOT NULL,     -- 0-23
  end_hour       INTEGER NOT NULL,     -- 0-23
  sort_order     INTEGER NOT NULL,
  is_core        BOOLEAN NOT NULL DEFAULT false
);

-- Seed: morning_boost(5-7), breakfast(7-10, core), midday_bite(10-12),
--       lunch(12-15, core), evening_snack(15-18), dinner(18-22, core), late_night(22-5)

CREATE TABLE meal_slots (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id),
  global_slot_id   UUID NOT NULL REFERENCES global_meal_slots(id),

  label            TEXT,              -- nullable = inherit global label
  start_hour       INTEGER,           -- nullable = inherit
  end_hour         INTEGER,           -- nullable = inherit
  sort_order       INTEGER NOT NULL,
  is_active        BOOLEAN NOT NULL DEFAULT true,

  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

No UNIQUE — users can instantiate the same slot type multiple times (e.g. two midday snacks). `meals.slot_key` and `meals.slot_label` snapshot at log time, no FK to meal_slots.

⸻

### 6. MealPlan — ⏸ DEFERRED

Depends on LLM pipeline + Recipe. `plan_enabled` defaults false. Bring in post-v0.

### 7. NutritionReview — ⏸ DEFERRED

Depends on enough MealLog data + LLM for narrative generation. Bring in post-v0.

### 8. ShoppingList — ⏸ DEFERRED

Derived from MealPlan. Deferred with it.

### 9. CookingPlan — ⏸ DEFERRED

Derived from MealPlan + Recipe. Deferred with both.

### 10. Events — ✅ LOCKED

Source: [events.md](file:///Users/ankit/Documents/resonic/core-model/architecture/data-model/events.md)

Append-only immutable log. No FK on artifact_ref (polymorphic).

```sql
CREATE TABLE events (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id),
  domain        TEXT NOT NULL DEFAULT 'nutrition',
  event_type    TEXT NOT NULL,
  timestamp     TIMESTAMPTZ NOT NULL DEFAULT now(),
  payload       JSONB DEFAULT '{}',
  artifact_ref  UUID
);
```

### 11. pgmq Queues — ⏸ DEFERRED

No consumer (svc-events) in v0. Create queues when event processing pipeline ships.

⸻

## Summary

| Entity | v0 Decision | Tables | Notes |
|---|---|---|---|
| Food | ✅ In | `global_foods`, `foods` | Two-table pattern, flat macros |
| Recipe | ⏸ Defer | — | Not needed for core loop |
| User Context | ✅ In | `fact_attributes`, `prose_attributes`, `circumstances` | EAV, intents deferred |
| NutritionGoal | ✅ In | `nutrition_goals` | Flat tag arrays |
| Meals | ✅ In | `meals`, `meal_items`, `global_meal_slots`, `meal_slots` | slot_key/label snapshot, two-table slot pattern |
| MealPlan | ⏸ Defer | — | Depends on LLM + Recipe |
| NutritionReview | ⏸ Defer | — | Depends on data + LLM |
| ShoppingList | ⏸ Defer | — | Derived from MealPlan |
| CookingPlan | ⏸ Defer | — | Derived from MealPlan + Recipe |
| Events | ✅ In | `events` | Append-only log |
| pgmq Queues | ⏸ Defer | — | No consumer in v0 |
