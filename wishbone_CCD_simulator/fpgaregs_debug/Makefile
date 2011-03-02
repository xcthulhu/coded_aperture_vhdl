WORK = CCD
OBJS = common_decs.o top_mod.o
BITMAP=fpga_debug.bit
DEVEL_BASE=../../

# Read the following document for details about using the Xilinx unisim library and ghdl
# http://www.dossmatik.de/ghdl/ghdl_unisim_eng.pdf
UNISIM_VHDL=$(DEVEL_BASE)/unisim
UNISIM=$(UNISIM_VHDL)/unisim-obj93.cf

COMP=ghdl
VHDL_C=$(COMP) -a -g --work=$(WORK) -P$(UNISIM_VHDL) --ieee=synopsys -fexplicit --warn-reserved --warn-default-binding --warn-binding --warn-library --warn-vital-generic --warn-delayed-checks --warn-body --warn-specs --warn-unused
RM=rm -f

all: $(OBJS) $(BITMAP)

$(UNISIM) : 
	$(MAKE) -C $(UNISIM_VHDL) all

%.o : %.vhdl $(UNISIM)
	$(VHDL_C) $< 

# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=fpgaregs_debug
top_module=top_mod
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=common_decs.vhdl top_mod.vhdl
include $(DEVEL_BASE)/xilinx.mk

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_bitmap

clean :
	# Clean GHDL products
	$(RM) $(OBJS) *.cf
