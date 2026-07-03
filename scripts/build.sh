#!/usr/bin/env bash
# =============================================================================
# Orth_pedeon — Render build script
# Runs from REPO ROOT. Called by render.yaml buildCommand.
# =============================================================================
set -e

echo "============================================"
echo "  [1/4] Installing Python dependencies"
echo "============================================"
pip install --upgrade pip --quiet
pip install -r backend/requirements.txt

echo "============================================"
echo "  [2/4] Installing Flutter ${FLUTTER_VERSION:=3.22.2}"
echo "============================================"
FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR/bin" ]; then
  echo "Downloading Flutter $FLUTTER_VERSION..."
  curl -fsSL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar xJ -C "$HOME"
else
  echo "Flutter already cached at $FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# Disable analytics & first-run prompts so build doesn't stall waiting for input
flutter config --no-analytics --no-cli-animations 2>/dev/null || true
flutter precache --web 2>/dev/null || true

flutter --version

echo "============================================"
echo "  [3/4] Building Flutter Web"
echo "============================================"
cd frontend
flutter pub get --no-example
flutter build web --release --dart-define=API_BASE_URL=/api/v1
cd ..

echo "============================================"
echo "  [4/4] Copying Flutter build → backend/app/static"
echo "============================================"
rm -rf backend/app/static
mkdir -p backend/app/static
cp -r frontend/build/web/. backend/app/static/

echo ""
echo "✅  Build complete."
echo "    Flutter web served from → backend/app/static/"
echo "    API docs                → /api/docs"
