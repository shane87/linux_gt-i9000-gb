# arch/arm/mach-s5pv210/Kconfig.talon
#
# Copyright 2011 existz
#	existz <robbeane@gmail.com>
#
# Licensed under GPLv2

menuconfig TALON
	bool "Talon Kernel Settings"
	default y

if TALON

config GALAXY_I897
       bool "select Captivate"
       depends on ARIES_EUR
       help
       Captivate specific settings

config S5P_BIGMEM
       bool "select Bigmem memory config"
       default n
       help 
         Enable 353MB memory config. Breaks 720p recording

config DISABLE_PRINTK
       bool "Disable Printk in Kernel"
       depends on EXPERIMENTAL
       help
         Disable printk completely in the kernel to reduce overhead

config GPU_OC
       bool "enable GPU Overclock"
       default n
       help 
         Enables GPU overclock for SGX540 (for future use)

endif
