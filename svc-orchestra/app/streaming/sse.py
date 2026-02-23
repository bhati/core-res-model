"""SSE event formatting utilities."""

import json


def sse_event(event: str, data: dict) -> str:
    """Format a single Server-Sent Event with LF line endings."""
    return f"event: {event}\ndata: {json.dumps(data)}\n\n"
