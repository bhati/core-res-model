Product Principles

(Design-Level Specification — Universal)

⸻

1. Purpose

Product Principles define the non-negotiable behavioral constraints of the product. They are organized by dimension — each representing an area where the product must take a position. Policies are minimal and constraining — they say what the product will NOT do, leaving maximum room for domain policies to operate.

⸻

2. Policy Architecture

Product Principles (constrain — universal)
    ↓
Domain Policy (constrain — domain-specific)
    ↓
Domain Strategy (solve — domain-specific)

All layers read User Context + Domain Context.

Product Principles CONSTRAIN — universal behavioral boundaries.
Domain Policy CONSTRAINS — domain-specific guardrails (safety, circumstance responses).
Domain Strategy SOLVES — how the domain actively serves user intent (tool orchestration, artifact shaping, transition guidance).

There is no separate “user policy” layer. User Context is data, not rules. Which user information escalates from “inform” to “constrain” is defined by Product Principles (e.g., medical safety).

⸻

3. Agency

Who has control.

	•	The user can enter any state at any time. The system does not prescribe sequences.
	•	Tools are independent capabilities. No tool is gated by another tool.
	•	Intent conflicts are surfaced to the user. Tie-breaking is a user intervention, not a system decision.
	•	Circumstances suggest — they do not override. User retains control.

⸻

4. Safety

What is non-negotiable.

	•	Product defines which user information escalates from "inform" to "constrain." Medical conditions are the primary example — they become hard constraints on domain behavior that cannot be bypassed.
	•	The domain proactively defines safety logic for conditions it understands. The product ensures those constraints are enforced.
	•	The system does not provide medical diagnoses, prescribe treatment, or contradict professional medical advice.

⸻

5. Privacy and Consent

What the system can know, infer, and retain.

	•	The system collects context only when it serves the user's expressed intent. No speculative data collection.
	•	Declared memories belong to the user. The user can view, correct, or delete them.
	•	Observed memories are transparent. The user can see what the system has inferred and reject or confirm it.
	•	Context does not leak across domains unless the user explicitly enables cross-domain sharing.

⸻

6. Interaction Posture

How the system shows up.

	•	The product does not create burden of adherence. It helps follow through without guilt or pressure.
	•	Proactive behavior (suggestions, alerts, nudges) is controlled by User Configuration. Default posture is responsive, not intrusive.
	•	Onboarding is context collection (attributes, configuration, declared memories) — not a funnel or tutorial sequence.
	•	Only collect what serves the current action. Don't pre-collect for future transitions.
	•	Policy gaps (missing configuration, insufficient context) are surfaced via system notifications — not by burdening the user.

⸻

7. Data Lifecycle

How context is created, used, evolved, and expired.

	•	Events are immutable.
	•	Observations are provisional — recomputed, not persisted as permanent truth.
	•	Memories can be declared or observed. Both lead to the same durable store.
	•	Declared memories take effect immediately. Observed memories require evidence and time.
	•	The user can correct or retract any memory without penalty.

⸻

8. Coherence

How the system stays internally consistent.

	•	Transitions out of any state are context-dependent. No single loop is enforced.
	•	Domain policies cannot violate product principles.
	•	Cross-domain context flows only through defined interfaces, not implicit assumptions.

⸻

9. Progression

How the system evolves with the user.

	•	The system becomes more useful over time as context accumulates. It does not become more demanding.
	•	Zero context is a valid starting state. The system is useful from the first interaction.
	•	As memories stabilize, the system should require less from the user, not more.

⸻

10. System Integrity

How the system protects itself.

	•	The system defends against probing, manipulation, or bypassing of policies through user misintent.
	•	Policy boundaries are enforced at the system level, not the conversation level. A user cannot talk their way past a safety constraint.

⸻

11. Open Questions

	•	Circumstance creation policy: declared, inferred, or conversational?
	•	Memory expiry: do memories decay if contradicted by recent events?
	•	Emotional safety: should dimensions of emotional harm be specified at product level?
	•	Multi-user: does the product support shared contexts (e.g., family meal planning)?

⸻

12. One-Line Definition

Product Principles are the universal behavioral constraints that ensure the product respects user agency, enforces safety, protects privacy, avoids burden, maintains coherence, defends its integrity, and grows with the user — leaving domain policies free to solve within those boundaries.
