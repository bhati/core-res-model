"""Note dispatch workflow.

Classifies user input intent and routes to the appropriate workflow.
Flow: user input → LLM classify → { LogMeal, SetGoal, BuildMealPlan, ... }
"""


async def classify_intent(user_input: str) -> str:
    """Classify the intent of a user's natural language input.

    Returns a workflow name: 'log_meal', 'set_goal', 'build_meal_plan', 'conversational'.
    Stub — always returns 'log_meal'.
    """
    # TODO: LLM call to classify intent
    return "log_meal"
