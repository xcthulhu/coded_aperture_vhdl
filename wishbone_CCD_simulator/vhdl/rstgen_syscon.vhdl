---------------------------------------------------------------------------
-- Company     : ARMadeus Systems
-- Author(s)   : Fabien Marteau
-- 
-- Creation Date : 05/03/2008
-- File          : rstgen_syscon.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity rstgen_syscon is
  generic (
    invert_reset : std_logic := '0'     -- 0 : not invert, 1 invert
    );
  port (
    clk   : in  std_logic;
    reset : out std_logic
    );
end entity;

architecture rstgen_syscon_1 of rstgen_syscon is
  signal dly       : std_logic := '0';
  signal rst       : std_logic := '0';
  signal ext_reset : std_logic;

begin
  ext_reset <= '0';

  process(clk)
  begin
    if(rising_edge(clk)) then
      -- Behavior of this loop: 
      -- (0th cycle) Everything starts off zero
      -- (1st cycle) dly = '0' and rst = '1'
      -- (2nd cycle) dly = '1' and rst = '0'
      -- (forever after) same as 2nd cycle ; it's a fixpoint
      dly <= not(ext_reset) and (dly xor rst);
      rst <= (not(ext_reset) and not(dly) and not(rst));
    end if;
  end process;

  reset <= rst xor invert_reset;
  
end architecture rstgen_syscon_1;
