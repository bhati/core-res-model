CookingPlan

A preparation strategy derived from a MealPlan + Recipes. Recomputes if plan recomputes.

- id
- user_id
- plan_ref
- prep_sessions: [
    {
      date,
      tasks: [{ user_recipe_ref, recipe_name, prep_steps, batch_quantity }]
    }
  ]
- assembly_guide (how to assemble meals from prepped components)
- created_at
