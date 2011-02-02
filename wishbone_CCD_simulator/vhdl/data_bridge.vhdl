library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

use work.common_decs.all;

entity data_bridge is
  port (
    sysc   : in  syscon;
    -- Strobe clock from physical pin on board
    STROBE : in  std_logic;
    -- Write instruction
    wr_en  : out std_logic := '0';
    -- Data Input
    a, b   : in  std_logic_vector (7 downto 0);
    -- Data Output
    dout   : out read_chan
    );
end;

architecture RTU of data_bridge is
-- Previous state of the STROBE pin according to the clk
-- Start high so wr_en doesn't accidentally get raised
begin
  strobe_emit : process(sysc.clk, sysc.reset)
    variable previous_STROBE : std_logic := '1';
  begin
    if (sysc.reset = '1') then
      wr_en           <= '0';
      previous_STROBE := '1';
    elsif rising_edge(sysc.clk) then
      if (STROBE /= previous_STROBE and STROBE = '1') then  -- If rising edge on strobe
        wr_en <= '1';                   -- Pulse a read instruction
      else
        wr_en <= '0';
      end if;
      previous_STROBE := STROBE;
    end if;
  end process strobe_emit;
  dout <= a & b;
end;
