-- Global Meal Slots: 7 predefined slot types with time ranges
-- 3 core (breakfast, lunch, dinner) + 4 interstitial
-- Seed data is in supabase/seed.sql

CREATE TABLE global_meal_slots (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slot_key       TEXT NOT NULL UNIQUE,
  label          TEXT NOT NULL,
  start_hour     INTEGER NOT NULL,
  end_hour       INTEGER NOT NULL,
  sort_order     INTEGER NOT NULL,
  is_core        BOOLEAN NOT NULL DEFAULT false
);
