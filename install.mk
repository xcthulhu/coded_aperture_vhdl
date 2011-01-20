.PHONY=install_bitmap install_modules

IP=192.168.0.3
ETHERNET_DEVICE=eth2

install_bitmap : $(BITMAP)
	cp $(BITMAP) /srv/tftp
	ifconfig $(ETHERNET_DEVICE) $(IP) up
	sed -e 's/BITMAP/$(BITMAP)/g' -e 's/IP/$(IP)/' $(DEVEL_BASE)/kermit_fpga_install \
	| kermit -q -y $(DEVEL_BASE)/configs/kermrc -c

install_modules : $(MODULES)
	cp $(MODULES) /srv/tftp
	ifconfig $(ETHERNET_DEVICE) $(IP) up
	for i in $(MODULES) ; do \
		sed -e "s/MODULE/$$i/g" -e 's/IP/$(IP)/' $(DEVEL_BASE)/kermit_module_install \
		| kermit -q -y $(DEVEL_BASE)/configs/kermrc -c ; \
	done
