Build a MealPlan

⸻

Part 1: Problem Statement

The system needs to suggest what the user should eat. This ranges from "what should I have for dinner?" to "plan my entire week." The challenge: planning is high effort for users but high value for the system (it enables plan-confirm logging, adherence tracking, and nutritional balance). The system should do the planning work and let the user review.

⸻

What Makes This Hard

1. Planning scope varies — one meal, one day, one week. Same artifact, different depth.
2. Plans go stale — by Wednesday, Monday's plan may be irrelevant if the user didn't follow it.
3. Users don't want to plan until they trust the system. Planning is opt-in, not forced.
4. Token cost scales with planning scope. Auto-generating weekly plans for users who don't want them wastes resources.
5. Meal variety vs user preference — system must balance "you should eat this" with "you actually like eating this."
6. Plans must respect all constraints simultaneously — calories, macros, allergens, dietary exclusions, medical priors, cooking capacity, preferences.

⸻

Invariants

Data:
- MealPlan is a temporal arrangement of intended meals
- Implicitly serves the active NutritionGoal (no goal_ref needed — one goal per domain)
- context_snapshot captures what influenced the plan at build time
- Staleness detection: compare current context against snapshot
- Copy at build. Safety resolves live.
- Superseded plans preserved (status: superseded, superseded_by)

Scope continuum:
- MealPlan covers meal | day | week — same schema, different depth
- "Recommend a meal" is a MealPlan with scope: meal
- No separate RecommendMeal tool

Slot states:
- suggestion — system auto-generated, can silently update
- soft — user loosely accepted, suggest changes with reason
- committed — user explicitly reviewed, ask before changing

⸻

Part 2: Proposal

MealPlan is a rolling, event-driven, opt-in suggestion layer.

Opt-in via plan settings (domain FactAttributes):

  plan_enabled:    true / false         — master toggle
  plan_window:     next_meal | day | week
  plan_reactivity: on_log | daily | manual

Default: plan_enabled: false. System doesn't assume user wants planning. Suggests opt-in after engagement builds: "You've been logging for a week. Want me to suggest meals?"

⸻

Rolling Suggestion Layer

When plan_enabled is true, the system maintains a rolling recommendation within the user's chosen window.

  Day 0 (user just set a goal):
    System knows: 1800 kcal, high protein, no eggs
    → Generates suggestions for next meal / today+tomorrow
    → Day View shows them as light suggestions

  Day 3 (system has some logs):
    System learns: user eats oats for breakfast, skips lunch often
    → Suggestions get smarter, match observed patterns

  Day 14 (user wants more structure):
    User: "Plan my whole week"
    → System extends rolling suggestion into a committed weekly MealPlan

Source and commitment:

  auto_suggested  — system generates from goal + patterns, always running
  user_requested  — user asked "plan tomorrow" or "plan my week"
  user_reviewed   — user explicitly reviewed and accepted

Day View rendering by commitment:
- committed → solid planned meal, strong [✓] [✎] [✗] buttons
- soft → regular suggestion, [✓] [✎] available
- suggestion → light recommendation ("we'd suggest..."), easily dismissed

⸻

Event-Driven Adaptation

MealPlan listens to events. Different events trigger different update scopes:

  Event                       Update scope        Why
  MealLog created             Next meal           Heavy lunch → lighter dinner
  MealLog skipped             Same day remaining  Skipped lunch → add protein to dinner
  MealLog high deviation      Rest of day         800 kcal over → evening adjusts
  Circumstance: traveling     All active slots    Switch to simpler meals
  Circumstance: sick          All active slots    Hydration + comfort food
  Goal revised                Full recompute      New targets → new plan
  Review generated            Next plan cycle     Pattern learning for future plans
  Food safety update          Affected slots only Allergen in recipe → swap that meal

Update threshold scales with commitment:
- suggestion slots → silently update (user never committed)
- soft slots → suggest change, show reason (user loosely committed)
- committed slots → flag as stale, ask before changing (user explicitly accepted)

Reactivity controls token spend:
- on_log — every log triggers update (most tokens, most adaptive)
- daily — batch recalculate once per day (moderate)
- manual — only when user explicitly asks (cheapest)

⸻

HP05a Surface for Plan Composition

When user explicitly builds or extends a plan, the composition surface opens:

Structure (top): the plan grid — days × meal slots, filling up. Shows nutrition totals per day and week.

Middle (contextual):
- Prose mode → assistant proposals ("Here's what I'd suggest for Monday")
- Structured mode → food search, recipe search, recent meals

User input (bottom):
- Prose: "Make it vegetarian, lots of protein, easy to cook"
- Structured: search → pick → assign to slot

Validation (HP05b):
- Allergen check across all planned items
- Caloric distribution (not all calories in one meal)
- Medical constraint compliance
- Weekly nutritional balance

⸻

Staleness Detection

context_snapshot enables: "Plan was built for travel. You're home now — rebuild?"

System compares current context against snapshot:
- Goal changed → stale
- Circumstance changed → stale
- FactAttributes changed (new allergen declared) → stale
- Significant preference shift observed → soft stale (suggest, don't push)

⸻

Known Concerns

1. Token cost of rolling suggestions. Even minimal windows have cost. Need to monitor and potentially throttle for free-tier users.

2. Suggestion quality at cold start. System has no patterns yet — early suggestions may feel generic. Need good default recipes/meals per cuisine preference.

3. Week view complexity. 21+ slots on a phone screen is hard to render. May need progressive disclosure (show today, peek at tomorrow, collapse rest).

4. Adaptation vs stability. If the plan changes every time the user logs, it feels unreliable. Need a stability threshold — small deviations don't trigger changes.

5. User trust in suggestions. "Why did you suggest paneer tikka?" — the system should be able to explain (matches protein target, you liked it last week, fits calorie budget).
