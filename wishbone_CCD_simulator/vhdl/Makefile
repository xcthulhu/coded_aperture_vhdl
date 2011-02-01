WORK = CCD
OBJS = common_decs.o intercon_decs.o data_bridge.o fifo.o wb_fifo.o sclk_data_acq.o irq_mngr.o wishbone_wrapper.o intercon.o rstgen_syscon.o top_mod.o
BITMAP=blink.bit
COMP=ghdl
VHDL_C=$(COMP) -a --work=$(WORK) --ieee=synopsys -fexplicit --warn-reserved --warn-default-binding --warn-binding --warn-library --warn-vital-generic --warn-delayed-checks --warn-body --warn-specs --warn-unused
VHDL_E=$(COMP) -e --work=$(WORK) 
VHDL_R=$(COMP) -r --work=$(WORK)
DEVEL_BASE=../..
RM=rm -f

#all: $(OBJS) $(PROGS) $(SIMS) $(BITMAP)
all: $(OBJS)

%.o : %.vhdl
	$(VHDL_C) $< 

# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=ccd_simulator
top_module=top_mod
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=top_mod.vhdl
include $(DEVEL_BASE)/xilinx.mk

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_bitmap

clean :
	# Clean GHDL products
	$(RM) $(OBJS) *.cf
