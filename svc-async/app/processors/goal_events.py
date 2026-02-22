"""Goal event processor.

Handles: goal_set, goal_revised.
"""


async def handle_goal_set(event: dict) -> None:
    """Process a goal_set event.

    Steps:
    1. Cascade config effects (write FactAttributes)
    2. Flag active MealPlan for recompute
    3. Call svc-orchestra /rebuild-plan
    4. Update WYLO state

    Stub — no-op.
    """
    # TODO: implement
    pass
