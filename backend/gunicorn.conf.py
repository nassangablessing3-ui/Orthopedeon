# gunicorn.conf.py — loaded automatically by gunicorn -c gunicorn.conf.py
import multiprocessing
import os

# Use uvicorn workers so async FastAPI works under gunicorn
worker_class = "uvicorn.workers.UvicornWorker"

# 2-4 workers per CPU is a common sweet spot
workers = int(os.environ.get("WEB_CONCURRENCY", max(2, multiprocessing.cpu_count())))

# Bind to Render's $PORT or 8000 locally
bind = f"0.0.0.0:{os.environ.get('PORT', '8000')}"

# Logging
accesslog = "-"
errorlog  = "-"
loglevel  = os.environ.get("LOG_LEVEL", "info")

# Graceful timeout (Render sends SIGTERM before killing)
graceful_timeout = 30
timeout = 120
keepalive = 5
