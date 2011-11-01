# Script to build for the captivate and zip the package.
# Written by Evan alias ytt3r
# modified by kodos96

if ! [ -e .config ]; then
 make $1
fi

# Linaro Android 4.5 (GCC 4.5.4) toolchain - http://www.linaro.org
#export CROSS_COMPILE="/opt/toolchains/android-toolchain-eabi-4.5/bin/arm-eabi-"
#^^^Not needed, I export CROSS_COMPILE before begining work, and this undoes my changes

export KBUILD_BUILD_VERSION="s87-t7-talon-dev"
#changed to my personal build version

#export LOCALVERSION="-I9000XWJVB-CL118186"
#export LOCALVERSION="-I9000XWJVH-CL184813"
#export LOCALVERSION="-I9000XXJVP-CL264642"
#export LOCALVERSION="-I9000XXJVQ-CL281085"
#export LOCALVERSION="-I9000XXJVR-CL425308"
#export LOCALVERSION="-I9000XXJVS-CL565837" 
export LOCALVERSION="-I9000XXJVT-CL617736"

export INSTALL_MOD_PATH=./mod_inst
make modules -j`grep 'processor' /proc/cpuinfo | wc -l`
make modules_install

if [ -e ./usr/initrd_files/lib/modules ]; then
 rm -rf ./usr/initrd_files/lib/modules
fi

mkdir -p ./usr/initrd_files/lib/modules

for i in `find mod_inst -name "*.ko"`; do
 cp $i ./usr/initrd_files/lib/modules/
done

rm -rf ./mod_inst
unzip ./usr/prebuilt_ko.zip -d ./usr/initrd_files/lib/modules/

cd drivers/misc/samsung_modemctl
make
cd ../../..

make -j`grep 'processor' /proc/cpuinfo | wc -l`
cp arch/arm/boot/zImage releasetools
cd releasetools
rm -f *.zip
zip -r Talon *
cd ..
echo "Finished."
