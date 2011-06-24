#!/bin/sh

if [ -f /system/media/sanim.zip ]; then
/system/bin/bootanimation &
sleep 15
kill $!
else
/system/bin/samsungani
fi

