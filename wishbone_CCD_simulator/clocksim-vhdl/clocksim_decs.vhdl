library IEEE;
use IEEE.std_logic_1164.all;

package clocksim_decs is
  subtype sig is std_logic_vector(15 downto 0);
  constant P1VI   : natural := 0;
  constant P2VI   : natural := 1;
  constant P1VS   : natural := 2;
  constant P2VS   : natural := 3;
  constant TG     : natural := 4;
  constant P1H    : natural := 8;
  constant P3H    : natural := 9;
  constant P2A4BH : natural := 10;
  constant P4A2BH : natural := 11;
  constant P2C4DH : natural := 12;
  constant P4C2DH : natural := 13;
  constant SG     : natural := 14;
  constant SPARE  : natural := 15;

  type MODE_TYPE is (PIXEL, PIXEL_MAYBE, DOWN,
                     FRAME, ROW, READOUT);
  constant STACK_SIZE    : natural := 4;
  type MODE_STACK is array (0 to STACK_SIZE-1) of MODE_TYPE;
end package;
