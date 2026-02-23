"""
Geolocation service — IP2Location DB11 LITE (MMDB format).

Downloads the MMDB from Supabase Storage on startup, loads it into
a maxminddb reader for sub-millisecond lookups. Gracefully degrades
to None when the database is unavailable.
"""

import logging
import os
import tempfile
from dataclasses import dataclass

import maxminddb

from app.config import settings
from app.db import get_supabase

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# GeoLocation dataclass
# ---------------------------------------------------------------------------


@dataclass
class GeoLocation:
    """Coarse location resolved from an IP address."""

    country_code: str | None = None   # "IN"
    country_name: str | None = None   # "India"
    region: str | None = None         # "Karnataka"
    city: str | None = None           # "Bengaluru"
    timezone: str | None = None       # "Asia/Kolkata" (IANA)
    latitude: float | None = None
    longitude: float | None = None


# ---------------------------------------------------------------------------
# Singleton reader
# ---------------------------------------------------------------------------

_reader: maxminddb.Reader | None = None
_db_path: str | None = None


def initialize() -> None:
    """Download MMDB from Supabase Storage and open the reader.

    Call once at app startup. If config is missing, geolocation is
    silently disabled.
    """
    global _reader, _db_path

    bucket = getattr(settings, "geolite_bucket", None)
    file = getattr(settings, "geolite_file", None)

    if not bucket or not file:
        logger.info("Geolocation disabled — GEOLITE_BUCKET / GEOLITE_FILE not set")
        return

    try:
        logger.info("Downloading %s/%s from Supabase Storage…", bucket, file)
        data = get_supabase().storage.from_(bucket).download(file)

        # Write to a temp file so maxminddb can memory-map it
        _db_path = os.path.join(tempfile.gettempdir(), file)
        with open(_db_path, "wb") as f:
            f.write(data)

        _reader = maxminddb.open_database(_db_path)
        logger.info("IP2Location database loaded (%s)", _db_path)

    except Exception as e:
        logger.warning("Failed to load IP2Location database: %s — geolocation disabled", e)
        _reader = None


def close() -> None:
    """Release the reader. Call on app shutdown."""
    global _reader
    if _reader:
        _reader.close()
        _reader = None
        logger.info("IP2Location database closed")


def lookup(ip: str) -> GeoLocation | None:
    """Look up an IP address. Returns None if geolocation is disabled or lookup fails."""
    if not _reader:
        return None

    try:
        record = _reader.get(ip)
        if not record or not isinstance(record, dict):
            return None

        # Nested MaxMind-compatible structure
        country = record.get("country", {})
        location = record.get("location", {})
        city = record.get("city", {})
        subdivisions = record.get("subdivisions", [])

        return GeoLocation(
            country_code=country.get("iso_code"),
            country_name=(country.get("names") or {}).get("en"),
            region=(subdivisions[0].get("names") or {}).get("en") if subdivisions else None,
            city=(city.get("names") or {}).get("en"),
            timezone=location.get("time_zone"),
            latitude=location.get("latitude"),
            longitude=location.get("longitude"),
        )
    except Exception as e:
        logger.warning("Geolocation lookup failed for %s: %s", ip, e)
        return None
