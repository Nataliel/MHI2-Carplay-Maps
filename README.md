<div align="center">

# CarPlay Maps VC for MHI2

**Bring the factory CarPlay map video to Volkswagen and Skoda virtual cockpits.**

[![Release](https://img.shields.io/github/v/release/tomasz-twardzicki/MHI2-Carplay-Maps?display_name=tag&style=flat-square)](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/latest)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue?style=flat-square)](LICENSE)
![Platform](https://img.shields.io/badge/platform-MHI2%20%2F%20QNX%206.5-2f6f9f?style=flat-square)
![Profiles](https://img.shields.io/badge/profiles-MU1102%20%7C%20MU1367%20%7C%20MU1427%20%7C%20MU1440-green?style=flat-square)

[Downloads](#downloads) · [Latest release](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/latest)

**Author: [omonob (汽车大玩家)](https://github.com/omonob)**

</div>

---

## Overview

CarPlay Maps VC is a free and open-source community project for Volkswagen and Skoda MHI2 systems. It sends the CarPlay map video to the factory virtual cockpit and adds steering-wheel map controls.

The public release uses the validated V70 display/control behavior as a fixed baseline and provides two complete installation routes:

- **MQB Toolbox interactive package**: detects the MU firmware automatically; the user selects the cluster type.
- **M.I.B. Toolbox automatic package**: each archive is locked to one MU/cluster profile and runs through the SWDL workflow.

## Included

- CarPlay map video on the factory virtual cockpit.
- Short steering-wheel press for map zoom in/out.
- Long steering-wheel press for map-view switching.
- MU1427 / 791 only: Apple Maps' turn card (next maneuver and distance), drawn by the iPhone on the cluster map. In the MQB Toolbox, Customization → CarPlay Maps VC → carplay-maps-vc-tuning switches between the default narrow card, a wide card and map only.
- Exact MU1102, MU1367, MU1427 and MU1440 firmware gates.
- Factory-file rollback evidence captured during installation.
- Status, repeat-install and factory-restore paths.
- Plaintext runtime under <code>/mnt/app/carplaymaps</code>.

## Not included

- Music metadata or cover art.
- Navigation text, road names, maneuver or lane guidance in the cockpit's own display (VW-style arrows). The MU1427 turn card above is part of the CarPlay video.
- Startup animation.


## Display profiles

| Cluster | Fixed display behavior | Steering-wheel control |
| --- | --- | --- |
| 791/794 AID 12.3 | 30 fps, navigation centered | Short press zoom; long press map switch |
| 790 AID 10.5 | 30 fps, non-navigation centered, navigation right | Short press zoom; long press map switch |

## Compatibility

| Firmware | Exact lsd.jxe size | 791/794 AID 12.3 | 790 AID 10.5 |
| --- | ---: | :---: | :---: |
| MU1102 | 55,915,411 bytes | ✅ | ✅ |
| MU1367 | 55,840,541 bytes | ✅ | ✅ |
| MU1427 | 52,751,492 bytes | ✅ (MQB Toolbox / standalone) | ❌ |
| MU1440 Skoda | 55,840,933 bytes | ❌ | ✅ |

Unknown file sizes and unsupported cluster combinations stop before factory files are changed.

## Downloads

Download complete, ready-to-extract toolbox distributions and extract each archive directly to the SD-card root:

| Package | Supports | Download |
| --- | --- | --- |
| **MQB Toolbox V4.2A** (release [`toolbox-plaintext-v1.2.0`](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/tag/toolbox-plaintext-v1.2.0)) | MU1102, MU1367, MU1427 (791 only), MU1440; choose 791 or 790 in the menu | [CarPlay_Maps_VC_FULL_MQB_Toolbox_V4.2A.zip](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.2.0/CarPlay_Maps_VC_FULL_MQB_Toolbox_V4.2A.zip) |
| M.I.B. Toolbox 3.6.0: MU1102 / 791/794 | MU1102 + 791/794 AID 12.3 | [upstream release](https://github.com/omonob/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.0.0/VW_MU1102_791.794_CarPlay_Maps_VC_FULL_MIB_Toolbox_3.6.0.zip) |
| M.I.B. Toolbox 3.6.0: MU1102 / 790 | MU1102 + 790 AID 10.5 | [upstream release](https://github.com/omonob/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.0.0/VW_MU1102_790_CarPlay_Maps_VC_FULL_MIB_Toolbox_3.6.0.zip) |
| M.I.B. Toolbox 3.6.0: MU1367 / 791/794 | MU1367 + 791/794 AID 12.3 | [upstream release](https://github.com/omonob/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.0.0/VW_MU1367_791.794_CarPlay_Maps_VC_FULL_MIB_Toolbox_3.6.0_MU1367_791.zip) |
| M.I.B. Toolbox 3.6.0: MU1367 / 790 | MU1367 + 790 AID 10.5 | [upstream release](https://github.com/omonob/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.0.0/VW_MU1367_790_CarPlay_Maps_VC_FULL_MIB_Toolbox_3.6.0.zip) |
| M.I.B. Toolbox 3.6.0: MU1440 / 790 Skoda | MU1440 Skoda + 790 AID 10.5 | [upstream release](https://github.com/omonob/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.0.0/SKODA_MU1440_790_CarPlay_Maps_VC_FULL_MIB_Toolbox_3.6.0.zip) |

The MQB Toolbox package is the only one that includes the MU1427 fixes (the cluster-stream `core.so` fix and the MU1427 "Ignore navigation-active" patch). The M.I.B. packages are omonob's original `toolbox-plaintext-v1.0.0` builds and don't support MU1427.

Verify downloads with the [SHA-256 manifest](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.2.0/FULL_TOOLBOX_SHA256.txt). It covers the MQB package above.

For manual integration into an existing toolbox, use the standalone project files stored directly in this repository. They are separated by firmware and cluster and **do not include a complete toolbox**:

| Firmware / cluster | Standalone files |
| --- | --- |
| MU1102 / 791/794 AID 12.3 | [`MU1102/791_AID12.3`](./MU1102/791_AID12.3/) |
| MU1102 / 790 AID 10.5 | [`MU1102/790_AID10.5`](./MU1102/790_AID10.5/) |
| MU1367 / 791/794 AID 12.3 | [`MU1367/791_AID12.3`](./MU1367/791_AID12.3/) |
| MU1367 / 790 AID 10.5 | [`MU1367/790_AID10.5`](./MU1367/790_AID10.5/) |
| MU1427 / 791/794 AID 12.3 | [`MU1427/791_AID12.3`](./MU1427/791_AID12.3/) |
| MU1440 Skoda / 790 AID 10.5 | [`MU1440_SKODA/790_AID10.5`](./MU1440_SKODA/790_AID10.5/) |

Each directory contains only the matching installer, shared runtime files, profile-specific `core.so`, status script, and factory-restore script. Most users should download the full toolbox archives above.

## Optional paid support

The open-source CarPlay Maps VC map-video and steering-control portion in this repository remains **free of charge**. The author does not sell the open-source package as a paid product, and downloading, using, or exercising the rights granted by GPLv3 does not require a purchase.

Users who want additional functions or wish to support continued development may choose a separate paid service: **¥399 RMB (approximately US$60)**. The USD figure is an estimate based on the [ECB reference rates for 30 September 2026](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html); the actual converted amount may vary.

<p align="center">
  <a href="https://www.goofish.com/item?id=1076254792602"><img src="./assets/optional-paid-support-goofish.png" alt="CarPlay Maps VC optional paid support" width="620"></a>
</p>

[**View the optional paid service on Goofish**](https://www.goofish.com/item?id=1076254792602)

The paid option includes:

1. Exclusive model-specific startup logo customization for all Volkswagen and Skoda vehicle models.
2. CarPlay navigation information mapped to the instrument cluster.
3. CarPlay music information mapped to the instrument cluster.
4. Smoothness optimization for 791/794 clusters.
5. Navigation-centering optimization for the 790 cluster.
6. Ongoing research and possible future support for factory wireless CarPlay. This feature is still under evaluation, is not currently guaranteed to be available, and has no fixed delivery date.

> [!NOTE]
> This is a separate feature and technical-support service, not a license fee for the open-source software. Confirm the exact firmware, cluster and supported scope on the product page before purchasing.

## Installation route A: MQB Toolbox

1. Download the full MQB Toolbox archive.
2. Extract its contents directly to the SD-card root.
3. Insert the card and open MQB Toolbox.
4. Go to <code>Customization → CarPlay Maps VC</code>.
5. Select the 791 or 790 installer.
6. The toolbox detects the MU and stops on an incompatible selection.
7. After <code>CPMAP_INSTALL_OK</code>, exit the toolbox and perform one full unit reboot.
8. Connect the iPhone and verify map video and steering-wheel controls.

The MQB menu also includes status and factory-restore actions. A full reboot is required after restoration.

## Installation route B: M.I.B. Toolbox

1. Download exactly one archive matching the MU and cluster.
2. Extract that archive directly to the root of a dedicated SD card.
3. Never merge files from two profile archives.
4. Insert the card and start/restart the unit.
5. SWDL performs the original M.I.B. backup and Launcher installation before CarPlay Maps VC.
6. Keep stable power and do not remove the card during the update.
7. Allow M.I.B./SWDL to complete its normal reboot, then remove the card and test CarPlay.

## Development stack

- QNX Neutrino 6.5 / ARMv7 runtime target.
- KornShell and POSIX shell for install, status, restore and automation.
- Java/JAR integration for steering-wheel map controls.
- MQB Toolbox GEM/ESD menu integration.
- M.I.B. 3.6.0 SWDL/Launcher integration.
- PowerShell for complete-toolbox assembly, archives, SHA-256 manifests and QA.
- Git and GitHub Releases for versioning and distribution.

## Build and verification status

The 2026-09-30 release build passed offline first-install, repeat-install, factory-restore and wrong-profile-stop tests for all five package profiles. Shell syntax, M.I.B. metadata checksums, ELF headers, JAR integrity, ASCII/LF requirements, complete ZIP reads and SHA-256 hashes were checked.

MU1427 with 791 AID 12.3 was validated in a vehicle on 2026-10-13 (iPhone over USB): the CarPlay map shows in the virtual cockpit, and the MU1427 "Ignore navigation-active" patch works alongside it. See [`MU1427/README.md`](./MU1427/README.md). Other firmware/cluster combinations still require independent live-vehicle validation. Compressed 790 and 791 demonstration videos will be added in a later Release update.

## Open-source notice

- Maintainer and author: **omonob (QCDWJ)**.
- Original integration scripts, build logic and documentation in this repository are licensed under [GNU GPL v3](LICENSE).
- GPL-covered redistribution must preserve attribution and license terms and provide corresponding source as required by GPLv3.
- MQB Toolbox, M.I.B. 3.6.0, Volkswagen, Skoda, Apple CarPlay and other third-party components, names and trademarks remain the property of their respective owners.
- Bundling a complete toolbox is for a ready-to-use SD-card layout; upstream files and license notices must remain intact.
- GPLv3 does not relicense third-party firmware, toolbox or vendor components.
- No unit-specific passwords, private keys, K1/K2, <code>shadow</code>, NAVDB ciphertext or vehicle-bound data are published.

## Safety and disclaimer

Writing infotainment files carries a boot-failure risk. Confirm the exact firmware and cluster, maintain stable power and keep a tested recovery route. Do not install or debug while driving.

This independent community project is not affiliated with or endorsed by Volkswagen AG, Skoda Auto or Apple Inc. It is provided as-is, without warranty.

---

<div align="center">

Free and open-source CarPlay Maps VC project by **omonob (QCDWJ)**.

</div>
