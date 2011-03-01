OBJS = common_decs.o ../vhdl/common_decs.o ../vhdl/sclk_data_acq.o ../vhdl/data_bridge.o ../vhdl/fifo.o ../vhdl/rstgen_syscon.o  #../vhdl/intercon_decs.o wb_fifo.o irq_mngr.o wishbone_wrapper.o intercon.o top_mod.o
PROGS = clocksim i_tb ii_tb iii_tb iv_tb v_tb
SIMS = clocksim.dat i_tb.vcd ii_tb.vcd iii_tb.vcd iv_tb.vcd v_tb.vcd
COMP=ghdl
C_VHDL=../../c_vhdl/c-obj/
CCD_VHDL=../vhdl/
UNISIM_VHDL=../../unisim/
UNISIM=$(UNISIM_VHDL)/unisim-obj93.cf
VHDL_C=$(COMP) -i --ieee=synopsys -fexplicit -P$(C_VHDL) -P$(CCD_VHDL) -P$(UNISIM_VHDL)
VHDL_E=$(COMP) -m -g --warn-unused --ieee=synopsys -fexplicit -P$(C_VHDL) -P$(CCD_VHDL) -P$(UNISIM_VHDL)
VHDL_R=$(COMP) -r
RM=rm -f
RMDIR=rm -rf
CC=gcc -Wall

all: $(OBJS) $(PROGS) $(SIMS)

clocksim : clocksim.c
	$(CC) $< -o $@

$(C_VHDL) :
	$(MAKE) -C $(shell dirname $(C_VHDL)) all

$(UNISIM) :
	$(MAKE) -C $(UNISIM_VHDL) all

clocksim.dat : clocksim
	./$< | tail -n +2 > $@

../vhdl/%.o : ../vhdl/%.vhdl $(UNISIM)
	$(MAKE) -C $(CCD_VHDL) $(shell basename $@)

%.o : %.vhdl $(UNISIM)
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
