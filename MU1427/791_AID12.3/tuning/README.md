# MU1427 / 791: experimental stream tuning (fps drops, pixelation, turn card)

Experimental, not part of the installer. Each variant is the installed MU1427 `core.so` (sha256 `46da2689…`) with a few immediates or the cluster URL changed:

| Variant | maxFPS (cluster, type 111) | Forced keyframe every | Cluster content | Safe area (x,y,w,h) | sha256 |
| --- | --- | --- | --- | --- | --- |
| `stock` | 40 | 20 frames | map | 160,20,480,440 | `46da2689…` |
| `fps30` | 30 | 20 frames | map | 160,20,480,440 | `b04c09c0…` |
| `card` | 40 | 20 frames | map + turn card | 160,20,480,440 | `8ad2e770…` |
| `card-y120-w400` | 30 | 20 frames | map + turn card | 200,120,400,340 | `7afb2ae1…` |
| `card-y80-w400` | 30 | 20 frames | map + turn card | 200,80,400,380 | `3e617cae…` |
| `card-y88-w400` | 30 | 20 frames | map + turn card | 200,88,400,372 | `b1db56ce…` |
| `card-y96-w400` | 30 | 20 frames | map + turn card | 200,96,400,364 | `173eac54…` |

The table assumes these patch sites:

- **maxFPS:** `0x2a70` in `AirPlayCopyServerInfo`. It's advertised to the iPhone, which delivered about 25–27 fps in earlier logs.
- **Forced keyframe:** `0x4370` (the check) and `0x452c` (the log value) in `passive_listener_thread`. `core.so` sends `forceKeyFrame` whenever `frame_count % N == 0`.
  - The idea is that one or two full IDR frames per second cause bursts on MOST.
  - Bridge-requested IDRs after latency recovery are unaffected.
- **Cluster content:** the 32-byte string at `0x8130`. It is both the cluster display's `initialURL` and the URL in the `showUI` command that `delayed_alt_activation_thread` sends when the stream starts.
  - Stock is `maps:/car/instrumentcluster/map`.
  - `map-card` is `maps:/car/instrumentcluster`, which the iPhone renders as the map with Apple's turn card drawn on it.
  - A third URL, `maps:/car/instrumentcluster/instructioncard` (card only), doesn't fit in place and isn't offered.
  - The URLs come from the DiPlay project's notes ([PR #47](https://github.com/shihabal3amri/DiPlay/pull/47)), not from Apple documentation.
- **Safe area:** the cluster `safeArea` from `create_area()` in `AirPlayCopyServerInfo`: x at `0x2ba4`, y at `0x2b94`, w at `0x2b98`, h at `0x2b9c`, inside the 800×480 view area.
  - The iPhone lays out the map, the car marker and the turn card inside it, so changing it moves the card, and the map centre moves with it.
  - `card-full` opens it to the full frame, to see where the iPhone places the card when unconstrained.
  - Values must be ARM rotated immediates: any value from 0 to 255, multiples of 4 up to 1020, and so on. The script refuses anything else.

Build a variant: `python3 patch-core-tuning.py [--max-fps N] [--keyframe-interval N] [--cluster-content map|map-card] [--safe-area X,Y,W,H] ../payload/profiles/MU1427/791/core.so out.so`. The script refuses any other input file.

## Results so far (2026-10-13, iPhone19,2, iOS build 24A437)

- **Stream:** `fps30` gives no stuttering or lag. With `fps30-kf120`, a change of direction showed up too late on the map, so a keyframe every 20 frames stays. Neither drive logged a slow MOST write, and only 8–11 frames were dropped.
- **Turn card:** `card` shows the map with Apple's turn card hanging from the top-left of the safe area. The cluster's top status bar (clock, temperature) covers the card's first line.
  - `card-full` shows that the cluster only displays roughly the middle of the 800×480 frame: the card moves to the frame's top-left, behind the left dial.
- **Second drive:** `card-y120` (160,120,480,340) and `card-y120-w400` (200,120,400,340) both show the card fully, but too far below the top of the map. The narrower safe area gave a narrower card.
  - In the photos, the cockpit's map strip shows only about frame rows 80–400, cropped from the 800×480 frame. The scale is about 2.5 photo px per frame px, estimated from the width difference between the two cards.
  - That is why the stock safe-area top (y = 20) put the card's first line under the clock bar.
- **Next:** the `card-y80/88/96-w400` variants put the card's top just under the strip's top edge, with gaps of roughly 0–20 frame px.
- **Card size:** the iPhone decides it from the guidance content: start-of-route text, distance, lane guidance, a "then" maneuver. The receiver can't cap its height. Anchoring the card at the top lets extra rows grow down into the map.
- **Removed from the menu after testing:** `kf120`, `fps30-kf120`, `card-full`, `card-y120` and `card-y148`. They remain in git history and can be rebuilt with the script.

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
- the value logged with `alt-periodic-force-keyframe`;
- the `url` in the `showUI` command, and `safeArea` in the cluster display entry, both in `carplaymaps-video.log`.

For the turn-card variants, start navigation in Apple Maps and take photos of the cockpit display. They show where the card lands relative to the gauges and to what the cluster crops, which is what the next safe-area values depend on.

To revert, pick **Stock**. "Install 791" and "Restore factory files" also discard the tuning.
