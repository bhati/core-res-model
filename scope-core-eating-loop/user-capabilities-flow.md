# User-Capabilities Flow

How the 13 atomic capabilities cluster behind the three user-visible flows.

---

## Flow 1: Log (user types and hits send)

```
User sees: "✓ Logged: chai (1), paratha (1)"
           "☀ Breakfast? · chai → milk tea · paratha → aloo"

┌─ CAPTURE ──────────────────┐  ┌─ SUGGEST ──────────────┐
│ ① parse_foods              │  │ ③ resolve_food_identity│
│ ② estimate_quantity        │  │ ④ infer_occasion       │
└────────────────────────────┘  └────────────────────────┘

Context read:
⑤ food_priors (day 1)  ──▶ helps ① and ③
⑥ occasion_priors (day 1) ──▶ helps ④
🗄 Food Vocabulary (day 2+) ──▶ helps ③
🗄 Meal Vocabulary (day 2+) ──▶ helps ④
```

---

## Flow 2: Clarify (user accepts, corrects, or ignores)

```
User sees: confirmed log + reflection sentence

┌─ LEARN (invisible) ────────────────────────────────────┐
│ ⑧ learn_food         (fires always — from capture)     │
│ ⑨ learn_occasion     (fires from accept/correct/pattern)│
│ ⑩ learn_day_shape    (fires from both vocabs)          │
└────────────────────────────────────────────────────────┘

┌─ REFLECT (visible) ───────────────────────────────────┐
│ ⑬ generate_reflection                                 │
│    reads: today's state + food vocab + meal vocab +    │
│           day model                                    │
└───────────────────────────────────────────────────────┘
```

---

## Flow 3: Day View (user opens app or returns)

```
User sees: today's meals, expected slots, gaps, reflection

┌─ AWARENESS ────────────────────────────────────────────┐
│ ⑪ compute_today      (assemble today from raw logs)    │
│ ⑫ detect_gaps        (compare today vs day model)      │
└────────────────────────────────────────────────────────┘

Context read:
⑦ day_model_priors (day 1) ──▶ seeds detect_gaps
🗄 Eating Day Model (day 2+) ──▶ powers detect_gaps
🗄 Meal Vocabulary ──▶ labels and expected slots

Also renders:
⑬ generate_reflection (if not already shown post-log)
```

---

## Capability Clusters

| Cluster | Capabilities | Fires when | User sees |
|---|---|---|---|
| Capture | ①② | user sends log_msg | logged items |
| Suggest | ③④ | user sends log_msg | suggested identity + occasion |
| Priors | ⑤⑥⑦ | day 1 context, pre-loaded | nothing directly |
| Learn | ⑧⑨⑩ | after log + clarification | nothing directly |
| Awareness | ⑪⑫ | user opens day view | today's state + gaps |
| Reflect | ⑬ | after clarification or on day view | one ambient sentence |

Six clusters. Three user-visible (capture, suggest, awareness+reflect). Three invisible (priors, learn).

---

## User-Visible Flows (what user sees, when)

### Log Flow

```
USER opens app
  ▼
Day View: logged meals, expected meals, gaps
  ▼
USER taps [+ log], types: "had chai and paratha"
  ▼
Immediately sees:
  ✓ Logged: chai (1), paratha (1)           ← CAPTURE
  ☀ Breakfast?                               ← SUGGEST
  chai → milk tea · paratha → aloo paratha   ← SUGGEST
  [✓ Looks right]  [✎ Fix]
```

### Clarify Flow

```
Accepts:
  USER taps [✓ Looks right]
  ▼
  Confirmed: ☀ Breakfast · chai (milk tea, 1) · paratha (aloo, 1)
  "Solid morning start."  ← REFLECT
  ▼
  Returns to Day View

Corrects:
  USER taps [✎ Fix]
  ▼
  Editable: occasion [Snack ▾], food items [change ▾]
  USER changes occasion to Snack, taps [Done]
  ▼
  Confirmed: 🍪 Snack · chai (milk tea, 1) · paratha (stuffed, 1)
  "Afternoon chai — noted."  ← REFLECT

Ignores:
  USER closes app / navigates away
  ▼
  Log is stored. Suggestions stay unresolved.
  System learns from patterns later.
```

### Day View Flow

**Day 1 (one log):**

```
  ☀ Breakfast · logged — chai, paratha
  🌤 Lunch · expected ~1pm
  🌙 Dinner · expected ~8pm
```

**Day 1 (evening, missed lunch):**

```
  ☀ Breakfast · logged — chai, paratha
  🌤 Lunch · not logged — "didn't show up today"
  🌙 Dinner · logged — roti, sabji
```

**Day 7 (system knows you):**

```
  ☀ Breakfast · logged — chai, paratha
    "Your usual — 5th day in a row."
  🌤 Lunch · expected ~1:30pm — usually: dal, rice
  🍪 Evening chai · expected ~4pm — usually: chai, biscuit
  🌙 Dinner · expected ~9pm — more varied
```
