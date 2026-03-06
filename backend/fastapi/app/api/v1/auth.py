"""인증 API (Firebase 등)."""
from fastapi import APIRouter

router = APIRouter(prefix="/auth", tags=["auth"])
