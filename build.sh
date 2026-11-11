#!/usr/bin/env bash
set -Eeuo pipefail
# Build WolfOS Desktop as a Debian 13 KDE Plasma live ISO.
# Runs ONLY inside this project's build-output directory; it does not touch host partitions.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="${ROOT}/build-output"
if [ "$EUID" -ne 0 ]; then
  echo "Run: sudo bash build.sh"
  exit 1
fi
if ! command -v lb >/dev/null 2>&1; then
  echo "Missing live-build. Install dependencies from README.md first."
  exit 1
fi
if [ -e "${BUILD}/config" ] || [ -e "${BUILD}/.build" ]; then
  echo "Build directory already configured. For safety, not replacing it: ${BUILD}"
  echo "Use a fresh project extraction, or carefully clean the build-output directory yourself."
  exit 1
fi
mkdir -p "$BUILD"
cd "$BUILD"
lb config \
  --mode debian \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer none \
  --archive-areas 'main contrib non-free-firmware' \
  --linux-flavours amd64 \
  --bootappend-live 'boot=live components quiet splash' \
  --iso-application 'WolfOS Desktop v0.4' \
  --iso-publisher 'Wolf Studio' \
  --iso-volume 'WOLFOS_04'
# Copy source-controlled package lists and desktop customizations.
cp -a "${ROOT}/image-config/." "${BUILD}/config/"
# Keep a full local build log to inspect on failure.
set -o pipefail
lb build 2>&1 | tee "${ROOT}/wolfos-build.log"
ISO="$(find "$BUILD" -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [ -z "$ISO" ]; then
  echo "Build ended but no ISO found; read wolfos-build.log."
  exit 1
fi
printf '\nWolfOS ISO created: %s\n' "$ISO"
printf 'Test in QEMU: ./test-qemu.sh\n'
