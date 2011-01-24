OBJS = data_wbs_bridge.o sclk_data_acq.o
PROGS = data_wbs_bridge_tb
SIMS = blink_tb.vcd
BITMAP=blink.bit
COMP=ghdl
VHDL_C=$(COMP) -a 
VHDL_E=$(COMP) -e
VHDL_R=$(COMP) -r
DEVEL_BASE=../../..
RM=rm -f
RMDIR=rm -rf

#all: $(OBJS) $(PROGS) $(SIMS) $(BITMAP)
all: $(OBJS)

%.o : %.vhdl
	$(VHDL_C) $< 

%_tb : %_tb.vhdl %.o
	$(VHDL_C) $<
	$(VHDL_E) $@

%_tb.vcd : %_tb %.o
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
	$(RM) -r work
	$(RM) *~
