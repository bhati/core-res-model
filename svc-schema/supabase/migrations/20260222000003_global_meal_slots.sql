-- Global Meal Slots: 7 predefined slot types with time ranges
-- 3 core (breakfast, lunch, dinner) + 4 interstitial

CREATE TABLE global_meal_slots (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slot_key       TEXT NOT NULL UNIQUE,
  label          TEXT NOT NULL,
  start_hour     INTEGER NOT NULL,
  end_hour       INTEGER NOT NULL,
  sort_order     INTEGER NOT NULL,
  is_core        BOOLEAN NOT NULL DEFAULT false
);

-- Seed the 7 predefined slots
INSERT INTO global_meal_slots (slot_key, label, start_hour, end_hour, sort_order, is_core) VALUES
  ('morning_boost',  'Morning boost',  5,  7,  1, false),
  ('breakfast',      'Breakfast',      7,  10, 2, true),
  ('midday_bite',    'Mid-day bite',   10, 12, 3, false),
  ('lunch',          'Lunch',          12, 15, 4, true),
  ('evening_snack',  'Evening snack',  15, 18, 5, false),
  ('dinner',         'Dinner',         18, 22, 6, true),
  ('late_night',     'Late night',     22, 5,  7, false);
