XILINX = /opt/Xilinx/12.3/ISE_DS/ISE/
UNISIM_VHDL = $(XILINX)/vhdl/src/unisims/*.vhd 
UNISIM_PRIMITIVE_VHDL = $(XILINX)/vhdl/src/unisims/primitive/*.vhd
COMP=ghdl
WORK=unisim
VHDL_C=$(COMP) -i --work=$(WORK) 
RM=rm -f

all: UNISIM

UNISIM : $(UNISIM_VHDL) $(UNISIM_PRIMITIVE_VHDL)
	$(VHDL_C) $(UNISIM_VHDL)
	$(VHDL_C) $(UNISIM_PRIMITIVE_VHDL)

clean :
	# Clean GHDL products
	$(RM) *.o *.cf 
