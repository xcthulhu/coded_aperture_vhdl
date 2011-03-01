library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

--library C;
--use C.stdio_h.all;

library CCD;
use CCD.common_decs.all;

use work.common_decs.all;

--  A testbench has no ports
entity V_tb is end;

architecture behav of V_tb is
  component intercon is
	  port
    (
      -- Global Signals
      sysc : in syscon;

      -- IRQ signals
      irq_wbr  : in  wbrs;
      irq_wbw  : out wbws;
      irq_sysc : out syscon;

      -- FIFO signals
      fifo_wbr  : in  wbrs;
      fifo_wbw  : out wbws;
      fifo_sysc : out syscon;

      -- Wishbone Wrapper
      ---- These are what we are multiplexing
      wwbr  : out wbrs;
      wwbw  : in  wbws;
      wsysc : out syscon
      );
  end component;
  for dut1   : intercon use entity CCD.intercon;
  signal sysc, irq_sysc, fifo_sysc, wsysc : syscon;
  signal irq_wbr, fifo_wbr, wwbr : wbrs;
  signal irq_wbw, fifo_wbw, wwbw : wbws;

  signal clk, reset : std_logic := '0';
begin
  sysc.clk <= clk;
  sysc.reset <= reset;
  
  dut1 : intercon
    port map (
	sysc => sysc, 
	irq_sysc => irq_sysc, 
	fifo_sysc => fifo_sysc, 
	wsysc => wsysc,
	irq_wbr => irq_wbr, 
	fifo_wbr => fifo_wbr,
	wwbr => wwbr,
	irq_wbw => irq_wbw,
	fifo_wbw => fifo_wbw, 
	wwbw => wwbw );

  process begin
	wait for 1 ns;
	reset <= '1';
	wait for 2 ns;
	reset <= '0';
	wait;
  end process;

  process
    constant the_end : integer := 10000;
    variable count   : integer;
  begin
    CLK <= '1';
    for count in 0 to the_end loop
      wait for 1 ns;
      clk <= not clk;
    end loop;
    wait;
  end process;
end;
