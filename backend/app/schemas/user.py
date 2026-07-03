from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime
import uuid


class UserCreate(BaseModel):
    email: EmailStr
    full_name: str
    password: str
    disability_types: List[str] = []


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: uuid.UUID
    email: str
    full_name: str
    disability_types: List[str]
    avatar_url: Optional[str]
    streak_days: str
    total_points: str
    created_at: datetime

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


class AccessibilitySettingsUpdate(BaseModel):
    font_size: Optional[str] = None        # small | medium | large | xlarge
    high_contrast: Optional[bool] = None
    reduce_motion: Optional[bool] = None
    voice_speed: Optional[float] = None    # 0.5 – 2.0
    haptic_feedback: Optional[bool] = None
