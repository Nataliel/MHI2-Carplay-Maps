# MU1367 / 790 AID 10.5

- Firmware gate: `/ifs/lsd.jxe` = **55,840,541 bytes**
- Display: **30 fps, CarPlay turn card** (safe area narrowed to the centre half). Stream 1010×376. Not yet tested in a car; other options, including the original 40 fps core, are in the MQB Toolbox menu. See [`tuning/`](./tuning/)
- Steering controls: short press zoom; long press map switch
- Profile core: `payload/profiles/MU1367/790/core.so`: the stock 790 build (shared with MU1102/MU1440, originally 40 fps, non-navigation centered, navigation right) with the display settings above ([`tuning/patch-core-tuning.py`](./tuning/patch-core-tuning.py)). Rebuild or verify with [`tuning/build-mu1367-790-cores.sh`](./tuning/build-mu1367-790-cores.sh) `[--check]`.

This is a standalone CarPlay Maps VC file set, not a complete toolbox. From this directory on the MMX shell, run `/bin/ksh ./run-install.sh`. The installer performs the exact firmware/profile check again and does not reboot automatically.

这是独立项目文件，不是完整工具箱。在 MMX 中进入本目录后运行 `/bin/ksh ./run-install.sh`；安装器会再次执行精确固件校验，且不会自动重启。
