from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from backend.app.models.social import CommunityGroup, GroupMembership, GroupMessage
import uuid


async def list_groups(db: AsyncSession, category: str = None):
    q = select(CommunityGroup).where(CommunityGroup.is_active == True)
    if category:
        q = q.where(CommunityGroup.category == category)
    result = await db.execute(q)
    return result.scalars().all()


async def join_group(db: AsyncSession, user_id: uuid.UUID, group_id: uuid.UUID):
    existing = await db.execute(
        select(GroupMembership).where(
            GroupMembership.user_id == user_id,
            GroupMembership.group_id == group_id
        )
    )
    if existing.scalar_one_or_none():
        return {"detail": "Already a member"}
    membership = GroupMembership(user_id=user_id, group_id=group_id)
    db.add(membership)
    await db.flush()
    return {"detail": "Joined successfully"}


async def get_messages(db: AsyncSession, group_id: uuid.UUID, limit: int = 50):
    result = await db.execute(
        select(GroupMessage).where(GroupMessage.group_id == group_id)
        .order_by(desc(GroupMessage.sent_at)).limit(limit)
    )
    return result.scalars().all()


async def send_message(db: AsyncSession, group_id: uuid.UUID, sender_id: uuid.UUID, content: str, msg_type: str = "text") -> GroupMessage:
    msg = GroupMessage(
        group_id=group_id,
        sender_id=sender_id,
        content=content,
        message_type=msg_type,
    )
    db.add(msg)
    await db.flush()
    return msg
