#!/usr/bin/env sh
set -e
cd "$(dirname "$0")"
killall Xcode 2>/dev/null || true
sleep 1
xcodegen generate
open -a Xcode InternetBanking.xcodeproj
