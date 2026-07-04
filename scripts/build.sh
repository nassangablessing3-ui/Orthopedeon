#!/usr/bin/env bash
# =============================================================================
# Orth_pedeon — Render build script
# Runs from REPO ROOT. render.yaml calls this as the buildCommand.
# =============================================================================
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.22.2}"
FLUTTER_DIR="$HOME/flutter"

# ── [1/4] Python deps ────────────────────────────────────────────────────────
echo "============================================"
echo "  [1/4] Installing Python dependencies"
echo "============================================"
pip install --upgrade pip --quiet
pip install -r backend/requirements.txt

# ── [2/4] Flutter install ────────────────────────────────────────────────────
echo "============================================"
echo "  [2/4] Installing Flutter $FLUTTER_VERSION"
echo "============================================"

if [ ! -d "$FLUTTER_DIR/bin" ]; then
  echo "Downloading Flutter $FLUTTER_VERSION ..."
  curl -fsSL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar xJ -C "$HOME"
  echo "Flutter downloaded."
else
  echo "Flutter already cached — skipping download."
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# Suppress first-run interactive prompts (would hang CI)
flutter config --no-analytics 2>/dev/null || true
flutter config --no-cli-animations 2>/dev/null || true
# Pre-download web artifacts
flutter precache --web --no-android --no-ios 2>/dev/null || true

flutter --version

# ── [3/4] Flutter web build ──────────────────────────────────────────────────
echo "============================================"
echo "  [3/4] Building Flutter Web"
echo "============================================"
cd frontend

# Ensure web/ platform support is registered
flutter create --platforms web . --project-name orthpedeon 2>/dev/null || true

flutter pub get
flutter build web --release --dart-define=API_BASE_URL=/api/v1

cd ..

# ── [4/4] Copy to FastAPI static folder ─────────────────────────────────────
echo "============================================"
echo "  [4/4] Copying build → backend/app/static"
echo "============================================"
rm -rf backend/app/static
mkdir -p backend/app/static
cp -r frontend/build/web/. backend/app/static/

echo ""
echo "✅  Build complete."
echo "    Flutter app  →  /  (backend/app/static)"
echo "    API          →  /api/v1"
echo "    Docs         →  /api/docs"
echo "    Health       →  /api/health"
