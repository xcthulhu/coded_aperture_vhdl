#
# Makefile for SXI driver sim
#

PWD:=$(shell pwd)
DEVEL_BASE:=$(PWD)/../..

KDIR=$(DEVEL_BASE)/armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/

obj-m += irq_ocore.o sxi_sd.o
irq_ocore-objs  := irq_mngr.o
sxi_sd-objs := sxi_sim_driver.o
MODULES=irq_ocore.ko sxi_sd.ko

all : $(MODULES)

%.ko :
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean
	rm -f Module.markers modules.order

-include $(DEVEL_BASE)/install.mk
install : install_modules
