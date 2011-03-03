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

architecture RTL of wishbone_wrapper is
  signal readdata : imx_chan;
  signal readf, strobe : std_logic;
begin
  readf <= not (imx.cs_n or imx.oe_n);
  strobe <= not (imx.cs_n) and not(imx.oe_n and imx.eb3_n);
  
  process(sysc.clk)
  begin
    if rising_edge(sysc.clk) then
      case imx.address is
        when "000000000000" => readdata <= x"F473";
        when "000000000001" => readdata <= x"F00F";
        when "000000000010" => readdata <= x"1337";
        when "000000000011" => readdata <= x"D0D0";
        when "000000000100" => readdata <= x"DEAD";
        when others         => readdata <= (others => '0');
      end case;
    end if;
  end process;

  imx_data <= readdata when (readf = '1')
              else (others => 'Z');

end architecture;
