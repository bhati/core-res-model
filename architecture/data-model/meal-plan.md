MealPlan

A rolling, event-driven suggestion layer for intended meals. Scope ranges from a single meal to a full week. Implicitly serves the active NutritionGoal.

⸻

Schema

- id
- user_id
- scope (meal / day / week)
- start_date, end_date
- source (auto_suggested / user_requested / user_reviewed)
- context_snapshot: {
    config: { calorie_target, macro_split, dietary_exclusions, allergy_exclusions, meal_count },
    circumstances: [traveling, fasting, ...],
    key_memories: [doesnt_cook_weekdays, prefers_high_protein_breakfast, ...],
    goal_tags: { medical: [...], body_composition: [...] }
  }
- days: [
    {
      date,
      meals: [
        {
          meal_type (breakfast / lunch / dinner / snack),
          commitment (suggestion / soft / committed),
          items: [{ user_food_ref, user_recipe_ref, display_name, quantity, unit, preparation }],
          computed_nutrition: { kcal, protein, carbs, fat } — copied at build time,
          original_items: [...] — preserved if slot was adapted
        }
      ]
    }
  ]
- status (active / superseded)
- created_at, superseded_at, superseded_by

⸻

Scope Continuum

"Recommend a meal" is a MealPlan with scope: meal. No separate tool.

  scope: meal → 1 slot (next meal suggestion)
  scope: day  → 1 day, all meal slots
  scope: week → 7 days, all meal slots

⸻

Commitment Levels

  suggestion — system auto-generated. Can silently update.
  soft       — user loosely accepted. Suggest changes with reason.
  committed  — user explicitly reviewed. Ask before changing.

⸻

Plan Settings (domain FactAttributes)

  plan_enabled:    true / false         — master toggle
  plan_window:     next_meal | day | week
  plan_reactivity: on_log | daily | manual

Default: plan_enabled: false. System suggests opt-in after engagement builds.

⸻

Event-Driven Adaptation

  Event                       Update scope        Threshold
  MealLog created             Next meal           Auto for suggestions, ask for committed
  MealLog skipped             Same day remaining  Auto for suggestions, ask for committed
  MealLog high deviation      Rest of day         Auto for suggestions, ask for committed
  Circumstance changed        All active slots    Flag all, suggest recompute
  Goal revised                Full recompute      Supersede current plan
  Food safety update          Affected slots only Immediate — safety

Adapted slots preserve original_items for transparency.

⸻

Context Snapshot + Staleness

Captures what influenced the plan at build time. Enables:
- "Plan was built for travel. You're home now — rebuild?"
- "Your goal changed since this plan was built."

System compares current context against snapshot to detect drift.

⸻

Propagation

Copy at build. Safety resolves live. User food update → trigger recomputation event (surfaced, not silent).
