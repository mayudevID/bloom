#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.." || exit

usage() {
  echo "❌ Parameter tidak valid"
  echo "👉 Android: ./build_fastlane.sh android release"
  echo "👉 iOS    : ./build_fastlane.sh ios release"
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Command tidak ditemukan: $cmd"
    exit 1
  fi
}

run_fastlane_upload() {
  local dir="$1"
  local lane="$2"

  (
    cd "$dir"

    # inject credential khusus iOS
    if [[ "$PLATFORM" == "ios" ]]; then      
      export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="munh-vkps-fnnj-sqrz"
    fi

    bundle check || bundle install --jobs 4 --retry 3
    bundle exec fastlane "$lane"
  )
}

# =========================
# VALIDASI ARGUMENT
# =========================
if [[ $# -ne 2 ]]; then
  usage
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
    if [[ "$TRACK_INPUT" != "release" ]]; then
      echo "❌ Track Android tidak valid: $TRACK_INPUT"
      echo "👉 Pilihan: release"
      exit 1
    fi
    FASTLANE_TRACK="prod_release"
    ;;
  ios)
    if [[ "$TRACK_INPUT" != "release" ]]; then
      echo "❌ Track iOS tidak valid: $TRACK_INPUT"
      echo "👉 Pilihan: release"
      exit 1
    fi
    FASTLANE_TRACK="prod_release"
    ;;
  *)
    echo "❌ Platform tidak valid: $PLATFORM"
    echo "👉 Pilihan: android | ios"
    exit 1
    ;;
esac

echo "🎯 Platform : $PLATFORM"
echo "🎯 Track    : $FASTLANE_TRACK"

require_command fvm
require_command bundle

# =========================
# CAFFEINATE
# =========================
CAFFEINATE_PID=""
if command -v caffeinate >/dev/null 2>&1; then
  caffeinate -dimsu &
  CAFFEINATE_PID=$!
fi

cleanup() {
  if [[ -n "${CAFFEINATE_PID:-}" ]]; then
    echo "🧹 Cleaning up caffeinate..."
    kill -TERM "$CAFFEINATE_PID" 2>/dev/null || true
    wait "$CAFFEINATE_PID" 2>/dev/null || true
  fi
}

trap cleanup EXIT
trap 'exit 130' INT TERM

echo "--- Memulai Proses Build & Deploy ---"

# =========================
# BUILD FLUTTER
# =========================
# echo "🧹 Cleaning Flutter project..."
# fvm flutter clean

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
  run_fastlane_upload "android" "$FASTLANE_TRACK"

elif [[ "$PLATFORM" == "ios" ]]; then
  echo "🏗️  Building iOS IPA..."
  fvm flutter build ipa --release \
    --obfuscate \
    --split-debug-info=./build/prod_dysm_ios \
    --flavor production \
    -t lib/main_production.dart

  echo "🍎 Deploy iOS via Fastlane..."
  run_fastlane_upload "ios" "$FASTLANE_TRACK"
fi

echo "✅ Build dan deployment selesai"
echo "--- Proses Selesai ---"
