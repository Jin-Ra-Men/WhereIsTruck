"""위치/지도 기반 API (PostGIS)."""
from fastapi import APIRouter

router = APIRouter(prefix="/locations", tags=["locations"])


@router.get("/nearby")
def get_nearby():
    return []
