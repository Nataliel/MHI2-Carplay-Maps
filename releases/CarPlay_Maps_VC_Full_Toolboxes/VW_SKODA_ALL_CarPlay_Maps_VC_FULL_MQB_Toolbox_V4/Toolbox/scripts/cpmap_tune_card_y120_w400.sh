#!/bin/ksh

SCRIPTS=/mnt/app/eso/hmi/engdefs/scripts/mqb
[ -s "$SCRIPTS/cpmap_tune.sh" ] || SCRIPTS=/net/mmx/mnt/app/eso/hmi/engdefs/scripts/mqb
/bin/ksh "$SCRIPTS/cpmap_tune.sh" card-y120-w400
exit $?
