User Context

Two data structures for all user context. Same scoping pattern on both.

⸻

FactAttributes (structured, code-consumed)

Field-level data. Consumed by code (deterministic switches, calculations) and LLM (as input data).

Each fact has: key, value, scope (user / account / domain), domain (null for cross-domain), required, entropy, who_writes.

User scope — about the person:

| Key | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| weight_kg | Numeric (30-300) | Yes | Moderate | User only |
| height_cm | Numeric (100-250) | Yes | Stable | User only |
| age | Numeric | Yes | Stable | User only |
| sex_at_birth | Enum (male/female) | No | Stable | User only |
| base_activity_level | Enum (sedentary/light/moderate/active/very_active) | No | Moderate | User + LLM |
| chronic_conditions | Enum[] | Yes | Stable | User only |
| pregnancy_status | Enum | Yes | Moderate | User only |

Account scope — how they want the system to behave:

| Key | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| notification_frequency | Enum | No | Stable | User only |
| proactivity_level | Enum | No | Stable | User only |
| data_density | Enum (numbers/qualitative/balanced) | No | Stable | User + LLM |
| tone | Enum (direct/gentle/balanced) | No | Stable | User + LLM |
| planning_rigidity | Enum (precise/moderate/loose) | No | Stable | User + LLM |
| autonomy_vs_guidance | Enum | No | Stable | User + LLM |
| tracking_granularity | Enum (exact/approximate) | No | Stable | User + LLM |

Domain scope (nutrition) — domain-specific constraints:

| Key | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| dietary_exclusions | Enum[] | Yes | Stable | User only |
| allergy_exclusions | Enum[] | Yes | Stable | User only |

dietary_exclusions: no_meat, no_beef, no_pork, no_fish, no_eggs, no_dairy, no_gluten, no_onion_garlic.
allergy_exclusions: peanuts, tree_nuts, shellfish, dairy, eggs, soy, wheat, fish, sesame, mustard, celery, lupin, mollusks, sulfites (FDA/EU Big 14).

New domains add their own domain-scoped facts to the same table.

⸻

ProseAttributes (prose blobs, LLM-consumed)

Named prose sections about the user. Each is a single prose document that gets enriched over time. Mutation model: LLM merges original + change into new prose. Original is versioned.

Each prose attribute has: type, content, scope, domain, entropy, who_writes.

User scope — cross-domain:

| Type | Entropy | Who Writes | Description |
|---|---|---|---|
| geocultural_notes | Stable | LLM + user | Geography, culture, festivals, household. |
| behavioral_notes | Moderate | LLM + user | Routines, motivation style, engagement patterns. |
| personality_notes | Stable | LLM + user | Communication preferences, response style, autonomy. |

Domain scope (nutrition):

| Type | Entropy | Who Writes | Description |
|---|---|---|---|
| dietary_notes | Stable | LLM + user | How the user eats — cuisine, lifestyle, soft intolerances. |
| food_avoidances | Moderate | LLM + user | Soft nos — taste/preference-based. |
| food_preferences | Moderate | LLM + user | Positive affinities — foods they enjoy. |
| meal_routines | Moderate | LLM + user + system | Typical eating patterns by occasion. |
| cooking_habits | Moderate | LLM + user | Cooking frequency, methods, meal prep habits. |

New domains add their own domain-scoped prose attributes.

⸻

Circumstances

Temporary conditions affecting behavior and needs.

- user_id
- active_circumstances: [{ type, description, status (upcoming / active / resolving), start_date, expected_end }]

Type vocabulary: traveling, fasting, sick, exam_period, holiday, moving, work_stress, social_event, ...

⸻

Intents (created as Goal side effects, cross-domain readable)

- user_id
- active_intents: [{ primary_tag, secondary_tags, goal_ref, domain }]

⸻

Engagement Level

Computed metric (HP02), not stored as a fact.

Derived from event counts: browsing / goal_setting / committed.
