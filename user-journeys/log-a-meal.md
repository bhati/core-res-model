Log a Meal

⸻

Part 1: Problem Statement

A user ate something. They want to tell the system what they ate so the system can track it and reason about it. This is the most frequent interaction in the nutrition domain and the highest-friction moment — if this is hard, the user stops using the system.

The challenge: people eat at wildly different levels of awareness. Some weigh food on a scale. Some say "I had lunch." Most are somewhere in between and vary day to day. The system must accept all of these and extract maximum value from whatever it gets.

⸻

What Makes This Hard

1. Input granularity varies per occasion, not per user.
2. Prose is natural but ambiguous — system must resolve without interrogating.
3. User may or may not have a plan — surface must work both ways.
4. Timing is variable — in-moment, end-of-day, next morning.
5. Quantity estimation is hard — "1 bowl" is subjective.
6. Entity resolution is ambiguous — "that rice thing" needs resolution.
7. Multi-item meals are common — each item needs independent resolution.
8. Corrections happen — "actually it was pasta not rice."
9. Motivation to log decays — surface must get easier, not harder, over time.

⸻

Invariants

Data:
- One MealLog per eating occasion
- date required, time optional, meal_type optional
- display_name and computed_nutrition copied at log time (immutable snapshot)
- Safety flags resolve live from user_food_ref (sole exception)
- user_food_ref always user-scoped
- Past MealLogs never propagate
- plan_ref links to active MealPlan's meal slot if plan exists

Confidence:
- Per-item confidence (0.0–1.0), overall derived from items
- initial_confidence preserved — tracks refinement distance
- Bands: 0.95 (precise), 0.8 (serving), 0.5-0.7 (qualitative), 0.3 (binary)
- Below 0.7 → downstream reports use approximate language

Input modes:
- All modes produce the same MealLog schema
- Source field captures which mode
- 5 modes: structured_input, plan_confirmed, plan_modified, prose_extracted, binary_checkin
- Prose → entity resolution: user table → global → create standalone
- raw_input preserved, resolved_quantity alongside user quantity

Refinement:
- Upward granularity only
- Corrections allowed, original noted
- Preserves initial_confidence, tracks last_refined_at

Input surface:
- Accept any granularity — never reject for insufficient detail
- Never block on missing detail — log what you get, mark confidence
- Confidence reflects input quality, not user quality
- Refinement available, never forced
- tracking_granularity sets default, not capability
- Plan-aware when plan exists, functional without plan
- System does the work — user declares, system resolves

⸻

Part 2: Proposal

Two dimensions define the input model:

Dimension 1: Batch vs Single
- Batch: user sees full day, acts on multiple meals at once
- Single: user focuses on one meal, composes it

Dimension 2: Prose vs Structured
- Prose: user types natural language, LLM resolves into structure
- Structured: user directly searches, picks, enters quantities

These produce a 2×2 interaction space, all creating the same MealLog artifacts:

                    Prose                 Structured
  Batch             Day View:             Day View:
                    accept/skip plans,    edit individual items
                    type batch prose      on pre-filled slots

  Single            Composition:          Composition:
                    type "had dal rice"   search → pick → quantity
                    → LLM resolves        → user builds directly

"Confirm" is not a separate mode — it's batch + pre-filled structure. One tap accepts what's already there.

⸻

Two Surfaces

Day View (batch surface — the parent)

Shows the user's full day. Slots come from active MealPlan (pre-filled) or are empty (no plan). User acts per slot or in bulk.

Per-slot states:
- Planned, not logged → show plan items. Actions: [✓ ate this] [✎ different] [✗ skip]
- Logged → show logged items + confidence. Action: [refine] if low confidence
- Empty (no plan) → blank slot. Action: [+ log]
- Skipped → marked, confidence 1.0

Bulk action: [✓ Accept all] logs everything as planned in one tap.

Bottom of day view: [+ log something else] for food without a meal slot.

Composition Surface (single-meal surface — the child)

Opens when user needs to compose: tapping [✎ different], [+ log], or [refine]. Three-section layout (HP05a):

Structure (top):
- The artifact being built. Updates live.
- Pre-filled if coming from plan edit. Empty if new log.
- Shows resolved items, quantities, nutrition, confidence per item.
- [✓ Log this] when ready.

Middle (contextual):
- Prose mode → assistant responses, clarifications, quick-select options
- Structured mode → search results, recent foods, quantity picker
- Adapts automatically based on what user is doing

User input (bottom):
- Text box for prose, search box for structured
- Quick-select buttons when assistant offers choices
- User can switch between typing and searching freely

⸻

How HP04 Is Mitigated

Prose → Structure: the structure section makes the conversion visible in real-time. User sees what the system understood and can correct immediately.

Context Drift: the structure section acts as an anchor. The middle section (assistant) always serves the structure being built. No scrolling chat thread. If user drifts, assistant redirects.

⸻

Open Questions Resolved

Plan-modified ("ate this but with changes"):
→ [✎ different] opens composition surface pre-filled from plan. User edits items. Source: plan_modified.

Binary ("I ate but won't say what"):
→ Minimal prose: user types "had breakfast" or taps [✓] on empty slot. System creates MealLog with no items, confidence 0.3.

Time (when they logged vs when they ate):
→ meal_type gives the occasion. Time is optional — if user doesn't state it, system infers from meal_type or leaves null.

Multiple occasions per slot ("oats at 7, smoothie at 10"):
→ Two MealLogs. Second one created via [+ log something else] at bottom of day view.

Food without occasion ("had some almonds"):
→ [+ log something else] at bottom of day view. Goes to composition surface with meal_type: null.

Cross-day (midnight eating):
→ User picks the date. System defaults to today. User can switch.

Logging decay:
→ Plan-confirm path is one tap — survives decay. As patterns build, system can pre-fill from behavioral predictions even without a plan. Surface gets easier as the system knows more.
