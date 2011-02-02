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
use work.common_decs.all;

entity rstgen_syscon is
  generic (
    invert_reset : std_logic := '0'     -- '0' : not invert, '1' invert
    );
  port (
    clk   : in  std_logic;
    sysc : out syscon
    );
end entity;

architecture RTL of rstgen_syscon is
  signal dly       : std_logic := '0';
  signal rst       : std_logic := '0';
begin
  process(clk)
  begin
    if(rising_edge(clk)) then
      -- Behavior of this loop: 
      -- (0th cycle) Everything starts off zero
      -- (1st cycle) dly = '0' and rst = '1'
      -- (2nd cycle) dly = '1' and rst = '0'
      -- (forever after) same as 2nd cycle ; it's a fixpoint
      dly <= dly xor rst;
      rst <= not (dly or rst);
    end if;
  end process;
  sysc.clk <= clk;
  sysc.reset <= rst xor invert_reset; -- Negates rst iff invert_reset is '1'
end architecture;
