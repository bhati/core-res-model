"""Log meal workflow.

Flow: LLM extract food items → entity resolution → write to meals + meal_items → publish event.
"""


async def log_meal(user_id: str, raw_input: str) -> dict:
    """Process a meal logging request.

    Steps:
    1. LLM extracts food items from natural language
    2. Entity resolution (match to foods table)
    3. Write meal + meal_items to Supabase
    4. Publish meal_logged event

    Stub — returns a placeholder.
    """
    # TODO: implement
    return {"status": "stub", "workflow": "log_meal", "input": raw_input}
