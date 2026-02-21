HP03 — Context Scaling

⸻

1. Problem

Context is load-bearing in this product. Unlike chat-first products where context is conversation history, this system composes context from multiple structured sources — entities, memories, reports, config, policy priors. As user engagement grows, context grows. More context means more expensive, slower, and paradoxically worse LLM judgment.

The system must decide what context to send to the LLM — but that selection is itself a judgment call.

⸻

2. Position

Surfaces Scope Context.

Hard surfaces have a known scope. That scope deterministically defines what context the LLM receives. The surface is the context filter.

No LLM judgment is needed for context selection. The surface the user is on makes it deterministic.

⸻

3. Surface → Context Mapping

Each surface (or section of a composite surface) is scoped to a domain model primitive — an entity, artifact, tool, or transition. Only context relevant to that primitive is injected.

LogMeal surface → active plan, food memories, allergens, dietary config
BuildMealPlan surface → goal, config, food preferences, cooking memories
ReviewPeriod surface → weekly reports, goal, adherence observations
Explain surface → food knowledge, dietary config, relevant memories

Context excluded from a surface is not loaded. The LLM never receives irrelevant context.

⸻

4. Composite Surfaces

Home is not a broad surface. It is a composite of narrow-scoped sections, each centered on a domain model primitive:

- Active artifact card (e.g., MealPlan in progress) → plan context only
- Last tool output card (e.g., meal logged) → logged meal + food memories only
- Goal progress card → goal + adherence metrics only

Each section gets its own narrow context injection. No single LLM call needs the full context universe.

⸻

5. Why Hard Surfaces Enable This

An open-ended chat surface would break this entirely. "Tell me about my nutrition" makes all context relevant. The UX would be unable to scope context, forcing the system to either load everything (expensive, noisy) or guess what's relevant (requires LLM judgment to decide what to send to LLM — recursive).

Hard surfaces are not just a UX choice. They are a context management architecture.

⸻

6. Context Tiers

Regardless of surface, some context is always required:

Always present — medical attributes, allergens, active policy priors. The safety floor. Cannot be pruned.
Surface-scoped — entity/artifact/tool relevant context. Determined by the surface.
Excluded — everything else. Not loaded.

⸻

7. Open Problem: Context Drift on LLM Surfaces

When the LLM talks directly to the user (assessment, empathy, explanation), the conversation can drift beyond the original surface scope. User starts on LogMeal, LLM surface activates, user says "I've been really stressed and overeating."

The context was scoped for meal logging, but the conversation shifted to circumstances + empathy. The LLM may not have the context it needs to respond well.

Resolution TBD — options include re-scoping mid-conversation, escalating to a broader context tier, or accepting bounded context as a constraint on LLM-surface conversations.

⸻

8. Principle

The UX structure is the context filter. Every surface — including every section of a composite surface — has a bounded context scope defined by what domain model primitive it serves. This makes context selection deterministic, keeps LLM calls focused, and avoids the recursive problem of needing judgment to select context for judgment.
