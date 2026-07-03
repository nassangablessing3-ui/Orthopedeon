#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Orth_pedeon — Render build script
# Runs from repo ROOT.  Render calls this as the buildCommand.
# ─────────────────────────────────────────────────────────────────────────────
set -e

echo "============================================"
echo "  [1/4] Installing Python dependencies"
echo "============================================"
pip install --upgrade pip
pip install -r backend/requirements.txt

echo "============================================"
echo "  [2/4] Installing Flutter"
echo "============================================"
# Render's build environment does not ship Flutter, so we download it.
FLUTTER_VERSION="3.22.2"
FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar xJ -C "$HOME"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version

echo "============================================"
echo "  [3/4] Building Flutter Web"
echo "============================================"
cd frontend
flutter pub get
flutter build web --release
cd ..

echo "============================================"
echo "  [4/4] Copying Flutter build → backend/app/static"
echo "============================================"
rm -rf backend/app/static
mkdir -p backend/app/static
cp -r frontend/build/web/. backend/app/static/

echo ""
echo "✅  Build complete."
echo "    Flutter web  → backend/app/static/"
echo "    API docs     → /api/docs"
