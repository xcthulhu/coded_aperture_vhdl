#
# Makefile for the Armadeus Wb_button drivers
#

obj-m += board_buttons.o gbutton.o
MODULES=board_buttons.ko gbutton.ko

PWD:=$(shell pwd)
DEVEL_BASE:=$(PWD)/../..
KDIR=$(DEVEL_BASE)/armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/
ARMADEUS_TOOLCHAIN_PATH=$(DEVEL_BASE)/armadeus/buildroot/build_armv5te/staging_dir/usr/bin/

all : $(MODULES)

%.ko :
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

testbutton:
	$(ARMADEUS_TOOLCHAIN_PATH)/arm-linux-gcc testbutton.c -o testbutton

# Install the modules on the armadeus, by loading into the FPGA
-include $(DEVEL_BASE)/install.mk
install : install_modules

clean:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean
	rm -f Module.markers
	rm -f modules.order
	rm -f testbutton
