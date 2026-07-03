#!/usr/bin/env bash
set -e

echo "=========================================="
echo "  Orth_pedeon — Local Development Setup"
echo "=========================================="

# ── Backend setup ────────────────────────────────────────────
echo ""
echo "[1/4] Setting up Python virtual environment..."
cd "$(dirname "$0")/../backend"
python3 -m venv venv
source venv/bin/activate

echo "[2/4] Installing Python dependencies..."
pip install --upgrade pip -q
pip install -r requirements.txt -q

if [ ! -f .env ]; then
  echo "[3/4] Creating .env from template..."
  cp .env.example .env
  echo ""
  echo "  ✅  .env created. Open backend/.env and set:"
  echo "       DATABASE_URL  — your PostgreSQL connection string"
  echo "       SECRET_KEY    — any long random string"
  echo "       OPENAI_API_KEY — your OpenAI key (optional for local testing)"
  echo ""
else
  echo "[3/4] .env already exists — skipping."
fi

echo "[4/4] Done! Start the backend with:"
echo ""
echo "   cd backend && source venv/bin/activate && uvicorn app.main:app --reload"
echo ""
echo "  API docs: http://localhost:8000/docs"
echo ""
echo "=========================================="
echo "  Flutter Setup"
echo "=========================================="
echo ""
echo "  1. Install Flutter: https://docs.flutter.dev/get-started/install"
echo "  2. cd frontend && flutter pub get"
echo "  3. flutter run"
echo ""
echo "  For Android emulator the API base URL is already set to:"
echo "  http://10.0.2.2:8000/api/v1  (maps to your localhost)"
echo ""
echo "  For a physical device, edit:"
echo "  frontend/lib/services/api_service.dart → _baseUrl"
echo "  and change to http://<your-machine-local-ip>:8000/api/v1"
echo ""
