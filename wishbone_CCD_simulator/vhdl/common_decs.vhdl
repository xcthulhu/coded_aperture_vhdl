library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package common_decs is
  
  constant chan_size : integer := 16;   -- Size of data channel
  subtype device_id is std_logic_vector(chan_size-1 downto 0);
  
  -- Wishbone Interface Signals
  type wbr is                                    -- Wishbone read system
  record
    readdata : std_logic_vector (chan_size-1 downto 0);  -- Data bus read by wishbone
    ack      : std_logic;  -- Acknowledge
  end record;

  type wbw is                                    -- Wishbone write system
  record
    strobe    : std_logic;                       -- Data Strobe
    writing   : std_logic;                       -- Busy writing
    cycle     : std_logic;                       -- Bus cycle in progress
    address   : std_logic_vector (12 downto 0);  -- Address bus
    writedata : std_logic_vector (chan_size-1 downto 0);  -- Data bus written by wishbone
  end record;

  -- Methods for checking for access to the wishbone bus
  ---- For wbw.writing = '0'
  function check_wb0 (wbw : wbw) return boolean ;
  ---- For wbw.writing = '1'
  function check_wb1 (wbw : wbw) return boolean ;
   -- i.MX Control Signals
   type imx_in is
   record
      address   : std_logic_vector(11 downto 0);  -- LSB not used 
      cs_n      : std_logic;
      oe_n      : std_logic;
      eb3_n     : std_logic;
   end record;
end package;

package body common_decs is
  function check_wb0(wbw : wbw) return boolean is
  begin return (wbw.strobe = '1' and wbw.cycle = '1' and wbw.writing = '0');
  end;

  function check_wb1 (wbw : wbw) return boolean is
  begin return (wbw.strobe = '1' and wbw.cycle = '1' and wbw.writing = '1');
  end;

end package body common_decs;
