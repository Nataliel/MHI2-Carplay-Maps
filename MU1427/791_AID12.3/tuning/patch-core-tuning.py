#!/usr/bin/env python3
"""Experimental stream tuning for the MU1427/791 core.so (cluster stream and turn card).

Input must be the AES-fixed MU1427 core.so (see ../patch-core-mu1427.py).
Each option rewrites one ARM `mov rX, #imm` immediate or the cluster URL string:

  --max-fps N         AirPlayCopyServerInfo @0x2a70: maxFPS advertised for the
                      cluster display (type 111). Stock 40. The iPhone delivered
                      ~25-27 fps in practice, so 30 costs nothing visible.
  --keyframe-interval N
                      passive_listener_thread @0x4370: core.so sends forceKeyFrame
                      whenever frame_count % N == 0. Stock 20 (1-2 IDRs per second).
                      @0x452c is the same constant passed to the
                      "alt-periodic-force-keyframe" log line; it is kept in sync.
                      The bridge still requests an IDR itself after latency recovery
                      (/ramdisk/carplay-alt-force-idr.request), independent of this.
  --cluster-content map|map-card
                      String @0x8130 (32 bytes), used both as the cluster display's
                      initialURL (AirPlayCopyServerInfo) and in the showUI command
                      (delayed_alt_activation_thread). Stock "map" =
                      maps:/car/instrumentcluster/map; "map-card" =
                      maps:/car/instrumentcluster, the map with Apple's turn card on it.
  --safe-area X,Y,W,H AirPlayCopyServerInfo create_area() for the cluster safeArea:
                      x @0x2ba4, y @0x2b94, w @0x2b98, h @0x2b9c, inside the 800x480
                      view area. Stock 160,20,480,440. The iPhone lays out the map,
                      car marker and turn card inside the safe area, so this moves
                      the card (and the map centre with it). Values must be ARM
                      rotated immediates (any 0..255, multiples of 4 up to 1020, ...).

Usage: patch-core-tuning.py [options] in.so out.so
"""
import argparse, hashlib, struct, sys

BASE_SHA = "46da26893c38367baa483f27ada72f601cc3d418e5b0fee21f7fe3cee88a6a35"

# file offset (== vaddr) -> stock instruction
MAX_FPS = [(0x2A70, 0xE3A02028)]                          # mov r2, #40
KEYFRAME = [(0x4370, 0xE3A02014), (0x452C, 0xE3A02014)]   # mov r2, #20 (check, log)
SAFE_AREA = [(0x2BA4, 0xE3A000A0),                        # x: mov r0, #160
             (0x2B94, 0xE3A01014),                        # y: mov r1, #20
             (0x2B98, 0xE3A02E1E),                        # w: mov r2, #480
             (0x2B9C, 0xE3A03F6E)]                        # h: mov r3, #440

URL_OFF, URL_LEN = 0x8130, 32
URLS = {"map": b"maps:/car/instrumentcluster/map",
        "map-card": b"maps:/car/instrumentcluster"}


def mov_imm(stock, value):
    """Re-encode the immediate of an ARM `mov rX, #imm` (imm8 rotated right by 2*rot)."""
    for rot in range(16):
        imm8 = ((value << 2 * rot) | (value >> (32 - 2 * rot))) & 0xFFFFFFFF if rot else value
        if imm8 <= 0xFF:
            return (stock & 0xFFFFF000) | (rot << 8) | imm8
    sys.exit("value %d is not an ARM rotated immediate" % value)


def safe_area(s):
    v = [int(x) for x in s.split(",")]
    if len(v) != 4 or v[0] + v[2] > 800 or v[1] + v[3] > 480 or min(v[2:]) < 1:
        raise argparse.ArgumentTypeError("X,Y,W,H must fit inside 800x480")
    return v


ap = argparse.ArgumentParser()
ap.add_argument("--max-fps", type=int)
ap.add_argument("--keyframe-interval", type=int)
ap.add_argument("--cluster-content", choices=sorted(URLS))
ap.add_argument("--safe-area", type=safe_area)
ap.add_argument("src")
ap.add_argument("dst")
a = ap.parse_args()

d = bytearray(open(a.src, "rb").read())
h = hashlib.sha256(d).hexdigest()
if h != BASE_SHA:
    sys.exit("unexpected core.so (sha256 %s), expected the AES-fixed MU1427 build" % h)

edits = [(MAX_FPS, [a.max_fps] * len(MAX_FPS)),
         (KEYFRAME, [a.keyframe_interval] * len(KEYFRAME)),
         (SAFE_AREA, a.safe_area or [None] * len(SAFE_AREA))]
for sites, values in edits:
    for (off, stock), value in zip(sites, values):
        assert struct.unpack_from("<I", d, off)[0] == stock, hex(off)
        if value is not None:
            struct.pack_into("<I", d, off, mov_imm(stock, value))

assert d[URL_OFF:URL_OFF + URL_LEN] == URLS["map"] + b"\0"
if a.cluster_content:
    d[URL_OFF:URL_OFF + URL_LEN] = URLS[a.cluster_content].ljust(URL_LEN, b"\0")

open(a.dst, "wb").write(d)
print("%s max_fps=%s keyframe_interval=%s cluster_content=%s safe_area=%s sha256=%s" % (
    a.dst, a.max_fps or 40, a.keyframe_interval or 20, a.cluster_content or "map",
    ",".join(map(str, a.safe_area or [160, 20, 480, 440])), hashlib.sha256(d).hexdigest()))
