from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc
from backend.app.models.wellness import MoodLog, JournalEntry, Reminder
from backend.app.schemas.wellness import MoodLogCreate, JournalCreate, ReminderCreate
from backend.app.ai.openai_service import get_mood_feedback, get_sentiment_score
import uuid


async def log_mood(db: AsyncSession, user_id: uuid.UUID, data: MoodLogCreate) -> MoodLog:
    feedback = await get_mood_feedback(data.mood_score, data.notes or "")
    entry = MoodLog(
        user_id=user_id,
        mood_score=data.mood_score,
        mood_emoji=data.mood_emoji,
        notes=data.notes,
        ai_feedback=feedback,
    )
    db.add(entry)
    await db.flush()
    return entry


async def get_mood_history(db: AsyncSession, user_id: uuid.UUID, limit: int = 30):
    result = await db.execute(
        select(MoodLog).where(MoodLog.user_id == user_id)
        .order_by(desc(MoodLog.logged_at)).limit(limit)
    )
    return result.scalars().all()


async def create_journal(db: AsyncSession, user_id: uuid.UUID, data: JournalCreate) -> JournalEntry:
    sentiment = await get_sentiment_score(data.content)
    entry = JournalEntry(
        user_id=user_id,
        content=data.content,
        entry_type=data.entry_type,
        sentiment_score=sentiment,
    )
    db.add(entry)
    await db.flush()
    return entry


async def get_journals(db: AsyncSession, user_id: uuid.UUID, limit: int = 20):
    result = await db.execute(
        select(JournalEntry).where(JournalEntry.user_id == user_id)
        .order_by(desc(JournalEntry.created_at)).limit(limit)
    )
    return result.scalars().all()


async def create_reminder(db: AsyncSession, user_id: uuid.UUID, data: ReminderCreate) -> Reminder:
    reminder = Reminder(user_id=user_id, **data.model_dump())
    db.add(reminder)
    await db.flush()
    return reminder


async def get_reminders(db: AsyncSession, user_id: uuid.UUID):
    result = await db.execute(
        select(Reminder).where(Reminder.user_id == user_id)
        .order_by(Reminder.remind_at)
    )
    return result.scalars().all()
