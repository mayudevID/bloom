#!/bin/bash
set -euo pipefail

fvm flutter clean
rm -rf .dart_tool pubspec.lock
fvm flutter pub get

# rm -rf ~/Library/Developer/Xcode/DerivedData

cd ios
pod deintegrate
rm -rf Pods Podfile.lock .symlinks Flutter/Flutter.framework Flutter/Flutter.podspec
pod install --repo-update
cd ..