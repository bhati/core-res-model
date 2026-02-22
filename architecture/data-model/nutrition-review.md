NutritionReview

A family of review artifacts for the nutrition domain. Currently two types; can evolve as the product matures (e.g., CulinaryReview for food diversity). Both exist independently at weekly and monthly scopes (weeks don't compose into months — they're separate time containers that each scan raw MealLogs).

⸻

MacroReview

Nutrient analysis vs targets. Closes the nutrition loop — provides the signal that feeds back into Goal assessment and MealPlan adjustment.

- id
- user_id
- scope (weekly / monthly)
- period: { start_date, end_date }
- trigger (cron / user_initiated)
- metrics: {
    avg_daily_kcal,
    avg_daily_protein_g,
    avg_daily_carbs_g,
    avg_daily_fat_g,
    avg_daily_fiber_g,
    total_kcal,
    days_logged,
    avg_confidence
  }
- targets_comparison: {
    calorie_target, calorie_actual, calorie_delta_pct,
    protein_target, protein_actual, protein_delta_pct,
    on_track: boolean
  }
- narrative (LLM-generated: "You averaged 1,750 kcal this week, 50 below target. Protein was 12% below target at 58g/day...")
- observations: [{ content, signal_type (positive / concern / neutral), evidence }]
- created_at

When the expertise reads a MacroReview, it can judge: adjust targets? Change plan? Encourage? Flag a concern?

⸻

MealReview

Meal patterns, routine, and plan adherence. Tracks the behavioral and logistical side — not what nutrients, but how the user eats.

- id
- user_id
- scope (weekly / monthly)
- period: { start_date, end_date }
- trigger (cron / user_initiated)
- metrics: {
    total_meals_logged,
    total_meals_planned,
    total_meals_skipped,
    plan_adherence_pct,
    avg_meals_per_day,
    breakfast_logged_pct,
    lunch_logged_pct,
    dinner_logged_pct,
    snack_count,
    avg_log_confidence,
    meals_without_time_pct,
    most_common_foods: [{ food_ref, display_name, count }],
    home_cooked_pct (if context data available)
  }
- narrative (LLM-generated: "You logged 18 of 21 planned meals. Breakfast consistency was strong at 100%, but you skipped lunch twice...")
- observations: [{ content, signal_type, evidence }]
- created_at

When the expertise reads a MealReview, it can judge: is the user engaged? Are they struggling with specific meals? Should the plan structure change?

⸻

Common Rules

Both review types:
- Immutable once created. Snapshots of analysis at that point.
- Weekly scope triggered by cron (e.g., every Sunday). Monthly scope triggered first of month.
- User can also request on-demand via the Analyze surface.
- Confidence-aware: if avg_confidence < 0.7, narrative uses approximate language ("~", "roughly", "looks like") instead of precise statements.
- No overlap concern: weekly and monthly scan independently. They're different lenses on the same data, not hierarchical containers.
