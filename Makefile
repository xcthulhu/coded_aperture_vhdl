OBJS = blink.o mask.o
PACKAGES = common_decs.o rom.o
C_LIBRARY = ./c_vhdl/c-obj
PROGS = blink_tb mask_tb
SIMS = blink_tb.vcd mask_tb.vcd
GHDL = ghdl

all: 
	$(MAKE) -C blink all
	$(MAKE) -C c_vhdl all
	$(MAKE) -C mask all

armadeus:
	git submodule init
	git submodule update
	$(MAKE) -C armadeus

clean:
	$(MAKE) -C blink clean
	$(MAKE) -C mask clean
	$(MAKE) -C c_vhdl clean
	$(MAKE) -C armadeus clean
