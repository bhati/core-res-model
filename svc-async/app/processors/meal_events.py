"""Meal event processor.

Handles: meal_logged, meal_refined, meal_skipped.
Triggered by pgmq consumption (deferred) or direct call.
"""


async def handle_meal_logged(event: dict) -> None:
    """Process a meal_logged event.

    Steps:
    1. Check plan_enabled + plan_reactivity
    2. If on_log → call svc-orchestra /adapt-plan
    3. Recompute daily calorie/macro observations
    4. Update WYLO state

    Stub — no-op.
    """
    # TODO: implement
    pass


async def handle_meal_refined(event: dict) -> None:
    """Process a meal_refined event.

    Recompute observations with updated data.
    Stub — no-op.
    """
    # TODO: implement
    pass
