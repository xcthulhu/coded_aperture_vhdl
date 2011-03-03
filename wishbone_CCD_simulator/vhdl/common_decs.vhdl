library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package common_decs is
  
  constant chan_size : natural := 16;   -- Size of data channel
  subtype device_id is std_logic_vector(chan_size-1 downto 0);
  subtype read_chan is std_logic_vector(chan_size-1 downto 0);
  subtype write_chan is std_logic_vector(chan_size-1 downto 0);
  subtype imx_chan is std_logic_vector(chan_size-1 downto 0);
  constant addr_size : natural := 12;   -- Size of address channel
  subtype addr is std_logic_vector(addr_size-1 downto 0);

  -- Syscon
  type syscon is
  record
    clk   : std_logic;                  -- Clock
    reset : std_logic;                  -- Asynchronous Reset
  end record;

  -- Wishbone Interface Signals
  type wbrs is                          -- Wishbone read system
  record
    readdata : read_chan;               -- Data bus read by wishbone
    ack      : std_logic;               -- Acknowledge
  end record;

  type wbws_common is        -- Common part of the wishbone write system
  record
    strobe    : std_logic;              -- Data Strobe
    writing   : std_logic;              -- Busy writing
    address   : addr;  -- Address bus
    writedata : write_chan;             -- Data bus written by wishbone    
  end record;

  type wbws is                          -- Wishbone write system
  record
    c     : wbws_common;
    cycle : std_logic;                  -- Bus cycle in progress
  end record;

  -- Methods for checking for access to the wishbone bus
  ---- For wbw.writing = '0'
  function check_wb0 (wbw : wbws) return boolean;
  ---- For wbw.writing = '1'
  function check_wb1 (wbw : wbws) return boolean;
  -- i.MX Control Signals

  -- Calculates minimum/maximum
  function minimum (a, b : natural) return natural;
  function maximum (a, b : natural) return natural;

  type imx_in is
  record
    address : addr;  -- LSB not used 
    cs_n    : std_logic;
    oe_n    : std_logic;
    eb3_n   : std_logic;
  end record;
end package;

package body common_decs is
  function check_wb0(wbw : wbws) return boolean is
  begin return (wbw.c.strobe = '1' and wbw.cycle = '1' and wbw.c.writing = '0');
  end;

  function check_wb1 (wbw : wbws) return boolean is
  begin return (wbw.c.strobe = '1' and wbw.cycle = '1' and wbw.c.writing = '1');
  end;

  function minimum (a, b : natural) return natural is
  begin
    if (a > b) then
      return b;
    else return a;
    end if;
  end;

  function maximum (a, b : natural) return natural is
  begin
    if (a < b) then
      return b;
    else return a;
    end if;
  end;
  
end package body common_decs;
