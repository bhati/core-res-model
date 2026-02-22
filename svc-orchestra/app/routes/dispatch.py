from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class DispatchRequest(BaseModel):
    """Main entry point for all user actions.

    The dispatch route classifies the intent and routes to the appropriate workflow.
    """

    user_id: str
    input: str
    context: dict | None = None


class DispatchResponse(BaseModel):
    status: str
    workflow: str | None = None
    result: dict | None = None


@router.post("/dispatch", response_model=DispatchResponse)
async def dispatch(request: DispatchRequest):
    """Dispatch a user action to the appropriate workflow.

    Flow: classify intent → route to workflow → return result.
    Stub — returns a placeholder response.
    """
    return DispatchResponse(
        status="stub",
        workflow=None,
        result={"message": f"Received: {request.input}", "note": "Workflow routing not implemented"},
    )
