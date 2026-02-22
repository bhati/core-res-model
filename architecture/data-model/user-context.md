User Context (cross-domain)

⸻

Attributes
- user_id
- age, sex, height, weight
- chronic_conditions: [diabetes_type1, diabetes_type2, pcos, kidney_disease, heart_disease, thyroid, ...]
- pregnancy_status (none / pregnant_trimester_1/2/3 / breastfeeding)

⸻

Traits
- user_id
- traits: [{ content, source (declared / observed) }]
- engagement_level (browsing / goal_setting / committed) — computed metric (HP02)

⸻

Circumstances
- user_id
- active_circumstances: [{ type, description, status (upcoming / active / resolving), start_date, expected_end }]

⸻

Intents (created as Goal side effects, cross-domain readable)
- user_id
- active_intents: [{ primary_tag, secondary_tags, goal_ref, domain }]

⸻

User Configuration
- user_id
- notification_frequency
- proactivity_level
- data_density (numbers / qualitative)
- tone (direct / gentle)
- planning_rigidity (precise / loose)
- autonomy_vs_guidance
