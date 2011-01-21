#
# Makefile for the Armadeus FPGA led driver
#


obj-m+=board_leds.o g_led.o
MODULES=board_leds.ko g_led.ko

PWD:=$(shell pwd)
DEVEL_BASE:=$(PWD)/../..
KDIR=$(DEVEL_BASE)/armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/
ARMADEUS_TOOLCHAIN_PATH = $(DEVEL_BASE)/armadeus/buildroot/build_armv5te/staging_dir/usr/bin/

all: $(MODULES)

%.ko:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

testled:
	$(ARMADEUS_TOOLCHAIN_PATH)/arm-linux-gcc -Wall testled.c -o testled

-include $(DEVEL_BASE)/install.mk
install : install_modules

clean:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean 
	rm -f modules.order
	rm -f Module.symvers
	rm -f Module.markers
	rm -f testled
