from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
import uuid
from backend.app.db.database import get_db
from backend.app.schemas.social import GroupOut, MessageCreate, MessageOut
from backend.app.services.auth_service import get_current_user
from backend.app.services.social_service import list_groups, join_group, get_messages, send_message
from backend.app.models.user import User

router = APIRouter(prefix="/social", tags=["Social"])


@router.get("/groups", response_model=List[GroupOut])
async def get_groups(category: Optional[str] = Query(None), db: AsyncSession = Depends(get_db)):
    return await list_groups(db, category)


@router.post("/groups/{group_id}/join")
async def join(group_id: uuid.UUID, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await join_group(db, user.id, group_id)


@router.get("/groups/{group_id}/messages", response_model=List[MessageOut])
async def messages(group_id: uuid.UUID, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await get_messages(db, group_id)


@router.post("/groups/{group_id}/messages", response_model=MessageOut, status_code=201)
async def post_message(group_id: uuid.UUID, data: MessageCreate, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await send_message(db, group_id, user.id, data.content, data.message_type)
