#!/bin/bash
set -euo pipefail

fvm flutter clean
rm -rf .dart_tool pubspec.lock
fvm flutter pub get

cd android
./gradlew clean

rm -rf .gradle
rm -rf ~/.gradle/caches/
rm -rf ~/.gradle/daemon/
rm -rf ~/.gradle/native/
rm -rf ~/.gradle/wrapper/

cd ..
