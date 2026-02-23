"""Auth dependency — JWT validation via Supabase."""

from fastapi import HTTPException, Request

from app.db import get_supabase


def _extract_token(request: Request) -> str:
    auth = request.headers.get("Authorization")
    if not auth or not auth.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing or invalid Authorization header")
    return auth[7:]


def get_account_id(request: Request) -> str:
    """FastAPI dependency — validates JWT via Supabase and returns account_id."""
    token = _extract_token(request)
    try:
        user_response = get_supabase().auth.get_user(token)
        user = user_response.user
        if not user:
            raise HTTPException(status_code=401, detail="Invalid token: no user found")
        return user.id
    except HTTPException:
        raise
    except Exception as e:
        if "401" in str(e) or "invalid" in str(e).lower():
            raise HTTPException(status_code=401, detail="Invalid or expired token")
        raise HTTPException(status_code=401, detail=f"Auth validation failed: {e}")
