#!/bin/sh
#
# This is a wrapper for xz to compress the kernel image using appropriate
# compression options depending on the architecture.
#
# Author: Lasse Collin <lasse.collin@tukaani.org>
#
# This file has been put into the public domain.
# You can do whatever you want with this file.
#

BCJ=
LZMA2OPTS=

case $ARCH in
	x86|x86_64)     BCJ=--x86 ;;
	powerpc)        BCJ=--powerpc ;;
	ia64)           BCJ=--ia64; LZMA2OPTS=pb=4 ;;
	arm)            BCJ=--arm ;;
	sparc)          BCJ=--sparc ;;
esac

exec xz --check=crc32 $BCJ --lzma2=dict=32MiB
#My build environment does not have/need any lzma2opts, and the empty string causes build issues, so remove the empty veriable
