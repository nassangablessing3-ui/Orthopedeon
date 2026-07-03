from sqlalchemy import Column, String, Boolean, DateTime, Text, Enum, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
import enum
from app.db.database import Base


class DisabilityType(str, enum.Enum):
    visual = "visual"
    hearing = "hearing"
    mobility = "mobility"
    cognitive = "cognitive"
    mental_wellness = "mental_wellness"


class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False, index=True)
    full_name = Column(String(255), nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    disability_types = Column(JSON, default=list)   # list of DisabilityType values
    avatar_url = Column(String(512), nullable=True)
    streak_days = Column(String(10), default="0")
    total_points = Column(String(10), default="0")
    accessibility_settings = Column(JSON, default=dict)  # font size, high contrast, etc.
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # relationships
    mood_logs = relationship("MoodLog", back_populates="user", cascade="all, delete")
    journal_entries = relationship("JournalEntry", back_populates="user", cascade="all, delete")
    reminders = relationship("Reminder", back_populates="user", cascade="all, delete")
    group_memberships = relationship("GroupMembership", back_populates="user", cascade="all, delete")
