LLM Pipeline + Tool Workflows

⸻

1. Pipeline Pattern

Every LLM interaction follows one pipeline:

Trigger → Scope Context → Assemble Prompt → Call LLM → Parse Output → Validate → Write

Triggers are either user-initiated (tool invocation, interaction) or system-initiated (cron, event threshold).

⸻

2. Tool Workflows

Tools are deterministic workflows with bounded LLM calls at judgment points.

Pattern:

Deterministic step (validate input, check config, load entities)
    ↓
LLM judgment (bounded call, structured output expected)
    ↓
Deterministic step (validate output, write entities, fire events)
    ↓
... repeat if multi-step ...

⸻

Tool Inventory:

BuildMealPlan
- Scope: goal, config (calories, macros, dietary type, meal count), food memories, cooking memories, allergens, policy priors
- Deterministic: validate config exists, create MealPlan entity shell
- LLM: generate meal suggestions fitting constraints (expertise: recommendation + knowledge)
- Write: MealPlan artifact

LogMeal
- Scope: food memories, allergens, dietary config, active plan (today's meals)
- Deterministic: validate input, create MealLog entity, fire meal_logged event
- LLM: if prose input, extract structured meal data. If structured input, no LLM needed.
- Write: MealLog entity, meal_logged event

SetGoal
- Scope: user context (attributes, circumstances), existing goals, config
- Deterministic: create Goal entity, fire side effects (config updates, memories, intent creation)
- LLM: assess goal appropriateness, suggest target values, check policy (e.g., minimum calorie floor)
- Write: Goal artifact, config updates, declared memories, intent

ReviewPeriod
- Scope: weekly reports/metrics (HP02), goal, active plan, memories
- Deterministic: load report data for period
- LLM: compose review narrative from metrics, surface insights, frame observations
- Write: Review artifact

DetectPatterns
- Scope: reports/metrics across multiple periods, memories
- Deterministic: load relevant reports
- LLM: identify patterns, correlations, behavioral trends from metrics
- Write: Review artifact (pattern type)

BuildShoppingList
- Scope: active MealPlan
- Deterministic: derive ingredient list from plan, aggregate quantities
- LLM: minimal — possibly categorize or suggest substitutions
- Write: ShoppingList artifact

BuildCookingPlan
- Scope: active MealPlan, recipe entities
- Deterministic: derive prep steps from plan
- LLM: organize into efficient prep strategy, batch cooking suggestions
- Write: CookingPlan artifact

Explain (state enabler)
- Scope: food knowledge, dietary config, relevant memories
- Deterministic: minimal — route the question
- LLM: primary — answer nutrition question with context (expertise: knowledge + communication)
- Write: nothing — output is prose to user

⸻

3. Content Fills

Not tool workflows. LLM populates content slots on surfaces.

Trigger: Surface renders (home, entity view, review display) or event fires
Scope: surface-section-specific context (HP03)
LLM: generate prose from structured data (metrics → insight, plan → summary)
Write: nothing — output goes to presentation only

Content fills are the simplest LLM call type: structured input, prose output, no state mutation.

⸻

4. Conversation Escape Hatch

At any LLM judgment point in a tool workflow, the system may need clarification from the user. This creates an escape from the deterministic workflow into conversation.

Workflow step → LLM judges → insufficient context or ambiguity
    ↓
Escape to conversation (LLM talks to user)
    ↓
User responds (prose)
    ↓
Parse response → re-enter workflow at the judgment point

The escape hatch is a general pattern available to any tool, not tool-specific.

⸻

5. Where HP04 Core Challenges Manifest

Two distinct architectural points:

Point A: Escape hatch in structured workflows
A clarification conversation within a tool workflow. Both core challenges present:
- Prose → structure: user's response must be parsed into structured data to re-enter the workflow
- Context drift: user may drift beyond the workflow's scoped context

Point B: Inherently conversational tools
Tools like Explain and analytical discussions (ReviewPeriod, DetectPatterns) where conversation IS the tool output. Context drift is the primary challenge here — the user can steer the conversation beyond the scoped context. Prose → structure is less of an issue since the conversation is the output, not an input to a deterministic step.

⸻

6. LLM Call Types Summary

Type           | Trigger          | Output      | State Mutation | HP04 Exposure
Tool judgment  | User action      | Structured  | Yes            | Low (bounded)
Content fill   | Render / event   | Prose       | No             | None
Escape hatch   | Ambiguity        | Structured  | Yes (via tool) | High (both)
Conversational | User initiates   | Prose       | Possible       | Medium (drift)
