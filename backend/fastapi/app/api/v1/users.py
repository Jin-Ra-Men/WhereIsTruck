"""사용자/사장님 API."""
from fastapi import APIRouter

router = APIRouter(prefix="/users", tags=["users"])
