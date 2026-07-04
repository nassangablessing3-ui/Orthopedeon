from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from backend.app.core.config import settings


def _get_async_url(url: str) -> str:
    """
    Render's managed Postgres injects DATABASE_URL as:
        postgres://...  or  postgresql://...   (both use the sync psycopg2 driver)

    SQLAlchemy asyncio requires the asyncpg driver, so the scheme must be:
        postgresql+asyncpg://...

    This function normalises any variant to the correct async scheme
    while leaving an already-correct URL untouched.
    Both the sync (psycopg2) and async (asyncpg) connection strings
    remain valid in their respective contexts — no conflict.
    """
    # Handle legacy 'postgres://' shorthand (Render sometimes uses this)
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql://", 1)

    # Ensure the asyncpg driver is specified
    if url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+asyncpg://", 1)

    # Already correct — leave as-is
    return url


_async_url = _get_async_url(settings.DATABASE_URL)

engine = create_async_engine(
    _async_url,
    echo=settings.APP_ENV == "development",
    pool_pre_ping=True,        # detects stale connections on Render's free tier
    pool_recycle=300,          # recycle connections every 5 min (free DB sleeps)
)

AsyncSessionLocal = async_sessionmaker(engine, expire_on_commit=False)


class Base(DeclarativeBase):
    pass


async def get_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()


async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
