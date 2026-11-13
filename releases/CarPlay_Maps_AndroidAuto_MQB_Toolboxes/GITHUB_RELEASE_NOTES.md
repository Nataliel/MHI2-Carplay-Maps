# CarPlay Maps VC + Android Auto — Complete Toolbox Release / 完整工具箱发布（含 Android Auto）

Free and open-source community project, based on **omonob (QCDWJ)**'s CarPlay Maps VC and
**MacsInSpace**'s mib-cluster-map (GPL-3).<br>
基于 **omonob（QCDWJ）** 的 CarPlay Maps VC 和 **MacsInSpace** 的 mib-cluster-map（GPL-3）开发的免费开源社区项目。

## 中文

本 Release 提供可直接解压到 SD 卡根目录使用的**完整工具箱**，不是单独插件。CarPlay 地图保持不变；新增
一块独立的绿色工程菜单（Customization → Android Auto map on the cluster），可选安装 Android Auto 的
车机地图（同一仪表，一次只接一台手机）。

### 功能

- CarPlay 地图视频投屏到原厂液晶仪表，方向盘短按放大/缩小、长按切换地图（MU1367，791 AID 12.3）。
- 弯道转向卡片（curva a curva）显示在仪表地图下方。
- 可选：接入 Android 手机时，Google Maps / Waze 的 Android Auto 地图显示在同一块仪表上（CarPlay 安装
  不受影响）。安装/卸载/状态都在绿色菜单里，自动备份受保护的 CarPlay 文件，任何文件被改动都会自动撤销。
- 明文运行目录：<code>/mnt/app/carplaymaps</code>（CarPlay）、<code>Custom/android_auto_map/</code>
  （Android Auto）。

### 不包含

- 音乐信息、封面、仪表自带箭头显示的转向引导（转向引导通过 CarPlay 卡片呈现）。
- Android Auto 第三方应用 <code>gal.json</code> 补丁（工厂版 MQB Toolbox 自带的 "AndroidAuto
  Customization" 菜单，本包未包含，与本功能无关）。
- 设备绑定加密、K1/K2、密码或 <code>shadow</code> 修改；NAVDB 文件操作或 250 ms 守护进程。

### 安装

1. 解压到 SD 卡根目录（Mac 上先执行 <code>dot_clean</code>）。
2. 插卡，走正常的软件更新流程（长按 MENU → Software update → 选择卡）。
3. CarPlay 和之前一样自动可用；要开启 Android Auto 地图，进入绿色菜单
   **Customization → Android Auto map on the cluster (keeps CarPlay)**，运行 **Install**，重启。

安装前请核对固件（MU1367）和仪表（791 AID 12.3），保持稳定供电，并使用
<code>FULL_TOOLBOX_SHA256.txt</code> 校验下载文件。

## English

This Release contains a **complete toolbox distribution** that can be extracted directly to the
SD-card root. It is not a standalone add-on archive. The CarPlay map is unchanged; a separate green
engineering-menu screen (Customization → Android Auto map on the cluster) lets you optionally install
the Android Auto cluster map as well (same display, one phone at a time).

### Features

- CarPlay map video on the factory virtual cockpit; short steering-wheel press for zoom, long press for
  map switching (MU1367, 791 AID 12.3).
- Turn-by-turn card drawn under the cluster map.
- Optional: with an Android phone connected, the Google Maps / Waze Android Auto map shows on the same
  cluster (the CarPlay installation is not affected). Install/uninstall/status live in the green menu;
  it backs up the protected CarPlay files and undoes everything automatically if any of them change.
- Plaintext runtime under <code>/mnt/app/carplaymaps</code> (CarPlay) and
  <code>Custom/android_auto_map/</code> (Android Auto).

### Excluded

- Music metadata, cover art, and lane guidance drawn by the cockpit's own arrows (turn guidance comes
  from the CarPlay card instead).
- The stock MQB Toolbox "AndroidAuto Customization" screen (a third-party app `gal.json` patch) is not
  included in this package — it is unrelated to the Android Auto map feature above.
- Device-bound encryption, K1/K2, password or <code>shadow</code> changes; NAVDB operations and the
  250 ms watchdog.

### Installation

1. Extract to the SD-card root (run `dot_clean` first on a Mac).
2. Insert the card and run the normal software update (hold MENU → Software update → select the card).
3. CarPlay works automatically as before; to enable the Android Auto map, open the green menu
   **Customization → Android Auto map on the cluster (keeps CarPlay)**, run **Install**, then reboot.

Confirm the firmware (MU1367) and cluster (791 AID 12.3), maintain stable power, and verify the
download with <code>FULL_TOOLBOX_SHA256.txt</code>.

This independent project is not affiliated with or endorsed by Volkswagen AG, Škoda Auto, Apple Inc. or
Google LLC. Third-party components (omonob's CarPlay Maps VC, MacsInSpace's mib-cluster-map) retain
their original GPLv3 licenses and ownership.
