OBJS = rstgen_syscon.o common_decs.o clocksim_decs.o clocksim.o top_mod.o
PROGS = clocksim_tb
SIMS = clocksim_tb.vcd
BITMAP=#clocksim.bit
DEVEL_BASE=../..
COMP=ghdl
VHDL_C=$(COMP) -i -P$(UNISIM_VHDL)

# Read the following document for details about using the Xilinx unisim library and ghdl
# http://www.dossmatik.de/ghdl/ghdl_unisim_eng.pdf
UNISIM_VHDL=$(DEVEL_BASE)/unisim
UNISIM=$(UNISIM_VHDL)/unisim-obj93.cf

# C Library for VHDL
C_VHDL=../../c_vhdl/c-obj/

VHDL_E=$(COMP) -m -g -P$(UNISIM_VHDL) -P$(C_VHDL) --warn-unused --ieee=synopsys 

VHDL_R=$(COMP) -r
RM=rm -f
RMDIR=rm -rf

all: $(OBJS) $(PROGS) $(SIMS) $(BITMAP)

$(UNISIM) : 
	$(MAKE) -C $(UNISIM_VHDL) all

$(C_VHDL) :
	$(MAKE) -C $(shell dirname $(C_VHDL)) all

%.o : %.vhdl $(UNISIM) $(C_VHDL)
	$(VHDL_C) $< 

%_tb : %_tb.vhdl %.o
	$(VHDL_C) $<
	$(VHDL_E) $@

%_tb.vcd : %_tb %.o
	$(VHDL_R) $< --vcd=$@

# Make instructions creating a bitmap from xilinx synthesis tools
# adapted from http://www.excamera.com/sphinx/fpga-makefile.html
project=blink
top_module=clocksim
vendor=xilinx
family=spartan3s
part=xc3s200a-4ft256
files=clocksim.vhdl
include $(DEVEL_BASE)/xilinx.mk

# Install the bitmap on the armadeus, by loading into the FPGA
include $(DEVEL_BASE)/install.mk
install : install_bitmap

clean :
	# Clean GHDL products
	$(RM) *.o *.cf $(PROGS) *.vcd
