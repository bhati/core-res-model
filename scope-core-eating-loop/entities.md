# Entities — Core Eating Loop PoC

One source of truth, one materialized view, everything else is compute.

---

## meal_item

One row per food item logged. Carries both capture (what user said) and suggest (what system thinks).

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
  suggested_food_identity       text        ← "milk tea"
  suggested_food_ref            uuid        ← → food_item (created by ASSUME_FOOD)
  food_identity_confidence      numeric     ← 0.6
  food_identity_status          text        ← assumed / inferred / accepted / corrected

  -- SUGGEST: occasion --
  suggested_occasion            text        ← "breakfast"
  occasion_confidence           numeric     ← 0.5
  occasion_status               text        ← assumed / inferred / accepted / corrected
```

### Status progression

```
assumed   → system guessed (ASSUME_FOOD / ASSUME_MEAL_OCCASION)
inferred  → pattern evidence upgraded it (REEVALUATE_ASSUMPTIONS)
accepted  → user explicitly confirmed (RESOLVE_ASSUMPTION)
corrected → user explicitly changed it (RESOLVE_ASSUMPTION)
```

### Key properties

- **Capture columns** are immutable. The user's words don't change.
- **Suggest columns** are mutable. Status evolves through the lifecycle.
- **meal_event_id** groups items from the same log_msg.
- **suggested_food_ref** always points to a real food_item — ASSUME_FOOD creates it if it doesn't exist.

---

## food_item

One row per distinct food in the user's vocabulary. Created by ASSUME_FOOD immediately on first encounter. Refined by LEARN_FOOD over time.

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

- **Created by ASSUME_FOOD** the moment a food is first assumed. User-visible immediately.
- **Refined by LEARN_FOOD** (reconciliation): merges duplicates, registers aliases, updates defaults, prunes unused priors.
- **Could be recomputed** from meal_items alone. It's a materialized view, not a source of truth.

---

## Event: meal_logged

Not a stored entity — an event that triggers processing.

```
event: meal_logged
  event_id                      uuid        ← = meal_event_id
  user_id                       uuid
  raw_input                     text
  item_count                    int
  timestamp                     timestamp
```

---

## Derived Views (queries, not entities)

### Occasion history

```sql
SELECT DISTINCT meal_event_id, date, logged_at,
       suggested_occasion, occasion_status
FROM meal_items
WHERE user_id = ?
ORDER BY date, logged_at
```

### Food frequency

```sql
SELECT food_name, COUNT(*) as freq,
       MODE() WITHIN GROUP (ORDER BY quantity) as typical_qty
FROM meal_items
WHERE user_id = ?
GROUP BY food_name
```

---

## Presentation: SUGGEST_EATING_DAY

Not stored — computed at render time.

```
SUGGEST_EATING_DAY(day_context, meal_items, food_items)
→ { logged, expected, gaps, emerging, reflection }
```

---

## Summary

```
STORED:
  meal_item     source of truth      created by CAPTURE, updated by ASSUME/RESOLVE/REEVALUATE
  food_item     materialized view    created by ASSUME_FOOD, refined by LEARN_FOOD

EVENT:
  meal_logged   trigger              fires the pipeline

COMPUTED:
  occasion history     query on meal_items
  eating day view      SUGGEST_EATING_DAY at render time
```
