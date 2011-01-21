#
# Main Makefile for the Armadeus FPGA Wishbone example
#
# Part executed when called from kernel build system:

all:
	$(MAKE) -C vhdl all
	$(MAKE) -C wb_irq_mngr all
	$(MAKE) -C wb_button all
	$(MAKE) -C wb_led all

clean:
	$(MAKE) -C vhdl clean
	$(MAKE) -C wb_irq_mngr clean
	$(MAKE) -C wb_button clean
	$(MAKE) -C wb_led clean

install:
	$(MAKE) -C $(LINUX_DIR) SUBDIRS=$(PWD) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
