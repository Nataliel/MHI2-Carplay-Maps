#!/bin/bash
# Offline test of a CarPlay Maps VC standalone profile against a mock MMX tree.
#
# Usage: tests/mock-install-test.sh PROFILE_DIR MU CLUSTER JXE_SIZE STOCK_LSD_SH [STOCK_DIO_MANAGER]
#   PROFILE_DIR        e.g. MU1427/791_AID12.3
#   STOCK_LSD_SH       the unit's factory /mnt/app/eso/hmi/lsd/lsd.sh (not shipped in this repo)
#   STOCK_DIO_MANAGER  optional factory dio_manager; a 600 KB dummy is used otherwise
#
# The installer runs with CPMAP_TEST_ROOT, so nothing outside the mock tree is touched.

set -u
PROFILE_DIR=$(cd "$1" && pwd); MU="$2"; CLUSTER="$3"; JXE_SIZE="$4"; STOCK_LSD="$5"; STOCK_DIO="${6:-}"
SHELL_BIN=$(command -v ksh || command -v bash)
WORK=$(mktemp -d "${TMPDIR:-/tmp}/cpmap-test.XXXXXX")
PASS=0; FAIL=0
ok()   { echo "  PASS  $1"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL  $1"; FAIL=$((FAIL+1)); }
check(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }
sha()  { sha1sum "$1" 2>/dev/null | cut -d' ' -f1; }

mkroot() {   # $1 = root, $2 = jxe size, $3 = lsd.sh source
    rm -rf "$1"
    mkdir -p "$1/ifs" "$1/ramdisk" "$1/mnt/app/eso/bin/apps" "$1/mnt/app/eso/hmi/lsd/jars"
    truncate -s "$2" "$1/ifs/lsd.jxe"
    if [ -n "$STOCK_DIO" ]; then cp "$STOCK_DIO" "$1/mnt/app/eso/bin/apps/dio_manager"
    else head -c 600000 /dev/urandom > "$1/mnt/app/eso/bin/apps/dio_manager"; fi
    chmod 755 "$1/mnt/app/eso/bin/apps/dio_manager"
    cp "$3" "$1/mnt/app/eso/hmi/lsd/lsd.sh"
}
run() { CPMAP_TEST_ROOT="$1" "$SHELL_BIN" "$PROFILE_DIR/install.sh" "${PAYLOAD:-$PROFILE_DIR/payload}" "$2" "$3" 2>&1; }
leftovers() { ls -d "$1"/mnt/app/.carplaymaps-* "$1"/ramdisk/.cpmap-* 2>/dev/null | wc -l; }

# Evaluate the BOOTCLASSPATH lines of a (patched) lsd.sh and print the effective value.
effective_bcp() {   # $1 = lsd.sh, $2 = DSITRACER_ACTIVATED (yes|no)
    # the lsd.sh region between the classpath setup and the production J9 launch
    awk '/^FIXBOOTCLASSPATH_EXT=/{on=1} on && /^\$J9 /{exit} on && !/^export LD_PRELOAD|^info /' "$1" > "$WORK/bcp.sh"
    mkdir -p "$WORK/hmi/lsd"; touch "$WORK/hmi/lsd/DSITracer.jar"   # so the DSITracer branch really runs
    BASE_DIR="$WORK/hmi" DSITRACER_ACTIVATED="$2" bash -c ". '$WORK/bcp.sh' 2>/dev/null; echo \"\$BOOTCLASSPATH\""
}

echo "Profile $PROFILE_DIR ($MU/$CLUSTER), shell $SHELL_BIN"
R="$WORK/root"
mkroot "$R" "$JXE_SIZE" "$STOCK_LSD"
LSD="$R/mnt/app/eso/hmi/lsd/lsd.sh"; DIO="$R/mnt/app/eso/bin/apps/dio_manager"
LSD0=$(sha "$LSD"); DIO0=$(sha "$DIO")

echo "[1] first install"
OUT=$(run "$R" "$MU" "$CLUSTER"); echo "$OUT" | sed 's/^/        /'
check "installer reports CPMAP_INSTALL_OK" 'echo "$OUT" | grep -q "^CPMAP_INSTALL_OK$"'
check "profile recorded as $MU/$CLUSTER" '[ "$(cat $R/mnt/app/carplaymaps/PROFILE)" = "$MU/$CLUSTER" ]'
check "dio_manager replaced by wrapper" 'cmp -s "$DIO" "$PROFILE_DIR/payload/common/dio_manager.wrapper.sh"'
check "factory dio_manager preserved" '[ "$(sha $R/mnt/app/carplaymaps/stock_first/dio_manager.real)" = "$DIO0" ]'
check "factory lsd.sh preserved" '[ "$(sha $R/mnt/app/carplaymaps/rollback/lsd.sh)" = "$LSD0" ]'
check "core.so is the $CLUSTER profile" 'cmp -s $R/mnt/app/carplaymaps/core.so "$PROFILE_DIR/payload/profiles/$MU/$CLUSTER/core.so"'
check "control JAR installed" 'cmp -s $R/mnt/app/eso/hmi/lsd/jars/CarPlayClusterControls.jar "$PROFILE_DIR/payload/common/CarPlayClusterControls.jar"'
check "exactly one JAR reference in lsd.sh" '[ $(grep -c CarPlayClusterControls.jar "$LSD") -eq 1 ]'
check "patched lsd.sh passes sh -n" 'sh -n "$LSD"'
check "no scratch dirs left" '[ $(leftovers "$R") -eq 0 ]'
echo "        lsd.sh diff:"; diff "$R/mnt/app/carplaymaps/rollback/lsd.sh" "$LSD" | sed 's/^/          /'
for t in no yes; do
    B=$(effective_bcp "$LSD" $t)
    echo "        effective BOOTCLASSPATH (DSITracer=$t): $B"
    check "JAR prepended via -Xbootclasspath/p (DSITracer=$t)" 'echo "$B" | grep -q -- " -Xbootclasspath/p:$WORK/hmi/lsd/jars/CarPlayClusterControls.jar$"'
    check "factory /a: classpath intact (DSITracer=$t)" 'echo "$B" | grep -q -- "^-Xbootclasspath/a:/ifs/lsd.jxe:"'
done

echo "[2] repeat install"
LSD1=$(sha "$LSD")
OUT=$(run "$R" "$MU" "$CLUSTER")
check "repeat install OK" 'echo "$OUT" | grep -q "^CPMAP_INSTALL_OK$"'
check "lsd.sh unchanged by repeat install" '[ "$(sha $LSD)" = "$LSD1" ]'
check "stock dio_manager still the factory binary" '[ "$(sha $R/mnt/app/carplaymaps/stock_first/dio_manager.real)" = "$DIO0" ]'
check "rollback lsd.sh still factory" '[ "$(sha $R/mnt/app/carplaymaps/rollback/lsd.sh)" = "$LSD0" ]'

echo "[3] status"
CPMAP_TEST_ROOT="$R" "$SHELL_BIN" "$PROFILE_DIR/status-carplay-maps.sh" | sed 's/^/        /'

echo "[4] restore"
OUT=$(CPMAP_TEST_ROOT="$R" "$SHELL_BIN" "$PROFILE_DIR/restore-carplay-maps.sh" 2>&1)
check "restore reports CPMAP_RESTORE_OK" 'echo "$OUT" | grep -q "^CPMAP_RESTORE_OK$"'
check "lsd.sh byte-identical to factory" '[ "$(sha $LSD)" = "$LSD0" ]'
check "dio_manager byte-identical to factory" '[ "$(sha $DIO)" = "$DIO0" ]'
check "control JAR removed" '[ ! -e $R/mnt/app/eso/hmi/lsd/jars/CarPlayClusterControls.jar ]'
check "runtime dir removed" '[ ! -e $R/mnt/app/carplaymaps ]'

echo "[5] wrong firmware (MU1367 size) is refused untouched"
mkroot "$R" 55840541 "$STOCK_LSD"; OUT=$(run "$R" "$MU" "$CLUSTER")
check "fails with PROFILE_MISMATCH" 'echo "$OUT" | grep -q "CPMAP_INSTALL_FAIL=PROFILE_MISMATCH_MU1367_EXPECTED_$MU"'
check "factory files untouched" '[ "$(sha $LSD)" = "$LSD0" ] && [ "$(sha $DIO)" = "$DIO0" ]'
check "no scratch dirs left" '[ $(leftovers "$R") -eq 0 ]'

echo "[6] unknown firmware size is refused"
mkroot "$R" 12345678 "$STOCK_LSD"; OUT=$(run "$R" "$MU" "$CLUSTER")
check "fails with UNSUPPORTED_JXE_SIZE" 'echo "$OUT" | grep -q "CPMAP_INSTALL_FAIL=UNSUPPORTED_JXE_SIZE_12345678"'

echo "[7] lsd.sh without a recognisable J9 launch is refused before any change"
grep -v '^\$J9 ' "$STOCK_LSD" > "$WORK/lsd-nolaunch.sh"
mkroot "$R" "$JXE_SIZE" "$WORK/lsd-nolaunch.sh"; L0=$(sha "$LSD"); OUT=$(run "$R" "$MU" "$CLUSTER")
check "fails with BOOTCLASSPATH_STRUCTURE_UNSUPPORTED" 'echo "$OUT" | grep -q "CPMAP_INSTALL_FAIL=BOOTCLASSPATH_STRUCTURE_UNSUPPORTED"'
check "factory files untouched" '[ "$(sha $LSD)" = "$L0" ] && [ "$(sha $DIO)" = "$DIO0" ] && [ ! -e $R/mnt/app/carplaymaps ]'
check "no scratch dirs left" '[ $(leftovers "$R") -eq 0 ]'

echo "[8] legacy layout (existing -Xbootclasspath/p: line) still uses the original patch"
{ grep -v '^\$J9 ' "$STOCK_LSD"; echo 'BOOTCLASSPATH="$BOOTCLASSPATH -Xbootclasspath/p:$BASE_DIR/lsd/jars/legacy.jar"'; grep '^\$J9 ' "$STOCK_LSD"; } > "$WORK/lsd-legacy.sh"
cp -R "$PROFILE_DIR/payload" "$WORK/payload"; mkdir -p "$WORK/payload/profiles/MU1367/791"
cp "$WORK/payload/profiles/$MU/$CLUSTER/core.so" "$WORK/payload/profiles/MU1367/791/core.so"
mkroot "$R" 55840541 "$WORK/lsd-legacy.sh"; OUT=$(PAYLOAD="$WORK/payload" run "$R" MU1367 791)
check "MU1367 install OK" 'echo "$OUT" | grep -q "^CPMAP_INSTALL_OK$"'
check "JAR inserted into the existing /p: line" 'grep -q "^BOOTCLASSPATH=\"\$BOOTCLASSPATH -Xbootclasspath/p:\$BASE_DIR/lsd/jars/CarPlayClusterControls.jar:\$BASE_DIR/lsd/jars/legacy.jar\"$" "$LSD"'
check "no extra line added" '[ $(wc -l < "$LSD") -eq $(wc -l < "$WORK/lsd-legacy.sh") ]'

rm -rf "$WORK"
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
