# Core Eating Loop — PoC Scope

This directory defines the scope, design, and specification for the Core Eating Loop Proof of Concept. The loop is a behavioral awareness engine — it learns what you eat, when, and how your eating day takes shape. It is not a nutrition tracker.

---

## What This Is

A specification for a system that:
- Accepts prose food logs ("had chai and paratha")
- Captures food items immediately, zero friction
- Assumes food identity and meal occasion (suggestions)
- Lets users accept, pick an alternate, correct, or ignore suggestions
- Learns from every interaction to improve future suggestions
- Presents an evolving day view showing logged, expected, and missing meals
- Converges to near-zero corrections by day 7

---

## Files

| File | What it defines |
|---|---|
| [core-eating-loop.md](core-eating-loop.md) | The loop concept — what it is, what it isn't, the 7-step process, the three artifacts (food vocabulary, meal vocabulary, eating day model), and what improves over time. |
| [entities.md](entities.md) | Two stored entities (`meal_item` as source of truth, `food_item` as materialized view), one event (`meal_logged`), and derived views. Includes field-level schema. |
| [functions.md](functions.md) | Seven functions that compose atomic capabilities: CAPTURE_MEAL_ITEMS, ASSUME_FOOD, ASSUME_MEAL_OCCASION, RESOLVE_ASSUMPTION, LEARN_FOOD, REEVALUATE_ASSUMPTIONS, SUGGEST_EATING_DAY. Each with input, context, output, confidence, commentary. |
| [reinforcement-loop.md](reinforcement-loop.md) | How the two user inputs (log_msg, clarification) drive four feedback loops through two entities. Status lifecycle (assumed → inferred → accepted → corrected). Self-reinforcement mechanics. |
| [user-function-flow.md](user-function-flow.md) | User-facing flows — what the user sees and when: Log, Clarify (accept/pick/correct/ignore), Day View, and lazy resolution of past logs. Maps functions to three screens. |
| [appendix-capabilities.md](appendix-capabilities.md) | Appendix. Deep brainstorm on edge cases and design decisions per atomic capability: canonical vs variant foods, quantity defaults, alias vs variant, occasion emergence, reflection tone. |

---

## Reading Order

1. **core-eating-loop.md** — understand the concept
2. **entities.md** — understand the data model
3. **functions.md** — understand what the system does
4. **reinforcement-loop.md** — understand how it improves
5. **user-function-flow.md** — understand what the user experiences

The atomic capabilities and nuances docs provide depth if needed.

---

## Key Design Decisions

- **Two entities only.** `meal_item` (source of truth) and `food_item` (materialized view). Everything else — occasion patterns, day model, reflections — is computed at read time.
- **Alternates persisted.** ASSUME_FOOD and ASSUME_MEAL_OCCASION return best + alternates, both stored on the meal_item. Enables lazy resolution (one-tap from past logs) and smarter REEVALUATE.
- **Four-state status.** `assumed → inferred → accepted → corrected`. Assumed = system guessed. Inferred = pattern confirmed. Accepted = user confirmed. Corrected = user changed.
- **SUGGEST_EATING_DAY is not stored.** The day view is a presentation computed at render time. No eating day model entity. The LLM reads meal_items history and computes the view fresh.
- **LEARN_FOOD is reconciliation.** It operates on food_items, not meal_items. ASSUME_FOOD creates food_items. LEARN_FOOD merges, aliases, prunes, and refines them.
- **food_priors = pre-seeded food_items.** Not a separate concept. Priors are the initial state of the food_item table.

---

## Open Questions

To be resolved by the implementation team.

### Entities

1. **Multi-message grouping.** If a user sends "had chai" then "oh and paratha" 5 minutes later — same `meal_event_id` or different? What's the time window? 15 minutes? Configurable?
2. **Edit/delete logs.** Can the user delete a meal_item? Can they edit capture columns (change quantity from 1 to 2)? Or is it delete-and-re-log?
3. **Day boundary.** When does an "eating day" start/end? Midnight? 4am? Should it be user-configurable?
4. **Retroactive logging.** "Yesterday I had pizza for dinner." Does CAPTURE extract the date from prose? Or is it always today?

### Functions

5. **REEVALUATE trigger.** When does the background sweep run? After every Nth log? Daily? On app open? Event-driven?
6. **REEVALUATE threshold.** How much pattern evidence is needed to promote assumed → inferred? 3 similar items? 80% consistency?
7. **ASSUME_FOOD on day 1.** Without food_items, what does ASSUME_FOOD use? LLM general knowledge? A hard-coded seed list? How many food_items to pre-seed?
8. **SUGGEST_EATING_DAY windowing.** How much history does it read? All meal_items ever? Last 30 days? This affects LLM context size and cost.
9. **Alternate generation.** How many alternates per suggestion? 2? 3? 5? Does the LLM generate them, or are they looked up from food_items/priors?

### User Experience

10. **Reflection frequency.** Does every log get a reflection? Or only some? How to avoid being annoying?
11. **Proactive nudge.** Does the system ever push "it's 2pm, lunch?" Or is it purely pull-based (user opens app)?
12. **No-log days.** What happens when the user doesn't log anything for a day? For 3 days? Does the day model degrade? Does the system notice?
13. **Week/history view.** PoC defines a day view. Is any historical view in scope? Or deferred?

### Scale

14. **Occasion priors.** Hard-coded for PoC (breakfast, lunch, dinner). How and when to make them configurable or locale-aware?
15. **Global food catalog (V2).** Alternates accumulate variant data. At what point do we extract this into a shared global_food_catalog?

---

## Implementation Guidelines

### LLM Usage

- **CAPTURE_MEAL_ITEMS + ASSUME_FOOD + ASSUME_MEAL_OCCASION** can likely be a single LLM call per log_msg. Parse, resolve food, and infer occasion in one structured output.
- **SUGGEST_EATING_DAY** is a separate LLM call. Reads meal_item history as context, produces the day view as structured output.
- **REEVALUATE_ASSUMPTIONS** may or may not need LLM. Pattern matching and confidence scoring could be deterministic (SQL queries + rules). LLM only if semantic similarity is needed for merging food_items.
- **LEARN_FOOD** should be as deterministic as possible. Frequency counts, mode calculations, co-occurrence joins — these are queries, not LLM tasks.

### Data Model

- `meal_item` is the single source of truth. Design the system such that food_items could be rebuilt from meal_items if needed (materialized view property).
- Alternates are jsonb blobs on meal_item. Keep them small (2–3 entries). Don't over-generate.
- Status transitions are one-directional: assumed → inferred, assumed → accepted, assumed → corrected. Never downgrade.

### Testing

- The core hypothesis is **convergence**: by day 7, the system should know the user's foods, occasions, and day shape well enough that corrections approach zero.
- Test with a single simulated user over a 7-day log sequence. Measure correction rate per day.
- SUGGEST_EATING_DAY is the integration test surface — if the day view looks right on day 7, the loop works.
