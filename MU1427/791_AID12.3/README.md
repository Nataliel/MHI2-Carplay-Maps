# MU1427 / 791 AID 12.3

- Firmware gate: `/ifs/lsd.jxe` = **52,751,492 bytes**
- Display: **30 fps, navigation centered, CarPlay turn card** (narrow, under the clock bar). Wide-card and map-only options are in the MQB Toolbox menu; see [`tuning/`](./tuning/)
- Steering controls: short press zoom; long press map switch
- Profile core: `payload/profiles/MU1427/791/core.so`: the MU1367/791 build with the alt-screen AES key offset fixed for AirPlay 210.81 (`0x1c8` → `0x1c0`, one byte, [`patch-core-mu1427.py`](./patch-core-mu1427.py)) plus the display settings above ([`tuning/patch-core-tuning.py`](./tuning/patch-core-tuning.py)). Rebuild or verify with [`tuning/build-mu1427-cores.sh`](./tuning/build-mu1427-cores.sh) `[--check]`.
- Installer: adds a dedicated `-Xbootclasspath/p:` line to `lsd.sh` (see [`../README.md`](../README.md))

This is a standalone CarPlay Maps VC file set, not a complete toolbox. From this directory on the MMX shell, run `/bin/ksh ./run-install.sh`. The installer performs the exact firmware/profile check again and does not reboot automatically.

After the first boot, check `/ramdisk/carplay_altscreen_handshake/handshake.log`, `/ramdisk/carplay-cluster-supervisor.log` and `/ramdisk/altscreen-most-bridge.log`. `/ramdisk/carplay_security_bridge/bridge.log` is expected to show `patch_failed_fingerprint` on this firmware.

这是独立项目文件，不是完整工具箱。在 MMX 中进入本目录后运行 `/bin/ksh ./run-install.sh`；安装器会再次执行精确固件校验，且不会自动重启。
