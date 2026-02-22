Domain Context

⸻

Configuration

Structured operational parameters — primarily set by Goal side effects.

- user_id
- dietary_type (omnivore / vegetarian / vegan / pescatarian / ...)
- calorie_target (kcal/day)
- macro_split: { protein_pct, carb_pct, fat_pct }
- meal_count (meals per day)
- fasting_window (e.g., 16:8)
- allergens: [list]
- tracking_granularity (exact / approximate)

⸻

Memories

Durable domain-scoped truths.

- id
- user_id
- domain (nutrition)
- content (prose: "avoids eggs", "prefers high-protein breakfast")
- path (declared / observed)
- source (user / goal / system_observation)
- tags: [food_preference, behavioral, cooking, medical, ...]
- created_at
- confidence (for observed memories)

Memories are tagged for retrieval by the context composer. Tags determine which memories are scoped into which surfaces (HP03).
