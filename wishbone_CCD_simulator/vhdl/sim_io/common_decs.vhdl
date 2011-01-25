library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package common_decs is
  -- Wishbone Interface Signals
  type wbr is                                  -- Wishbone read system
  record
    readdata : std_logic_vector(15 downto 0);  -- Data bus read by wishbone
    ack      : std_logic;                      -- Acknowledge
  end record;

  type wbw is                                   -- Wishbone write system
  record
    strobe    : std_logic;                      -- Data Strobe
    writing   : std_logic;                      -- Busy writing
    cycle     : std_logic;                      -- Bus cycle in progress
    address   : std_logic_vector(12 downto 0);  -- Address bus
    writedata : std_logic_vector(15 downto 0);  -- Data bus for write access
  end record;

   -- i.MX Control Signals
   type imx_in is
   record
      address   : std_logic_vector(11 downto 0);  -- LSB not used 
      cs_n      : std_logic;
      oe_n      : std_logic;
      eb3_n     : std_logic;
   end record;

end package;
