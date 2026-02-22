-- Foods: user-scoped food records
-- Override mode: nullable columns inherit from global via app-level COALESCE
-- Standalone mode: global_food_id is null, all fields populated (e.g. LLM-estimated)

CREATE TABLE foods (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  global_food_id         UUID REFERENCES global_foods(id),

  display_name           TEXT NOT NULL,
  aliases                TEXT[] DEFAULT '{}',

  -- Macros per 100g (nullable = inherit from global)
  kcal                   NUMERIC,
  protein_g              NUMERIC,
  carbs_g                NUMERIC,
  fat_g                  NUMERIC,
  fiber_g                NUMERIC,

  -- Safety / Dietary (nullable = inherit from global)
  allergen_tags          TEXT[],
  dietary_flags          TEXT[],
  safety_flags           TEXT[],

  -- Standard serving (nullable = inherit from global)
  standard_serving_qty   NUMERIC,
  standard_serving_unit  TEXT,
  common_serving_units   TEXT[],

  -- Behavioral
  first_used_at          TIMESTAMPTZ,
  last_used_at           TIMESTAMPTZ,
  usage_count            INTEGER DEFAULT 0,

  -- Meta
  source                 TEXT NOT NULL DEFAULT 'user_created',
  status                 TEXT NOT NULL DEFAULT 'active',
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, global_food_id)
);

-- Indexes
CREATE INDEX idx_foods_user_id ON foods (user_id);
CREATE INDEX idx_foods_display_name ON foods USING gin (to_tsvector('english', display_name));
