"""Set goal workflow.

Flow: LLM compose (multi-turn) → validation gate → write nutrition_goal → cascade side effects.
"""


async def set_goal(user_id: str, raw_input: str) -> dict:
    """Process a goal setting request.

    Steps:
    1. LLM composes goal from user input (HP05a multi-turn)
    2. Validation gate (HP05b pass/warn/block)
    3. Write nutrition_goal to Supabase
    4. Cascade config_effects to fact_attributes
    5. Publish goal_set event

    Stub — returns a placeholder.
    """
    # TODO: implement
    return {"status": "stub", "workflow": "set_goal", "input": raw_input}
