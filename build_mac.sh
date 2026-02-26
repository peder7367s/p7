#!/bin/bash
# Build P7.dylib and package as .deb (run on macOS with Xcode)
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

SDK="$(xcrun -sdk iphoneos -show-sdk-path)"
CLANG="$(xcrun -sdk iphoneos -find clang)"
ARCH=arm64

echo "[P7] Building P7.dylib for $ARCH..."
"$CLANG" -arch "$ARCH" \
  -isysroot "$SDK" \
  -dynamiclib \
  -fobjc-arc \
  -framework UIKit \
  -framework QuartzCore \
  -framework Speech \
  -framework AVFoundation \
  -framework Foundation \
  -framework UniformTypeIdentifiers \
  -install_name /Library/MobileSubstrate/DynamicLibraries/P7.dylib \
  "P7 Backend.m" "P7 Frontend.m" \
  -o P7.dylib

echo "[P7] Creating deb package..."
PKG_DIR="P7_1.0_iphoneos-arm"
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/DEBIAN"
mkdir -p "$PKG_DIR/Library/MobileSubstrate/DynamicLibraries"

cp deb/DEBIAN/control "$PKG_DIR/DEBIAN/"
cp deb/Library/MobileSubstrate/DynamicLibraries/P7.plist "$PKG_DIR/Library/MobileSubstrate/DynamicLibraries/"
cp P7.dylib "$PKG_DIR/Library/MobileSubstrate/DynamicLibraries/"

dpkg-deb -b "$PKG_DIR" P7_1.0_iphoneos-arm.deb 2>/dev/null || (echo "dpkg-deb not found. Install dpkg (e.g. brew install dpkg) or copy $PKG_DIR to your device and pack there."; exit 1)

# Rootless variant (/var/jb/ for Dopamine etc.)
PKG_RL="P7_1.0_iphoneos-arm_rootless"
rm -rf "$PKG_RL"
mkdir -p "$PKG_RL/DEBIAN"
mkdir -p "$PKG_RL/var/jb/Library/MobileSubstrate/DynamicLibraries"
cp deb/DEBIAN/control "$PKG_RL/DEBIAN/"
cp deb/Library/MobileSubstrate/DynamicLibraries/P7.plist "$PKG_RL/var/jb/Library/MobileSubstrate/DynamicLibraries/"
cp P7.dylib "$PKG_RL/var/jb/Library/MobileSubstrate/DynamicLibraries/"
dpkg-deb -b "$PKG_RL" P7_1.0_iphoneos-arm_rootless.deb 2>/dev/null || true

echo "[P7] Done:"
echo "      P7_1.0_iphoneos-arm.deb         (classic Substrate path)"
echo "      P7_1.0_iphoneos-arm_rootless.deb (rootless /var/jb)"
echo "      Install: copy .deb to device, install with Filza/Sileo/Zebra, then respring."
