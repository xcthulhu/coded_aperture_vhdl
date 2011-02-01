library IEEE;
use ieee.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.intercon_decs.all;
use work.common_decs.all;

entity intercon is
  port
    (
      -- Global Signals
      clk   : in std_logic;
      reset : in std_logic;

      -- IRQ signals
      irq_wbr   : in  wbr;
      irq_wbw   : out wbw;
      irq_clk   : out std_logic;
      irq_reset : out std_logic;

      -- FIFO signals
      fifo_wbr   : in  wbr;
      fifo_wbw   : out wbw;
      fifo_clk   : out std_logic;
      fifo_reset : out std_logic;

      -- Wishbone Wrapper
      ---- These are what we are multiplexing
      gwbr          : out wbr;
      gwbw          : in  wbw;
      wrapper_clk   : out std_logic;
      wrapper_reset : out std_logic
      );
end entity intercon;

architecture RTL of intercon is
  signal dead : wbr;
begin
-- Clock and reset distribution. Maybe this doesn't belong here.
  wrapper_clk   <= clk;
  irq_clk       <= clk;
  fifo_clk      <= clk;
  wrapper_reset <= reset;
  irq_reset     <= reset;
  fifo_reset    <= reset;

-- Most data signals to slaves may be routed to all slaves, need no gating.
  irq_wbw  <= gwbw;
  fifo_wbw <= gwbw;

-- Gate strobe to slaves.
  irq_wbw.cycle <= gwbw.cycle when is_slctd(gwbw, irqa)
                   else '0';
  fifo_wbw.cycle <= gwbw.cycle when is_slctd(gwbw, fifoa)
                    else '0';

-- Multiplex data and ack from slaves.
-- Respond with 0xdead if no slave selected.
  dead.ack      <= gwbw.cycle;
  dead.readdata <= x"DEAD";
  gwbr          <= irq_wbr when is_slctd(gwbw, irqa)
                   else fifo_wbr when is_slctd(gwbw, fifoa)
                   else dead;

end architecture;
