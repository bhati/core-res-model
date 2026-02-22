"""Scheduled job processor.

Handles: daily_recalc, weekly_review.
Triggered by pg_cron → cron routes → these handlers.
"""


async def daily_recalc(user_id: str) -> None:
    """Daily recalculation for a single user.

    Recompute observations, check plan staleness.
    Stub — no-op.
    """
    # TODO: implement
    pass


async def weekly_review(user_id: str) -> None:
    """Weekly review generation for a single user.

    Call svc-orchestra to generate MacroReview + MealReview.
    Stub — no-op.
    """
    # TODO: implement
    pass
