# Functions — Core Eating Loop PoC

Each function composes atomic capabilities into one call.

---

## CAPTURE_MEAL_ITEMS

```
(parse_foods, estimate_quantity) =>

CAPTURE_MEAL_ITEMS(
  input:    raw prose,
  context:  food_priors
)
  -> output:      [{ food_name, quantity, qualifier }]
  -> confidence:  high (user's own words)
  -> commentary:  "Got it: chai (1), paratha (1)"
```

Creates meal_item rows (capture columns). Always stores. User can walk away.

---

## ASSUME_FOOD

```
(resolve_food_identity) =>

ASSUME_FOOD(
  input:    food_name (from capture),
  context:  food_items (user vocab) + food_priors
)
  -> output:      { food_ref, identity }
  -> confidence:  0.0–1.0 (prior only → low, vocab match → high)
  -> commentary:  "chai → milk tea" or "chai → new food, first time"
```

Matches existing food_item or **creates a new one immediately.** The food_item is user-visible from the moment it's assumed. Sets meal_item status to `assumed`.

---

## ASSUME_MEAL_OCCASION

```
(infer_occasion) =>

ASSUME_MEAL_OCCASION(
  input:    [meal_items from this event] + timestamp,
  context:  meal_items (occasion history) + occasion_priors
)
  -> output:      { occasion_label, time_window }
  -> confidence:  0.0–1.0 (prior only → low, repeated pattern → high)
  -> commentary:  "Lunch — matches your usual 1:30pm slot"
```

One occasion per meal_event_id. Sets meal_item status to `assumed`.

---

## RESOLVE_ASSUMPTION

```
(learn_food, learn_occasion) =>

RESOLVE_ASSUMPTION(
  input:    user action (accept | correct | ignore),
  context:  meal_item being resolved
)
  -> output:      updated meal_item suggest columns
  -> confidence:  accepted → medium, corrected → highest, ignored → unchanged
  -> commentary:  "Updated: chai = ginger tea" or "Confirmed: Lunch"
```

Updates meal_item status to `accepted` or `corrected`. Corrections trigger LEARN_FOOD.

---

## LEARN_FOOD

```
(learn_food) =>

LEARN_FOOD(
  input:    food_items to reconcile,
  context:  meal_items (history of usage)
)
  -> output:      food_items updated (merged / aliased / pruned / refined)
  -> confidence:  n/a (reconciliation)
  -> commentary:  "merged 'morning tea' into 'chai', default qty → 1 cup"
```

Operates ON food_items, not meal_items. Reconciliation, not creation:
- **Merge** duplicates (detected from patterns)
- **Register aliases** (from corrections)
- **Update defaults** (quantity, unit from mode)
- **Build co-occurrences** (cross meal_event patterns)
- **Prune** unused prior food_items

Runs after RESOLVE_ASSUMPTION and REEVALUATE_ASSUMPTIONS.

---

## REEVALUATE_ASSUMPTIONS

```
(pattern matching across accumulated data) =>

REEVALUATE_ASSUMPTIONS(
  input:    meal_items WHERE status = 'assumed',
  context:  meal_items WHERE status IN ('accepted', 'corrected', 'inferred')
)
  -> output:      meal_items with status: assumed → inferred
  -> confidence:  based on pattern consistency
  -> commentary:  "5 breakfast assumptions promoted to inferred"
```

Background sweep. Promotes assumed → inferred when pattern evidence supports it. Triggers LEARN_FOOD after promotion.

---

## SUGGEST_EATING_DAY

```
(compute_today, detect_gaps, generate_reflection, learn_day_shape) =>

SUGGEST_EATING_DAY(
  input:    day_context { date, current_time, day_of_week },
  context:  meal_items (full history) + food_items (vocab)
)
  -> output:      { logged, expected, gaps, emerging }
  -> confidence:  day 1 → low (priors), day 7 → high (patterns)
  -> commentary:  "Solid breakfast week — 5th day of chai-paratha."
```

Read-only presentation. Never stores. Computed at render time.

---

## Summary

```
CAPTURE_MEAL_ITEMS(prose, priors)               creates meal_items
ASSUME_FOOD(food_name, vocab+priors)            creates/matches food_item, updates meal_item
ASSUME_MEAL_OCCASION(items+time, history)       updates meal_item
RESOLVE_ASSUMPTION(user_action, meal_item)      updates meal_item → triggers LEARN_FOOD
LEARN_FOOD(food_items, meal_item history)        reconciles food_items
REEVALUATE_ASSUMPTIONS(assumed items, corpus)   promotes assumed → inferred → triggers LEARN_FOOD
SUGGEST_EATING_DAY(day_context, all_data)       presentation (read-only)
```

Seven functions. Two entities.
