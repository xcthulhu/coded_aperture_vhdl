OBJS = blink.o
PROGS = blink_tb
SIMS = blink_tb.vcd

all: $(OBJS) $(PROGS) $(SIMS)

%.o : %.vhd
	ghdl -a $<

%.vcd : %
	ghdl -r $< --vcd=$@ --stop-time=1000ns

% : %.vhd
	ghdl -a $<
	ghdl -e $@

clean:
	rm -f *.o *.cf $(PROGS) *.vcd
	rm -f work/*
	rm -f *~
