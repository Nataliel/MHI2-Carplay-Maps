# MU1427 standalone profiles

Firmware: `MHI2_ER_VWG11_K3342_MU1427` (HMI H28.28.210, framework 5.41.10.SR5 MIB2CLU6).
Exact firmware identity: `/ifs/lsd.jxe` = **52,751,492 bytes** (identical on hardware variants 50 and 70).

| Cluster | Profile files | Display baseline |
| --- | --- | --- |
| 791 AID 12.3 | [`791_AID12.3`](./791_AID12.3/) | 40 fps, navigation centered |

These directories contain only the CarPlay Maps VC project files. They are not complete MQB or M.I.B. Toolbox distributions.

## What differs from MU1367

The runtime payload is identical to MU1367/791 except `core.so`, which carries a one-byte fix (below). The installer also changed:

- `52751492` is recognised as `MU1427`; `MU1427:791` and `MU1427:790` are accepted profiles.
- MU1427's factory `lsd.sh` has no `-Xbootclasspath/p:` line; it only uses `BOOTCLASSPATH=-Xbootclasspath/a:...`. When no such line exists, the installer adds one dedicated line directly before the single production launch `$J9 $VMOPTIONS $BOOTCLASSPATH -jxe $HMI_JXE &`:

      BOOTCLASSPATH="$BOOTCLASSPATH -Xbootclasspath/p:$BASE_DIR/lsd/jars/CarPlayClusterControls.jar"

  Placing it after the optional DSITracer block keeps that block's `:` append from altering it. Firmware with the older layout is still patched exactly as before.
- A failed install now removes its own staging directories (`/ramdisk/.cpmap-plaintext-stage-*`, `/mnt/app/.carplaymaps-new-*`).

## `core.so`: alt-screen AES key offset (MU1427 only)

`core.so` derives the cluster stream's (type 111) AES key and IV with the stock `AirPlay_DeriveAESKeySHA512ForScreen(session + offset, 16, streamConnectionID, key, iv)`.

- The shared 791 build uses offset `0x1c8`, which matches the newer `libairplay.so` in MU1102/MU1367.
- MU1427 ships AirPlay 210.81 (`libairplay.so`, 857,735 bytes). Its own receiver passes `session + 0x1c0` for the main screen stream.
- With `0x1c8`, the iPhone connects and streams to the cluster, but every frame decrypts to garbage: `alt-aes-decrypt-invalid-avcc` in `/ramdisk/carplaymaps-video.log`, no `alt-stream-ready`, and the MOST bridge never starts.

The fix:

- File offset `0x5284` changes `add r0, r8, #0x1c8` (`e2880f72`) to `add r0, r8, #0x1c0` (`e2880f70`).
- sha256 before: `00b48a8f…`; after: `46da2689…`.
- [`791_AID12.3/patch-core-mu1427.py`](./791_AID12.3/patch-core-mu1427.py) reapplies and verifies it.
- This is the only hard-coded session-struct offset in `core.so`.
- Validated in the car on 2026-10-13 (iPhone over USB): the CarPlay map appears in the virtual cockpit.

## Ignore navigation-active (MQB Toolbox) on MU1427

The toolbox's generic `NavActiveIgnore.jar` was built for a newer firmware. It stops CarPlay from starting on MU1427 (`NoSuchMethodError` in the CarPlay HMI target), and it also carries corrupted constants. [`NavActiveIgnore/`](./NavActiveIgnore/) rebuilds it from MU1427's own `lsd.jxe` classes, with a README covering the build, verification and the history of the three revisions.

The toolbox installer picks the MU1427 jar automatically by `lsd.jxe` size. It also coexists with this project's `-Xbootclasspath/p:` line.

Validated in the car on 2026-10-13: CarPlay works, the OEM map loads in the virtual cockpit, and the CarPlay Maps VC stream works alongside it.

## Offline verification against the MU1427 SWDL package

| Check | Result |
| --- | --- |
| `libairplay.so` exports every symbol `core.so` resolves (AirPlay session hooks, `AirPlay_DeriveAESKeySHA512ForScreen`, `AES_CTR_*`, `HID*`, `CF*`) | OK |
| `CarPlayClusterControls.jar` override of `de.esolutions.fw.dsi.keypanel.DSIKeyPanelDispatcher` vs the class in MU1427 `lsd.jxe` (`DSIKeyPanelReply`, `DSIKeyPanelListener`, `AbstractDispatcher`, `DSIKeyPanelReplyService`) | Compatible |
| `/eso/bin/apps/dmdt`, `/dev/mlb/isoTX2`, videoovermost | Present |
| `libcarplay-security-bridge.so` fingerprint | Does not match (`HTTPConnectionCreate` moved). The bridge logs `patch_failed_fingerprint` to `/ramdisk/carplay_security_bridge/bridge.log` and passes through unchanged. It is observe-only, so this is expected and harmless. |

Mock install, repeat install, status, restore and refusal paths were tested with the factory MU1427 `lsd.sh` and `dio_manager` using [`tests/mock-install-test.sh`](../tests/mock-install-test.sh) (33/33 checks). Live-vehicle validation: 2026-10-13, MU1427 + VC 791, iPhone over USB.

固件识别条件：`/ifs/lsd.jxe` 精确大小为 **52,751,492 bytes**。目录内仅为 CarPlay Maps VC 独立项目文件，不含完整工具箱。
