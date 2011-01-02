COMP=ghdl
C_VHDL=../c_vhdl/c-obj
VHDL_C=$(COMP) -a -P$(C_VHDL)
VHDL_E=$(COMP) -e -P$(C_VHDL)
VHDL_R=$(COMP) -r
PACKAGES=rom.o common_decs.o
OBJS=mask.o
PROGS=mask_tb
SIMS=mask_tb.vcd

all: $(C_VHDL) $(PACKAGES) $(OBJS) $(PROGS) $(SIMS)

$(C_VHDL):
	$(MAKE) -C ../c_vhdl all 

mask.o: mask.vhdl $(PACKAGES) 
	$(VHDL_C) $<

mask_tb: mask_tb.vhdl $(OBJS) $(PACKAGES) $(C_VHDL)
	$(VHDL_C) $<
	$(VHDL_E) $@

mask_tb.vcd: $(PROGS) $(OBJS) $(PACKAGES) $(C_VHDL)
	$(VHDL_R) $< --vcd=$@

%.o: %.vhdl
	$(VHDL_C) $<

clean:
	rm -f *.o *.cf $(PROGS) *.vcd
	rm -rf work
	rm -f *~
