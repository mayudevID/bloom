#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.." || exit

# =========================
# CAFFEINATE
# =========================
caffeinate -dimsu &
CAFFEINATE_PID=$!

cleanup() {
  echo "🧹 Cleaning up caffeinate..."
  kill -TERM "$CAFFEINATE_PID" 2>/dev/null || true
  wait "$CAFFEINATE_PID" 2>/dev/null || true
}

trap cleanup EXIT
trap 'exit 130' INT TERM

SSH_HOST="vps-46"
REMOTE_BASE="/var/www"
APP_DIR="$REMOTE_BASE/ar-rauda-app"

BUILD_DIR="build/web"
ZIP_NAME="web.zip"

# =========================
# BUILD FLUTTER
# =========================
echo "🧹 Cleaning Flutter project..."
fvm flutter clean

echo "📦 Getting dependencies..."
fvm flutter pub get

echo "🔧 Activating flutterfire CLI..."
fvm dart pub global activate flutterfire_cli

echo "🏗️  Build Flutter Web (production)..."
fvm flutter build web --release -t lib/main_production.dart

echo "📦 Zip isi build/web → $ZIP_NAME"
rm -f "$ZIP_NAME"
cd build/web
zip -r "../../$ZIP_NAME" .
cd ../..

echo "🚀 Upload $ZIP_NAME ke VPS..."
scp "$ZIP_NAME" "$SSH_HOST:$REMOTE_BASE/"

echo "⚙️  Deploy di VPS..."
ssh "$SSH_HOST" << EOF
set -e

cd "$REMOTE_BASE"

echo "🧹 Bersihkan app lama"
rm -rf "$APP_DIR"/*

echo "📦 Extract web.zip langsung ke app root"
unzip -o web.zip -d "$APP_DIR"

echo "🗑️  Cleanup zip"
rm -f web.zip

echo "✅ Deploy selesai di server"
EOF

rm -f "$ZIP_NAME"

echo "🎉 Deploy Flutter Web PRODUCTION selesai!"
