from fastapi import APIRouter

router = APIRouter(prefix="/cron")


@router.post("/daily")
async def daily_recalc():
    """Daily recalculation trigger.

    Called by pg_cron. For users with plan_reactivity: daily:
    1. Recompute observations
    2. Call svc-orchestra /rebuild-plan (when plan is live)

    Stub — returns acknowledgment.
    """
    # TODO: implement daily recomputation logic
    return {"status": "stub", "job": "daily_recalc"}


@router.post("/weekly")
async def weekly_review():
    """Weekly review trigger.

    Called by pg_cron (e.g. every Sunday):
    1. Generate MacroReview + MealReview via svc-orchestra
    2. Surface review card in WYLO

    Stub — returns acknowledgment.
    """
    # TODO: implement weekly review generation
    return {"status": "stub", "job": "weekly_review"}
