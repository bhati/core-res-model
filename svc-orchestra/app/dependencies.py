"""Shared FastAPI dependencies for svc-orchestra."""

import logging

from fastapi import Request

from app.services.geolocation import GeoLocation, lookup

logger = logging.getLogger(__name__)


def get_client_location(request: Request) -> GeoLocation | None:
    """Resolve coarse location from the client's IP address.

    Extracts the real client IP from X-Forwarded-For (set by Render's
    reverse proxy) or falls back to request.client.host.
    """
    # X-Forwarded-For may contain: "client, proxy1, proxy2"
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        ip = forwarded.split(",")[0].strip()
    elif request.client:
        ip = request.client.host
    else:
        return None

    # Skip private / loopback addresses
    if ip.startswith(("127.", "10.", "192.168.", "172.")) or ip == "::1":
        return None

    return lookup(ip)
