MODULE=hello.ko
KDIR=../armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/

obj-m += hello.o

all : $(MODULE)

$(MODULE):
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean
	rm -f Module.markers modules.order

# Install the bitmap on the armadeus, by loading into the FPGA
IP=192.168.0.3
ETHERNET_DEVICE=eth2
install : $(MODULE)
	cp $(MODULE) /srv/tftp
	ifconfig $(ETHERNET_DEVICE) $(IP) up
	sed -e 's/MODULE/$(MODULE)/g' -e 's/IP/$(IP)/' ../kermit_module_install | kermit -q -y ../configs/kermrc -c
