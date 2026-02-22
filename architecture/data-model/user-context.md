User Context (cross-domain)

⸻

Attributes

Physical facts about the user. Cross-domain — any domain may read these.

Each field has metadata: criticality (must-collect at onboarding or optional), expiry (when to prompt re-confirmation), who-writes (user-only or LLM can observe/infer).

| Field | Value Type | Criticality | Expiry | Who Writes | Description |
|---|---|---|---|---|---|
| weight_kg | Numeric (30-300) | High | 90 days | User only | Body weight. Drives BMR/TDEE calculation. |
| height_cm | Numeric (100-250) | High | Stable | User only | Height. Drives BMR calculation. |
| sex_at_birth | Enum (male/female) | Medium | Stable | User only | For BMR formula only. Not used beyond calculation. |
| base_activity_level | Enum | Medium | 90 days | User + LLM | Sedentary / light / moderate / active / very_active. Affects TDEE. LLM can suggest updates from behavioral data. |
| age | Numeric | High | Annual | User only | Affects BMR calculation. |
| chronic_conditions | Enum[] | Critical | Stable | User only | diabetes_type1, diabetes_type2, pcos, kidney_disease, heart_disease, thyroid, ... Activates safety policies. |
| pregnancy_status | Enum | Critical | Trimester | User only | none / pregnant_trimester_1/2/3 / breastfeeding. Activates pregnancy nutrition policies. |

Criticality levels:
- Critical: system must collect before allowing goal-setting. Safety-affecting.
- High: system should collect at onboarding. Affects calculation quality.
- Medium: system can function without, but improves accuracy.

Expiry: when the value goes stale and system should prompt re-confirmation. "Stable" = rarely changes. "90 days" = prompt quarterly.

Who writes: "User only" = system never infers or updates, only user can set. "User + LLM" = LLM can observe patterns and suggest updates ("You seem more active than your profile says. Want to update?") but user must confirm.

⸻

Traits

Behavioral and personality patterns. Accumulated over time.

- user_id
- traits: [{ content, source (declared / observed), confidence }]
- engagement_level (browsing / goal_setting / committed) — computed metric (HP02)

⸻

Circumstances

Temporary conditions affecting behavior and needs.

- user_id
- active_circumstances: [{ type, description, status (upcoming / active / resolving), start_date, expected_end }]

Type vocabulary: traveling, fasting, sick, exam_period, holiday, moving, work_stress, social_event, ...
Circumstances are declared by user or detected by LLM from conversation.

⸻

Intents (created as Goal side effects, cross-domain readable)

- user_id
- active_intents: [{ primary_tag, secondary_tags, goal_ref, domain }]

⸻

User Configuration

Presentation and interaction preferences. These govern how the system communicates, not what it computes.

| Field | Value Type | Default | Who Writes | Description |
|---|---|---|---|---|
| notification_frequency | Enum | moderate | User only | How often system reaches out proactively. |
| proactivity_level | Enum | moderate | User only | How aggressively system suggests actions. |
| data_density | Enum | balanced | User + LLM | numbers / qualitative / balanced. Affects report style. |
| tone | Enum | balanced | User + LLM | direct / gentle / balanced. Affects narrative voice. |
| planning_rigidity | Enum | moderate | User + LLM | precise / moderate / loose. Affects MealPlan detail level. |
| autonomy_vs_guidance | Enum | balanced | User + LLM | How much the system guides vs lets user lead. |
