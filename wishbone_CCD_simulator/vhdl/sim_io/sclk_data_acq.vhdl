library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sclk_data_acq is
  port (
    -- Global clock
    clk : in  std_logic ;
    -- A clock pin from LVDS
   SCLK : in  std_logic ;
    -- Data Input
   a_in, b_in : in  std_logic ;
   -- Data Output
   a,b  : out std_logic_vector(7 downto 0)
    );
end sclk_data_acq;

architecture sclk_data_acq_1 of sclk_data_acq is
  -- Previous state of the SCLK pin according to the clk
  signal previous_SCLK : std_logic;
  -- Output values
  signal a_val , b_val : std_logic_vector(7 downto 0);
begin
  sclk_emit : process(clk)
  begin
    if (rising_edge(clk)) then
      if (SCLK /= previous_SCLK) then   -- If "rising edge" of SCLK value
        if (SCLK = '1') then
          a_val <= a_val(7 downto 1) & a_in;
          b_val <= b_val(7 downto 1) & b_in;
        end if;
        previous_SCLK <= SCLK;
      end if;
    end if;
  end process;
  a <= a_val;
  b <= b_val;
end;
