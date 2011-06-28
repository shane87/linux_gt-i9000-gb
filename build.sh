# Script to build for the captivate and zip the package.
# Written by Evan alias ytt3r
# modified by kodos96

if ! [ -e .config ]; then
 make $1
fi

export KBUILD_BUILD_VERSION="0.2.1-talon-dev"

#export LOCALVERSION="-I9000XWJVB-CL118186"
#export LOCALVERSION="-I9000XWJVH-CL184813"
#export LOCALVERSION="-I9000XXJVP-CL264642"
export LOCALVERSION="-I9000XXJVQ-CL281085"

export INSTALL_MOD_PATH=./mod_inst
make modules -j`grep 'processor' /proc/cpuinfo | wc -l`
make modules_install

if [ -e ./usr/initrd_files/lib/modules ]; then
 rm -rf ./usr/initrd_files/lib/modules
fi

mkdir ./usr/initrd_files/lib/modules

for i in `find mod_inst -name "*.ko"`; do
 cp $i ./usr/initrd_files/lib/modules/
done

rm -rf ./mod_inst
unzip ./usr/prebuilt_ko.zip -d ./usr/initrd_files/lib/modules/

make -j`grep 'processor' /proc/cpuinfo | wc -l`
cp arch/arm/boot/zImage releasetools
cd releasetools
rm -f *.zip
zip -r Talon *
cd ..
echo "Finished."
