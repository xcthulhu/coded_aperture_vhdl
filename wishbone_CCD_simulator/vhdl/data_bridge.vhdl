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
    wr_en  : out std_logic;
    -- Data Input
    a, b   : in  std_logic_vector (7 downto 0);
    -- Data Output
    dout   : out std_logic_vector (chan_size-1 downto 0)
    );
end;

architecture RTU of data_bridge is
  -- Previous state of the STROBE pin according to the clk
  signal previous_STROBE : std_logic := STROBE;
begin
  strobe_emit : process(clk)
  begin
    if (rising_edge(clk)) then
      if (STROBE /= previous_STROBE) then  -- If change in STROBE value
        wr_en           <= '1';            -- Pulse a read instruction
        previous_STROBE <= STROBE;
      else
        wr_en <= '0';
      end if;
    end if;
  end process strobe_emit;
  dout <= a & b;
end;
