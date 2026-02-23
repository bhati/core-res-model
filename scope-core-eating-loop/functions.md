# Functions — Core Eating Loop PoC

Seven functions. Two entities. Each function composes atomic capabilities.

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
  -> output:      { best: { identity, food_ref, confidence },
                    alternates: [{ identity, food_ref, confidence }] }
  -> confidence:  0.0–1.0 (prior only → low, vocab match → high)
  -> commentary:  "chai → ginger tea (also: milk tea, green tea)"
```

Matches existing food_item or **creates a new one immediately.** User-visible from moment one. Returns best guess + alternates. Both persisted on meal_item. Status set to `assumed`.

---

## ASSUME_MEAL_OCCASION

```
(infer_occasion) =>

ASSUME_MEAL_OCCASION(
  input:    [meal_items from this event] + timestamp,
  context:  meal_items (occasion history) + occasion_priors
)
  -> output:      { best: { label, confidence },
                    alternates: [{ label, confidence }] }
  -> confidence:  0.0–1.0 (prior only → low, repeated pattern → high)
  -> commentary:  "Lunch (also: late breakfast)"
```

One occasion per meal_event_id. Best + alternates persisted. Status set to `assumed`.

---

## RESOLVE_ASSUMPTION

```
(learn_food, learn_occasion) =>

RESOLVE_ASSUMPTION(
  input:    user action (accept | correct | pick_alternate) + value,
  context:  meal_item being resolved
)
  -> output:      updated meal_item suggest columns
  -> confidence:  accepted → medium, corrected → highest, pick_alternate → high
  -> commentary:  "Updated: chai = milk tea" or "Confirmed: Lunch"
```

Three user actions:
- **accept**: status → accepted, best stays.
- **pick_alternate**: status → corrected, alternate becomes best. One tap, no typing.
- **correct (free text)**: status → corrected, new value. Strongest signal.

Corrections trigger LEARN_FOOD.

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

Operates ON food_items, not meal_items. Reconciliation:
- **Merge** duplicates detected from patterns
- **Register aliases** from corrections
- **Update defaults** (quantity, unit from mode)
- **Build co-occurrences** (cross meal_event patterns)
- **Prune** unused or inactive food_items

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

Background sweep. Can also swap best ↔ alternate when pattern evidence supports a different choice. Triggers LEARN_FOOD after promotion.

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

Read-only presentation. Computed at render time. Weights by status: corrected > accepted > inferred > assumed.

---

## Summary

```
CAPTURE_MEAL_ITEMS(prose, priors)             → creates meal_items
ASSUME_FOOD(name, vocab+priors)               → creates/matches food_item + alternates
ASSUME_MEAL_OCCASION(items+time, history)     → suggests occasion + alternates
RESOLVE_ASSUMPTION(action, meal_item)         → accept / pick alternate / correct
LEARN_FOOD(food_items, meal_item history)      → reconcile food vocabulary
REEVALUATE_ASSUMPTIONS(assumed, corpus)       → promote assumed → inferred
SUGGEST_EATING_DAY(day_context, all_data)     → presentation (read-only)
```

Seven functions. Two entities. Alternates persisted for lazy resolution and REEVALUATE.
