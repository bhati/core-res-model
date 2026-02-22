-- User Context: fact_attributes + prose_attributes + circumstances
-- EAV pattern for facts, prose blobs for LLM context

-- Fact Attributes: structured, code-consumed (EAV)
-- Scopes: user (about the person), account (system behavior), domain (domain-specific)
CREATE TABLE fact_attributes (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scope       TEXT NOT NULL,          -- user | account | domain
  domain      TEXT,                   -- null for user/account scope, 'nutrition' for domain scope
  key         TEXT NOT NULL,
  value       JSONB NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, scope, domain, key)
);

CREATE INDEX idx_fact_attributes_user_id ON fact_attributes (user_id);
CREATE INDEX idx_fact_attributes_lookup ON fact_attributes (user_id, scope, domain);

-- Prose Attributes: named prose sections, LLM-consumed
-- Mutation: LLM merges old + new into updated prose. Version bumped on each update.
-- Full version history deferred — overwrite with version bump for now.
CREATE TABLE prose_attributes (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scope       TEXT NOT NULL,          -- user | domain
  domain      TEXT,
  type        TEXT NOT NULL,          -- dietary_notes, food_preferences, behavioral_notes, etc.
  content     TEXT NOT NULL,
  version     INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, scope, domain, type)
);

CREATE INDEX idx_prose_attributes_user_id ON prose_attributes (user_id);

-- Circumstances: temporary conditions affecting behavior
-- Multiple active circumstances per user (traveling + fasting simultaneously)
CREATE TABLE circumstances (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type          TEXT NOT NULL,
  description   TEXT,
  status        TEXT NOT NULL DEFAULT 'active',  -- upcoming | active | resolving
  start_date    DATE,
  expected_end  DATE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_circumstances_user_id ON circumstances (user_id);
CREATE INDEX idx_circumstances_active ON circumstances (user_id, status) WHERE status = 'active';
