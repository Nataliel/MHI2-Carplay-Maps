# MQB Toolbox add-on

This package adds **CarPlay Maps VC** to the Toolbox **Customization** menu.

## Install choices

- `791 AID 12.3`: MU1102, MU1367 and MU1427.
- `790 AID 10.5`: MU1102, MU1367 and MU1440 Skoda.

MU1427 (`lsd.jxe` = 52,751,492 bytes) uses a factory `lsd.sh` without a `-Xbootclasspath/p:` entry; the installer adds one dedicated line before the J9 launch instead of extending an existing one. Restore returns the factory `lsd.sh` byte-for-byte.

The selected installer detects the exact `lsd.jxe` profile before writing. A profile mismatch stops before changing the unit.

## Scope

- CarPlay map video projection only.
- Steering-wheel zoom in, zoom out and long-press map switching.
- Plaintext runtime in `/mnt/app/carplaymaps`.
- No CarPlay music or cover-art data.
- No navigation text or guidance data.
- No startup animation.
- No device-bound encryption, NAVDB payload or 250 ms watchdog.

Keep this update medium inserted when starting an installation from the Toolbox menu. The package does not reboot the unit automatically.

Free open-source project by **omonob (QCDWJ)**.
