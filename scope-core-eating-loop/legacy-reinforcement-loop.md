# Reinforcement Loop

Two user inputs, three immediate objects, three accumulated stores, two downstream outputs.

---

## Flow

```
USER INPUT 1: log_msg

log_msg ──── parse_foods + estimate_quantity ──────▶ meal_item_log
                │                                        │
                │                                        │ (always stored)
                │                                        ▼
                │                                   ┌─────────┐
                │                                   │ 🗄 RAW  │
                │                                   │  LOGS   │
                │                                   └────┬────┘
                │                                        │
                ├──── resolve_food_identity ──────▶ food_item (suggested)
                │         ▲                              │
                │         │                              ▼
                │    ┌────┴──────┐               ┌──────────────┐
                │    │ 🗄 FOOD   │◂── learn_food ◂┤              │
                │    │ VOCABULARY│               │              │
                │    └───────────┘               │              │
                │                                │   accepted?  │
                ├──── infer_occasion + time ──▶ meal_occasion   │  corrected?
                          ▲                  (suggested)        │  ignored?
                          │                      │              │
                     ┌────┴──────┐               │              │
                     │ 🗄 MEAL   │◂─learn_occasion◂┘             │
                     │ VOCABULARY│                              │
                     └───────────┘                              │
                                                                │
                                                                │
USER INPUT 2: clarification                                     │
                                                                │
clarification ──────────────────────────────────────────────────┘
  │
  │  (user acts on suggestions: accept / correct / ignore)
  │
  ├── corrects food_item ──────▶ learn_food ──▶ Food Vocabulary
  │   "no, my chai has ginger"
  │
  ├── corrects meal_occasion ──▶ learn_occasion ──▶ Meal Vocabulary
  │   "that was a snack, not lunch"
  │
  └── accepts ─────────────────▶ both vocabularies (medium signal)


DOWNSTREAM (no user input — emerges from accumulated stores):

  ┌───────────┐   ┌───────────┐
  │ 🗄 FOOD   │   │ 🗄 MEAL   │
  │ VOCABULARY│   │ VOCABULARY│
  └─────┬─────┘   └─────┬─────┘
        │               │
        └───────┬───────┘
                │
                ▼
         learn_day_shape
                │
                ▼
        ┌──────────────┐
        │ 🗄 EATING    │
        │ DAY MODEL    │
        └───────┬──────┘
                │
                ▼
         compute_today (reads raw logs + meal vocab)
                │
                ▼
         detect_gaps (reads today vs day model)
                │
                ▼
         generate_reflection (reads everything)
                │
                ▼
           📋 DAY VIEW
```

---

## Three Kinds of Capability

| Kind | Capabilities | Trigger |
|---|---|---|
| Parse-time | parse_foods, estimate_quantity, resolve_food_identity, infer_occasion | log_msg |
| Correction-time | learn_food, learn_occasion (from corrections) | clarification |
| Emergent | learn_day_shape, compute_today, detect_gaps, generate_reflection | accumulated data |

---

## Two User Inputs

**log_msg** — creates raw data (always) and suggestions (always). The system gets fuel.

**clarification** — sharpens suggestions into confirmed knowledge. The system gets signal quality.

The system works without clarification — suggestions bootstrap from patterns across the accumulated corpus. But clarification accelerates convergence. A single correction on day 1 is worth 5 pattern-matched suggestions on day 5.

---

## Self-Reinforcement

Suggestions don't only improve from user actions. They improve from each other.

```
Day 1:  sug: breakfast? (0.5)     evidence: just time
Day 5:  same sug: breakfast (0.85) evidence: 4 other 8am logs + food pattern

Day 1:  sug: chai→green tea? (0.4) evidence: prior only
Day 5:  same sug: chai→milk tea (0.9) evidence: user corrected once, 4 consistent logs
```

Three learning sources for suggestions:

1. **User corrects** — strongest, immediate
2. **User accepts** — medium, passive
3. **Pattern across accumulated suggestions** — grows over time, unresolved suggestions confirm each other

---

## Accumulated Objects

| Object | Grows from | Rate | Used by |
|---|---|---|---|
| Raw Logs | every log_msg | fast | learn_food, compute_today |
| Food Vocabulary | learn_food (every log) + corrections | fast | resolve_food_identity |
| Meal Vocabulary | suggestion outcomes + suggestion patterns | medium | infer_occasion, detect_gaps |
| Eating Day Model | both vocabularies converging | slow | detect_gaps, generate_reflection |
