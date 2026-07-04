# gunicorn.conf.py
# Render runs gunicorn from the REPO ROOT.
# All imports use `backend.app.*` so no chdir is needed.

import multiprocessing
import os

# ── Worker — UvicornWorker required for async FastAPI ─────────────────────────
worker_class = "uvicorn.workers.UvicornWorker"
workers = int(os.environ.get("WEB_CONCURRENCY", max(2, multiprocessing.cpu_count())))

# ── Bind to Render's $PORT or 8000 locally ────────────────────────────────────
bind = f"0.0.0.0:{os.environ.get('PORT', '8000')}"

# ── Logging ───────────────────────────────────────────────────────────────────
accesslog = "-"
errorlog  = "-"
loglevel  = os.environ.get("LOG_LEVEL", "info")

# ── Timeouts ──────────────────────────────────────────────────────────────────
graceful_timeout = 30
timeout = 120
keepalive = 5
