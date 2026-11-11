# WolfOS Desktop v0.4 — Professional Linux desktop build

This is a **new Linux-based WolfOS edition**, not the earlier scratch-built 32-bit kernel. The v0.1–v0.3 kernel project is untouched.

The goal is to have a real, polished desktop rather than a custom terminal pretending to be one. This project creates a **Debian 13 (trixie) + KDE Plasma 6 live ISO** and brands it as WolfOS. It has a real window manager, application launcher, taskbar, desktop icons, file manager, terminal, browser, system settings, and a custom Qt Control Center.

## What it is / is not

- This is a **Linux distribution remix** with independent WolfOS branding and a WolfOS Control Center, not an original kernel.
- Real KDE Plasma provides movable/resizable windows, panels, desktop shortcuts, and app menus.
- `test-qemu.sh` attaches **no hard disk** and **no network**; running the live ISO won't install over ScarfaceOS.
- The live environment is **temporary**; files in its home disappear when the VM closes. An installed/persistent version is a future milestone.
- It uses a custom dark wallpaper, Breeze Dark theme, and teal-blue WolfOS icon.
- Source can remain private, but Debian and KDE packages remain subject to their own open-source licences; distributing a full ISO requires respecting those licences and trademarks.

## Requirements — on Kali / ScarfaceOS

A working internet connection to Debian mirrors, about **12 GB free disk space** for build/cache and at least **4 GB VM RAM** (6 GB recommended if available). ISO size will vary with package updates.

```bash
sudo apt update
sudo apt install live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin qemu-system-x86 qemu-utils
```

## Build

Unzip this archive in a convenient folder. **Look at `build.sh` before running sudo**.

```bash
cd ~/Downloads
unzip WolfOS_Desktop_v0.4_Source.zip
cd WolfOS_Desktop_v0.4
sudo bash build.sh
```

The ISO, when successfully built, appears in `build-output/`, commonly named `live-image-amd64.hybrid.iso`.

## Test in QEMU

```bash
./test-qemu.sh
```

This opens the real KDE Plasma desktop. It may take a little while to boot with software emulation. In the live session the user is normally `user` and SDDM is configured to log them into Plasma X11 automatically. If the SDDM login appears unexpectedly, select the `user` account and Plasma (X11). Keyboard layout defaults to the live-image system defaults.

In KDE, open the application launcher, the Files icon, System Settings or the WolfOS Control Center desktop icon. The Control Center is a real Qt application. To test that it runs: open Konsole and type `wolfos-control-center`.

## Privacy and safety

- The QEMU test disables networking (`-nic none`). This is a test-only choice and does not imply the ISO is network-incapable.
- The QEMU command attaches no existing disks or partitions and has no installer configured.
- Do **not** put the ISO on your laptop's boot disk or modify GRUB during these tests.
- No telemetry or user-IP collection was added to WolfOS custom code. KDE, Firefox and Debian components have their own privacy settings.

## Troubleshooting

- **`lb: command not found`**: install `live-build` (requirements above).
- **`lb build` fails**: check `wolfos-build.log` for the first real error. Most failures are network/disk-space/apt mirror issues.
- **No ISO**: the build has not completed successfully.
- **Black screen after login**: try the Plasma (X11) session; the package list includes `kwin-x11`.
- **Not automatically logged in**: the live session typically uses username `user`; SDDM's autologin config points at that username.
- **Blank wallpaper**: open WolfOS Control Center from the app menu, or right-click the desktop to set `/usr/share/wallpapers/WolfOS/contents/images/2560x1440.png` as the background.

## Confirmed vs untested

Included scripts are syntax-checked, and the Qt application is compiled for Python syntax only. **This environment cannot download the entire Debian/KDE package set or boot the resulting ISO, so actual QEMU boot still needs testing on your Kali machine.**

References:
- Debian Live Manual: https://live-team.pages.debian.net/live-manual/html/live-manual.en.html
- Debian KDE metapackage: https://packages.debian.org/trixie/kde-plasma-desktop
- Debian SDDM documentation: https://wiki.debian.org/SDDM
