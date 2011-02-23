OBJS = blink.o
PROGS = blink_tb
SIMS = blink_tb.vcd
BITMAP=blink.bit
DEVEL_BASE=../..
COMP=ghdl
VHDL_C=$(COMP) -i 

# Read the following document for details about using the Xilinx unisim library and ghdl
# http://www.dossmatik.de/ghdl/ghdl_unisim_eng.pdf
UNISIM_VHDL=$(DEVEL_BASE)/unisim
UNISIM=$(UNISIM_VHDL)/unisim-obj93.cf

VHDL_E=$(COMP) -m -g -P$(UNISIM_VHDL) --warn-unused --ieee=synopsys 

VHDL_R=$(COMP) -r
RM=rm -f
RMDIR=rm -rf

all: $(OBJS) $(PROGS) $(SIMS) $(BITMAP)

$(UNISIM) : 
	$(MAKE) -C ../unisim all

%.o : %.vhdl $(UNISIM)
	$(VHDL_C) $< 

blink_tb : blink_tb.vhdl blink.o
	$(VHDL_C) $<
	$(VHDL_E) $@

blink_tb.vcd : blink_tb blink.o
	$(VHDL_R) $< --vcd=$@

# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=blink
top_module=Clk_div_led
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=blink.vhdl
include $(DEVEL_BASE)/xilinx.mk

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_bitmap

clean :
	# Clean GHDL products
	$(RM) *.o *.cf $(PROGS) *.vcd
