library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package common_decs is
  function int_to_bit (i : integer) return std_logic;
end package;

package body common_decs is
  function int_to_bit (i : integer) return std_logic is
  begin return conv_std_logic_vector(i, 1)(0); end;
end package body common_decs;
