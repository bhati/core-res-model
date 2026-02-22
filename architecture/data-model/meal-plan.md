MealPlan

A temporal arrangement of intended meals. Implicitly serves the active Goal (no goal_ref needed — one Goal per domain).

⸻

Schema

- id
- user_id
- period (day / week)
- start_date, end_date
- context_snapshot: {
    config: { calorie_target, macro_split, dietary_type, meal_count, allergens },
    circumstances: [traveling, fasting, ...],
    key_memories: [avoids_eggs, doesnt_cook_weekdays, ...],
    goal_tags: { medical: [...], body_composition: [...] }
  }
- days: [
    {
      date,
      meals: [
        {
          meal_type (breakfast / lunch / dinner / snack),
          items: [{ user_food_ref, user_recipe_ref, display_name, quantity, unit, preparation }],
          computed_nutrition: { kcal, protein, carbs, fat } — copied at build time
        }
      ]
    }
  ]
- status (active / superseded)
- created_at, superseded_at, superseded_by

⸻

Context Snapshot

Captures what influenced the plan at build time. Enables staleness detection: "Plan was built for travel. You're home now — rebuild?"

System compares current context against snapshot to flag when conditions have changed.

⸻

Propagation

Copy at build. User food update → trigger recomputation event (surfaced, not silent). Safety resolves live.
