# Reinforcement Loop

Two user inputs, two entities, seven functions.

---

## The Loop

```
USER INPUT 1: log_msg
"had chai and paratha for lunch"
                │
                ▼
        CAPTURE_MEAL_ITEMS
        (parse_foods, estimate_quantity)
                │
                │ creates meal_items (capture columns)
                │
                ├──▶ ASSUME_FOOD
                │    match/create food_item
                │    meal_item.food_status = assumed
                │         │
                │         ▼
                │    ┌──────────────────────┐
                │    │ 🗄 FOOD_ITEM         │
                │    │ chai: created/matched│
                │    │ paratha: created     │
                │    └──────────────────────┘
                │
                ├──▶ ASSUME_MEAL_OCCASION
                │    meal_item.occasion_status = assumed
                │
                ▼
   ┌──────────────────────────────────────────────────────┐
   │ 🗄 MEAL_ITEM                                        │
   │                                                      │
   │  CAPTURE (immutable)      SUGGEST (mutable)          │
   │  ─────────────────        ──────────────────         │
   │  food_name: "chai"        food: milk tea (assumed)   │
   │  quantity: 1              occasion: lunch (assumed)  │
   │  food_name: "paratha"     food: aloo (assumed)       │
   │  quantity: 1              occasion: lunch (assumed)  │
   └──────────────────────────────────┬───────────────────┘
                                      │
                                      │ shown to user
                                      ▼
                              ┌──────────────────────┐
                              │ User sees:           │
                              │ ✓ chai(1), paratha(1)│
                              │ 🌤 Lunch?            │
                              │ chai → milk tea       │
                              │ paratha → aloo        │
                              │ [✓ ok] [✎ fix]       │
                              └──────────┬───────────┘
                                         │
                                         │
USER INPUT 2: clarification              │
                                         │
clarification ◂──────────────────────────┘
  │
  │  accept / correct / ignore
  │
  ▼
  RESOLVE_ASSUMPTION
  │
  ├── accept ──▶ meal_item status → accepted
  │
  ├── correct ──▶ meal_item status → corrected
  │               meal_item.corrected_to = new value
  │
  └── ignore ──▶ status stays assumed
  │
  │  (if accepted or corrected)
  ▼
  LEARN_FOOD (reconciliation)
  │
  ├── merge duplicates in food_items
  ├── register aliases from corrections
  ├── update defaults (qty, co-occurrences)
  └── prune unused priors


BACKGROUND SWEEP (periodic):

  REEVALUATE_ASSUMPTIONS
  │
  │  walks meal_items WHERE status = 'assumed'
  │  compares against accepted + corrected + inferred corpus
  │
  ├── pattern fits ──▶ status: assumed → inferred
  └── triggers LEARN_FOOD (reconcile with new data)


PRESENTATION (user opens day view):

  SUGGEST_EATING_DAY(day_context, meal_items, food_items)
  │
  ▼
  📋 DAY VIEW (computed, never stored)
    logged:      ☀ Breakfast — chai, paratha
    expected:    🌙 Dinner ~9pm
    gap:         🌤 Lunch — didn't show up
    reflection:  "Solid morning, lunch skipped."
```

---

## Status Lifecycle

```
 ASSUME_FOOD / ASSUME_MEAL_OCCASION
               │
               ▼
           ┌────────┐
           │assumed │─────────────────────────────────┐
           └───┬────┘                                 │
               │                                      │
               │ REEVALUATE_ASSUMPTIONS               │ RESOLVE_ASSUMPTION
               │ (pattern evidence)                   │ (user action)
               ▼                                      ▼
           ┌────────┐                          ┌──────────┐
           │inferred│                          │ accepted │
           └────────┘                          │ corrected│
                                               └──────────┘

  corrected > accepted > inferred > assumed
    (user)     (user)    (pattern)   (guess)
```

---

## Self-Reinforcement

Three mechanisms, all operating on the same two entities:

```
① CORRECTIONS (strongest, immediate)
   user corrects → RESOLVE_ASSUMPTION → meal_item updated
                 → LEARN_FOOD → food_item refined

② ACCEPTANCES (medium, passive)
   user accepts → RESOLVE_ASSUMPTION → meal_item confirmed
                → LEARN_FOOD (weaker signal)

③ PATTERN ACCUMULATION (grows over time, no user action)
   meal_items accumulate → REEVALUATE_ASSUMPTIONS
   → assumed items promoted to inferred
   → LEARN_FOOD → food_items refined
```

---

## Functions ↔ Entities Map

| Function | Reads | Creates | Updates | Trigger |
|---|---|---|---|---|
| CAPTURE_MEAL_ITEMS | — | meal_item | — | log_msg |
| ASSUME_FOOD | food_item, priors | food_item (if new) | meal_item (suggest) | log_msg |
| ASSUME_MEAL_OCCASION | meal_items (history), priors | — | meal_item (suggest) | log_msg |
| RESOLVE_ASSUMPTION | meal_item | — | meal_item (status) | user action |
| LEARN_FOOD | meal_items (history) | — | food_item (reconcile) | after RESOLVE + REEVALUATE |
| REEVALUATE_ASSUMPTIONS | meal_items (corpus) | — | meal_item (status) | background sweep |
| SUGGEST_EATING_DAY | meal_items, food_items | — | nothing | user opens day view |

---

## Convergence

```
Day 1:   mostly assumed → noisy food_items, generic day view
Day 3:   some accepted/corrected → LEARN_FOOD merges, aliases form
Day 5:   REEVALUATE promotes → assumed → inferred, food vocab solid
Day 7:   mostly inferred+accepted → SUGGEST_EATING_DAY is accurate
         corrections approach zero
```
