# Orth_pedeon

> AI-powered accessibility & wellbeing platform for people with disabilities.
> Single Render service — Flutter Web frontend + FastAPI backend, one deploy.

---

## Project Structure

```
orthpedeon/                        ← repo root (also Render's working dir)
├── backend/
│   ├── app/
│   │   ├── main.py               FastAPI app; serves /api/* + Flutter from /static
│   │   ├── static/               Flutter web build goes here (auto-copied by build.sh)
│   │   ├── core/                 Config, JWT security
│   │   ├── db/                   Async SQLAlchemy engine
│   │   ├── models/               User, Wellness, Social DB models
│   │   ├── schemas/              Pydantic request/response types
│   │   ├── services/             Business logic
│   │   ├── ai/                   OpenAI voice, mood, OCR
│   │   └── api/routes/           auth · users · wellness · social · ai
│   ├── requirements.txt
│   ├── gunicorn.conf.py          Gunicorn + UvicornWorker config
│   └── .env.example
├── frontend/                      Flutter project (Android + iOS + Web)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/                 Theme
│   │   ├── screens/              All 8 screens
│   │   ├── widgets/              MoodSelector, FeatureCard
│   │   └── services/api_service.dart
│   └── pubspec.yaml
├── scripts/
│   └── build.sh                  Render build: pip → flutter build web → copy
├── render.yaml                   One-click Render deploy
├── runtime.txt                   Pins Python 3.12 on Render
├── docker-compose.yml            Local dev (Postgres + backend)
└── README.md
```

---

## How It Works on Render

```
Git Push
    │
    ▼
Render (Python 3.12)
    │
    ├── pip install -r backend/requirements.txt
    ├── Download Flutter 3.22 (cached after first build)
    ├── flutter build web --release
    ├── cp frontend/build/web/ → backend/app/static/
    └── gunicorn -c backend/gunicorn.conf.py backend.app.main:app
                         │
                         ├── /            → Flutter Web (backend/app/static/)
                         ├── /api/v1/*    → FastAPI routes
                         └── /api/docs    → Swagger UI
```

No CORS config needed — frontend and backend share the same origin.

---

## Deploy to Render (One Click)

1. Push this repo to GitHub.
2. Render → **New** → **Blueprint** → connect the repo.
3. Render reads `render.yaml` and creates:
   - **PostgreSQL** database (`orthpedeon-db`)
   - **Web service** (`orthpedeon`) — Python 3.12, runs `build.sh`
4. In Render dashboard → service → **Environment**:
   - Set `OPENAI_API_KEY` = your key
5. Click **Deploy**.

Live at: `https://orthpedeon.onrender.com`
API docs: `https://orthpedeon.onrender.com/api/docs`

---

## Local Development

### Backend only (no Docker)

```bash
cd backend
python3.12 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env          # fill in DATABASE_URL + SECRET_KEY

# needs a local Postgres — or use Docker just for DB:
docker run -d -e POSTGRES_DB=orthpedeon -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password -p 5432:5432 postgres:16-alpine

gunicorn -c gunicorn.conf.py app.main:app
# → http://localhost:8000/api/docs
```

### Flutter (mobile)

```bash
cd frontend
flutter pub get
# For Android emulator, edit lib/services/api_service.dart:
#   defaultValue: 'http://10.0.2.2:8000/api/v1'
flutter run
```

### Full stack with Docker

```bash
cp backend/.env.example backend/.env
docker-compose up --build
# API at http://localhost:8000
```

---

## API Reference

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/api/health` | — | Health check |
| POST | `/api/v1/auth/register` | — | Register |
| POST | `/api/v1/auth/login` | — | Login → JWT |
| GET | `/api/v1/users/me` | ✅ | My profile |
| PATCH | `/api/v1/users/me/accessibility` | ✅ | Update a11y settings |
| POST | `/api/v1/wellness/mood` | ✅ | Log mood |
| GET | `/api/v1/wellness/mood` | ✅ | Mood history |
| POST | `/api/v1/wellness/journal` | ✅ | Save journal entry |
| GET | `/api/v1/wellness/journal` | ✅ | Journal history |
| POST | `/api/v1/wellness/reminders` | ✅ | Create reminder |
| GET | `/api/v1/wellness/reminders` | ✅ | List reminders |
| GET | `/api/v1/social/groups` | — | List groups |
| POST | `/api/v1/social/groups/{id}/join` | ✅ | Join group |
| GET | `/api/v1/social/groups/{id}/messages` | ✅ | Get messages |
| POST | `/api/v1/social/groups/{id}/messages` | ✅ | Send message |
| POST | `/api/v1/ai/voice` | ✅ | AI voice command |
| POST | `/api/v1/ai/ocr` | ✅ | OCR image → text |

---

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | ✅ | `postgresql+asyncpg://user:pass@host/db` |
| `SECRET_KEY` | ✅ | Long random string for JWT signing |
| `OPENAI_API_KEY` | Optional | Enables AI features |
| `APP_ENV` | Optional | `development` or `production` |
| `WEB_CONCURRENCY` | Optional | Gunicorn worker count (default: cpu×2) |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.22 (Dart) — Web + Android + iOS |
| Backend | FastAPI + Python 3.12 |
| Server | Gunicorn + UvicornWorker |
| Database | PostgreSQL 16 (async via asyncpg) |
| ORM | SQLAlchemy 2.0 async |
| AI | OpenAI GPT-4o / GPT-4o-mini |
| Auth | JWT (python-jose + bcrypt) |
| Deploy | Render.com — single service |
