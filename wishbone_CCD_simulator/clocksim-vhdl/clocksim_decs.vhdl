library IEEE;
use IEEE.std_logic_1164.all;

package clocksim_decs is
	subtype sig is std_logic_vector(15 downto 0); 
	constant P1V1   : sig := "0000000000000001";
	constant P2V1   : sig := "0000000000000010";
	constant P1VS   : sig := "0000000000000100";
	constant P2VS   : sig := "0000000000001000";
	constant TG     : sig := "0000000000010000";
	constant P1H    : sig := "0000000100000000";
	constant P3H    : sig := "0000001000000000";
	constant P2A4BH : sig := "0000010000000000";
	constant P4A2BH : sig := "0000100000000000";
	constant P2C4DH : sig := "0001000000000000";
	constant P4C2DH : sig := "0010000000000000";
	constant SG     : sig := "0100000000000000";
	constant SPARE  : sig := "1000000000000000";
end package;

package body clocksim_decs is
end package body;
