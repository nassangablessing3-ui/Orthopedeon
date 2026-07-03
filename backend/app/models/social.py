from sqlalchemy import Column, String, Text, DateTime, ForeignKey, Boolean
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
from app.db.database import Base


class CommunityGroup(Base):
    __tablename__ = "community_groups"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    category = Column(String(100), nullable=True)   # visual | hearing | mobility | general
    icon = Column(String(100), nullable=True)
    member_count = Column(String(10), default="0")
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    memberships = relationship("GroupMembership", back_populates="group", cascade="all, delete")
    messages = relationship("GroupMessage", back_populates="group", cascade="all, delete")


class GroupMembership(Base):
    __tablename__ = "group_memberships"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    group_id = Column(UUID(as_uuid=True), ForeignKey("community_groups.id"), nullable=False)
    joined_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="group_memberships")
    group = relationship("CommunityGroup", back_populates="memberships")


class GroupMessage(Base):
    __tablename__ = "group_messages"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    group_id = Column(UUID(as_uuid=True), ForeignKey("community_groups.id"), nullable=False)
    sender_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    content = Column(Text, nullable=False)
    message_type = Column(String(20), default="text")  # text | voice_note | image
    audio_url = Column(String(512), nullable=True)
    transcription = Column(Text, nullable=True)
    sent_at = Column(DateTime, default=datetime.utcnow)

    group = relationship("CommunityGroup", back_populates="messages")
