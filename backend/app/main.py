from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from pathlib import Path
from backend.app.core.config import settings
from backend.app.db.database import init_db
from backend.app.api.routes import auth, users, wellness, social, ai


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield


app = FastAPI(
    title=settings.APP_TITLE,
    version=settings.APP_VERSION,
    description="AI-powered accessibility & wellbeing platform.",
    lifespan=lifespan,
    # Scope docs under /api so they don't clash with Flutter's root mount
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # same-origin in production; relax only during dev
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── API routes (/api/*) ───────────────────────────────────────────────────────
app.include_router(auth.router,     prefix="/api/v1")
app.include_router(users.router,    prefix="/api/v1")
app.include_router(wellness.router, prefix="/api/v1")
app.include_router(social.router,   prefix="/api/v1")
app.include_router(ai.router,       prefix="/api/v1")


@app.get("/api/health")
async def health():
    return {"app": settings.APP_TITLE, "version": settings.APP_VERSION, "status": "ok"}


# ── Flutter web (must be LAST — catches everything else) ─────────────────────
_static = Path(__file__).parent / "static"
if _static.exists() and any(_static.iterdir()):
    app.mount("/", StaticFiles(directory=str(_static), html=True), name="frontend")
