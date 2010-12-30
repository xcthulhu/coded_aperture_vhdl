OBJS = blink.o mask.o
PACKAGES = common_decs.o rom.o
PROGS = blink_tb mask_tb
SIMS = blink_tb.vcd mask_tb.vcd
GHDL = ghdl

all: $(PACKAGES) $(OBJS) $(PROGS) $(SIMS)

%.o : %.vhd
	$(GHDL) -a $< 

%.vcd : %
	$(GHDL) -r $< --vcd=$@

% : %.vhd
	$(GHDL) -a $<
	$(GHDL) -e $@

clean:
	rm -f *.o *.cf $(PROGS) *.vcd
	rm -rf work
	rm -f *~
