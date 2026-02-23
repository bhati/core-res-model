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
                │
                │ creates meal_items (capture columns)
                │
                ├──▶ ASSUME_FOOD
                │    reads food_items (user vocab) + priors
                │    creates/matches food_item
                │    returns best + alternates
                │         │
                │         ▼
                │    ┌──────────────────────┐
                │    │ 🗄 FOOD_ITEM         │
                │    │ chai: created/matched│
                │    │ paratha: created     │
                │    └──────────────────────┘
                │
                ├──▶ ASSUME_MEAL_OCCASION
                │    reads occasion history + priors
                │    returns best + alternates
                │
                ▼
   ┌──────────────────────────────────────────────────────┐
   │ 🗄 MEAL_ITEM                                        │
   │                                                      │
   │  CAPTURE              SUGGEST                        │
   │  ──────               ──────                         │
   │  chai (1)             food: ginger tea (assumed)     │
   │                       alts: [milk, masala, green]    │
   │  paratha (1)          food: aloo (assumed)           │
   │                       alts: [stuffed, plain]         │
   │                                                      │
   │  occasion: lunch (assumed), alts: [late breakfast]   │
   └───────────────────────┬──────────────────────────────┘
                           │
                           │ shown to user
                           ▼
                   ┌───────────────────────┐
                   │ 📱 Log Confirmation   │
                   │                       │
                   │ ✓ chai(1), paratha(1)  │
                   │ 🌤 Lunch?              │
                   │ chai → ginger tea      │
                   │  also: milk · masala   │
                   │ [✓ ok] [milk tea] [✎]  │
                   └───────────┬───────────┘
                               │

USER INPUT 2: clarification    │
                               │
  ┌────────────────────────────┘
  │
  ├── accept ──▶ RESOLVE_ASSUMPTION → status: accepted
  │                   │
  │                   └──▶ LEARN_FOOD (reconcile food_items)
  │
  ├── pick alternate ──▶ RESOLVE_ASSUMPTION → status: corrected
  │   (one tap)              alt becomes best
  │                          │
  │                          └──▶ LEARN_FOOD (reconcile)
  │
  ├── correct (type) ──▶ RESOLVE_ASSUMPTION → status: corrected
  │   (free text)            new value
  │                          │
  │                          └──▶ LEARN_FOOD (reconcile + new food_item?)
  │
  └── ignore ──▶ nothing. stays assumed. revisited later.


BACKGROUND:

  REEVALUATE_ASSUMPTIONS
  │
  │  walks meal_items WHERE status = 'assumed'
  │  compares against accepted + corrected + inferred corpus
  │
  ├── confirms best ────▶ promotes: assumed → inferred
  ├── swaps best ↔ alt ──▶ promotes: assumed → inferred (with new best)
  └── triggers LEARN_FOOD (reconcile with promoted data)


PRESENTATION:

  SUGGEST_EATING_DAY(day_context, meal_items, food_items)
  │
  │  weights by status: corrected > accepted > inferred > assumed
  │
  ▼
  📋 DAY VIEW (computed, never stored)
    logged:       ☀ Breakfast — chai (ginger tea), paratha
    expected:     🌙 Dinner ~9pm
    gap:          🌤 Lunch — didn't show up
    reflection:   "Solid morning, lunch skipped."
```

---

## Status Lifecycle

```
  ASSUME_FOOD / ASSUME_MEAL_OCCASION
                │
                ▼
            ┌────────┐
            │assumed │──────────────────────────────────────┐
            └───┬────┘                                     │
                │                                          │
                │ REEVALUATE              RESOLVE           │
                │ (pattern)              (user action)      │
                ▼                         ▼                 │
            ┌────────┐             ┌──────────┐            │
            │inferred│             │ accepted │            │
            └────────┘             │ corrected│            │
                                   └──────────┘            │
                                                           │
  user can also resolve by picking an alternate ───────────┘
  from persisted alternates on old logs (lazy resolution)
```

---

## Four Feedback Loops

```
Loop 1: CAPTURE → ASSUME → meal_items → next ASSUME reads richer history
        (every log improves the next log's suggestions)

Loop 2: RESOLVE → LEARN_FOOD → food_items refined → ASSUME reads better vocab
        (user corrections sharpen food vocabulary)

Loop 3: REEVALUATE → promotes assumed → inferred → LEARN_FOOD reconciles
        (background sweep tightens everything without user effort)

Loop 4: alternates accumulate → variant patterns emerge → seed for global catalog
        (data asset grows for V2 multi-user sharing)
```

---

## Functions × Entities

| Function | Reads | Creates | Updates | Trigger |
|---|---|---|---|---|
| CAPTURE_MEAL_ITEMS | — | meal_item | — | log_msg |
| ASSUME_FOOD | food_item, priors | food_item (if new) | meal_item (suggest + alts) | log_msg |
| ASSUME_MEAL_OCCASION | meal_items (history), priors | — | meal_item (suggest + alts) | log_msg |
| RESOLVE_ASSUMPTION | meal_item | — | meal_item (status) | user: accept/pick/correct |
| LEARN_FOOD | meal_items (history) | — | food_item (reconcile) | after RESOLVE + REEVALUATE |
| REEVALUATE_ASSUMPTIONS | meal_items (corpus) | — | meal_item (promote + swap) | background sweep |
| SUGGEST_EATING_DAY | meal_items, food_items | — | nothing | user opens day view |

---

## Convergence

```
Day 1:   all assumed → noisy, alternates everywhere
Day 3:   some accepted/corrected → LEARN_FOOD merges, aliases form
Day 5:   REEVALUATE promotes → food vocab solid, alternates narrow
Day 7:   mostly inferred+accepted → day view is accurate
         user rarely corrects, often just accepts or ignores
```
