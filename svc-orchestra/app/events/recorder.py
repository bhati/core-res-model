"""Event recorder — writes events to Supabase for async processing."""

import logging
import uuid
from datetime import datetime, timezone

from app.db import get_supabase

logger = logging.getLogger(__name__)


def record_event(account_id: str, event_type: str, content: dict) -> None:
    """Record an event for async processing.

    Events are written with state='recorded'. Async Svc polls for
    these and processes them (aggregation, etc.).

    Fire-and-forget — failures are logged but don't break the request.
    """
    try:
        get_supabase().table("events").insert({
            "id": str(uuid.uuid4()),
            "account_id": account_id,
            "type": event_type,
            "content": content,
            "state": "recorded",
            "created_at": datetime.now(timezone.utc).isoformat(),
        }).execute()
    except Exception as e:
        logger.warning("Failed to record event %s for %s: %s", event_type, account_id, e)
