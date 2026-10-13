# MU1427 / 791: experimental stream tuning (fps drops, pixelation)

Experimental, not part of the installer. Each variant is the installed MU1427 `core.so` (sha256 `46da2689…`) with one or two immediates changed:

| Variant | maxFPS (cluster, type 111) | Forced keyframe every | sha256 |
| --- | --- | --- | --- |
| `stock` | 40 | 20 frames | `46da2689…` |
| `fps30` | 30 | 20 frames | `b04c09c0…` |
| `kf120` | 40 | 120 frames | `da0debf0…` |
| `fps30-kf120` | 30 | 120 frames | `bbfa653e…` |

The table assumes these patch sites:

- **maxFPS:** `0x2a70` in `AirPlayCopyServerInfo`. It's advertised to the iPhone, which delivered about 25–27 fps in earlier logs.
- **Forced keyframe:** `0x4370` (the check) and `0x452c` (the log value) in `passive_listener_thread`. `core.so` sends `forceKeyFrame` whenever `frame_count % N == 0`.
  - The idea is that one or two full IDR frames per second cause bursts on MOST.
  - Bridge-requested IDRs after latency recovery are unaffected.

Build a variant: `python3 patch-core-tuning.py [--max-fps N] [--keyframe-interval N] ../payload/profiles/MU1427/791/core.so out.so`. The script refuses any other input file.

## Toolbox menu

The MQB Toolbox ships the variants on the SD card under `Custom/carplay_maps_vc/tuning/MU1427/791/<variant>/core.so`. To switch, go to **Customization > carplay-maps-vc > carplay-maps-vc-tuning** and pick a variant.

- The entry runs `cpmap_tune.sh`. It works only on an installed MU1427/791 profile.
- On the first swap it backs up the installed core as `/mnt/app/carplaymaps/core.so.pre-tuning`.
- It replaces `core.so` by renaming a new copy over it, never by rewriting it in place, because the running `dio_manager` has it mapped.
- It leaves a `CORE_VARIANT-<name>` marker file. "Show CarPlay Maps VC status" displays the active variant.

## Test procedure

Starting with **Stock** as the baseline, repeat for each variant:

1. Pick the variant in the tuning menu.
2. Reboot the unit.
3. Drive with the CarPlay map in the cockpit for a few minutes, using the same route or kind of map movement each time.
4. Run "Collect diagnostics to SD" before the next reboot, because the logs are in `/ramdisk`.

You can tell each dump's variant three ways:

- the `CORE_VARIANT-<name>` file in `summary.txt`;
- `maxFPS` in the cluster display entry of `carplaymaps-video.log`;
- the value logged with `alt-periodic-force-keyframe`.

To revert, pick **Stock**. "Install 791" and "Restore factory files" also discard the tuning.
