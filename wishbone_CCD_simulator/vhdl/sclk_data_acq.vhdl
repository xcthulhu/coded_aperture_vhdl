library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_decs.all;

entity sclk_data_acq is
  port (
    -- Syscon system
    sysc       : in  syscon;
    -- A clock pin from LVDS
    SCLK       : in  std_logic;
    -- Data Input
    a_in, b_in : in  std_logic;
    -- Data Output
    a, b       : out std_logic_vector(7 downto 0)
    );
end;

architecture RTL of sclk_data_acq is
  -- Output values
  signal a_val, b_val : std_logic_vector(7 downto 0);
begin
  sclk_emit : process(sysc.clk, sysc.reset)
    -- Previous state of the SCLK pin according to the clk
    variable previous_SCLK : std_logic := '1';
  begin
    if (sysc.reset = '1') then
      previous_SCLK := '1';
      a_val         <= (others => '0');
      b_val         <= (others => '0');
    elsif rising_edge(sysc.clk) then
      if (SCLK /= previous_SCLK) then
        if (SCLK = '1') then            -- If "rising edge" of SCLK value
          a_val <= a_val(6 downto 0) & a_in;
          b_val <= b_val(6 downto 0) & b_in;
        end if;
        previous_SCLK := SCLK;
      end if;
    end if;
  end process;
  a <= a_val;
  b <= b_val;
end;
