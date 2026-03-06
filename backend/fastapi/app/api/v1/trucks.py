"""트럭(노점) API."""
from fastapi import APIRouter

router = APIRouter(prefix="/trucks", tags=["trucks"])


@router.get("/")
def list_trucks():
    return []
