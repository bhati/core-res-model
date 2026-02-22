User Context (cross-domain)

⸻

Attributes

Physical facts about the user. Cross-domain — any domain may read these.

Field schema: each field has required (boolean), entropy (how likely to change), and who_writes (who can set/update).

| Field | Value Type | Required | Entropy | Who Writes |
|---|---|---|---|---|
| weight_kg | Numeric (30-300) | Yes | Moderate — changes over months | User only |
| height_cm | Numeric (100-250) | Yes | Stable | User only |
| age | Numeric | Yes | Stable (computed from DOB) | User only |
| sex_at_birth | Enum (male/female) | No | Stable | User only |
| base_activity_level | Enum (sedentary/light/moderate/active/very_active) | No | Moderate | User + LLM |
| chronic_conditions | Enum[] | Yes | Stable | User only |
| pregnancy_status | Enum | Yes | Moderate — changes per trimester | User only |

Entropy levels:
- Stable: rarely changes once set.
- Moderate: may change over weeks/months. System should track last_updated and allow re-confirmation.

Who writes:
- User only: system never infers or updates.
- User + LLM: LLM can suggest updates, user must confirm.

⸻

Traits

Behavioral, personality, and cultural patterns. Accumulated over time.

- user_id
- traits: [{ content, source (declared / observed), confidence }]
- engagement_level (browsing / goal_setting / committed) — computed metric (HP02)
- geocultural_notes (prose — cross-domain context about geography, culture, festivals, household. e.g., "Lives in Bangalore. Punjabi household. Observes Navratri fasting. Family of 4." Mutation model: same as domain memories — LLM merges old + change into new prose.)

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

User Configuration

Presentation and interaction preferences.

| Field | Value Type | Default | Entropy | Who Writes |
|---|---|---|---|---|
| notification_frequency | Enum | moderate | Stable | User only |
| proactivity_level | Enum | moderate | Stable | User only |
| data_density | Enum (numbers/qualitative/balanced) | balanced | Stable | User + LLM |
| tone | Enum (direct/gentle/balanced) | balanced | Stable | User + LLM |
| planning_rigidity | Enum (precise/moderate/loose) | moderate | Stable | User + LLM |
| autonomy_vs_guidance | Enum | balanced | Stable | User + LLM |
| tracking_granularity | Enum (exact/approximate) | approximate | Stable | User + LLM |
