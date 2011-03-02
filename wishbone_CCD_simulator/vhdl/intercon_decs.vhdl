library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

package intercon_decs is
  constant topb  : integer := 7;
  constant botb  : integer := 2;
  subtype idaddr is std_logic_vector(topb downto botb);
  constant irqa  : idaddr  := "000000";
  constant fifoa : idaddr  := "000001";

  -- Checks the wishbone bus to see if an address is selected
  function is_slctd (my_wbw : wbws; addr : idaddr) return boolean;
end package;

package body intercon_decs is
  function is_slctd (my_wbw : wbws; addr : idaddr) return boolean is
  begin return(my_wbw.c.address(topb downto botb) = addr); end;
end package body;
