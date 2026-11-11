#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO="${1:-$(find "$ROOT/build-output" -maxdepth 1 -name '*.iso' -print -quit 2>/dev/null || true)}"
if [ ! -f "$ISO" ]; then
  echo "No ISO yet. Build it with: sudo bash build.sh"
  exit 1
fi
if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
  echo "Install qemu-system-x86"
  exit 1
fi
# Start entirely inside a VM: no virtual disk attached and no networking.
# A hardware virtualisation accelerator is used only when available to this user.
ACCEL=tcg
if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then ACCEL=kvm; fi
exec qemu-system-x86_64 \
  -machine "accel=${ACCEL}" \
  -m 4096 -smp 2 \
  -cdrom "$ISO" -boot d \
  -vga std -display gtk \
  -usb -device usb-tablet \
  -nic none \
  -no-reboot
