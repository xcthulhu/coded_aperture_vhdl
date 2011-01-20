MODULE=hello-1.ko

obj-m += hello-1.o

all : $(MODULE)

$(MODULE):
	make -C ../armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/ M=$(PWD) modules

clean:
	make -C ../armadeus/buildroot/project_build_armv5te/apf27/linux-2.6.29.6/ M=$(PWD) clean

# Install the bitmap on the armadeus, by loading into the FPGA
IP=192.168.0.3
ETHERNET_DEVICE=eth2
install : $(MODULE)
	cp $(MODULE) /srv/tftp
	ifconfig $(ETHERNET_DEVICE) $(IP) up
	sed -e 's/MODULE/$(MODULE)/g' -e 's/IP/$(IP)/' ../kermit_module_install | kermit -y ../configs/kermrc -c
