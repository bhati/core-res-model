-- ═══════════════════════════════════════════
-- SEED DATA
-- Run after migrations: supabase db seed
-- ═══════════════════════════════════════════

-- ═══════════════════════════════════════════
-- GLOBAL MEAL SLOTS (7 predefined)
-- 3 core (breakfast, lunch, dinner) + 4 interstitial
-- ═══════════════════════════════════════════
INSERT INTO global_meal_slots (slot_key, label, start_hour, end_hour, sort_order, is_core) VALUES
  ('morning_boost',  'Morning boost',  5,  7,  1, false),
  ('breakfast',      'Breakfast',      7,  10, 2, true),
  ('midday_bite',    'Mid-day bite',   10, 12, 3, false),
  ('lunch',          'Lunch',          12, 15, 4, true),
  ('evening_snack',  'Evening snack',  15, 18, 5, false),
  ('dinner',         'Dinner',         18, 22, 6, true),
  ('late_night',     'Late night',     22, 5,  7, false);

-- ═══════════════════════════════════════════
-- GLOBAL FOODS
-- ═══════════════════════════════════════════
-- Seed data for global_foods
-- Macros are per 100g. Sources: IFCT 2017, USDA, common references.
-- This is a starter catalog — grows over time based on usage.

INSERT INTO global_foods (display_name, slug, aliases, kcal, protein_g, carbs_g, fat_g, fiber_g, allergen_tags, dietary_flags, safety_flags, standard_serving_qty, standard_serving_unit, common_serving_units, source) VALUES

-- ═══════════════════════════════════════════
-- GRAINS & CEREALS
-- ═══════════════════════════════════════════
('White Rice (cooked)', 'white-rice-cooked', '{"chawal", "steamed rice"}', 130, 2.7, 28, 0.3, 0.4, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 150, 'g', '{"bowl", "katori", "cup"}', 'system_database'),
('Brown Rice (cooked)', 'brown-rice-cooked', '{"brown chawal"}', 112, 2.6, 23, 0.9, 1.8, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 150, 'g', '{"bowl", "katori", "cup"}', 'system_database'),
('Roti', 'roti', '{"chapati", "phulka", "rotli"}', 264, 8.7, 50, 3.7, 3.3, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 35, 'g', '{"piece"}', 'system_database'),
('Naan', 'naan', '{"tandoori naan"}', 290, 8.0, 50, 5.7, 2.0, '{"gluten", "dairy"}', '{"vegetarian"}', '{}', 90, 'g', '{"piece"}', 'system_database'),
('Paratha', 'paratha', '{"aloo paratha", "plain paratha"}', 320, 7.5, 42, 14, 2.5, '{"gluten"}', '{"vegetarian"}', '{}', 60, 'g', '{"piece"}', 'system_database'),
('Poha (cooked)', 'poha-cooked', '{"flattened rice", "chivda", "aval"}', 115, 2.5, 22, 1.5, 0.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "plate"}', 'system_database'),
('Upma', 'upma', '{"rava upma", "sooji upma"}', 130, 3.5, 18, 4.5, 1.2, '{"gluten"}', '{"vegetarian"}', '{}', 200, 'g', '{"bowl", "plate"}', 'system_database'),
('Idli', 'idli', '{"steamed idli"}', 78, 2.0, 15, 0.4, 0.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 40, 'g', '{"piece"}', 'system_database'),
('Dosa', 'dosa', '{"plain dosa", "masala dosa", "paper dosa"}', 150, 3.5, 22, 5.0, 0.8, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 100, 'g', '{"piece"}', 'system_database'),
('Oats (cooked)', 'oats-cooked', '{"oatmeal", "porridge"}', 68, 2.4, 12, 1.4, 1.7, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 240, 'g', '{"bowl", "cup"}', 'system_database'),
('Wheat Bread', 'wheat-bread', '{"brown bread", "whole wheat bread"}', 247, 10, 43, 3.5, 6.0, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 30, 'g', '{"slice"}', 'system_database'),
('White Bread', 'white-bread', '{"sandwich bread", "toast"}', 265, 8.0, 49, 3.2, 2.7, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 30, 'g', '{"slice"}', 'system_database'),

-- ═══════════════════════════════════════════
-- LENTILS & LEGUMES
-- ═══════════════════════════════════════════
('Dal Tadka', 'dal-tadka', '{"yellow dal", "toor dal", "arhar dal"}', 80, 5.0, 11, 1.5, 3.0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Chana Dal', 'chana-dal', '{"bengal gram dal"}', 90, 6.0, 12, 1.8, 4.0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Rajma (cooked)', 'rajma-cooked', '{"kidney beans", "rajma masala"}', 105, 6.5, 15, 1.8, 5.0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Chole (cooked)', 'chole-cooked', '{"chickpeas", "chana masala", "kabuli chana"}', 115, 6.0, 16, 2.5, 5.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Moong Dal (cooked)', 'moong-dal-cooked', '{"green gram dal", "mung dal"}', 75, 5.5, 10, 0.5, 2.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Sambar', 'sambar', '{"sambhar"}', 65, 3.0, 9, 1.5, 2.0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),

-- ═══════════════════════════════════════════
-- DAIRY & PANEER
-- ═══════════════════════════════════════════
('Paneer', 'paneer', '{"cottage cheese", "Indian cheese"}', 265, 18, 1.2, 21, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 50, 'g', '{"piece", "slice", "cube"}', 'system_database'),
('Paneer Bhurji', 'paneer-bhurji', '{"scrambled paneer"}', 220, 14, 4, 17, 0.5, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 150, 'g', '{"serving", "katori"}', 'system_database'),
('Curd', 'curd', '{"dahi", "yogurt", "plain yogurt"}', 60, 3.5, 4.7, 3.3, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 100, 'g', '{"bowl", "katori", "cup"}', 'system_database'),
('Lassi', 'lassi', '{"sweet lassi", "punjabi lassi"}', 75, 2.5, 10, 2.5, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 250, 'ml', '{"glass"}', 'system_database'),
('Milk (whole)', 'milk-whole', '{"full cream milk", "doodh"}', 62, 3.2, 4.8, 3.3, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 200, 'ml', '{"glass", "cup"}', 'system_database'),
('Butter', 'butter', '{"makhan"}', 717, 0.9, 0.1, 81, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 10, 'g', '{"tbsp", "pat"}', 'system_database'),
('Ghee', 'ghee', '{"clarified butter", "desi ghee"}', 900, 0, 0, 100, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 5, 'g', '{"tsp", "tbsp"}', 'system_database'),
('Cheese', 'cheese', '{"cheddar", "processed cheese"}', 350, 22, 2, 28, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 20, 'g', '{"slice", "cube"}', 'system_database'),

-- ═══════════════════════════════════════════
-- PROTEINS (NON-VEG)
-- ═══════════════════════════════════════════
('Chicken Breast (cooked)', 'chicken-breast-cooked', '{"grilled chicken"}', 165, 31, 0, 3.6, 0, '{}', '{"gluten_free"}', '{}', 120, 'g', '{"piece", "serving"}', 'system_database'),
('Chicken Curry', 'chicken-curry', '{"chicken gravy", "murg curry"}', 150, 15, 5, 8, 0.5, '{}', '{"gluten_free"}', '{}', 200, 'g', '{"bowl", "serving"}', 'system_database'),
('Chicken Tikka', 'chicken-tikka', '{"tandoori chicken tikka"}', 148, 22, 4, 5, 0.3, '{}', '{"gluten_free"}', '{}', 100, 'g', '{"piece", "serving"}', 'system_database'),
('Egg (boiled)', 'egg-boiled', '{"anda", "hard boiled egg"}', 155, 13, 1.1, 11, 0, '{"egg"}', '{"gluten_free"}', '{}', 50, 'g', '{"piece"}', 'system_database'),
('Egg Omelette', 'egg-omelette', '{"anda omelette"}', 154, 11, 0.7, 12, 0, '{"egg"}', '{"gluten_free"}', '{}', 60, 'g', '{"piece"}', 'system_database'),
('Fish Curry', 'fish-curry', '{"machhi curry"}', 120, 14, 4, 5, 0.3, '{"fish"}', '{"gluten_free"}', '{}', 200, 'g', '{"bowl", "serving"}', 'system_database'),
('Mutton Curry', 'mutton-curry', '{"gosht curry", "lamb curry"}', 180, 16, 4, 11, 0.5, '{}', '{"gluten_free"}', '{}', 200, 'g', '{"bowl", "serving"}', 'system_database'),
('Butter Chicken', 'butter-chicken', '{"murgh makhani"}', 175, 14, 6, 11, 0.5, '{"dairy"}', '{"gluten_free"}', '{}', 200, 'g', '{"bowl", "serving"}', 'system_database'),

-- ═══════════════════════════════════════════
-- VEGETABLES
-- ═══════════════════════════════════════════
('Aloo Gobi', 'aloo-gobi', '{"potato cauliflower"}', 85, 2.5, 12, 3.5, 2.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori", "serving"}', 'system_database'),
('Palak Paneer', 'palak-paneer', '{"spinach paneer", "saag paneer"}', 130, 8, 5, 9, 2.0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Bhindi Masala', 'bhindi-masala', '{"okra", "lady finger"}', 75, 2.5, 8, 4, 3.0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Mixed Sabzi', 'mixed-sabzi', '{"mixed vegetables", "subji"}', 70, 2.5, 8, 3, 2.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Mixed Salad', 'mixed-salad', '{"green salad", "kachumber"}', 20, 1.2, 3.5, 0.2, 1.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 100, 'g', '{"bowl", "plate"}', 'system_database'),
('Raita', 'raita', '{"boondi raita", "cucumber raita"}', 50, 2.5, 4, 2.5, 0.3, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 100, 'g', '{"bowl", "katori"}', 'system_database'),
('Dal Makhani', 'dal-makhani', '{"maa ki dal", "black dal"}', 105, 5, 12, 4, 3.5, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 200, 'g', '{"bowl", "katori"}', 'system_database'),
('Biryani (chicken)', 'chicken-biryani', '{"hyderabadi biryani", "dum biryani"}', 180, 10, 22, 6, 1.0, '{}', '{"gluten_free"}', '{}', 250, 'g', '{"plate", "serving"}', 'system_database'),
('Biryani (veg)', 'veg-biryani', '{"vegetable biryani", "pulao"}', 150, 4, 24, 4, 1.5, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 250, 'g', '{"plate", "serving"}', 'system_database'),

-- ═══════════════════════════════════════════
-- FRUITS
-- ═══════════════════════════════════════════
('Banana', 'banana', '{"kela"}', 89, 1.1, 23, 0.3, 2.6, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 120, 'g', '{"piece", "medium"}', 'system_database'),
('Apple', 'apple', '{"seb"}', 52, 0.3, 14, 0.2, 2.4, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 180, 'g', '{"piece", "medium"}', 'system_database'),
('Mango', 'mango', '{"aam"}', 60, 0.8, 15, 0.4, 1.6, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 150, 'g', '{"piece", "medium", "cup"}', 'system_database'),
('Papaya', 'papaya', '{"papita"}', 43, 0.5, 11, 0.3, 1.7, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 150, 'g', '{"slice", "cup", "bowl"}', 'system_database'),
('Orange', 'orange', '{"santra", "narangi"}', 47, 0.9, 12, 0.1, 2.4, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 130, 'g', '{"piece", "medium"}', 'system_database'),
('Watermelon', 'watermelon', '{"tarbooz"}', 30, 0.6, 8, 0.2, 0.4, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 280, 'g', '{"slice", "cup", "bowl"}', 'system_database'),
('Pomegranate', 'pomegranate', '{"anaar"}', 83, 1.7, 19, 1.2, 4, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 150, 'g', '{"bowl", "cup"}', 'system_database'),

-- ═══════════════════════════════════════════
-- SNACKS
-- ═══════════════════════════════════════════
('Samosa', 'samosa', '{"aloo samosa"}', 260, 4.5, 28, 15, 1.5, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 80, 'g', '{"piece"}', 'system_database'),
('Pakora', 'pakora', '{"bhajiya", "fritter"}', 235, 5, 22, 14, 2, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 50, 'g', '{"piece", "serving"}', 'system_database'),
('Vada Pav', 'vada-pav', '{"batata vada pav"}', 290, 6, 38, 13, 2, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 150, 'g', '{"piece"}', 'system_database'),
('Pav Bhaji', 'pav-bhaji', '{}', 260, 6, 35, 11, 3, '{"gluten", "dairy"}', '{"vegetarian"}', '{}', 300, 'g', '{"plate", "serving"}', 'system_database'),

-- ═══════════════════════════════════════════
-- BEVERAGES
-- ═══════════════════════════════════════════
('Chai', 'chai', '{"tea", "masala chai", "Indian tea"}', 35, 1.2, 5, 1.2, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 150, 'ml', '{"cup"}', 'system_database'),
('Black Coffee', 'black-coffee', '{"coffee", "filter coffee"}', 2, 0.3, 0, 0, 0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 200, 'ml', '{"cup"}', 'system_database'),
('Coffee with Milk', 'coffee-with-milk', '{"latte", "cappuccino", "milk coffee"}', 30, 1.5, 3, 1.2, 0, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 200, 'ml', '{"cup"}', 'system_database'),
('Coconut Water', 'coconut-water', '{"nariyal pani"}', 19, 0.7, 3.7, 0.2, 1.1, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 250, 'ml', '{"glass"}', 'system_database'),
('Nimbu Pani', 'nimbu-pani', '{"lemonade", "lime water", "shikanji"}', 25, 0.1, 6, 0, 0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 250, 'ml', '{"glass"}', 'system_database'),

-- ═══════════════════════════════════════════
-- NUTS & DRY FRUITS
-- ═══════════════════════════════════════════
('Almonds', 'almonds', '{"badam"}', 579, 21, 22, 50, 12, '{"tree_nut"}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 30, 'g', '{"handful", "piece"}', 'system_database'),
('Cashews', 'cashews', '{"kaju"}', 553, 18, 30, 44, 3, '{"tree_nut"}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 30, 'g', '{"handful", "piece"}', 'system_database'),
('Peanuts', 'peanuts', '{"mungfali", "groundnut"}', 567, 26, 16, 49, 9, '{"peanut"}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 30, 'g', '{"handful"}', 'system_database'),
('Walnuts', 'walnuts', '{"akhrot"}', 654, 15, 14, 65, 7, '{"tree_nut"}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 30, 'g', '{"piece", "handful"}', 'system_database'),

-- ═══════════════════════════════════════════
-- SWEETS & DESSERTS
-- ═══════════════════════════════════════════
('Gulab Jamun', 'gulab-jamun', '{}', 325, 4, 45, 15, 0.3, '{"dairy", "gluten"}', '{"vegetarian"}', '{}', 40, 'g', '{"piece"}', 'system_database'),
('Kheer', 'kheer', '{"rice pudding", "payasam"}', 135, 3.5, 18, 5.5, 0.2, '{"dairy"}', '{"gluten_free", "vegetarian"}', '{}', 150, 'g', '{"bowl", "katori"}', 'system_database'),
('Jalebi', 'jalebi', '{}', 370, 2, 55, 16, 0, '{"gluten"}', '{"vegetarian"}', '{}', 50, 'g', '{"piece"}', 'system_database'),

-- ═══════════════════════════════════════════
-- GLOBAL BASICS
-- ═══════════════════════════════════════════
('Pasta (cooked)', 'pasta-cooked', '{"spaghetti", "penne", "macaroni"}', 131, 5, 25, 1.1, 1.8, '{"gluten"}', '{"vegetarian", "vegan"}', '{}', 200, 'g', '{"bowl", "plate", "cup"}', 'system_database'),
('Pizza', 'pizza', '{"cheese pizza"}', 266, 11, 33, 10, 2.3, '{"gluten", "dairy"}', '{"vegetarian"}', '{}', 107, 'g', '{"slice"}', 'system_database'),
('Peanut Butter', 'peanut-butter', '{}', 588, 25, 20, 50, 6, '{"peanut"}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 15, 'g', '{"tbsp"}', 'system_database'),
('Honey', 'honey', '{"shahad"}', 304, 0.3, 82, 0, 0.2, '{}', '{"gluten_free", "vegetarian"}', '{}', 15, 'g', '{"tsp", "tbsp"}', 'system_database'),
('Olive Oil', 'olive-oil', '{}', 884, 0, 0, 100, 0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 10, 'ml', '{"tsp", "tbsp"}', 'system_database'),
('Sugar', 'sugar', '{"cheeni"}', 387, 0, 100, 0, 0, '{}', '{"gluten_free", "vegetarian", "vegan"}', '{}', 5, 'g', '{"tsp", "tbsp"}', 'system_database');
