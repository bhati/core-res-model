Set a NutritionGoal

⸻

Part 1: Problem Statement

A user wants to define what they're trying to achieve with nutrition. This sets the direction for everything — plan targets, review benchmarks, policy activation, system behavior. It's the most consequential interaction because it shapes all downstream artifacts.

The challenge: goals are expressed in wildly different ways ("lose weight", "eat better", "manage my diabetes at 1800 kcal"). The system must extract structure, validate safety, and activate the right policies — while keeping the user in control of their own direction.

⸻

What Makes This Hard

1. Goals are expressed as prose but need structural extraction — tags, targets, config effects.
2. The system must validate against medical priors without feeling paternalistic.
3. Some goals are dangerous for some users — the system must block without alienating.
4. Goal-setting blurs with onboarding — FactAttributes may not exist yet when the goal is set.
5. Multiple intents coexist ("lose weight AND manage diabetes AND eat better") — system must decompose without overwhelming.
6. Goals evolve — revision needs a clean predecessor chain without losing history.

⸻

Invariants

Data:
- One active NutritionGoal per domain
- Statement is prose (user's words), tags are structural (two-level: primary/secondary)
- Targets are LLM-derived from statement + user assessment
- config_effects write to domain-scoped FactAttributes
- Predecessor chain: revised goals link to their predecessor
- Status lifecycle: active → revised → retired

Side effects:
- Config effects cascade (calorie target, macro split written as domain FactAttributes)
- Memories created (goal statement echoed as ProseAttribute)
- Intents created (cross-domain readable)
- Active MealPlan flagged for recomputation on revision

Validation:
- Three-tier gate: pass / warn / block
- Block rules are hard — no override (calorie floor, pregnancy deficit, medical contradictions)
- Warn rules are soft — user can acknowledge and proceed
- LLM evaluates using policy + FactAttributes — not a static rule engine

⸻

Part 2: Proposal

HP05 applies: Prose → Confirm → Structured, with HP05a three-section composition surface.

Two-phase flow:

Phase 1: Declaration
User tells the system what they want. Prose-first.

Structure (top): Goal being built — statement, tags extracted, targets proposed
Middle (assistant): Assessment questions, validation feedback, suggestions
User input (bottom): Prose statement, quick-select for common goals

Flow:
1. User enters prose: "I want to lose weight and manage my diabetes"
2. LLM extracts tags: { body_composition: [weight_loss], medical: [diabetes_management] }
3. Structure shows extracted tags. Assistant asks assessment questions if needed:
   "What type of diabetes? Are you on medication?"
4. LLM proposes targets based on assessment + FactAttributes:
   { calorie_target: 1800, protein: 130g, macro: 30/40/30 }
5. Structure shows complete goal with targets

Phase 2: Validation Gate
Before activation, the goal passes through the validation layer.

Pass: structure confirms. [✓ Set this goal]

Warn: structure highlights concern. Assistant explains. User can override:
   "1300 kcal is a steep deficit. This may be hard to sustain."
   [Adjust to 1500] [Keep 1300, I understand]
   Override is logged.

Block: structure shows blocked item. Assistant explains why. No proceed button:
   "I can't set a target below 1200 kcal for safety."
   [Suggest safe target]
   System redirects.

⸻

Onboarding Overlap

If FactAttributes are missing (weight, height, conditions), the assistant collects them inline during goal-setting. The goal assessment naturally requires these inputs.

Flow: user declares goal → assistant recognizes missing attributes → asks within the same composition surface → attributes stored → assessment proceeds.

This means onboarding and goal-setting can be one continuous flow — not two separate journeys. The assistant collects what it needs for the goal to make sense.

⸻

Goal Revision

"I want to focus on muscle gain now instead"

Same composition surface. Structure pre-fills from current goal. User modifies.
On save:
- Current goal → status: revised
- New goal → predecessor_id: old goal
- Config effects cascade (new targets)
- Active MealPlan flagged
- Memory updated ("user shifted from weight loss to muscle gain")

⸻

Known Concerns

1. Assessment depth. How many questions before the system just proceeds? Collecting medical details mid-goal-setting could feel too clinical. Need to balance thoroughness with flow.

2. Multi-intent decomposition. "Lose weight AND manage diabetes AND eat better" — does this become one goal with 3 primary tags, or should the system help the user prioritize?

3. Targets feel automated. "Here are your targets" from the LLM might feel opaque. User should understand WHY 1800 kcal was suggested. Transparency in target derivation.

4. Validation tone. Block messages must be firm but not preachy. "I can't do that because..." not "That's dangerous and you shouldn't..."
