-- Events: immutable log of all domain activity
-- Append-only. No FK on artifact_ref (polymorphic — could point to meals, nutrition_goals, etc.)

CREATE TABLE events (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  domain        TEXT NOT NULL DEFAULT 'nutrition',
  event_type    TEXT NOT NULL,           -- meal_logged, meal_refined, goal_set, goal_revised, circumstance_changed, etc.
  timestamp     TIMESTAMPTZ NOT NULL DEFAULT now(),
  payload       JSONB DEFAULT '{}',      -- type-specific structured data
  artifact_ref  UUID                    -- which artifact was created/modified (polymorphic)
);

-- Indexes
CREATE INDEX idx_events_user_id ON events (user_id);
CREATE INDEX idx_events_user_type ON events (user_id, event_type);
CREATE INDEX idx_events_user_timestamp ON events (user_id, timestamp DESC);
