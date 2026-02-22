Log a Meal

Problem statement and invariants. No solution proposals.

⸻

The Problem

A user ate something. They want to tell the system what they ate so the system can track it and reason about it. This is the most frequent interaction in the nutrition domain and the highest-friction moment — if this is hard, the user stops using the system.

The challenge: people eat at wildly different levels of awareness. Some weigh food on a scale. Some say "I had lunch." Most are somewhere in between and vary day to day. The system must accept all of these and extract maximum value from whatever it gets.

⸻

What Makes This Hard

1. Input granularity varies per occasion, not per user. The same person weighs their protein shake and eyeballs their office lunch. The system can't assume a fixed granularity.

2. Prose is the natural input for most people. But prose is ambiguous. "I had some rice" — what kind? How much? When? The system must resolve these without interrogating the user.

3. The user may or may not have a plan. If they do, the plan provides context that makes logging easier (confirm vs declare). If they don't, the system has zero context.

4. Timing is variable. People log in the moment, or at the end of the day, or the next morning. The system must handle all these patterns.

5. Quantity estimation is hard. "1 bowl" means different things to different people. The system needs a resolved quantity but the user thinks in subjective units.

6. Entity resolution is ambiguous. "Poha" is clean. "That rice thing" is not. Multiple foods might match. User-created foods have no global reference.

7. Multi-item meals are common. "Had dal rice and salad" is three foods in one sentence. Each needs independent resolution.

8. Corrections happen. "Actually it was pasta not rice." The system must allow this without losing the original.

9. The user's motivation to log decays over time. Early enthusiasm → routine → fatigue. The input surface must survive this decay by being progressively easier, not progressively harder.

⸻

Data Invariants

- One MealLog per eating occasion
- date required, time optional, meal_type optional
- display_name and computed_nutrition copied at log time (snapshot, immutable)
- Safety flags resolve live from user_food_ref (sole exception to copy-everywhere)
- user_food_ref always user-scoped (never global IDs)
- Past MealLogs never propagate — immutable historical record
- plan_ref links to active MealPlan's meal slot if plan exists

⸻

Confidence Invariants

- Per-item confidence (0.0–1.0)
- Overall log confidence derived from item confidences
- initial_confidence preserved — tracks refinement distance
- Confidence bands: 0.95 (precise), 0.8 (serving), 0.5-0.7 (qualitative), 0.3 (binary)
- Confidence drives downstream language — below 0.7, reports use approximate language

⸻

Input Mode Invariants

- All input modes produce the same MealLog schema
- Source field captures which mode was used
- 5 modes: structured_input, plan_confirmed, plan_modified, prose_extracted, binary_checkin
- Prose input gets entity resolution: user table → global catalog → create standalone
- raw_input preserved for prose logs
- resolved_quantity/resolved_unit alongside user's declared quantity/unit

⸻

Refinement Invariants

- Upward granularity only — add detail, never remove
- Corrections allowed — original noted
- Refinement updates confidence, preserves initial_confidence
- last_refined_at tracked

⸻

Input Surface Invariants

- Accept any granularity — never reject for insufficient detail
- Never block on missing detail — log what you get, mark confidence
- Confidence reflects input quality, not user quality
- Refinement available, never forced
- One surface, multiple input modes — surface adapts to what user does
- tracking_granularity sets the default presentation, not the capability
- Plan-aware when plan exists, functional without plan
- System does the work — user declares, system resolves, estimates, and assigns confidence

⸻

Open Questions (to resolve during design)

- Plan-modified: how does "ate this but with changes" work?
- Binary on empty slot: how does "I ate but won't say what" surface?
- Time: is it when they logged or when they ate? Who decides?
- Multiple occasions per slot: "oats at 7am + smoothie at 10am" — one MealLog or two?
- Food without occasion: how does unslotted logging relate to slotted logging?
- Cross-day: midnight eating — today or tomorrow?
- Logging decay: how does the surface get easier over time, not harder?
