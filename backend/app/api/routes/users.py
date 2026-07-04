from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.db.database import get_db
from backend.app.schemas.user import UserOut, AccessibilitySettingsUpdate
from backend.app.services.auth_service import get_current_user
from backend.app.models.user import User

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/me", response_model=UserOut)
async def get_me(current_user: User = Depends(get_current_user)):
    return current_user


@router.patch("/me/accessibility")
async def update_accessibility(
    data: AccessibilitySettingsUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    settings = current_user.accessibility_settings or {}
    update = data.model_dump(exclude_none=True)
    settings.update(update)
    current_user.accessibility_settings = settings
    db.add(current_user)
    return {"detail": "Accessibility settings updated", "settings": settings}
