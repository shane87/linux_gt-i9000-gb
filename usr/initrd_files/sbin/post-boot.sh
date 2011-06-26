#!/bin/sh

# run the init.d scripts first, so that if anything in them conflicts with our
# settings, ours win ;)
/bin/sh /voodoo/scripts/run-parts.sh /system/etc/init.d

