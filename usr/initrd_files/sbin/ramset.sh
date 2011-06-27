# RAMset - kodos
#
# This script configures, and provides configuration presets for a variety of android's
# RAM-related settings, including lowmemorykill thresholds, kernel swappiness, and 
# ZRAM/ZCACHE settings.
#
# Presets are defined/selected in /etc/ram.conf

source /sbin/ram.conf.default
RAM_CONF_VERSION_CURRENT=$RAM_CONF_VERSION
RAM_CONF_VERSION=0

/voodoo/bin/remount_system_rw

if [ ! -e /system/etc/ram.conf ]; then
 /bin/cp /sbin/ram.conf.default /system/etc/ram.conf
fi;

source /system/etc/ram.conf

if [ ! "$RAM_CONF_VERSION" == "$RAM_CONF_VERSION_CURRENT" ]; then
 /bin/rm /system/etc/lmk.conf
 /bin/rm /system/etc/zram.conf
 /bin/rm /data/property/persist.lmkset.preset
 /bin/cp /sbin/ram.conf.default /system/etc/ram.conf
 source /system/etc/ram.conf
fi;

/voodoo/bin/remount_system_ro

eval export set RAMSET_ADJ_1=\${"PRESET_${PRESET}_ADJ_1"}
eval export set RAMSET_ADJ_2=\${"PRESET_${PRESET}_ADJ_2"}
eval export set RAMSET_ADJ_3=\${"PRESET_${PRESET}_ADJ_3"}
eval export set RAMSET_ADJ_4=\${"PRESET_${PRESET}_ADJ_4"}
eval export set RAMSET_ADJ_5=\${"PRESET_${PRESET}_ADJ_5"}
eval export set RAMSET_ADJ_6=\${"PRESET_${PRESET}_ADJ_6"}
eval export set RAMSET_ADJ_7=\${"PRESET_${PRESET}_ADJ_7"}
eval export set RAMSET_ADJ_8=\${"PRESET_${PRESET}_ADJ_8"}
eval export set RAMSET_ADJ_9=\${"PRESET_${PRESET}_ADJ_9"}

eval export set RAMSET_MEM_1=\${"PRESET_${PRESET}_MEM_1"}
eval export set RAMSET_MEM_2=\${"PRESET_${PRESET}_MEM_2"}
eval export set RAMSET_MEM_3=\${"PRESET_${PRESET}_MEM_3"}
eval export set RAMSET_MEM_4=\${"PRESET_${PRESET}_MEM_4"}
eval export set RAMSET_MEM_5=\${"PRESET_${PRESET}_MEM_5"}
eval export set RAMSET_MEM_6=\${"PRESET_${PRESET}_MEM_6"}
eval export set RAMSET_MEM_7=\${"PRESET_${PRESET}_MEM_7"}
eval export set RAMSET_MEM_8=\${"PRESET_${PRESET}_MEM_8"}
eval export set RAMSET_MEM_9=\${"PRESET_${PRESET}_MEM_9"}

eval export set RAMSET_ADJ=\${"PRESET_${PRESET}_ADJ"}
eval export set RAMSET_MINFREE=\${"PRESET_${PRESET}_MINFREE"}

eval export set RAMSET_ZRAM_ENABLED=\${"PRESET_${PRESET}_ZRAM_ENABLED"}
eval export set RAMSET_SWAPPINESS=\${"PRESET_${PRESET}_SWAPPINESS"}
eval export set RAMSET_ZCACHE_MEMLIMIT=\${"PRESET_${PRESET}_ZCACHE_MEMLIMIT"}

setprop ro.FOREGROUND_APP_ADJ $RAMSET_ADJ_1
setprop ro.VISIBLE_APP_ADJ $RAMSET_ADJ_2
setprop ro.PERCEPTIBLE_APP_ADJ $RAMSET_ADJ_3
setprop ro.HEAVY_WEIGHT_APP_ADJ $RAMSET_ADJ_4
setprop ro.SECONDARY_SERVER_ADJ $RAMSET_ADJ_5
setprop ro.BACKUP_APP_ADJ $RAMSET_ADJ_6
setprop ro.HOME_APP_ADJ $RAMSET_ADJ_7
setprop ro.HIDDEN_APP_MIN_ADJ $RAMSET_ADJ_8
setprop ro.EMPTY_APP_ADJ $RAMSET_ADJ_9

setprop wifi.interface "eth0"

setprop ro.FOREGROUND_APP_MEM $RAMSET_MEM_1
setprop ro.VISIBLE_APP_MEM $RAMSET_MEM_2
setprop ro.PERCEPTIBLE_APP_MEM $RAMSET_MEM_3
setprop ro.HEAVY_WEIGHT_APP_MEM $RAMSET_MEM_4
setprop ro.SECONDARY_SERVER_MEM $RAMSET_MEM_5
setprop ro.BACKUP_APP_MEM $RAMSET_MEM_6
setprop ro.HOME_APP_MEM $RAMSET_MEM_7
setprop ro.HIDDEN_APP_MEM $RAMSET_MEM_8
setprop ro.EMPTY_APP_MEM $RAMSET_MEM_9

echo $RAMSET_ADJ > /sys/module/lowmemorykiller/parameters/adj
echo "1" > /proc/sys/vm/overcommit_memory
echo "4" > /proc/sys/vm/min_free_order_shift   
echo $RAMSET_MINFREE > /sys/module/lowmemorykiller/parameters/minfree

if [ $RAMSET_ZRAM_ENABLED == "1" ]; then
 if [ -e /lib/modules/lzo_compress.ko ]; then
   /bin/insmod /lib/modules/lzo_compress.ko
   /bin/insmod /lib/modules/lzo_decompress.ko
 fi;
 /bin/insmod /lib/modules/zram.ko num_devices=1
 /sbin/zramconfig /dev/block/zram0 --disksize_kb 262144
 /sbin/zramconfig /dev/block/zram0 --init
 mkswap /dev/block/zram0
 swapon /dev/block/zram0
fi;

echo $RAMSET_SWAPPINESS > /proc/sys/vm/swappiness
