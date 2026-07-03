from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid


class MoodLogCreate(BaseModel):
    mood_score: int          # 1-5
    mood_emoji: Optional[str] = None
    notes: Optional[str] = None


class MoodLogOut(BaseModel):
    id: uuid.UUID
    mood_score: int
    mood_emoji: Optional[str]
    notes: Optional[str]
    ai_feedback: Optional[str]
    logged_at: datetime

    class Config:
        from_attributes = True


class JournalCreate(BaseModel):
    content: str
    entry_type: str = "gratitude"


class JournalOut(BaseModel):
    id: uuid.UUID
    content: str
    entry_type: str
    sentiment_score: Optional[float]
    created_at: datetime

    class Config:
        from_attributes = True


class ReminderCreate(BaseModel):
    title: str
    description: Optional[str] = None
    remind_at: datetime
    is_recurring: str = "none"


class ReminderOut(BaseModel):
    id: uuid.UUID
    title: str
    description: Optional[str]
    remind_at: datetime
    is_recurring: str
    is_done: str
    created_at: datetime

    class Config:
        from_attributes = True
