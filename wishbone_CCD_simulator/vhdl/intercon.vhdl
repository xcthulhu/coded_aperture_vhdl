library IEEE;
use ieee.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.intercon_decs.all;
use work.common_decs.all;

entity intercon is
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
end entity intercon;

architecture RTL of intercon is
  signal dead : wbrs;
begin
-- Clock and reset distribution. Maybe this doesn't belong here.
  irq_sysc  <= sysc;
  fifo_sysc <= sysc;
  wsysc     <= sysc;

-- Most data signals to slaves may be routed to all slaves, need no gating.
  irq_wbw.c  <= wwbw.c;
  fifo_wbw.c <= wwbw.c;

-- Gate strobe to slaves.
  irq_wbw.cycle  <= wwbw.cycle when is_slctd(wwbw, irqa)  else '0';
  fifo_wbw.cycle <= wwbw.cycle when is_slctd(wwbw, fifoa) else '0';

-- Multiplex data and ack from slaves.
-- Respond with 0xdead if no slave selected.
  dead.ack      <= wwbw.cycle;
  dead.readdata <= x"DEAD";
  wwbr          <= irq_wbr when is_slctd(wwbw, irqa)
                   else fifo_wbr when is_slctd(wwbw, fifoa)
                   else dead;

end architecture;
