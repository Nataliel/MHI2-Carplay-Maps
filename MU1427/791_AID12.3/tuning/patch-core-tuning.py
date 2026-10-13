#!/usr/bin/env python3
"""Experimental stream tuning for the MU1427/791 core.so (cluster fps drops / pixelation).

Input must be the AES-fixed MU1427 core.so (see ../patch-core-mu1427.py).
Two immediates can be changed, each one ARM `mov rX, #imm8` (1..255):

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

Usage: patch-core-tuning.py [--max-fps N] [--keyframe-interval N] in.so out.so
"""
import argparse, hashlib, struct, sys

BASE_SHA = "46da26893c38367baa483f27ada72f601cc3d418e5b0fee21f7fe3cee88a6a35"

# file offset (== vaddr) -> (stock instruction, register field for the rebuilt mov)
MAX_FPS = [(0x2A70, 0xE3A02028)]                          # mov r2, #40
KEYFRAME = [(0x4370, 0xE3A02014), (0x452C, 0xE3A02014)]   # mov r2, #20 (check, log)


def mov_imm(stock, value):
    if not 1 <= value <= 255:
        sys.exit("value %d out of range 1..255" % value)
    return (stock & 0xFFFFF000) | value


ap = argparse.ArgumentParser()
ap.add_argument("--max-fps", type=int)
ap.add_argument("--keyframe-interval", type=int)
ap.add_argument("src")
ap.add_argument("dst")
a = ap.parse_args()

d = bytearray(open(a.src, "rb").read())
h = hashlib.sha256(d).hexdigest()
if h != BASE_SHA:
    sys.exit("unexpected core.so (sha256 %s), expected the AES-fixed MU1427 build" % h)

for sites, value in ((MAX_FPS, a.max_fps), (KEYFRAME, a.keyframe_interval)):
    for off, stock in sites:
        assert struct.unpack_from("<I", d, off)[0] == stock, hex(off)
        if value is not None:
            struct.pack_into("<I", d, off, mov_imm(stock, value))

open(a.dst, "wb").write(d)
print("%s max_fps=%s keyframe_interval=%s sha256=%s" % (
    a.dst, a.max_fps or 40, a.keyframe_interval or 20, hashlib.sha256(d).hexdigest()))
