"""
Run this once after setup to populate starter community groups.
Usage: cd backend && python ../scripts/seed_db.py
"""
import asyncio
from app.db.database import init_db, AsyncSessionLocal
from app.models.social import CommunityGroup

GROUPS = [
    dict(name="Low Vision Connect",   description="Share tips and experiences with other low-vision users", category="visual",   icon="visibility",       member_count="1200"),
    dict(name="Mobility Warriors",    description="Adaptive sports, tech hacks, and daily wins",            category="mobility",  icon="accessible",       member_count="876"),
    dict(name="Memory & Learning",    description="Cognitive tools, strategies, and peer support",          category="cognitive", icon="psychology",       member_count="540"),
    dict(name="Deaf Music Lovers",    description="Vibration, rhythm, and music felt — not just heard",    category="hearing",   icon="hearing_disabled", member_count="318"),
    dict(name="Wellness Warriors",    description="Mental health and emotional wellbeing community",        category="mental_wellness", icon="favorite",   member_count="721"),
    dict(name="Tech for All",         description="Reviews and guides for accessible technology",          category="general",   icon="devices",          member_count="1450"),
]

async def seed():
    await init_db()
    async with AsyncSessionLocal() as db:
        for g in GROUPS:
            db.add(CommunityGroup(**g))
        await db.commit()
        print(f"✅ Seeded {len(GROUPS)} community groups.")

asyncio.run(seed())
