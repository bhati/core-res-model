-- Nutrition Goals: tagged commitment with flat tag arrays
-- One active goal per domain. All artifacts implicitly serve the active goal.
-- Tags use dot-notation for secondaries: ['medical.diabetes_management', 'body_composition.weight_loss']

CREATE TABLE nutrition_goals (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  domain            TEXT NOT NULL DEFAULT 'nutrition',

  statement         TEXT NOT NULL,
  primary_tags      TEXT[] NOT NULL DEFAULT '{}',
  secondary_tags    TEXT[] NOT NULL DEFAULT '{}',
  targets           JSONB DEFAULT '[]',
  config_effects    JSONB DEFAULT '[]',

  status            TEXT NOT NULL DEFAULT 'active',  -- active | revised | retired
  predecessor_id    UUID REFERENCES nutrition_goals(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  revised_at        TIMESTAMPTZ,
  retired_at        TIMESTAMPTZ
);

-- Indexes
CREATE INDEX idx_nutrition_goals_user_id ON nutrition_goals (user_id);
CREATE INDEX idx_nutrition_goals_active ON nutrition_goals (user_id, status) WHERE status = 'active';
CREATE INDEX idx_nutrition_goals_primary_tags ON nutrition_goals USING gin (primary_tags);
CREATE INDEX idx_nutrition_goals_secondary_tags ON nutrition_goals USING gin (secondary_tags);
