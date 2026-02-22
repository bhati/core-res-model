MealLog

The load-bearing artifact of the nutrition domain. Everything downstream (reports, observations, reviews, patterns) depends on MealLog data quality. One per eating occasion.

⸻

Schema

- id
- user_id
- date
- time (optional — null for unstructured logs like "had some almonds today")
- meal_type (optional — breakfast / lunch / dinner / snack / null)
- items: [
    {
      user_food_ref,                  ← identity reference (user-local)
      display_name,                    ← copied (snapshot, never changes)
      quantity, unit,                  ← as declared by user ("1 bowl", "200g", "some")
      resolved_quantity, resolved_unit, ← system's best estimate in standard units
      preparation,                     ← optional (grilled, fried, raw)
      computed_nutrition: { kcal, protein, carbs, fat },  ← copied at log time
      confidence                       ← per-item: 0.0-1.0
    }
  ]
- plan_ref (if plan active — links to planned meal for comparison)
- context (optional prose: "ate out", "craving", "cooked at home", "skipped")
- skipped (boolean — explicit declaration of not eating)
- source (structured_input / plan_confirmed / plan_modified / prose_extracted / binary_checkin)
- raw_input (preserved if prose — "had dal rice and salad for lunch")
- confidence (overall log confidence — min or avg of item confidences)
- initial_confidence (what confidence was at first log — for refinement tracking)
- last_refined_at (timestamp of last refinement, null if never refined)

⸻

Input Modes

All modes produce the same MealLog schema. Source field captures which mode was used.

Structured: user picks food from list, enters quantity. No LLM needed. Confidence: 0.9-0.95.
Plan-confirmed: user confirms planned meal with one tap. Items copied from active MealPlan. Confidence: 0.8.
Plan-modified: user starts from plan, swaps/adjusts items. Confidence: 0.8-0.85.
Prose-extracted: user types natural language. LLM extracts items + entity resolution. Confidence: 0.5-0.7.
Binary check-in: "I had breakfast." No items, no detail. Confidence: 0.3.

⸻

Granularity Spectrum

Granularity is per-entry, not per-user. The tracking_granularity config sets the default logging surface, but any log can be at any level.

Precise: quantity in grams, weighed. Confidence: 0.95. Athletes, medical tracking.
Serving-based: standard servings ("1 bowl", "2 rotis"). Confidence: 0.8. Most users.
Qualitative: natural language, estimated portions ("big plate of dal rice"). Confidence: 0.5-0.7.
Binary: existence only ("had lunch"). Confidence: 0.3. Behavioral tracking.
Food without occasion: food specified, no meal_type or time ("had some almonds"). Confidence: 0.5.

Reports and observations treat confidence as signal — estimates get "~" prefix, behavioral language ("your protein looks low" vs "your protein is 52% below target").

⸻

Refinement

Logs can be refined upward in granularity after initial creation.

Rules:
- Add detail (binary → items, missing time → specific time) → always allowed
- Change substance ("actually had pasta not dal") → correction, original noted
- Downgrade → not applicable
- Refinement updates confidence, preserves initial_confidence for tracking

Example flow:
12:30 PM log: "had lunch" → binary, confidence: 0.3
 8:00 PM refine: adds "dal rice and roti" → confidence: 0.65, initial_confidence: 0.3

⸻

Skipped Meals

Explicit declaration of not eating. Distinct from "no log exists" (which could mean forgot to log).

MealLog { meal_type: lunch, skipped: true, items: [], confidence: 1.0, source: manual_entry }

Skipped meals are valuable signal for the report engine — fasting patterns, irregular eating, etc.

⸻

Plan Comparison

plan_ref links to the active MealPlan's corresponding meal slot. Enables:
- Adherence tracking (planned vs actual)
- Deviation detection (swapped foods, different portions)
- Report: "you followed your plan 4/7 days this week"

If no plan active, plan_ref is null. Comparison is downstream (report engine), not stored in MealLog.

Safety: allergen and safety flags always resolve live from user_food_ref.
