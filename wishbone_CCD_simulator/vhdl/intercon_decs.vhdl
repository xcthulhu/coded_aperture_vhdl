library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

package intercon_decs is
  constant topb  : integer := 12;
  constant botb  : integer := 7;
  subtype topsix is std_logic_vector(topb downto botb);
  constant irqa  : topsix  := "000000";
  constant fifoa : topsix  := "000001";

  -- Checks the wishbone bus to see if an address is selected
  function is_slctd (my_wbw : wbws; addr : topsix) return boolean;
end package;

package body intercon_decs is
  function is_slctd (my_wbw : wbws; addr : topsix) return boolean is
  begin return(my_wbw.address(topb downto botb) = addr); end;
end package body;
