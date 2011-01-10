COMP=ghdl
C_VHDL=../c_vhdl/c-obj
VHDL_C=$(COMP) -a -P$(C_VHDL)
VHDL_E=$(COMP) -e -P$(C_VHDL)
VHDL_R=$(COMP) -r
PACKAGES=rom.o common_decs.o
OBJS=mask.o
PROGS=mask_tb
SIMS=mask_tb.vcd mask_tb.out mask_tb.pdf

all: $(C_VHDL) garrett $(PACKAGES) $(OBJS) $(PROGS) $(SIMS)

$(C_VHDL):
	$(MAKE) -C ../c_vhdl all 

garrett:
	$(MAKE) -C garrett all

mask.o: mask.vhdl $(PACKAGES) 
	$(VHDL_C) $<

mask_tb: mask_tb.vhdl $(OBJS) $(PACKAGES) $(C_VHDL)
	$(VHDL_C) $<
	$(VHDL_E) $@

mask_tb.vcd: mask_tb $(PROGS) $(OBJS) $(PACKAGES) $(C_VHDL)
	$(VHDL_R) $< --vcd=$@ > $<.out

mask_tb.out: mask_tb.vcd

mask_tb.pdf: mask_tb.out
	./python/bar.py $< $@

%.o: %.vhdl
	$(VHDL_C) $<

clean:
	$(MAKE) -C garrett clean
	rm -f *.o *.cf $(PROGS) *.vcd *.pdf *.out
	rm -rf work
	rm -f *~
