HP05 — Three-Mode Input Pattern

⸻

Principle

Every user-facing composition that accepts input supports three modes at three effort levels:

Prose → Confirm → Structured

Each mode produces the same output schema. The mode determines who does the work and how confident the result is.

⸻

The Three Modes

Prose (low effort, LLM resolves)
User provides natural language. System extracts structure, resolves entities, estimates values. Confidence varies by input quality. This is the default entry point — meets the user at their natural expression.

Confirm / Template (medium effort, system proposes)
System generates a suggestion from context (active plan, previous behavior, LLM judgment). User approves, rejects, or adjusts. One-tap when accepted. Only available when the system has enough context to propose.

Structured (high effort, user specifies)
User explicitly fills fields — search, select, enter values. Highest confidence. Also serves as the fallback when prose is ambiguous and the correction path when confirm/prose got it wrong.

⸻

Effort-Confidence Tradeoff

The three modes form a spectrum:

  Low effort ─────────────── Medium ─────────────── High effort
  Prose                      Confirm                 Structured
  LLM resolves               System proposes         User specifies
  Lower confidence           Medium confidence       Highest confidence

The system optimizes for the lowest-effort path that produces sufficient confidence. If prose gives 0.8 confidence, structured isn't needed. If prose gives 0.4, system may suggest structured refinement.

⸻

How It Applies

Meal logging:
- Prose: "had dal rice for lunch"
- Confirm: plan says paneer tikka → [✓ ate this]
- Structured: search paneer → 200g → grilled

Goal setting:
- Prose: "want to lose weight and eat better"
- Confirm: system suggests goal from assessment → [✓ accept]
- Structured: pick tags → set calorie target → confirm

Meal plan building:
- Prose: "plan me a vegetarian week"
- Confirm: accept LLM-generated plan → [✓ looks good]
- Structured: build meal by meal, pick foods

Circumstance declaration:
- Prose: "traveling next week"
- Confirm: pick from common types → [traveling]
- Structured: set type, dates, description

⸻

Design Rules

1. Prose is always available. Every input surface has a text input as the baseline.

2. Confirm is contextual. Only appears when the system has enough context to propose (active plan, behavioral patterns, clear intent).

3. Structured is always available as fallback. User can always switch from prose/confirm to structured. Never hidden.

4. Mode selection is implicit. User doesn't choose a mode — they just start interacting. Typing = prose. Tapping a suggestion = confirm. Opening the picker = structured.

5. Mode transitions are seamless. Prose → system can't resolve → offers structured fallback. Confirm → user wants to adjust → opens structured edit. No dead ends.

6. tracking_granularity biases the default. exact users see structured surface first. approximate users see prose first. Same capability, different entry point.
