-- Row Level Security: all user-scoped tables secured by user_id
-- global_ tables are readable by all authenticated users, not writable

-- Enable RLS on all tables
ALTER TABLE global_foods ENABLE ROW LEVEL SECURITY;
ALTER TABLE foods ENABLE ROW LEVEL SECURITY;
ALTER TABLE global_meal_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE fact_attributes ENABLE ROW LEVEL SECURITY;
ALTER TABLE prose_attributes ENABLE ROW LEVEL SECURITY;
ALTER TABLE circumstances ENABLE ROW LEVEL SECURITY;
ALTER TABLE nutrition_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Global tables: read-only for authenticated users
CREATE POLICY "global_foods_read" ON global_foods
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "global_meal_slots_read" ON global_meal_slots
  FOR SELECT TO authenticated
  USING (true);

-- User-scoped tables: full access scoped to own data
-- Pattern: SELECT/INSERT/UPDATE/DELETE WHERE auth.uid() = user_id

-- foods
CREATE POLICY "foods_select" ON foods
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "foods_insert" ON foods
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "foods_update" ON foods
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "foods_delete" ON foods
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- meal_slots
CREATE POLICY "meal_slots_select" ON meal_slots
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "meal_slots_insert" ON meal_slots
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "meal_slots_update" ON meal_slots
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "meal_slots_delete" ON meal_slots
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- fact_attributes
CREATE POLICY "fact_attributes_select" ON fact_attributes
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "fact_attributes_insert" ON fact_attributes
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "fact_attributes_update" ON fact_attributes
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "fact_attributes_delete" ON fact_attributes
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- prose_attributes
CREATE POLICY "prose_attributes_select" ON prose_attributes
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "prose_attributes_insert" ON prose_attributes
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "prose_attributes_update" ON prose_attributes
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "prose_attributes_delete" ON prose_attributes
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- circumstances
CREATE POLICY "circumstances_select" ON circumstances
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "circumstances_insert" ON circumstances
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "circumstances_update" ON circumstances
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "circumstances_delete" ON circumstances
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- nutrition_goals
CREATE POLICY "nutrition_goals_select" ON nutrition_goals
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "nutrition_goals_insert" ON nutrition_goals
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "nutrition_goals_update" ON nutrition_goals
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "nutrition_goals_delete" ON nutrition_goals
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- meals
CREATE POLICY "meals_select" ON meals
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "meals_insert" ON meals
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "meals_update" ON meals
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "meals_delete" ON meals
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- meal_items: access controlled via parent meal (join through meals)
CREATE POLICY "meal_items_select" ON meal_items
  FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM meals WHERE meals.id = meal_items.meal_id AND meals.user_id = auth.uid()));

CREATE POLICY "meal_items_insert" ON meal_items
  FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM meals WHERE meals.id = meal_items.meal_id AND meals.user_id = auth.uid()));

CREATE POLICY "meal_items_update" ON meal_items
  FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM meals WHERE meals.id = meal_items.meal_id AND meals.user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM meals WHERE meals.id = meal_items.meal_id AND meals.user_id = auth.uid()));

CREATE POLICY "meal_items_delete" ON meal_items
  FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM meals WHERE meals.id = meal_items.meal_id AND meals.user_id = auth.uid()));

-- events
CREATE POLICY "events_select" ON events
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "events_insert" ON events
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Events are immutable — no update or delete policies
