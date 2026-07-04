from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import List
import json


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",   # ignore extra env vars Render injects (PORT, etc.)
    )

    APP_ENV: str = "development"
    APP_TITLE: str = "Orth_pedeon API"
    APP_VERSION: str = "1.0.0"

    # ── DATABASE_URL ──────────────────────────────────────────────────────────
    # Render injects this as  postgresql://user:pass@host/db  (sync/psycopg2).
    # Our database.py._get_async_url() converts it to postgresql+asyncpg://...
    # at runtime so BOTH variables remain present and neither conflicts:
    #   • DATABASE_URL   = what Render sets (postgresql://)
    #   • _async_url     = what SQLAlchemy asyncio uses (postgresql+asyncpg://)
    # For local dev set the asyncpg form directly — _get_async_url() is a no-op.
    DATABASE_URL: str = "postgresql+asyncpg://postgres:password@localhost:5432/orthpedeon"

    SECRET_KEY: str = "change-me-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 10080

    OPENAI_API_KEY: str = ""
    CORS_ORIGINS: str = '["http://localhost:8000"]'

    def get_cors_origins(self) -> List[str]:
        try:
            return json.loads(self.CORS_ORIGINS)
        except Exception:
            return ["*"]


settings = Settings()
