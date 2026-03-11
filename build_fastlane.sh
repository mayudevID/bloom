#!/bin/bash
set -euo pipefail

# =========================
# VALIDASI ARGUMENT
# =========================
if [[ $# -lt 2 ]]; then
  echo "❌ Parameter kurang"
  echo "👉 Android: ./build_fastlane.sh android [internal|draft|release]"
  echo "👉 iOS    : ./build_fastlane.sh ios [draft|release]"
  exit 1
fi

PLATFORM="$1"
TRACK_INPUT="$2"

FASTLANE_TRACK=""

# =========================
# MAPPING TRACK
# =========================
case "$PLATFORM" in
  android)
    case "$TRACK_INPUT" in
      internal) FASTLANE_TRACK="prod_internal" ;;
      draft)    FASTLANE_TRACK="prod_draft" ;;
      release)  FASTLANE_TRACK="prod_release" ;;
      *)
        echo "❌ Track Android tidak valid: $TRACK_INPUT"
        echo "👉 Pilihan: internal | draft | release"
        exit 1
        ;;
    esac
    ;;
  ios)
    case "$TRACK_INPUT" in
      draft)   FASTLANE_TRACK="prod_draft" ;;
      release) FASTLANE_TRACK="prod_release" ;;
      *)
        echo "❌ Track iOS tidak valid: $TRACK_INPUT"
        echo "👉 Pilihan: draft | release"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "❌ Platform tidak valid: $PLATFORM"
    echo "👉 Pilihan: android | ios"
    exit 1
    ;;
esac

echo "🎯 Platform : $PLATFORM"
echo "🎯 Track    : $FASTLANE_TRACK"

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

echo "--- Memulai Proses Build & Deploy ---"

# =========================
# BUILD FLUTTER
# =========================
echo "🧹 Cleaning Flutter project..."
fvm flutter clean

echo "📦 Getting dependencies..."
fvm flutter pub get

echo "🔧 Activating flutterfire CLI..."
fvm dart pub global activate flutterfire_cli

# =========================
# BUILD PER PLATFORM
# =========================
if [[ "$PLATFORM" == "android" ]]; then
  echo "🏗️  Building Android AppBundle..."
  fvm flutter build appbundle --release \
    --obfuscate \
    --split-debug-info=./build/appbundle_prod_dysm_android \
    --flavor production \
    -t lib/main_production.dart

  echo "📱 Deploy Android via Fastlane..."
  cd android
  bundle exec fastlane android "$FASTLANE_TRACK"
  cd ..

elif [[ "$PLATFORM" == "ios" ]]; then
  echo "🏗️  Building iOS IPA..."
  fvm flutter build ipa --release \
    --obfuscate \
    --split-debug-info=./build/prod_dysm_ios \
    --flavor production \
    -t lib/main_production.dart

  echo "🍎 Deploy iOS via Fastlane..."
  cd ios
  bundle exec fastlane ios "$FASTLANE_TRACK"
  cd ..
fi

echo "✅ Build dan deployment selesai"
echo "--- Proses Selesai ---"
