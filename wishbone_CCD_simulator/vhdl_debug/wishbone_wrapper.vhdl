library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity wishbone_wrapper is
  port
    (
      -- External Clock
      sysc     : in    syscon;
      -- Armadeus handshaking
      imx_data : inout imx_chan;
      imx      : in    imx_in;
      wbr      : in    wbrs;
      wbw      : out   wbws
      );
end entity;

architecture RTL of top_mod is
  signal read_data : imx_chan;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      case imx.address is
        when "000000000001" => read_data <= x"F00F";
        when "000000000010" => read_data <= x"1337";
        when "000000000011" => read_data <= x"D0D0";
        when "000000000100" => read_data <= x"DEAD";
        when others         => read_data <= (others => '0');
      end case;
    end if;
  end process;

  imx_data <= read_data when (not (imx.cs_n or imx.oe_n) = '1')
              else (others => 'Z');

end architecture;
