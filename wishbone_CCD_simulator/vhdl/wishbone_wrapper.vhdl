-------------------------------------------------------------------------------
--
--  File          :  wishbone_wrapper.vhd
--  Related files :  (none)
--
--  Author(s)     :  Fabrice Mousset (fabrice.mousset@laposte.net)
--  Project       :  i.MX wrapper to Wishbone bus
--
--  Creation Date :  2007/01/19
--
--  Description   :  This is the top file of the IP
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.common_decs.all;

entity wishbone_wrapper is
  port
    (
      -- Global Signals
      sysc     : in    syscon;
      -- i.MX Signals
      imx_data : inout imx_chan;
      imx      : in    imx_in;
      -- Wishbone interface signals
      wbr      : in    wbrs;
      wbw      : out   wbws
      );
---- Note : imx, wbr and wbw declared in common_decs
end entity;

architecture RTL of wishbone_wrapper is
  -- Control Signals
  signal writing   : std_logic;
  signal readf     : std_logic;
  signal strobe    : std_logic;
  signal writedata : write_chan;
  signal address   : addr;
begin
  -- Control Wiring
  strobe    <= not (imx.cs_n) and not(imx.oe_n and imx.eb3_n);
  writing   <= not (imx.cs_n or imx.eb3_n);
  readf     <= not (imx.cs_n or imx.oe_n);
  address   <= imx.address;
  writedata <= imx_data;

  -- Write Logic
  wbw.c.address   <= address   when (strobe = '1')  else (others => '0');
  wbw.c.writedata <= writedata when (writing = '1') else (others => '0');
  wbw.c.strobe    <= strobe;
  wbw.c.writing   <= writing;
  wbw.cycle       <= strobe;

  -- Read Logic
  imx_data <= wbr.readdata when (readf = '1') else (others => 'Z');

end architecture;
