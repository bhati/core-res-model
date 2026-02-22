-- Global Foods: system-curated food catalog
-- Two-table pattern: global_foods (catalog) + foods (user-scoped)

CREATE TABLE global_foods (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  display_name           TEXT NOT NULL,
  slug                   TEXT NOT NULL UNIQUE,
  aliases                TEXT[] DEFAULT '{}',

  -- Macros per 100g (flat columns for aggregation)
  kcal                   NUMERIC NOT NULL,
  protein_g              NUMERIC NOT NULL,
  carbs_g                NUMERIC NOT NULL,
  fat_g                  NUMERIC NOT NULL,
  fiber_g                NUMERIC DEFAULT 0,

  -- Safety / Dietary
  allergen_tags          TEXT[] DEFAULT '{}',
  dietary_flags          TEXT[] DEFAULT '{}',
  safety_flags           TEXT[] DEFAULT '{}',

  -- Standard serving
  standard_serving_qty   NUMERIC,
  standard_serving_unit  TEXT,
  common_serving_units   TEXT[] DEFAULT '{}',

  -- Meta
  source                 TEXT NOT NULL DEFAULT 'system_database',
  status                 TEXT NOT NULL DEFAULT 'active',
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for search
CREATE INDEX idx_global_foods_slug ON global_foods (slug);
CREATE INDEX idx_global_foods_display_name ON global_foods USING gin (to_tsvector('english', display_name));
