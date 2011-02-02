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
      sysc : in syscon;
      -- i.MX Signals
      imx_data : inout std_logic_vector(chan_size-1 downto 0);
      imx      : in    imx_in;
      -- Wishbone interface signals
      wbr      : in    wbrs;
      wbw      : out   wbws
      );
---- Note : imx, wbr and wbw declared in common_decs
end entity;

architecture RTL of wishbone_wrapper is
  signal writing   : std_logic;
  signal readf     : std_logic;
  signal strobe    : std_logic;
  signal writedata : std_logic_vector(chan_size-1 downto 0);
  signal address   : std_logic_vector(12 downto 0);
begin

-- ----------------------------------------------------------------------------
--  External signals synchronization process
-- ----------------------------------------------------------------------------
  process(sysc.clk, sysc.reset)
  begin
    if(sysc.reset = '1') then
      writing   <= '0';
      readf     <= '0';
      strobe    <= '0';
      writedata <= (others => '0');
      address   <= (others => '0');
    elsif (rising_edge(sysc.clk)) then
      strobe    <= not (imx.cs_n) and not(imx.oe_n and imx.eb3_n);
      writing   <= not (imx.cs_n or imx.eb3_n);
      readf     <= not (imx.cs_n or imx.oe_n);
      address   <= imx.address & '0';
      writedata <= imx_data;
    end if;
  end process;

  wbw.address   <= address   when (strobe = '1')  else (others => '0');
  wbw.writedata <= writedata when (writing = '1') else (others => '0');
  wbw.strobe    <= strobe;
  wbw.writing   <= writing;
  wbw.cycle     <= strobe;

  imx_data <= wbr.readdata when (readf = '1') else (others => 'Z');

end architecture RTL;
