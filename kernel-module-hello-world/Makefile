MODULES=hello.ko
DEVEL_BASE=..
KDIR=$(DEVEL_BASE)/armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/

obj-m += hello.o

all : $(MODULES)

%.ko:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean
	rm -f Module.markers modules.order

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_modules
