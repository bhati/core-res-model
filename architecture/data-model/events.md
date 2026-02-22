Events

Immutable log of all domain activity.

- id
- user_id
- domain (nutrition)
- type (meal_logged / plan_created / plan_modified / goal_set / goal_revised / review_completed / pattern_detected / shopping_list_generated / cooking_plan_generated / food_updated / exception_declared / signal_reported)
- timestamp
- payload (type-specific structured data)
- artifact_ref (which artifact was created/modified)

Events feed the report engine (HP02). Event-driven computation triggers report recomputation.
