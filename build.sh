# Script to build for the captivate and zip the package.
# Written by Evan alias ytt3r
# modified by kodos96

if ! [ -e .config ]; then
 make $1
fi

# Linaro Android 4.5 (GCC 4.5.4) toolchain - http://www.linaro.org
export CROSS_COMPILE="/opt/toolchains/android-toolchain-eabi-4.5/bin/arm-eabi-"

export KBUILD_BUILD_VERSION="0.5.1-RC1-talon-dev"

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

# Compile seperate overclock module, must be compiled with CodeSourcery 2009q3
# Make sure to replace the path for CROSS_COMPILE to match your location, also
# you need to set your path in sema_mod/Makefile to compile the module. 
cd sema_mod/
make ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-2009q3/bin/arm-none-eabi-
cp semaphore_oc.ko ../usr/initrd_files/lib/modules/
cd ..

make -j`grep 'processor' /proc/cpuinfo | wc -l`
cp arch/arm/boot/zImage releasetools
cd releasetools
rm -f *.zip
zip -r Talon *
cd ..
echo "Finished."
