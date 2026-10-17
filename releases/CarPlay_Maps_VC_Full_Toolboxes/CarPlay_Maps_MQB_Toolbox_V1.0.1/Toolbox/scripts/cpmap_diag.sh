#!/bin/ksh
# CarPlay Maps VC - collect runtime diagnostics to the SD card.
# Read-only on the unit: nothing on the MMX is modified.

M=/net/mmx
[ -d "$M/mnt/app" ] || M=""

echo "CarPlay Maps VC - collect diagnostics"

VOL=""
for v in /net/mmx/fs/sda0 /net/mmx/fs/sdb0 /fs/sda0 /fs/sdb0; do
    if [ -d "$v" ]; then VOL="$v"; break; fi
done
if [ -z "$VOL" ]; then
    echo "FAIL: no SD card found"
    exit 1
fi
mount -uw "$VOL" >/dev/null 2>&1

STAMP=`date +%Y%m%d-%H%M%S 2>/dev/null`
[ -n "$STAMP" ] || STAMP=$$
OUT="$VOL/Log/cpmap-diag-$STAMP"
mkdir -p "$OUT/ramdisk" || { echo "FAIL: cannot write to $VOL"; exit 1; }

ROOT="$M/mnt/app/carplaymaps"
APP="$M/mnt/app"

proc_list() {
    pidin -F "%a %N" 2>/dev/null || pidin -n mmx -F "%a %N" 2>/dev/null || pidin 2>/dev/null
}

{
    echo "=== date";            date
    echo "=== lsd.jxe";         ls -ln "$M/ifs/lsd.jxe"
    echo "=== VERSION/PROFILE"; cat "$ROOT/VERSION" "$ROOT/PROFILE"
    echo "=== runtime files";   ls -lnR "$ROOT"
    echo "=== dio_manager";     ls -ln "$APP/eso/bin/apps/dio_manager"*
    echo "=== dio_manager head (should be the wrapper script)"
    head -n 5 "$APP/eso/bin/apps/dio_manager"
    echo "=== lsd.sh JAR reference"
    grep -n 'CarPlayClusterControls' "$APP/eso/hmi/lsd/lsd.sh"
    echo "=== control JAR";     ls -ln "$APP/eso/hmi/lsd/jars/CarPlayClusterControls.jar"
    echo "=== ramdisk listing"; ls -ln "$M/ramdisk" | grep -i -E 'carplay|altscreen|cpmap'
    echo "=== processes (carplay / dio / lsd)"
    proc_list | grep -i -E 'dio_manager|carplay|altscreen|supervisor|pairing|j9|lsd'
    echo "=== dio_manager environment"
    pidin -p dio_manager.real env 2>/dev/null || pidin -p dio_manager env 2>/dev/null
    echo "=== MOST device nodes"
    ls -ln /dev/mlb 2>/dev/null; ls -ln "$M/dev/mlb" 2>/dev/null
} > "$OUT/summary.txt" 2>&1

# Runtime logs and captures (skip the large shared video ring buffer).
for f in "$M"/ramdisk/carplay* "$M"/ramdisk/altscreen* "$M"/ramdisk/cpmap*; do
    [ -e "$f" ] || continue
    case "$f" in
        *carplay-alt-ring.bin) continue ;;
    esac
    cp -r "$f" "$OUT/ramdisk/" 2>/dev/null
done

sloginfo > "$OUT/sloginfo.txt" 2>&1

sync 2>/dev/null
mount -ur "$VOL" >/dev/null 2>&1
echo "Diagnostics written to:"
echo "  $OUT"
echo "CPMAP_DIAG_OK"
exit 0
