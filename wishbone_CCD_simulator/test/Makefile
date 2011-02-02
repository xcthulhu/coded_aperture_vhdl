OBJS = common_decs.o ../vhdl/common_decs.o ../vhdl/sclk_data_acq.o ../vhdl/data_bridge.o #../vhdl/intercon_decs.o fifo.o wb_fifo.o irq_mngr.o wishbone_wrapper.o intercon.o rstgen_syscon.o top_mod.o
PROGS = clocksim i_tb ii_tb
SIMS = clocksim.dat i_tb.vcd ii_tb.vcd
COMP=ghdl
C_VHDL=../../c_vhdl/c-obj/
CCD_VHDL=../vhdl/
VHDL_C=$(COMP) -a --ieee=synopsys -P$(C_VHDL) -P$(CCD_VHDL)
VHDL_E=$(COMP) -e --ieee=synopsys -P$(C_VHDL) -P$(CCD_VHDL)
VHDL_R=$(COMP) -r
RM=rm -f
RMDIR=rm -rf
CC=gcc -Wall

all: $(OBJS) $(PROGS) $(SIMS)

clocksim : clocksim.c
	$(CC) $< -o $@

clocksim.dat : clocksim
	./$< | tail -n +2 > $@

../vhdl/%.o : ../vhdl/%.vhdl
	$(MAKE) -C ../vhdl $(shell basename $@)

%.o : %.vhdl
	$(VHDL_C) $< 

%_tb : %_tb.vhdl
	$(VHDL_C) $<
	$(VHDL_E) $@

%_tb.vcd : %_tb
	$(VHDL_R) $< --stop-time=20000ns --vcd=$@ > /dev/null

clean :
	# Clean GHDL products
	$(RM) *.o *.cf $(PROGS) $(SIMS)
	$(RM) *~
