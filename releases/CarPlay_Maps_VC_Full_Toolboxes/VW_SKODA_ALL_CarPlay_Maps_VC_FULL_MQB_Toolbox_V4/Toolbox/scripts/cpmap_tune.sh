#!/bin/ksh
# CarPlay Maps VC - switch the installed core.so between the default and its tuning options.
# Usage: cpmap_tune.sh <default|no-card|wide-card|low-card|stock-40fps>  (called by cpmap_tune_*.sh)
# Profiles: MU1427/791 and MU1367/790. low-card and stock-40fps exist for MU1367/790 only.
# Variants are read from SD: Custom/carplay_maps_vc/tuning/<MU>/<cluster>/<variant>/core.so
# Takes effect after a full unit reboot. Collect diagnostics BEFORE rebooting.

VARIANT="$1"

fail() {
    echo "CPMAP_TUNE_FAIL=$1"
    exit 1
}

[ -n "$VARIANT" ] || fail "NO_VARIANT"

if [ -n "${CPMAP_TEST_ROOT:-}" ] && [ -d "$CPMAP_TEST_ROOT/mnt/app" ] && [ -s "$CPMAP_TEST_ROOT/ifs/lsd.jxe" ]; then
    MMX="$CPMAP_TEST_ROOT"
elif [ -d /mnt/app ] && [ -s /ifs/lsd.jxe ]; then
    MMX=""
elif [ -d /net/mmx/mnt/app ] && [ -s /net/mmx/ifs/lsd.jxe ]; then
    MMX="/net/mmx"
else
    fail "MMX_FILESYSTEM_NOT_FOUND"
fi

ROOT="$MMX/mnt/app/carplaymaps"
[ -s "$ROOT/core.so" ] || fail "CARPLAY_MAPS_VC_NOT_INSTALLED"
PROFILE=`cat "$ROOT/PROFILE" 2>/dev/null`
case "$PROFILE" in
    MU1427/791|MU1367/790) ;;
    *) fail "NO_TUNING_FOR_PROFILE_$PROFILE" ;;
esac

SRC=""
for medium in ${CPMAP_TEST_MEDIA:-/fs/sda0 /fs/sdb0 /net/mmx/fs/sda0 /net/mmx/fs/sdb0 /media/mp000 /media/mp001 /media/mp002}; do
    candidate="$medium/Custom/carplay_maps_vc/tuning/$PROFILE/$VARIANT/core.so"
    if [ -s "$candidate" ]; then
        SRC="$candidate"
        break
    fi
done
[ -n "$SRC" ] || fail "VARIANT_NOT_ON_SD_$VARIANT"

echo "CarPlay Maps VC - core tuning"
echo "Profile: $PROFILE"
echo "Variant: $VARIANT"

if [ -n "${CPMAP_TEST_ROOT:-}" ]; then
    :
elif [ -n "$MMX" ]; then
    on -f mmx mount -uw /mnt/app >/dev/null 2>&1 || fail "APP_REMOUNT_FAILED"
else
    mount -uw /mnt/app >/dev/null 2>&1 || fail "APP_REMOUNT_FAILED"
fi

# One-time backup of the core.so that was installed before the first swap.
if [ ! -s "$ROOT/core.so.pre-tuning" ]; then
    cp "$ROOT/core.so" "$ROOT/core.so.pre-tuning" || fail "BACKUP_FAILED"
fi

# dio_manager has core.so mapped: never rewrite it in place, rename over it.
cp "$SRC" "$ROOT/core.so.new" || fail "COPY_FAILED"
chmod 644 "$ROOT/core.so.new"
mv "$ROOT/core.so.new" "$ROOT/core.so" || fail "ACTIVATE_FAILED"

# Marker name is visible in the diagnostics "runtime files" listing.
rm -f "$ROOT"/CORE_VARIANT-* 2>/dev/null
touch "$ROOT/CORE_VARIANT-$VARIANT"
sync 2>/dev/null || true

echo "CPMAP_CORE_VARIANT=$VARIANT"
echo "CPMAP_TUNE_OK"
echo "A full unit reboot is required."
exit 0
