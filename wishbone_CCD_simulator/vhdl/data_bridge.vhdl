library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

use work.common_decs.all;

entity data_bridge is
  port (
    -- Global clock
    clk    : in  std_logic;
    -- Strobe clock from physical pin on board
    STROBE : in  std_logic;
    -- Write instruction
    wr_en  : out std_logic := '0';
    -- Data Input
    a, b   : in  std_logic_vector (7 downto 0);
    -- Data Output
    dout   : out std_logic_vector (chan_size-1 downto 0)
    );
end;

architecture RTU of data_bridge is
  -- Previous state of the STROBE pin according to the clk
  -- Start high so wr_en doesn't accidentally get raised
  signal previous_STROBE : std_logic := '1';
begin
  strobe_emit : process(clk)
  begin
    if (rising_edge(clk)) then
      if (STROBE /= previous_STROBE and STROBE='1') then       -- If rising edge on strobe
        wr_en           <= '1'; -- Pulse a read instruction
      else
        wr_en <= '0';
      end if;
      previous_STROBE <= STROBE;
    end if;
  end process strobe_emit;
  dout <= a & b;
end;
