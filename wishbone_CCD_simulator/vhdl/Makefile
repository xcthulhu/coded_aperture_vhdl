# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=wishbone_CCD_simulator
top_module=top_wishbone_example
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=button.vhd  intercon.vhd  irq_mngr.vhd  led.vhd  rstgen_syscon.vhd  top_wishbone_example.vhd  wishbone_wrapper.vhd
PWD:=$(shell pwd)
DEVEL_BASE:=$(PWD)/../..
include $(DEVEL_BASE)/xilinx.mk

BITMAP=$(project).bit
all: $(BITMAP)

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_bitmap

# Clean up (in case you were foolish enough to call the fucking ISE)
RMDIR=rm -rf
RM=rm -f
clean :
	# Clean GHDL products
	$(RM) *.o *.cf $(PROGS) *.vcd
	$(RM) -r work
	$(RM) *~
