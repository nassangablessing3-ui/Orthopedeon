from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid


class GroupOut(BaseModel):
    id: uuid.UUID
    name: str
    description: Optional[str]
    category: Optional[str]
    icon: Optional[str]
    member_count: str
    created_at: datetime

    class Config:
        from_attributes = True


class MessageCreate(BaseModel):
    content: str
    message_type: str = "text"


class MessageOut(BaseModel):
    id: uuid.UUID
    group_id: uuid.UUID
    sender_id: uuid.UUID
    content: str
    message_type: str
    audio_url: Optional[str]
    transcription: Optional[str]
    sent_at: datetime

    class Config:
        from_attributes = True
