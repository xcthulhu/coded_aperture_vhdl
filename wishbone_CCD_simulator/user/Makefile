#
# Main Makefile for the Armadeus FPGA Wishbone example
#

PROGS=sxi_clocks_mmio #sxi_clocks
DEVEL_BASE=../..
CC=$(DEVEL_BASE)/armadeus/buildroot/build_armv5te/staging_dir/usr/bin/arm-linux-gcc

all: $(PROGS)

% : %.c
	$(CC) -o $@ $<

clean:
	rm $(PROGS)

include $(DEVEL_BASE)/install.mk
install: install_programs