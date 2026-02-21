Horizontal Notes

Running log of horizontal-level decisions discovered through vertical work. These will be committed to proper horizontal files once they stabilize.

⸻

Architecture

	•	Three layers: Product Principles (constrain, universal) → Domain Policy (constrain, domain-specific) → Domain Strategy (solve, domain-specific)
	•	All layers read User Context + Domain Context
	•	User Context is data, not rules — no "user policy" layer exists
	•	Product defines which user information escalates from "inform" to "constrain" (e.g., medical attributes)

⸻

Tool Model

	•	Two types: artifact tools (artifact-scoped, one per artifact) and state enablers (domain-scoped, no artifact)
	•	Artifact tools produce exactly one artifact — the artifact defines the tool's shape
	•	State enablers operate across all entities/concepts within the domain
	•	Tool reuse across domains is a product-space concern, not a domain model concern
	•	Tools have params — granularity handled via parameters, not tool proliferation (e.g., BuildMealPlan with single-meal mode, not a separate RecommendMeal tool)

⸻

Artifacts and Context

	•	Artifacts can create side effects in the context layer (Goal → sets Configuration values + creates declared memories)
	•	Goal (not Target) is the right name — it's a commitment, not a metric
	•	Transition gravity belongs in Strategy, not in the domain model — the model defines what's possible, strategy defines what's emphasized

⸻

Memory Model

	•	Two paths: declared (user states a truth → immediate memory) and observed (events → observations → stabilized memory)
	•	Declared memories are the cold start primer — they populate context before any events exist
	•	Configuration is pure operational parameters, not truths about the person
	•	Items like food preferences, cooking habits are memories, not configuration

⸻

Policy vs Strategy

	•	"Policy" is inherently constraining — it says what NOT to do
	•	"Strategy" (provisional word) is the solving layer — it says what TO do
	•	Domain Policy: safety rules, circumstance responses
	•	Domain Strategy: intent activation, onboarding, artifact shaping, tool behavior, transition guidance

⸻

Open Questions

	•	Better word than "Strategy" for the solving layer?
	•	Circumstance creation policy: declared, inferred, or conversational?
	•	Memory expiry: do memories decay if contradicted by recent events?
	•	Emotional safety: should dimensions of emotional harm be specified at product level?
	•	Multi-user: does the product support shared contexts (e.g., family meal planning)?
	•	Should domain-model.md also adopt the two-type tool model and the Goal concept?
