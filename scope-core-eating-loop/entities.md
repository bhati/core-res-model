# Entities — Core Eating Loop PoC

One source of truth, one materialized view, everything else is compute.

---

## meal_item

One row per food item logged. Carries capture (what user said), suggest (what system thinks), and alternates (other possibilities).

```
meal_item:
  id                            uuid
  meal_event_id                 uuid        ← groups items from one log_msg
  user_id                       uuid

  -- CAPTURE (immutable after creation) --
  raw_input                     text        ← full prose: "had chai and paratha"
  food_name                     text        ← parsed token: "chai"
  quantity                      numeric     ← 1
  quantity_qualifier             text        ← "small" / "large" / null
  logged_at                     timestamp
  date                          date

  -- SUGGEST: food identity --
  suggested_food_identity       text        ← "ginger tea" (best guess)
  suggested_food_ref            uuid        ← → food_item
  food_identity_confidence      numeric     ← 0.7
  food_identity_status          text        ← assumed / inferred / accepted / corrected
  food_identity_alternates      jsonb       ← [{ identity, food_ref, confidence }]

  -- SUGGEST: occasion --
  suggested_occasion            text        ← "breakfast" (best guess)
  occasion_confidence           numeric     ← 0.6
  occasion_status               text        ← assumed / inferred / accepted / corrected
  occasion_alternates           jsonb       ← [{ label, confidence }]
```

### Status progression

```
assumed   → system guessed (ASSUME_FOOD / ASSUME_MEAL_OCCASION)
inferred  → pattern evidence promoted it (REEVALUATE_ASSUMPTIONS)
accepted  → user explicitly confirmed (RESOLVE_ASSUMPTION)
corrected → user explicitly changed it (RESOLVE_ASSUMPTION)

corrected > accepted > inferred > assumed
```

### Key properties

- **Capture columns** are immutable.
- **Suggest columns** are mutable. Status and confidence evolve.
- **Alternates** are persisted for lazy resolution and REEVALUATE. Alternates double as variant data — seed for a future global food catalog.
- **suggested_food_ref** always points to a real food_item — ASSUME_FOOD creates it if new.

---

## food_item

One row per distinct food in the user's vocabulary. Created by ASSUME_FOOD immediately. Refined by LEARN_FOOD over time.

```
food_item:
  id                            uuid
  user_id                       uuid

  -- IDENTITY --
  display_name                  text        ← "chai"
  aliases                       text[]      ← ["morning tea", "adrak chai"]
  source                        text        ← prior / assumed / corrected

  -- DEFAULTS (refined by LEARN_FOOD) --
  default_quantity               numeric     ← 1
  default_quantity_unit          text        ← "cup"

  -- USAGE (refined by LEARN_FOOD) --
  frequency                     int         ← 12
  last_seen                     date
  co_occurrences                jsonb       ← [{food_ref, count}]

  -- STATUS --
  active                        boolean     ← false if pruned by LEARN_FOOD
```

### Key properties

- **Created by ASSUME_FOOD** immediately on first encounter. User-visible from moment one.
- **Refined by LEARN_FOOD** — merges duplicates, registers aliases, updates defaults, prunes unused items.
- **Materialized view** — could be recomputed from meal_items. Cached for performance.

---

## Event: meal_logged

Not a stored entity — triggers processing.

```
event: meal_logged
  event_id        uuid        ← = meal_event_id
  user_id         uuid
  raw_input       text
  item_count      int
  timestamp       timestamp
```

---

## Derived Views (queries, not entities)

### Occasion history

```sql
SELECT DISTINCT meal_event_id, date, logged_at,
       suggested_occasion, occasion_status
FROM meal_items WHERE user_id = ?
ORDER BY date, logged_at
```

### Variant map (seed for future global catalog)

```sql
SELECT food_name,
       jsonb_array_elements(food_identity_alternates) as variant,
       COUNT(*) as appearances
FROM meal_items WHERE user_id = ?
GROUP BY food_name, variant
```

---

## Summary

```
STORED:
  meal_item     source of truth      capture + suggest + alternates
  food_item     materialized view    created by ASSUME, refined by LEARN

EVENT:
  meal_logged   trigger              fires the pipeline

COMPUTED:
  occasion patterns    query on meal_items
  variant map          query on alternates
  eating day view      SUGGEST_EATING_DAY at render time

FUTURE (V2):
  global_food_catalog  built from accumulated alternates across users
```
