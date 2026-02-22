NutritionGoal

One active Goal per domain. All artifacts implicitly serve the active Goal — no artifact-level goal scoping needed.

A tagged commitment. The statement is prose (the user's words). Tags are structural anchors at two levels for policy activation and product behavior.

⸻

Schema

- id
- user_id
- domain (nutrition)
- statement (prose: "Manage diabetes through diet, lose weight, eat better")
- tags: { [primary]: [secondary, ...], ... }
  Primary tags activate policy sets. Secondary tags give granularity.
  e.g., { medical: [diabetes_management, medication_aware_diet], body_composition: [weight_loss, caloric_deficit], behavioral: [mindful_eating] }
- targets: [{ metric, value, unit }] — optional, LLM-derived from statement + assessment
  e.g., [{ calorie_target, 1800, kcal/day }, { protein_target, 130, g/day }]
- config_effects: [{ key, value }] — LLM determines from statement + assessment
  e.g., [{ calorie_target, 1800 }, { macro_split, { protein: 30, carb: 40, fat: 30 } }]
- status (active / revised / retired)
- predecessor_id (if revised, which Goal it replaced)
- created_at, revised_at, retired_at

⸻

Primary Tag Vocabulary

- medical — activates medical safety policies, disclaimers, medication awareness
- body_composition — caloric assessment, minimum floors, timeline validation
- performance — performance-specific nutrients, training-load awareness
- behavioral — qualitative goals allowed, pattern-focused reviews
- operational — execution-focused, practical artifacts prioritized

Secondary tags are granular sub-intents under each primary. Multiple primaries and multiple secondaries per primary — all that fit, applied.

⸻

Side Effects

Goal revision: when revised, config effects cascade. Active MealPlan flagged for recomputation. Prior Goal preserved with predecessor chain.

Memories: Goal statement echoes as a cross-domain memory in user context ("user wants to manage diabetes and lose weight"). Readable by other domains.

Intents: Goal creates intents as side effects. Within domain, Goal → domain intent. Across domains, visible as cross-domain context. Intents use the same primary/secondary tag structure.

⸻

Validation Gate

Every goal passes through a three-tier validation before activation. LLM evaluates the proposed goal against user's FactAttributes, active priors, and platform policy.

Severity levels:

Pass — goal is safe and reasonable. Proceed.
Warn — goal has concerns but isn't dangerous. User can override after acknowledging the concern. System logs the acknowledgment.
Block — goal violates hard safety policy. System redirects to alternatives. No override.

Validation rules:

| Trigger | Severity | Reason |
|---|---|---|
| Calorie target < 1200 without medical clearance | Block | Below safe intake for any adult |
| Weight loss goal + pregnant/breastfeeding | Block | Deficit unsafe during pregnancy |
| High protein target + kidney disease | Block | Renal risk — protein restriction required |
| Restriction language + eating disorder history | Block | May trigger disordered patterns |
| Caloric deficit > 500 kcal/day | Warn | Sustainability concern — hard to maintain |
| Multiple simultaneous targets (4+) | Warn | Complexity risk — suggest simplifying |
| Ambitious timeline ("lose 10kg in a month") | Warn | Unrealistic — system suggests adjustment |
| Carb elimination + Type 1 diabetes | Block | Hypoglycemia risk |
| Goal contradicts current medical prior | Block | Medical safety — refer to provider |

Rules are evaluated by the LLM using policy + FactAttributes. Not a static rule engine — the LLM applies judgment for edge cases (e.g., is "no carbs" truly zero or just low-carb intent?).

