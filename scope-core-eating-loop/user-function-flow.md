# User-Function Flow

What the user sees, when, and which functions fire behind each moment.

---

## Flow 1: Log (user types and hits send)

```
User sees:
  ✓ Logged: chai (1), paratha (1)
  🌤 Lunch?  also: late breakfast
  chai → ginger tea  also: milk tea · masala chai
  paratha → aloo  also: stuffed · plain
  [✓ Looks right]  [milk tea]  [masala]  [✎ Fix]

Functions behind this:
  CAPTURE_MEAL_ITEMS     → creates meal_items (capture columns)
  ASSUME_FOOD            → creates/matches food_items, best + alternates
  ASSUME_MEAL_OCCASION   → occasion best + alternates

All three fire on log_msg. Status on everything: assumed.
```

---

## Flow 2: Clarify (user accepts, picks alternate, corrects, or ignores)

**Accepts:**

```
User taps [✓ Looks right]

User sees:
  ✓ Logged · 🌤 Lunch
  chai (ginger tea, 1) · paratha (aloo, 1)
  "Afternoon fuel — noted."

Functions:
  RESOLVE_ASSUMPTION  → status: assumed → accepted
  LEARN_FOOD          → reconciles food_items
```

**Picks alternate:**

```
User taps [milk tea]

User sees:
  ✓ Logged · 🌤 Lunch
  chai (milk tea, 1) · paratha (aloo, 1)
  "Different chai today — noted."

Functions:
  RESOLVE_ASSUMPTION  → status: assumed → corrected
                         milk tea becomes best, ginger tea becomes alt
  LEARN_FOOD          → reconciles food_items
```

One tap. No typing. The right answer was already in the alternates.

**Corrects (free text):**

```
User taps [✎ Fix], types "jaggery tea"

User sees:
  ✓ Logged · 🌤 Lunch
  chai (jaggery tea, 1) · paratha (aloo, 1)
  "Something new — jaggery tea noted."

Functions:
  RESOLVE_ASSUMPTION  → status: assumed → corrected
                         new food_item "jaggery tea" created
  LEARN_FOOD          → reconciles + adds new variant
```

**Ignores:**

```
User closes app / navigates away

Nothing fires. Status stays assumed.
REEVALUATE_ASSUMPTIONS revisits later.
```

**Lazy resolution (past logs):**

```
User opens day view, taps on an old log from Day 2

User sees:
  Day 2, 8:15am
  chai (1)
  → ginger tea (assumed)
  also: milk tea · masala chai
  [ginger tea ✓]  [milk tea]  [✎]

User taps [ginger tea ✓] → confirmed

Functions:
  RESOLVE_ASSUMPTION → status: assumed → accepted
  LEARN_FOOD         → reconciles
```

---

## Flow 3: Day View (user opens app)

**Day 1:**

```
  ☀ Breakfast · logged — chai, paratha
  🌤 Lunch · expected ~1pm
  🌙 Dinner · expected ~8pm

Function: SUGGEST_EATING_DAY
```

**Day 1 (evening, missed lunch):**

```
  ☀ Breakfast · logged — chai, paratha
  🌤 Lunch · not logged — "didn't show up today"
  🌙 Dinner · logged — roti, sabji

Function: SUGGEST_EATING_DAY
```

**Day 7 (system knows you):**

```
  ☀ Breakfast · logged — chai (ginger tea), paratha
    "Your usual — 5th day in a row."
  🌤 Lunch · expected ~1:30pm — usually: dal, rice
  🍪 Evening chai · expected ~4pm — usually: chai, biscuit
  🌙 Dinner · expected ~9pm — more varied

Function: SUGGEST_EATING_DAY
  Most meal_items are inferred or accepted by now.
```

---

## Background (no user interaction)

```
REEVALUATE_ASSUMPTIONS
  walks assumed meal_items
  promotes to inferred when pattern supports
  may swap best ↔ alternate
  triggers LEARN_FOOD

User sees: nothing directly.
Effect: next SUGGEST_EATING_DAY is more confident.
```

---

## Functions × Flows

| Function | Log | Clarify | Day View | Background |
|---|---|---|---|---|
| CAPTURE_MEAL_ITEMS | ✦ | | | |
| ASSUME_FOOD | ✦ | | | |
| ASSUME_MEAL_OCCASION | ✦ | | | |
| RESOLVE_ASSUMPTION | | ✦ | | |
| LEARN_FOOD | | ✦ | | ✦ |
| REEVALUATE_ASSUMPTIONS | | | | ✦ |
| SUGGEST_EATING_DAY | | | ✦ | |

---

## Three Screens

| Screen | Content | Functions |
|---|---|---|
| Day View | logged meals, expected, gaps, reflection | SUGGEST_EATING_DAY |
| Log Input | text field → parsed items | CAPTURE_MEAL_ITEMS |
| Suggestion Review | best + alternates, accept/pick/fix | ASSUME_FOOD, ASSUME_MEAL_OCCASION, RESOLVE_ASSUMPTION |
