# Brainstorm: Slimmest PoC for the Core Eating Loop

## What I Understand

### The Core Eating Loop is a *behavioral* engine, not a nutrition engine

The `core-eating-loop.md` draws a very deliberate line: **this loop models behavior — not nutrition.** Nutrition can sit on top later. The three durable artifacts it produces are:

1. **Food Vocabulary** — what this person eats, what they call things, their defaults
2. **Meal Vocabulary** — when/why they eat, their occasions, time windows, typical bundles
3. **Eating Day Model** — what a full day looks like, expected occasions, gaps, timing

These are *personal behavioral models*, not nutritional assessments. The loop doesn't care about macros or calories. It cares about: *I know you usually have tea and toast around 8am, and you haven't logged anything yet today.*

### The 7-step loop is the entire engine

Log → Understand → Clarify (rare) → Learn Foods → Learn Occasions → Update Day Model → Reflect. Then wait.

The loop gets smarter with every log. Logging gets easier as the system learns the user. The product is **awareness** — a mirror of how you actually eat — not metrics, not compliance, not analytics.

### How this relates to the broader model (illustrations, not requirements)

The nutrition domain documents describe a *much* larger surface area:

| Broader model concept | Core Eating Loop equivalent | PoC relevance |
|---|---|---|
| MealLog artifact | The "Log" step — what the user ate | **Core** |
| Food / Recipe entities | Food Vocabulary — the user's personal food lexicon | **Core** |
| MealPlan artifact | Not present — the loop has no plan | **Out** |
| NutritionGoal | Not present — the loop has no goals | **Out** |
| NutritionReview | Not in this form — the "Reflect" step is ambient, not a structured review | **Partial** |
| Configuration (calorie targets, macro splits) | Not present — the loop doesn't track nutrition | **Out** |
| Events → Observations → Memories pipeline | Implicitly present — logs build vocabulary and day model over time | **Partial** |
| Policy (medical, emotional safety) | Not present at PoC scope — no recommendations, no compliance | **Out** |
| HP05a composition surface | One input mode needed — prose or structured, not both | **Slim** |
| Day View | A view of today's eating — occasions logged, gaps expected | **Core** |

> [!IMPORTANT]
> The Core Eating Loop is deliberately *upstream* of the nutrition engine. It's the behavioral substrate that nutrition, goals, plans, and reviews would eventually sit on top of. The PoC proves that this substrate can work.

---

## What the PoC Actually Needs to Prove

Three hypotheses, ordered by risk:

### Hypothesis 1: The system can learn a person's food vocabulary from natural language logs

Can a person say "had chai and paratha" and the system correctly resolve, store, and remember that for next time? Can it build a growing personal food lexicon where "chai" means *their* chai (milk tea, no sugar) and "paratha" means *their* paratha (aloo, ghee)?

**What this tests:** Prose → structure extraction reliability. Entity resolution. Personal food identity accumulation.

### Hypothesis 2: The system can learn eating occasions from repeated logs

After 5–7 days of logging, can the system correctly identify that this person has a "morning tea" around 7:30am, a "lunch" around 1pm (usually dal + rice), and a "late dinner" around 9:30pm? Can it notice the distinction between weekday and weekend patterns?

**What this tests:** Temporal pattern recognition. Occasion clustering. Meal vocabulary construction.

### Hypothesis 3: The system can form and use an Eating Day Model

Once the loop has run for a week, can the system know what a "normal day" looks like for this person, identify what's missing today, and offer a light mirror? Can it say "looks like your usual morning tea" or "lunch hasn't shown up yet"?

**What this tests:** Day model prediction. Gap detection. Ambient awareness that feels personal, not robotic.

---

## Scoping Decisions for the Slimmest PoC

### What's IN

| Concern | PoC Scope |
|---|---|
| **Input** | One mode only: prose. User types what they ate. No structured search, no plan-confirm, no photo. |
| **Entity resolution** | LLM resolves food items from prose. Builds a user-scoped food table. Matches against prior entries first. |
| **Occasion detection** | LLM infers which eating occasion this belongs to (breakfast, lunch, snack, etc.) based on time + content + user history. |
| **Day model** | System maintains a soft model of this user's typical eating day. Updates after each log. |
| **Reflection** | After each log, system offers one short ambient observation. Not a recommendation. Not a judgment. A mirror. |
| **Day view** | A simple chronological view of today: what's been logged, what occasions are expected but unlogged. |
| **Priors** | Generic 3-meal + optional snack template. Region hint if available. These dissolve as personal patterns emerge. |
| **Persistence** | Logs, food vocabulary, meal vocabulary, and day model persist across sessions. |

### What's OUT

| Concern | Why it's out |
|---|---|
| Nutrition data (calories, macros) | The loop is behavioral, not nutritional. No food composition DB needed. |
| Goals and targets | No compliance, no tracking against targets. |
| Meal plans | No planning surface. The loop is reactive (log what you ate), not proactive (here's what to eat). |
| Multiple input modes | No structured search, no plan-confirm, no photo, no voice. Prose only. |
| Policy enforcement | No medical safety, no emotional safety guardrails — because there are no recommendations to guard. |
| Reviews and analytics | No weekly summaries, no trend lines, no dashboards. Only ambient per-log reflections. |
| Onboarding flow | Cold start uses priors. No attribute collection, no goal setting. |
| Refinement / confidence bands | Log what you get. No "refine your portions" flow. |
| Multi-user / cross-domain | Single user, single domain. |

---

## The Sharpest Question: What's the *one user journey*?

The entire PoC is one journey, repeated:

```
User opens app → sees today (Day View: what's logged, what's expected)
    → taps "+ log" → types what they ate in prose
    → system resolves food items, infers occasion, updates vocabulary
    → system shows what it understood + one ambient reflection
    → user sees updated Day View
```

That's it. The loop runs every time the user logs. The system gets smarter every time. The Day View gets more personal every day.

---

## Open Tensions Worth Naming

### 1. Where does the LLM live?

The Core Eating Loop leans *heavily* on LLM judgment — prose extraction, occasion inference, day model reasoning, ambient reflection. In the broader architecture (HP01), the LLM fills content in hard shells and acts as judge in tool workflows.

For the PoC: **the LLM is the entire brain.** Every log is an LLM call that reads the user's accumulated context (food vocabulary, meal vocabulary, day model, today's logs so far) and produces structured output (resolved items, occasion, updated models, reflection).

> [!NOTE]
> This is the biggest cost-risk for the PoC. Every log = an LLM call with growing context. The question is whether this can be fast and cheap enough for a daily-use product, or whether deterministic shortcuts need to be built early.

### 2. Food vocabulary: LLM memory vs. structured DB?

Two approaches:

- **Structured DB** — food vocabulary is a table. Each food item has a canonical name, user aliases, typical quantities, frequency. LLM reads and writes to this table. Vocabulary is inspectable, editable, portable.

- **LLM memory** — food vocabulary lives in a growing context blob that the LLM reads each time. No explicit table. The LLM "remembers" by re-reading its own prior outputs.

The structured approach aligns with HP01 (entity/memory-first architecture). The LLM memory approach is faster to prototype but fragile (context windows, drift, no editability).

**PoC tension:** Structured is more work but the one the broader model assumes. LLM memory is faster but won't scale.

### 3. Eating Day Model: Who computes it?

The day model could be:

- **LLM-computed** — after each log, the LLM reads all historical logs and re-derives "what a normal day looks like." Pure judgment.
- **Deterministically computed** — a report pipeline (HP02-style) aggregates logs into patterns (meal frequency by time, food co-occurrence), and the LLM reads these computed metrics.
- **Hybrid** — deterministic aggregation for quantitative patterns, LLM for qualitative interpretation.

For the PoC, pure LLM-computed is simplest. But context window and cost scale linearly with history. A week is fine. A month may not be.

### 4. How much "priors" matter at cold start

The doc says "on Day 0, the system is not blind" — it starts with a generic 3-meal template and region-based food language hints. In the PoC, how rich are these priors?

- **Minimal prior:** 3 empty slots (breakfast, lunch, dinner) with generic times. No food hints.
- **Regional prior:** If we know the user is in India, pre-load common Indian food names, typical meal structures, regional patterns.

Regional priors make the first few days feel magical ("it already knows chai and paratha!"). But they're a content investment.

### 5. "Reflect" — what does the mirror actually say?

The doc gives examples: "Looks like your usual morning tea." / "Lunch hasn't shown up yet — did it happen?" / "Evenings seem more fluid than mornings."

This is the **product differentiator.** If reflections feel robotic or generic ("You logged 3 meals today"), the loop has no soul. If they feel personal and warm, the product clicks.

The quality of reflection depends entirely on the LLM prompt + how much personal context it has. Early logs (days 1–3) will have thin context → thin reflections. The PoC needs to show the *trajectory* — reflections getting richer as context accumulates.

---

## The Minimum Stack

If I were to think about what the slimmest technical stack looks like (without locking anything):

| Layer | Simplest option |
|---|---|
| **Client** | A single-page app with two views: Day View + Log input |
| **Backend** | A single API endpoint: POST /log (prose in, structured response out) |
| **LLM** | One prompt per log — reads user context, parses prose, returns structured output + reflection |
| **Storage** | Three tables: `meal_logs`, `food_vocabulary`, `eating_day_model`. Could start as flat JSON. |
| **Day model computation** | Recomputed on every log from full history. No separate pipeline. |

The entire backend could be one LLM call with carefully composed context. The "system" at PoC stage is basically: **a client that shows the day + a prompt that does all the thinking.**

---

## One-Line Summary

The Core Eating Loop PoC is: *a prose-based meal logger that gets smarter with every log — learning what you eat, when you eat it, and what your eating day looks like — and mirrors that understanding back to you without ever counting a calorie.*
