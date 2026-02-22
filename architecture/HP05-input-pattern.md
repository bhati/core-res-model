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

⸻

HP05a — Three-Section Composition Surface

When prose input is used to build a structured artifact (meal log, goal, plan), the surface uses three sections:

Structure (top) — the artifact being built. Updates live as prose resolves into data. Acts as an anchor — always visible, always showing what the system has captured. Prevents context drift by keeping the destination visible. Zero state can show high-probability predictions (time of day, plan, history).

Assistant (middle) — the system's latest response only. Not a scrolling chat thread. Always in service of completing the structure — not freeform conversation. If user drifts, assistant redirects toward the structure. Holds cues at zero state, clarification questions during input, confirmation when complete.

User (bottom) — input surface. Free-form text box as default. When assistant asks a clarification, quick-select options appear alongside the text box. User can always type or tap.

Why this solves HP04:
- Prose → Structure: structure surface makes the conversion visible and verifiable in real-time. User sees what the system understood immediately.
- Context Drift: structure surface acts as anchor. Assistant is bounded — serves the structure, not the conversation. No scrolling thread to drift into.

This is what makes the interaction not-a-chatbot. Without the structure surface, it's a chat app. With it, it's a guided composition tool that accepts natural language.

Design rules:
1. Structure accumulates, conversation doesn't. Structure grows as data resolves. Assistant only shows latest exchange.
2. Assistant always serves the structure. Every assistant response moves the structure toward completion.
3. User input is flexible. Prose and quick-select coexist. Mode blends naturally.
4. Conversation depth is bounded. System logs what it has after reasonable attempts rather than interrogating.

