-- Meal Slots: user-scoped slot configuration
-- Override pattern: nullable columns inherit from global_meal_slots via app-level COALESCE
-- No UNIQUE — users can instantiate the same slot type multiple times (e.g. two midday snacks)
-- Populated on first use during onboarding

CREATE TABLE meal_slots (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  global_slot_id   UUID NOT NULL REFERENCES global_meal_slots(id),

  label            TEXT,              -- nullable = inherit global label
  start_hour       INTEGER,           -- nullable = inherit
  end_hour         INTEGER,           -- nullable = inherit
  sort_order       INTEGER NOT NULL,
  is_active        BOOLEAN NOT NULL DEFAULT true,

  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index
CREATE INDEX idx_meal_slots_user_id ON meal_slots (user_id);
