OBJS = blink.o
PROGS = blink_tb
SIMS = blink_tb.vcd
COMP=ghdl
VHDL_C=$(COMP) -a 
VHDL_E=$(COMP) -e
VHDL_R=$(COMP) -r


all: $(OBJS) $(PROGS) $(SIMS)

%.o : %.vhdl
	$(VHDL_C) $< 

blink_tb : blink_tb.vhdl blink.o
	$(VHDL_C) $<
	$(VHDL_E) $@

blink_tb.vcd : blink_tb blink.o
	$(VHDL_R) $< --vcd=$@

clean:
	rm -f *.o *.cf $(PROGS) *.vcd
	rm -rf work
	rm -f *~
