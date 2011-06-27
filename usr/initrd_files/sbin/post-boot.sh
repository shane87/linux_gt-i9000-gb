#!/bin/sh

#create busybox symlinks
DIR=`pwd`
/voodoo/bin/remount_system_rw
if test -e /system/xbin/busybox; then
 cd /system/xbin
 for i in $(/system/xbin/busybox --list)
 do
  ln -s busybox $i
 done
 echo '/system/xbin/busybox ls -l $*' > /system/xbin/ll
 /system/xbin/busybox chmod +x /system/xbin/ll
 cd $DIR
fi
/voodoo/bin/remount_system_ro

# run the init.d scripts first, so that if anything in them conflicts with our
# settings, ours win ;)
/bin/sh /voodoo/scripts/run-parts.sh /system/etc/init.d

#clean up old cf-root tweak properties
/system/xbin/busybox rm /data/property/persist.tweak*
