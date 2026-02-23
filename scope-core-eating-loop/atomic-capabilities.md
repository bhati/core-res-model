# Atomic Capabilities

13 discrete judgments the Core Eating Loop must perform.

---

## Tier 1 — Capture

### 1. parse_foods

Extract individual food items from prose.

- **Input:** raw prose ("had chai and paratha with some pickle")
- **Output:** list of food tokens [`chai`, `paratha`, `pickle`]

### 2. estimate_quantity

Infer quantity from prose or apply a sensible default.

- **Input:** food token + prose context ("2 rotis", "some dal", "chai")
- **Output:** quantity per item (2 rotis, 1 serving dal, 1 cup chai)

---

## Tier 2 — Suggest

### 3. resolve_food_identity

Match extracted food token against the user's food vocabulary. Fall back to priors. Create new entry if unknown.

- **Input:** food token + user food vocabulary + food_priors
- **Output:** matched food entry (existing, alias match, or new)

### 4. infer_occasion

Classify this log into an eating occasion based on time, content, and user history.

- **Input:** resolved items + timestamp + meal vocabulary + occasion_priors
- **Output:** occasion label (breakfast, lunch, evening snack, late night…)

---

## Priors

### 5. food_priors

Pre-loaded food knowledge for a region/locale. Makes parse and resolve work on day 1.

- **Input:** region/locale hint (or none)
- **Output:** base food vocabulary (common names, aliases, typical quantities)

### 6. occasion_priors

Default meal template. Seeds the meal vocabulary before any personal data exists.

- **Input:** none
- **Output:** default occasion template (breakfast ~8am, lunch ~1pm, dinner ~8pm, optional snack)

### 7. day_model_priors

Generic day shape. Seeds the eating day model before any personal data exists.

- **Input:** none
- **Output:** generic day shape (3 expected occasions + approximate time windows)

---

## Learn

### 8. learn_food

Update food vocabulary after a log. Add new food, register alias, strengthen default quantity, record co-occurrences.

- **Input:** resolved log entry (food items + quantities + user action on suggestion)
- **Output:** updated food vocabulary

### 9. learn_occasion

Update meal vocabulary after a log. Strengthen existing occasion, adjust time window, record typical foods per occasion, detect emerging new occasions.

- **Input:** resolved log + occasion label + timestamp + user action on suggestion
- **Output:** updated meal vocabulary

### 10. learn_day_shape

Update eating day model. Refine expected occasions, typical timing, expected food bundles per slot.

- **Input:** all logs for the day + existing eating day model
- **Output:** updated eating day model

---

## Day Awareness

### 11. compute_today

Assemble today's state: which occasions have been logged, what foods, at what times.

- **Input:** today's logs + meal vocabulary
- **Output:** today's state (occasions logged, foods per occasion, time coverage)

### 12. detect_gaps

Compare today's state against the eating day model. Surface expected occasions that haven't shown up yet.

- **Input:** today's state + eating day model
- **Output:** list of expected-but-missing occasions + approximate expected time

---

## Reflect

### 13. generate_reflection

Produce one short ambient observation after a log. Must feel personal, not robotic. Never judgmental. Never repetitive.

- **Input:** today's state + gaps + food vocabulary + meal vocabulary + eating day model
- **Output:** one ambient sentence
