# Orth_pedeon — Setup Guide

Complete guide for running Orth_pedeon locally and deploying to Render.

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Python | 3.12.8 | [python.org](https://python.org/downloads) |
| Flutter | 3.22.2 | [flutter.dev](https://docs.flutter.dev/get-started/install) |
| PostgreSQL | 14+ | [postgresql.org](https://www.postgresql.org/download) or Docker |
| Git | any | [git-scm.com](https://git-scm.com) |
| Docker (optional) | any | [docker.com](https://www.docker.com/get-started) |

---

## Option A — Local Development (No Docker)

### Step 1 — Clone the repo

```bash
git clone https://github.com/your-username/orthpedeon.git
cd orthpedeon
```

### Step 2 — Set up the Python backend

```bash
cd backend

# Create a virtual environment with Python 3.12
python3.12 -m venv venv

# Activate it
source venv/bin/activate          # macOS / Linux
# venv\Scripts\activate           # Windows

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt
```

### Step 3 — Configure environment variables

```bash
cp .env.example .env
```

Open `backend/.env` and fill in these values:

```env
DATABASE_URL=postgresql+asyncpg://postgres:password@localhost:5432/orthpedeon
SECRET_KEY=any-long-random-string-here
OPENAI_API_KEY=sk-...         # optional — AI features still show fallback text without it
APP_ENV=development
```

### Step 4 — Create the database

```bash
# If PostgreSQL is installed locally:
createdb orthpedeon

# Or spin up a Postgres container (Docker):
docker run -d \
  --name orthpedeon-db \
  -e POSTGRES_DB=orthpedeon \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  postgres:16-alpine
```

### Step 5 — Start the backend

```bash
# From the backend/ directory (venv active)
gunicorn -c gunicorn.conf.py app.main:app

# Or for hot-reload during development:
uvicorn app.main:app --reload
```

Backend is live at:
- API: http://localhost:8000/api/v1
- Swagger docs: http://localhost:8000/api/docs

### Step 6 — Seed community groups (first time only)

```bash
# From repo root (venv active)
python scripts/seed_db.py
```

### Step 7 — Run the Flutter app (mobile)

```bash
cd frontend
flutter pub get

# Android emulator (the default base URL already points here):
flutter run

# Physical device on the same WiFi — edit api_service.dart first:
# change defaultValue: '/api/v1'
# to    defaultValue: 'http://192.168.x.x:8000/api/v1'
flutter run
```

### Step 8 — Build Flutter Web locally (optional)

```bash
cd frontend
flutter build web --release --dart-define=API_BASE_URL=/api/v1
# Output: frontend/build/web/
```

---

## Option B — Local Development (Docker Compose)

Runs Postgres + the backend together. Flutter still runs separately via `flutter run`.

```bash
# From repo root
cp backend/.env.example backend/.env
# Edit backend/.env — at minimum set SECRET_KEY

docker-compose up --build
```

- API: http://localhost:8000/api/v1
- Docs: http://localhost:8000/api/docs

Stop with `Ctrl+C`, then `docker-compose down`.

---

## Option C — Deploy to Render (Production)

### Step 1 — Push to GitHub

```bash
git add .
git commit -m "initial commit"
git push origin main
```

### Step 2 — Create a Render Blueprint

1. Go to [render.com](https://render.com) → **New** → **Blueprint**
2. Connect your GitHub repository
3. Render reads `render.yaml` from the root and automatically creates:
   - **PostgreSQL** database (`orthpedeon-db`, free tier)
   - **Web service** (`orthpedeon`, Python 3.12.8)

### Step 3 — Add your OpenAI key

In the Render dashboard:
1. Click the `orthpedeon` service
2. Go to **Environment**
3. Add: `OPENAI_API_KEY` = your key from [platform.openai.com](https://platform.openai.com)

### Step 4 — Deploy

Click **Deploy**. Render will:

```
pip install -r backend/requirements.txt
↓
Download Flutter 3.22.2 (cached after first build ~2 min)
↓
flutter build web --release
↓
Copy build → backend/app/static/
↓
gunicorn -c backend/gunicorn.conf.py backend.app.main:app
```

### Step 5 — Seed the database on Render

In the Render dashboard → `orthpedeon` service → **Shell**:

```bash
python scripts/seed_db.py
```

### URLs after deploy

| URL | What |
|-----|------|
| `https://orthpedeon.onrender.com/` | Flutter Web app |
| `https://orthpedeon.onrender.com/api/v1/...` | REST API |
| `https://orthpedeon.onrender.com/api/docs` | Swagger UI |
| `https://orthpedeon.onrender.com/api/health` | Health check |

---

## Project Structure

```
orthpedeon/                        ← repo root
├── backend/
│   ├── app/
│   │   ├── main.py               FastAPI — serves /api/* and Flutter from /static
│   │   ├── static/               Flutter web build (auto-generated, not committed)
│   │   ├── core/                 Config, JWT security
│   │   ├── db/                   Async SQLAlchemy engine
│   │   ├── models/               User, Wellness, Social DB models
│   │   ├── schemas/              Pydantic request/response types
│   │   ├── services/             Business logic layer
│   │   ├── ai/                   OpenAI voice, mood, OCR
│   │   └── api/routes/           auth · users · wellness · social · ai
│   ├── gunicorn.conf.py          Gunicorn config (UvicornWorker, port from $PORT)
│   ├── requirements.txt          Python dependencies (Python 3.12 wheels only)
│   └── .env.example              Environment variable template
├── frontend/                     Flutter project
│   ├── lib/
│   │   ├── main.dart             Entry point + GoRouter navigation
│   │   ├── core/theme.dart       App theme (light + dark)
│   │   ├── screens/              8 screens: splash · onboard · login · register
│   │   │                                    dashboard · voice · wellness · social · joy
│   │   ├── widgets/              MoodSelector, FeatureCard
│   │   └── services/             ApiService (Dio, JWT injection, relative URLs)
│   └── pubspec.yaml              Flutter dependencies (Dart 3.4.x compatible)
├── scripts/
│   ├── build.sh                  Render build: pip → flutter → copy static
│   ├── seed_db.py                Populate starter community groups
│   └── setup_local.sh            Local setup helper
├── render.yaml                   Render Blueprint (single service)
├── runtime.txt                   Pins Python 3.12.8 for Render
├── .python-version               Pins Python 3.12.8 for pyenv
├── docker-compose.yml            Local dev: Postgres + backend
├── SETUP.md                      This file
└── README.md                     Architecture + API reference
```

---

## API Endpoints Quick Reference

All endpoints are prefixed with `/api/v1`.

| Method | Path | Auth | Description |
|--------|------|:----:|-------------|
| GET | `/api/health` | | Health check |
| POST | `/api/v1/auth/register` | | Create account |
| POST | `/api/v1/auth/login` | | Login → JWT token |
| GET | `/api/v1/users/me` | ✅ | My profile |
| PATCH | `/api/v1/users/me/accessibility` | ✅ | Update accessibility settings |
| POST | `/api/v1/wellness/mood` | ✅ | Log mood (1–5 + emoji) |
| GET | `/api/v1/wellness/mood` | ✅ | Mood history |
| POST | `/api/v1/wellness/journal` | ✅ | Save journal entry |
| GET | `/api/v1/wellness/journal` | ✅ | Journal history |
| POST | `/api/v1/wellness/reminders` | ✅ | Create reminder |
| GET | `/api/v1/wellness/reminders` | ✅ | List reminders |
| GET | `/api/v1/social/groups` | | List community groups |
| POST | `/api/v1/social/groups/{id}/join` | ✅ | Join a group |
| GET | `/api/v1/social/groups/{id}/messages` | ✅ | Get messages |
| POST | `/api/v1/social/groups/{id}/messages` | ✅ | Send a message |
| POST | `/api/v1/ai/voice` | ✅ | AI voice command (text → response) |
| POST | `/api/v1/ai/ocr` | ✅ | Extract text from image (base64) |

---

## Environment Variables

| Variable | Required | Default | Description |
|----------|:--------:|---------|-------------|
| `DATABASE_URL` | ✅ | — | `postgresql+asyncpg://user:pass@host/db` |
| `SECRET_KEY` | ✅ | — | Long random string for JWT signing |
| `ALGORITHM` | | `HS256` | JWT algorithm |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | | `10080` | Token lifetime (7 days) |
| `OPENAI_API_KEY` | | — | GPT-4o for voice/mood/OCR features |
| `APP_ENV` | | `development` | `development` or `production` |
| `PYTHON_VERSION` | | `3.12.8` | Set by render.yaml automatically |
| `WEB_CONCURRENCY` | | CPU × 2 | Gunicorn worker count |
| `PORT` | | `8000` | Set by Render automatically |

---

## Common Issues & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `pydantic-core build failed` | Render defaulted to Python 3.14 | `runtime.txt` pins 3.12.8; `PYTHON_VERSION` env var set in `render.yaml` |
| `pillow wheel failed` | Python 3.14 has no Pillow wheel | Same fix — Python 3.12.8 has pre-built wheels |
| `flutter: command not found` | Render has no Flutter installed | `build.sh` downloads Flutter 3.22.2 at build time |
| `version solving failed` | `retrofit_generator` + `riverpod_generator` conflict on Dart 3.4 | Both removed from `pubspec.yaml` — API calls use Dio directly |
| `permission_handler ^11.3.1` needs Dart 3.5 | Flutter 3.22 ships Dart 3.4.3 | Pinned to `^11.2.0` which is Dart 3.4 compatible |
| `flutter_secure_storage ^10.x beta` | Unstable on Android/Web | Downgraded to stable `^9.2.4` |
| Flutter analytics prompt stalls build | First-run interactive prompt | `build.sh` runs `flutter config --no-analytics` before building |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile frontend | Flutter 3.22.2 (Dart 3.4.3) — Android + iOS + Web |
| Web server | Gunicorn 22 + UvicornWorker |
| API framework | FastAPI 0.111 + Python 3.12.8 |
| Database | PostgreSQL 16 (async via asyncpg) |
| ORM | SQLAlchemy 2.0 async |
| Auth | JWT — python-jose + bcrypt |
| AI | OpenAI GPT-4o / GPT-4o-mini |
| Deploy | Render.com — single web service |
