library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

use work.common_decs.all;

entity data_bridge is
  port (
    -- Global clock
    clk                    : in  std_logic;
    -- Strobe clock from physical pin on board
   STROBE                 : in  std_logic ;
    -- Data Input
   a, b                   : in  std_logic_vector(7 downto 0) ;
    -- IRQ Flag
   irqport                    : out std_logic ;
    -- Wishbone Signals
   wbw : in wbw ;
   wbr : out wbr 
    );
end; 

architecture data_bridge_1 of data_bridge is
  -- Previous state of the STROBE pin according to the clk
  signal previous_STROBE : std_logic := STROBE;
begin
  strobe_emit : process(clk)
  begin
    if (rising_edge(clk)) then
      if (STROBE /= previous_STROBE) then  -- If change in STROBE value
        irqport             <= '1';            -- throw interupt
        previous_STROBE <= STROBE;
      else
        irqport <= '0';                        -- ...otherwise make interupt quiet
      end if;
    end if;
  end process strobe_emit;

  wb_interact : process(clk)
  begin
    if (rising_edge(clk)) then
      if(wbw.strobe = '1' and wbw.writing = '0' and wbw.cycle = '1') then
        -- If wishbone is ready, dump data
        wbr.ack      <= '1';
        wbr.readdata <= a & b;
      else
        -- Otherwise remain quiet
        wbr.ack      <= '0';
        wbr.readdata <= (others => '0');
      end if;
    end if;
  end process;
end;
