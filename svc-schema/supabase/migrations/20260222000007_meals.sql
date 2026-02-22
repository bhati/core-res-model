-- Meals: eating occasions + what was eaten
-- Two tables: meals (the occasion) + meal_items (individual food items)
-- slot_key and slot_label are snapshots — no FK to meal_slots

CREATE TABLE meals (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date                 DATE NOT NULL,
  time                 TIME,
  slot_key             TEXT,              -- breakfast | lunch | dinner | etc. (snapshot from global_meal_slots.slot_key)
  slot_label           TEXT,              -- user's display name at log time (snapshot)

  plan_ref             UUID,              -- FK to meal_plan (deferred, nullable)
  context              TEXT,              -- "ate out", "craving", "cooked at home"
  skipped              BOOLEAN NOT NULL DEFAULT false,
  source               TEXT NOT NULL,     -- structured_input | prose_extracted | plan_confirmed | plan_modified | binary_checkin
  raw_input            TEXT,              -- preserved if prose

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

  display_name         TEXT NOT NULL,     -- snapshot at log time
  quantity             NUMERIC,           -- as declared: "1 bowl", "200g", "some"
  unit                 TEXT,
  resolved_quantity    NUMERIC,           -- system estimate in standard units
  resolved_unit        TEXT,
  preparation          TEXT,              -- grilled, fried, raw

  -- Nutrition snapshot at log time (flat for aggregation)
  kcal                 NUMERIC,
  protein_g            NUMERIC,
  carbs_g              NUMERIC,
  fat_g                NUMERIC,

  confidence           NUMERIC NOT NULL DEFAULT 1.0,
  position             INTEGER NOT NULL DEFAULT 0
);

-- Indexes
CREATE INDEX idx_meals_user_id ON meals (user_id);
CREATE INDEX idx_meals_user_date ON meals (user_id, date);
CREATE INDEX idx_meals_slot_key ON meals (user_id, slot_key);
CREATE INDEX idx_meal_items_meal_id ON meal_items (meal_id);
CREATE INDEX idx_meal_items_food_ref ON meal_items (food_ref);
