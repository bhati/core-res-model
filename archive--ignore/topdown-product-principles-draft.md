Product Principles — Top-Down Draft

(Design-Level Specification — Universal)

⸻

1. Purpose

Product Principles define the non-negotiable behavioral constraints of the product. They are organized by dimension — each dimension represents an area where the product must take a position. Policies within each dimension are minimal and constraining — they say what the product will NOT do, leaving maximum room for domain and user-level policies to operate.

⸻

2. Agency

Who has control.

	•	The user can enter any state at any time. The system does not prescribe sequences.
	•	Tools are independent capabilities. No tool is gated by another tool.
	•	Intent conflicts are surfaced to the user. The system does not silently resolve tension between competing intents.
	•	Circumstances suggest — they do not override. User retains control over how circumstances affect their experience.

⸻

3. Safety

What is non-negotiable.

	•	Product defines which user information escalates from "inform" to "constrain." Medical conditions are the primary example — they become hard constraints on domain behavior that cannot be bypassed.
	•	The domain proactively defines safety logic for conditions it understands. The product ensures those constraints are enforced.
	•	The system does not provide medical diagnoses, prescribe treatment, or contradict professional medical advice.

⸻

4. Privacy and Consent

What the system can know, infer, and retain.

	•	The system collects context only when it serves the user's expressed intent. No speculative data collection.
	•	Declared memories belong to the user. The user can view, correct, or delete them.
	•	Observed memories (system-inferred) are transparent. The user can see what the system has inferred and reject or confirm it.
	•	Context does not leak across domains unless the user explicitly enables cross-domain sharing.

⸻

5. Interaction Posture

How the system shows up.

	•	The product does not create burden of adherence. It helps follow through without guilt or pressure.
	•	Proactive behavior (suggestions, alerts, nudges) is controlled by User Configuration. The default posture is responsive, not intrusive.
	•	Onboarding is context collection (attributes, configuration, declared memories) — not a funnel or tutorial sequence.
	•	The system collects only what serves the current action. It does not pre-collect for future transitions.
	•	Policy gaps (missing configuration, insufficient context, unresolved dependencies) are surfaced via system notifications — not by burdening the user with system-level issues.

⸻

6. Data Lifecycle

How context is created, used, evolved, and expired.

	•	Events are immutable. Once recorded, they are not modified.
	•	Observations are provisional. They are recomputed, not persisted as permanent truth.
	•	Memories can be declared (user-stated) or observed (system-inferred). Both paths lead to the same durable store.
	•	Declared memories take effect immediately. Observed memories require evidence and time.
	•	The user can correct or retract any memory. The system respects corrections without penalty.

⸻

7. Coherence

How the system stays internally consistent.

	•	Transitions out of any state are context-dependent. The system does not enforce a single loop.
	•	Domain policies operate within product principles. A domain policy cannot violate a product principle.
	•	Cross-domain context (e.g., fitness schedule informing nutrition) flows only through defined interfaces, not implicit assumptions.

⸻

8. Progression

How the system evolves with the user.

	•	The system becomes more useful over time as context accumulates. It does not become more demanding.
	•	Zero context is a valid starting state. The system is useful from the first interaction.
	•	As memories stabilize, the system should require less from the user, not more.

⸻

9. System Integrity

How the system protects itself.

	•	The system defends against probing, manipulation, or bypassing of system policies through user misintent. Safety and product constraints cannot be socially engineered away.
	•	Policy boundaries are enforced at the system level, not at the conversation level. A user cannot talk their way past a safety constraint.

⸻

10. Policy Architecture

Product Principles (this document)
    ↓ constrains
User Context
    ↓ informs
Domain Policies
    ↓ solves

Product policies CONSTRAIN.
User policies INFORM.
Domain policies SOLVE.

⸻

10. Open Questions

	•	Circumstance creation policy: declared, inferred, or conversational?
	•	Memory expiry: do memories decay if contradicted by recent events?
	•	Emotional safety: should dimensions of emotional harm be specified at product level?
	•	Multi-user: does the product support shared contexts (e.g., family meal planning)?

⸻

11. One-Line Definition

Product Principles are the universal behavioral constraints that ensure the product respects user agency, enforces safety, protects privacy, avoids burden, maintains coherence, and grows with the user — leaving domain policies free to solve within those boundaries.
