# gunicorn.conf.py
# Render runs gunicorn from the repo ROOT, not from backend/.
# So the app module is backend.app.main:app and we chdir into backend/
# so that relative imports (app.core, app.db, etc.) resolve correctly.

import multiprocessing
import os

# ── Worker ────────────────────────────────────────────────────────────────────
worker_class = "uvicorn.workers.UvicornWorker"
workers = int(os.environ.get("WEB_CONCURRENCY", max(2, multiprocessing.cpu_count())))

# ── Bind ──────────────────────────────────────────────────────────────────────
bind = f"0.0.0.0:{os.environ.get('PORT', '8000')}"

# ── Change directory ──────────────────────────────────────────────────────────
# This makes Python treat backend/ as the working directory so
# `from app.core.config import settings` resolves correctly.
chdir = os.path.join(os.path.dirname(__file__))  # → .../backend/

# ── Logging ───────────────────────────────────────────────────────────────────
accesslog = "-"
errorlog  = "-"
loglevel  = os.environ.get("LOG_LEVEL", "info")

# ── Timeouts ──────────────────────────────────────────────────────────────────
graceful_timeout = 30
timeout = 120
keepalive = 5
