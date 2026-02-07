#!/bin/bash
set -e

echo "=== Killing old processes ==="
pkill -f flutter || true
pkill -f python || true
pkill -f dart || true

echo "=== Cleaning build artifacts ==="
cd /home/user/flutter_app
rm -rf build .dart_tool

echo "=== Resolving dependencies ==="
flutter clean
flutter pub get

echo "=== Building Web (Release) ==="
flutter build web --release

echo "=== Verifying Build ==="
if [ ! -f "build/web/main.dart.js" ]; then
  echo "Error: Build failed, main.dart.js not found!"
  exit 1
fi

echo "=== Starting Server ==="
python3 no_cache_server.py
