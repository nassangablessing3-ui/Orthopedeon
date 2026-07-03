from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app.db.database import get_db
from app.schemas.wellness import MoodLogCreate, MoodLogOut, JournalCreate, JournalOut, ReminderCreate, ReminderOut
from app.services.auth_service import get_current_user
from app.services.wellness_service import log_mood, get_mood_history, create_journal, get_journals, create_reminder, get_reminders
from app.models.user import User

router = APIRouter(prefix="/wellness", tags=["Wellness"])


@router.post("/mood", response_model=MoodLogOut, status_code=201)
async def add_mood(data: MoodLogCreate, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await log_mood(db, user.id, data)


@router.get("/mood", response_model=List[MoodLogOut])
async def mood_history(user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await get_mood_history(db, user.id)


@router.post("/journal", response_model=JournalOut, status_code=201)
async def add_journal(data: JournalCreate, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await create_journal(db, user.id, data)


@router.get("/journal", response_model=List[JournalOut])
async def list_journals(user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await get_journals(db, user.id)


@router.post("/reminders", response_model=ReminderOut, status_code=201)
async def add_reminder(data: ReminderCreate, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await create_reminder(db, user.id, data)


@router.get("/reminders", response_model=List[ReminderOut])
async def list_reminders(user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await get_reminders(db, user.id)
