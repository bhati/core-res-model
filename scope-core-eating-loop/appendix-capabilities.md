# Atomic Capabilities — Nuances

Brainstorm: edge cases, design decisions, and subtleties per capability.

---

## 1. parse_foods

**Core question: is the token a canonical food or a variant dish?**

- "chicken" → canonical ingredient
- "butter chicken" → prepared dish (specific)
- "mom's chicken curry" → personal dish name (very specific)

All three are valid food tokens. The parser shouldn't normalize — it should preserve what the user said. "butter chicken" ≠ "chicken". Resolution (capability #3) handles identity later.

**Compound items:**
- "chole bhature" — one dish or two items (chole + bhature)? Keep as one token when named as a unit. If user says "chole and bhature" → two tokens.
- "dal rice" — depends on phrasing. "dal rice" = one token (a combo). "dal and rice" = two tokens.

**Adjectives — which ones are part of the food?**
- "fried egg" → "fried" matters — different food than "boiled egg"
- "cold coffee" → "cold" matters — different drink
- "quick lunch" → "quick" is noise
- Rule: adjective is part of the token if it changes what the food IS. Discard if it describes the occasion.

**Preparation as identity:**
- "grilled paneer" vs "fried paneer" — these are different foods for behavioral tracking
- Preserve the preparation method as part of the token

**Brand names / cultural shorthand:**
- "Maggi" = instant noodles (India-specific)
- "Bournvita" = chocolate milk drink
- These should parse as food tokens. Food priors (capability #5) need to know these.

**Negation and exclusion:**
- "had everything except the salad" — hard to parse. Punt: extract what's mentioned positively.
- "didn't eat lunch" — not a food log. This is a skip signal for infer_occasion or detect_gaps.

**Non-food noise:**
- "had coffee at Starbucks with Rahul" → extract "coffee", discard "Starbucks" and "Rahul"
- "grabbed a quick bite — samosa and chai before the meeting" → extract "samosa", "chai"

---

## 2. estimate_quantity

**Default: 1 standard serving.**

When the user doesn't specify quantity, the system assumes 1 serving. Not 100g. Not a calculated portion. One normal-sized serving of that food.

**What is a "serving"?** Context-dependent, not universal.
- 1 serving of dal ≈ 1 bowl / 1 katori
- 1 serving of rice ≈ 1 plate-worth
- 1 serving of roti = 1 roti
- Priors can seed typical serving definitions. User corrections refine them.

**Explicit quantity types:**
- Count: "2 rotis", "3 eggs"
- Container: "a bowl of dal", "a glass of milk", "a plate of rice"
- Relative: "some dal", "a bit of pickle", "lots of rice"
- Measured: "200ml milk", "a cup of curd" (rare in casual logging)

**What to store:**
- Store the user's phrasing: "a bowl" not "250ml"
- Store the estimated standard quantity alongside: { user_said: "a bowl", resolved: "1 serving" }
- Don't invent precision. "a bowl of dal" → "1 serving" is fine. "a bowl of dal" → "237ml" is false precision.

**"A little" / "a lot":**
- These are qualifiers, not quantities. Store as qualifier, not as multiplier.
- "a little pickle" → { qty: 1, qualifier: "small" }
- "lots of rice" → { qty: 1, qualifier: "large" }
- This matters later for food vocabulary defaults — if user always says "lots of rice", their standard serving of rice is bigger.

---

## 3. resolve_food_identity

**Matching hierarchy:**
1. User's own food vocabulary (strongest match)
2. Food priors (regional knowledge)
3. Create new entry (last resort)

**False-new is the main failure mode.** If the user has logged "chai" 10 times, and the system creates a new entry for "chai" on log 11, that's a vocabulary failure.

**Alias handling:**
- "chai" = "morning tea" = "adrak chai" — different names, same food for this user
- Aliases are user-scoped. "chai" for user A might be milk tea. For user B, green tea.
- How to detect alias: user corrects "this is the same as my chai" → alias registered

**Variant handling:**
- "paneer tikka" logged previously. Now "paneer tikka masala" — new food or same?
- Default: treat as new unless user merges. Better to over-split than under-merge.
- Over time, the system could suggest: "is paneer tikka masala the same as your paneer tikka?"

**Personal identity vs canonical knowledge:**
- System might know "chai" = tea from food_priors
- But this user's chai = ginger tea with jaggery, no sugar, 1 cup
- The food identity is USER-scoped. The canonical knowledge (priors) is just the starting point.

**What gets stored per food entry?**
- display_name (what the user calls it)
- aliases (other names they've used)
- default_quantity (their typical serving, refined over time)
- frequency (how often it appears)
- co_occurrences (what it typically appears with)

---

## 4. infer_occasion

**Three signals, weighted:**
1. **Explicit in prose:** "had lunch" → user said it, use it directly
2. **Time-based:** 1pm → probably lunch (from occasion_priors or meal vocabulary)
3. **Content-based:** "oats and coffee" → probably breakfast regardless of time

**Priority: explicit > time + content combined.**

**User rhythm vs generic rhythm:**
- Generic: breakfast 7–9am, lunch 12–2pm, dinner 7–9pm
- This user: breakfast at 10am, lunch at 3pm, dinner at 10pm
- By day 7, the system should use the user's rhythm, not the generic one.

**Edge cases:**
- No time provided: infer from content + what's already been logged today
- Late logging: "logging yesterday's dinner" — occasion is dinner, time is yesterday evening
- Multiple items across occasions: "had oats this morning and then pizza for lunch" — two logs? Or one log with occasion ambiguity?
- "Snack" as catch-all: food that doesn't fit a major meal → assign to nearest snack slot or create "unslotted"

**What gets stored:**
- occasion_label (breakfast, morning_snack, lunch, afternoon_snack, dinner, late_night, unslotted)
- inferred_from (explicit / time / content / combined)
- confidence (high if explicit, lower if inferred)

---

## 5. food_priors

**What's in a prior set?**
- Common food names for the region (chai, roti, dal, rice, paneer, dosa, idli…)
- Common aliases (roti = chapati = phulka)
- Brand names as food (Maggi, Bournvita, Amul butter)
- Typical serving sizes (1 roti, 1 bowl dal, 1 cup chai)
- Common combinations (chai + biscuit, dal + rice, idli + sambar)

**Granularity question:**
- Do priors include "chicken" or "butter chicken" or both?
- Both — canonical ingredients AND common prepared dishes
- But keep the list manageable. 100–200 items per region, not 2000.

**How priors dissolve:**
- On day 1, resolve_food_identity leans heavily on priors
- As user logs accumulate, food vocabulary takes over
- Prior entries that never match any user log become irrelevant — they don't need to be deleted, they just stop being useful

**Regional prior sets — how many to start?**
- PoC: one (Indian, likely North Indian). Expand later.
- Or: let the LLM's general food knowledge BE the prior, no curated list needed
- Tension: curated priors are more reliable but need manual work. LLM knowledge is broad but may not know "Maggi" = instant noodles in India.

---

## 6. occasion_priors

**Default template:**
- Breakfast (~7–10am)
- Lunch (~12–2pm)
- Dinner (~7–10pm)
- Optional: morning snack, afternoon snack, late night

**How many slots?**
- Start with 3 core + 2 optional = 5
- User's actual pattern may have fewer (2 meals + 1 snack) or more (6 small meals)
- Priors are scaffolding — they should feel reasonable, not imposing

**Time windows — how wide?**
- Wide enough to not misclassify: if breakfast window is 7–9am and user eats at 9:30, don't call it "morning snack"
- Start wide (3-hour windows), narrow as user data arrives

**What if user's culture doesn't fit 3-meal model?**
- Some users eat 2 meals + chai times
- Some fast and eat in windows
- Priors should be loose enough that learn_occasion can reshape them quickly

---

## 7. day_model_priors

**How this differs from occasion_priors:**
- occasion_priors = what meals exist and when they typically happen
- day_model_priors = what a full day looks like in sequence

Occasion priors say "breakfast exists." Day model priors say "a typical day has breakfast → lunch → dinner, in that order, with approximate gaps."

**What a generic day shape contains:**
- Expected occasion sequence: [breakfast, lunch, dinner]
- Expected time spacing: ~4–6 hours between meals
- Expected total occasions per day: 3–5

**This matters for detect_gaps:**
- At 3pm, if breakfast and lunch are logged, the day model knows dinner is expected around 8pm → no gap yet
- At 10pm, if only breakfast is logged, the day model flags lunch and dinner as gaps

**How it dissolves:**
- After 5–7 days, the system should know THIS user's day shape
- Weekend vs weekday distinction may emerge
- Some users are very consistent (same shape daily), some are chaotic (different every day) — the day model should represent both

---

## 8. learn_food

**What triggers a vocabulary update?**
- New food → create entry
- Known food with new name → register alias
- Known food with different quantity → adjust default
- Two foods logged together repeatedly → record co-occurrence

**When to merge vs keep separate:**
- "chai" and "chai with ginger" — merge (alias) or separate (variant)?
- Default: separate unless user explicitly merges
- Heuristic: if the user switches between names interchangeably for the same occasion, likely alias. If they tend to use one at breakfast and another at evening, likely different variants.

**Default quantity refinement:**
- User logs "chai" 5 times. First 3 say "1 cup", then "2 cups", then "1 cup"
- Default → 1 cup (mode, not average)
- If user never specifies quantity, default stays at "1 serving" — don't guess

**Co-occurrence:**
- chai + biscuit logged together 4 out of 5 times → strong co-occurrence
- Useful for: future suggestions, parse assistance ("had my usual chai" → system auto-suggests biscuit)
- PoC scope: store co-occurrence, don't act on it yet

**Signal strength from user action on suggestion:**
- User accepted suggestion → medium confidence update
- User corrected → high confidence, exact update
- User ignored → food was logged (tier 1), but identity is low confidence — still update vocabulary but with lower weight

---

## 9. learn_occasion

**Strengthening:**
- User logs breakfast at 8:15am, 8:30am, 7:45am, 8:00am → breakfast window tightens to 7:45–8:30am
- Confidence increases with repetition

**Emerging occasions:**
- User logs "post-gym snack" at 6pm three times → new occasion slot emerges
- Threshold: how many times before the system recognizes a new occasion? 3? 5?
- Should the system ASK ("Looks like you regularly eat after the gym. Want me to track this as its own meal?") or just silently create the slot?

**Typical food bundles per occasion:**
- Breakfast: oats + coffee (80% of the time), eggs + toast (20%)
- This is powerful for future suggestions and for reflection ("your usual oats + coffee")

**Weekday vs weekend:**
- Breakfast at 8am Mon–Fri, 10:30am Sat–Sun → two patterns for same occasion?
- PoC: don't split yet. Track all times. If the variance is too high, it may need weekend/weekday split later.

**Occasion label evolution:**
- System started with prior "Breakfast." User often says "morning chai" instead. Should the label adapt?
- Probably yes — display the user's language, not the system's

---

## 10. learn_day_shape

**How many days to form a model?**
- 3 days: very rough shape (fragile)
- 5 days: reasonable pattern (okay)
- 7 days: one full week (solid, includes weekend)
- PoC benchmark: the day model should be meaningfully personal by day 7

**What constitutes a "normal" day?**
- Mode over median — what happens MOST days, not the average
- If user eats 3 meals 5 days and 2 meals 2 days, normal = 3 meals

**Outlier handling:**
- Sick day, travel day, celebration → these shouldn't distort the model
- But how does the system know it's an outlier on day 3? It doesn't have enough data.
- Solution: don't try to exclude outliers early. Let the model settle. Outliers wash out as more data arrives.

**What the model outputs:**
- Expected occasions for a day (ordered list with time windows)
- Confidence per occasion (how stable is this pattern?)
- Which occasions are highly predictable (breakfast) vs fluid (snacks)

---

## 11. compute_today

**Straightforward assembly — but nuances exist:**

- Logs without occasion: where do they go? Show in an "other" bucket?
- Low-confidence logs (user ignored suggestion): include but mark as approximate?
- Multiple logs for same occasion: "had oats at 8" then "also had coffee at 8:15" — same occasion? Merge or keep separate?
- Logs from yesterday corrected today: exclude from today's state

**What "today's state" contains:**
- List of logged occasions with items + time
- List of unlogged expected occasions (from day model)
- Time of last log
- Current gap status (hours since last food)

---

## 12. detect_gaps

**Gap vs not-yet:**
- At 10am, dinner hasn't happened → not a gap, it hasn't been expected yet
- At 10pm, lunch wasn't logged → real gap (or the user skipped it)
- The system needs to distinguish "hasn't happened yet" from "was expected and didn't happen"

**How to decide:**
- If current time is before the occasion's expected time window → not yet
- If current time is past the occasion's window + buffer → gap
- Buffer: how long past the window before it's flagged? 1 hour? 2?

**Consistently skipped occasions:**
- User never eats afternoon snack → stop flagging it as a gap
- This means detect_gaps reads day model, which should reflect that this user doesn't have an afternoon snack
- learn_day_shape is responsible for removing this from the model

**What a gap produces:**
- Occasion label + expected time window + "not logged"
- NOT a prompt or a nag. Just a data point for the day view and for generate_reflection.

---

## 13. generate_reflection

**Types of reflection:**
- **Recognition:** "Looks like your usual morning tea." — I know your pattern.
- **Observation:** "Lunch hasn't shown up today." — I notice what's missing.
- **Pattern:** "Your evenings seem more fluid than mornings." — I see trends.
- **Novelty:** "First time logging pasta — something new?" — I notice change.

**Tone: mirror, not judge.**
- "You logged 3 meals" → worthless, robotic
- "Solid chai-and-paratha morning" → warm, personal
- "You missed lunch again" → judgmental, bad
- "Lunch hasn't appeared yet — did it happen?" → neutral, caring

**Cold start (day 1–3):**
- Not enough context for personal reflection
- Fall back to light acknowledgment: "Got it — chai and paratha noted."
- Or gentle curiosity: "Is this a typical breakfast for you?"
- Never fake familiarity. Don't say "your usual" on day 1.

**Repetition avoidance:**
- If user logs breakfast every day at 8am, don't say "your usual breakfast" every single time
- Vary: sometimes recognition, sometimes silence (no reflection), sometimes a novelty observation
- Track what was said recently — don't repeat the same type within 3 logs

**When NOT to reflect:**
- Sometimes the best reflection is none. User logged quickly, doesn't want commentary.
- Reflection should feel like a bonus, not a toll booth.

**What about multi-log reflections?**
- After 3rd log of the day, reflection can be about the day so far, not just this log
- "Consistent day so far — breakfast, lunch, and an afternoon snack."
- End-of-day reflection (if user returns): "Full day logged — 3 meals, one snack."
